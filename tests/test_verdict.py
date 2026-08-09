from __future__ import annotations

import concurrent.futures
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from verdict import VerdictStatus, _parse_axioms, verdict


PROJECT_DIR = Path(__file__).resolve().parents[1] / "lean"
TMP_DIR = PROJECT_DIR / "tmp"


def _lean_paths_from_subprocess_cmd(cmd: object) -> list[str]:
    """Extract attempt .lean paths from a sandbox/lean argv list."""
    if not isinstance(cmd, list):
        return []
    return [part for part in cmd if isinstance(part, str) and part.endswith(".lean") and "BasinAttempt_" in part]


class VerdictAcceptanceTests(unittest.TestCase):
    def test_provable_body_for_frozen_statement_is_accepted(self) -> None:
        result = verdict("True", "PROVABLE", "by trivial", project_dir=PROJECT_DIR)

        self.assertEqual(result.status, VerdictStatus.ACCEPT)
        self.assertEqual(result.axioms, ())
        self.assertTrue(result.compiled)

    def test_refutable_body_is_assembled_as_negated_frozen_statement(self) -> None:
        result = verdict("False", "REFUTABLE", "by simp", project_dir=PROJECT_DIR)

        self.assertEqual(result.status, VerdictStatus.ACCEPT)
        self.assertEqual(result.axioms, ("propext",))
        self.assertTrue(result.compiled)

    def test_unknown_stance_compiles_nothing_and_ignores_lean_text(self) -> None:
        """UNKNOWN never touches Lean. Coherent REJECT: abstention is not earned evidence."""
        result = verdict(
            "True",
            "UNKNOWN",
            "by trivial",  # would ACCEPT under PROVABLE; must be ignored
            project_dir=PROJECT_DIR,
        )

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.axioms, ())
        self.assertFalse(result.compiled)
        self.assertEqual(result.reject_reason, "unknown_stance")
        self.assertEqual(result.compile_log, "")

    def test_sorry_body_is_rejected(self) -> None:
        result = verdict("True", "PROVABLE", "by sorry", project_dir=PROJECT_DIR)

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "sorry")
        self.assertTrue(result.compiled)

    def test_native_decide_body_is_rejected(self) -> None:
        result = verdict("True", "PROVABLE", "by native_decide", project_dir=PROJECT_DIR)

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "banned_tactic")
        self.assertTrue(result.compiled)

    def test_reduceBool_route_in_body_is_rejected(self) -> None:
        # Body would otherwise prove True; reduceBool token must still refuse.
        result = verdict(
            "True",
            "PROVABLE",
            "by trivial -- reduceBool",
            project_dir=PROJECT_DIR,
        )

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "banned_tactic")
        self.assertTrue(result.compiled)

    def test_body_proving_different_proposition_is_rejected_by_construction(self) -> None:
        """Assembly locks the goal to P; a proof of a different type fails at compile.

        Refusal is by construction (goalpost lock), not by a separate detector.
        """
        result = verdict(
            "True",
            "PROVABLE",
            "(rfl : 1 = 1)",
            project_dir=PROJECT_DIR,
        )

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "compile_error")
        self.assertTrue(result.compiled)

    def test_refutable_claim_whose_body_proves_P_is_rejected(self) -> None:
        """REFUTABLE assembles ¬P; a body that proves P cannot inhabit ¬P."""
        result = verdict("True", "REFUTABLE", "by trivial", project_dir=PROJECT_DIR)

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "compile_error")
        self.assertTrue(result.compiled)

    def test_default_compile_timeout_is_120_seconds(self) -> None:
        self.assertIsNone(verdict.__defaults__)
        self.assertEqual(verdict.__kwdefaults__["timeout_seconds"], 120)

    def test_compile_timeout_is_rejected(self) -> None:
        result = verdict(
            "True",
            "PROVABLE",
            "by trivial",
            project_dir=PROJECT_DIR,
            timeout_seconds=0.001,
        )

        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "timeout")
        self.assertTrue(result.compiled)

    def test_attempt_modules_use_unique_names_and_are_cleaned_up(self) -> None:
        before_files = {p for p in TMP_DIR.rglob("BasinAttempt_*.lean")}
        paths_seen: list[str] = []

        real_run = __import__("subprocess").run

        def tracking_run(*args, **kwargs):
            cmd = args[0] if args else kwargs.get("args")
            paths_seen.extend(_lean_paths_from_subprocess_cmd(cmd))
            return real_run(*args, **kwargs)

        with mock.patch("verdict.subprocess.run", side_effect=tracking_run):
            with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
                futures = [
                    pool.submit(
                        verdict,
                        "True",
                        "PROVABLE",
                        "by trivial",
                        project_dir=PROJECT_DIR,
                    )
                    for _ in range(2)
                ]
                results = [f.result() for f in futures]

        after_files = {p for p in TMP_DIR.rglob("BasinAttempt_*.lean")}
        self.assertTrue(all(r.status == VerdictStatus.ACCEPT for r in results))
        self.assertEqual(len(paths_seen), 2)
        self.assertEqual(len(set(paths_seen)), 2)
        self.assertTrue(all("BasinAttempt_" in p for p in paths_seen))
        self.assertEqual(after_files, before_files)

    def test_toplevel_run_cmd_source_injection_is_rejected_and_does_not_write_canary(
        self,
    ) -> None:
        """Model body must not break out into top-level run_cmd side effects on the host."""
        canary = Path(tempfile.gettempdir()) / f"basin_p0_inject_canary_{os.getpid()}"
        canary.unlink(missing_ok=True)
        body = f'''by trivial

run_cmd IO.FS.writeFile "{canary}" "PWNED"
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertEqual(result.status, VerdictStatus.REJECT)
            self.assertTrue(result.compiled)
            self.assertFalse(canary.exists(), msg="host side-effect canary must not be written")
        finally:
            canary.unlink(missing_ok=True)

    def test_interm_metaprogram_side_effect_is_rejected_and_does_not_write_canary(
        self,
    ) -> None:
        """In-term/metaprogram paths must not write host files even if elaboration runs."""
        canary = Path(tempfile.gettempdir()) / f"basin_p0_meta_canary_{os.getpid()}"
        canary.unlink(missing_ok=True)
        body = f'''by
  run_tac do
    let _ ← Lean.Elab.Tactic.evalTactic (← `(tactic| trivial))
    IO.FS.writeFile "{canary}" "META_PWNED"
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertEqual(result.status, VerdictStatus.REJECT)
            self.assertTrue(result.compiled)
            self.assertFalse(canary.exists(), msg="metaprogram must not write host canary")
        finally:
            canary.unlink(missing_ok=True)

    def test_metaprogram_cannot_read_unrelated_home_file(self) -> None:
        """Untrusted elaboration cannot read or echo files outside the Basin roots."""
        canary = Path.home() / f".basin_p0_read_canary_{os.getpid()}"
        secret = f"BASIN_PRIVATE_CANARY_{os.getpid()}"
        canary.write_text(secret, encoding="utf-8")
        body = f'''by
  run_tac do
    Lean.Elab.Tactic.evalTactic (← `(tactic| trivial))
    try
      let leaked ← IO.FS.readFile "{canary}"
      IO.println leaked
    catch _ =>
      IO.println "HOME_READ_BLOCKED"
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertNotIn(secret, result.compile_log)
        finally:
            canary.unlink(missing_ok=True)

    def test_metaprogram_cannot_read_unrelated_temp_file(self) -> None:
        """Seatbelt must not expose other processes' files in the shared temp root."""
        canary = Path(tempfile.gettempdir()) / f"basin_p0_tmp_read_{os.getpid()}"
        secret = f"BASIN_TMP_PRIVATE_{os.getpid()}"
        canary.write_text(secret, encoding="utf-8")
        body = f'''by
  run_tac do
    Lean.Elab.Tactic.evalTactic (← `(tactic| trivial))
    try
      let leaked ← IO.FS.readFile "{canary}"
      IO.println leaked
    catch _ =>
      IO.println "TMP_READ_BLOCKED"
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertNotIn(secret, result.compile_log)
        finally:
            canary.unlink(missing_ok=True)

    def test_metaprogram_cannot_read_private_tmp_file(self) -> None:
        """Seatbelt rules use canonical paths, so /private/tmp must be denied explicitly."""
        canary = Path("/private/tmp") / f"basin_p0_private_tmp_{os.getpid()}"
        secret = f"BASIN_PRIVATE_TMP_{os.getpid()}"
        canary.write_text(secret, encoding="utf-8")
        body = f'''by
  run_tac do
    Lean.Elab.Tactic.evalTactic (← `(tactic| trivial))
    try
      let leaked ← IO.FS.readFile "{canary}"
      IO.println leaked
    catch _ =>
      IO.println "PRIVATE_TMP_READ_BLOCKED"
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertEqual(result.status, VerdictStatus.ACCEPT)
            self.assertTrue(result.compiled)
            self.assertIn("PRIVATE_TMP_READ_BLOCKED", result.compile_log)
            self.assertNotIn(secret, result.compile_log)
        finally:
            canary.unlink(missing_ok=True)

    def test_metaprogram_cannot_spawn_child_process(self) -> None:
        """Lean may elaborate, but it cannot exec an arbitrary child binary."""
        marker = f"BASIN_CHILD_PROCESS_{os.getpid()}"
        body = f'''by
  run_tac do
    Lean.Elab.Tactic.evalTactic (← `(tactic| trivial))
    try
      let output ← IO.Process.run {{ cmd := "/usr/bin/id", args := #[] }}
      IO.println "{marker}"
      IO.println output
    catch _ =>
      IO.println "CHILD_PROCESS_BLOCKED"
'''
        result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
        self.assertEqual(result.status, VerdictStatus.ACCEPT)
        self.assertTrue(result.compiled)
        self.assertIn("CHILD_PROCESS_BLOCKED", result.compile_log)
        self.assertNotIn(marker, result.compile_log)

    def test_caught_toplevel_run_cmd_injection_is_still_rejected(self) -> None:
        """Catching a denied side effect must not turn command injection into ACCEPT."""
        canary = Path(tempfile.gettempdir()) / f"basin_p0_caught_write_{os.getpid()}"
        canary.unlink(missing_ok=True)
        body = f'''by trivial

run_cmd do
  try
    IO.FS.writeFile "{canary}" "PWNED"
  catch _ =>
    pure ()
'''
        try:
            result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
            self.assertEqual(result.status, VerdictStatus.REJECT)
            self.assertFalse(canary.exists())
        finally:
            canary.unlink(missing_ok=True)

    def test_false_proposition_cannot_accept_via_addDecl_and_print_axioms_shadow(self) -> None:
        """Attestation must come from trusted collectAxioms, not attacker-shadowed print."""
        shadow = (
            "\n\nopen Lean Elab Command in\n"
            'elab "#print" "axioms" _i:ident : command => do\n'
            "  logInfo \"'basin_target' does not depend on any axioms\"\n"
        )
        cheat = """by
  run_tac do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let ty ← goal.getType
    Lean.addDecl (Lean.Declaration.axiomDecl {
      name := `basin_target.cheat,
      levelParams := [],
      type := ty,
      isUnsafe := false })
    goal.assign (Lean.mkConst `basin_target.cheat)
"""
        result = verdict(
            "2 + 2 = 5",
            "PROVABLE",
            cheat + shadow,
            project_dir=PROJECT_DIR,
        )
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertNotEqual(result.reject_reason, None)
        # Either the trailing command fails term parsing, or a fabricated axiom
        # is reported and fail-closed by the allowlist. Never ACCEPT a false prop.
        self.assertIn(
            result.reject_reason,
            {"compile_error", "axiom_not_allowlisted", "missing_axiom_attestation"},
        )

    def test_trailing_elab_command_is_rejected_as_non_term(self) -> None:
        """Proof bodies are term-only; trailing command syntax cannot redefine attestation."""
        body = (
            "by trivial\n\n"
            "open Lean Elab Command in\n"
            'elab "#print" "axioms" _i:ident : command => do\n'
            "  logInfo \"'basin_target' does not depend on any axioms\"\n"
        )
        result = verdict("True", "PROVABLE", body, project_dir=PROJECT_DIR)
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "compile_error")
        self.assertTrue(result.compiled)

    def test_fabricated_basin_target_axiom_is_reported_and_rejected(self) -> None:
        """If a body fabricates basin_target.cheat, trusted collectAxioms must surface it."""
        cheat = """by
  run_tac do
    let goal ← Lean.Elab.Tactic.getMainGoal
    let ty ← goal.getType
    Lean.addDecl (Lean.Declaration.axiomDecl {
      name := `basin_target.cheat,
      levelParams := [],
      type := ty,
      isUnsafe := false })
    goal.assign (Lean.mkConst `basin_target.cheat)
"""
        result = verdict("2 + 2 = 5", "PROVABLE", cheat, project_dir=PROJECT_DIR)
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "axiom_not_allowlisted")
        self.assertIn("basin_target.cheat", result.axioms)

    def test_returncode_zero_panic_is_rejected(self) -> None:
        """A return-code-0 log containing PANIC must not ACCEPT."""
        fake = mock.Mock(
            returncode=0,
            stdout="'basin_target' does not depend on any axioms\n",
            stderr="PANIC at Lean.MetavarContext.instantiateExprMVars\n",
        )
        with mock.patch("verdict.subprocess.run", return_value=fake):
            # Force sandbox path to treat the mocked run as the lean compile.
            with mock.patch("verdict._sandbox_available", return_value=True):
                with mock.patch(
                    "verdict._resolve_lean_env",
                    return_value={
                        "LEAN": "/usr/bin/true",
                        "LEAN_PATH": "x",
                        "LEAN_SRC_PATH": "x",
                        "LEAN_SYSROOT": "x",
                    },
                ):
                    with mock.patch("verdict._write_sandbox_profile", return_value=Path("/tmp/fake.sb")):
                        with mock.patch("verdict.Path.unlink"):
                            result = verdict(
                                "True",
                                "PROVABLE",
                                "by trivial",
                                project_dir=PROJECT_DIR,
                            )
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "panic")
        self.assertTrue(result.compiled)

    def test_missing_axiom_attestation_is_rejected(self) -> None:
        """No recognizable #print axioms basin_target line => REJECT, not empty axioms."""
        self.assertIsNone(_parse_axioms(""))
        self.assertIsNone(_parse_axioms("compiled ok with no attestation line"))
        self.assertEqual(
            _parse_axioms("'basin_target' does not depend on any axioms"),
            (),
        )
        self.assertEqual(
            _parse_axioms("'basin_target' depends on axioms: [propext, Classical.choice]"),
            ("propext", "Classical.choice"),
        )
        self.assertIsNone(
            _parse_axioms(
                "'basin_target' does not depend on any axioms\n"
                "'basin_target' depends on axioms: [sorryAx]\n"
            )
        )

        fake = mock.Mock(
            returncode=0,
            stdout="elaboration successful\n",
            stderr="",
        )
        with mock.patch("verdict.subprocess.run", return_value=fake):
            with mock.patch("verdict._sandbox_available", return_value=True):
                with mock.patch(
                    "verdict._resolve_lean_env",
                    return_value={
                        "LEAN": "/usr/bin/true",
                        "LEAN_PATH": "x",
                        "LEAN_SRC_PATH": "x",
                        "LEAN_SYSROOT": "x",
                    },
                ):
                    with mock.patch("verdict._write_sandbox_profile", return_value=Path("/tmp/fake.sb")):
                        with mock.patch("verdict.Path.unlink"):
                            result = verdict(
                                "True",
                                "PROVABLE",
                                "by trivial",
                                project_dir=PROJECT_DIR,
                            )
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "missing_axiom_attestation")
        self.assertEqual(result.axioms, ())
        self.assertTrue(result.compiled)

    def test_sandbox_unavailable_rejects_without_compiling_untrusted_source(self) -> None:
        """If sandbox setup fails, REJECT and never execute model-controlled Lean."""
        with mock.patch("verdict._sandbox_available", return_value=False):
            with mock.patch("verdict.subprocess.run") as run_mock:
                result = verdict(
                    "True",
                    "PROVABLE",
                    "by trivial",
                    project_dir=PROJECT_DIR,
                )
        self.assertEqual(result.status, VerdictStatus.REJECT)
        self.assertEqual(result.reject_reason, "sandbox_unavailable")
        self.assertFalse(result.compiled)
        run_mock.assert_not_called()


if __name__ == "__main__":
    unittest.main()
