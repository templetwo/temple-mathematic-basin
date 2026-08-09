from __future__ import annotations

import os
import platform
import re
import shutil
import subprocess
import tempfile
from dataclasses import dataclass
from enum import Enum
from pathlib import Path


AXIOM_ALLOWLIST: frozenset[str] = frozenset(
    {"propext", "Classical.choice", "Quot.sound"}
)

_SANDBOX_EXEC = "/usr/bin/sandbox-exec"
_LEAN_ENV_KEYS = (
    "LEAN",
    "LEAN_PATH",
    "LEAN_SRC_PATH",
    "LEAN_SYSROOT",
    "LEAN_GITHASH",
    "PATH",
    "HOME",
    "TMPDIR",
)


class VerdictStatus(str, Enum):
    ACCEPT = "ACCEPT"
    REJECT = "REJECT"


@dataclass(frozen=True)
class VerdictResult:
    status: VerdictStatus
    axioms: tuple[str, ...]
    compile_log: str
    reject_reason: str | None
    compiled: bool


def _lake_executable() -> str:
    resolved = shutil.which("lake")
    if resolved is not None:
        return resolved
    fallback = Path.home() / ".elan" / "bin" / "lake"
    return str(fallback)


def _sandbox_available() -> bool:
    """macOS seatbelt only. Fail closed elsewhere / if binary missing."""
    return platform.system() == "Darwin" and Path(_SANDBOX_EXEC).is_file()


def _lean_string_literal(value: str) -> str:
    """Embed an untrusted string as a Lean double-quoted string literal."""
    escaped = (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return f'"{escaped}"'


def _assemble_source(*, target: str, proof_body: str) -> str:
    """Assemble a trusted harness that treats proof_body as a term-only string.

    The untrusted body is never concatenated as raw Lean source. It is embedded
    as a string literal, parsed with Lean's `term` parser (which rejects leftover
    input such as trailing `elab` / `macro_rules` commands), elaborated against
    the frozen target type, and then axiom-attested via trusted `collectAxioms`.

    Blind spots (what this assembly cannot see):
    - Lean parser/elaborator bugs that accept non-term residual syntax as a term.
    - Axioms introduced under names that `collectAxioms` fails to report.
    - Side effects performed during term elaboration that do not affect the
      resulting proof term or axiom set (containment is the sandbox's job).
    """
    return (
        "import Mathlib\n"
        "import Lean\n\n"
        "open Lean Meta Elab Term Command Parser\n\n"
        f"def basinTargetType : String := {_lean_string_literal(target)}\n"
        f"def basinProofBody : String := {_lean_string_literal(proof_body)}\n\n"
        "run_cmd do\n"
        "  let env ← getEnv\n"
        "  let tyRaw ← match runParserCategory env `term basinTargetType "
        '(fileName := "<type>") with\n'
        "    | .ok s => pure s\n"
        "    | .error e => throwError e\n"
        "  let bodyRaw ← match runParserCategory env `term basinProofBody "
        '(fileName := "<body>") with\n'
        "    | .ok s => pure s\n"
        "    | .error e => throwError e\n"
        "  let tyStx : TSyntax `term := ⟨tyRaw⟩\n"
        "  let bodyStx : TSyntax `term := ⟨bodyRaw⟩\n"
        "  let (val, ty) ← liftTermElabM do\n"
        "    let ty ← elabType tyStx\n"
        "    synthesizeSyntheticMVarsNoPostponing\n"
        "    let val ← elabTermEnsuringType bodyStx ty\n"
        "    synthesizeSyntheticMVarsNoPostponing\n"
        "    pure (← instantiateMVars val, ← instantiateMVars ty)\n"
        "  liftCoreM <| addAndCompile <| .thmDecl {\n"
        "    name := `basin_target\n"
        "    levelParams := []\n"
        "    type := ty\n"
        "    value := val\n"
        "  }\n"
        "  let axioms ← collectAxioms `basin_target\n"
        "  if axioms.isEmpty then\n"
        "    logInfo \"'basin_target' does not depend on any axioms\"\n"
        "  else\n"
        "    let sorted := axioms.qsort Name.lt\n"
        '    let names := ", ".intercalate (sorted.toList.map (·.toString))\n'
        "    logInfo s!\"'basin_target' depends on axioms: [{names}]\"\n"
    )


def _parse_axioms(output: str) -> tuple[str, ...] | None:
    """Parse the trusted harness attestation line for basin_target.

    Returns:
      - () when attestation says basin_target depends on no axioms
      - non-empty tuple when a bracket axiom list is present
      - None when no recognizable basin_target attestation is present (fail closed)

    The harness emits this line via trusted `collectAxioms` after elaborating a
    term-only proof body. Untrusted source cannot append top-level commands that
    redefine `#print axioms`.

    Blind spots (what this parser cannot see):
    - Axiom lines that do not mention basin_target by name.
    - Non-bracket pretty-printer formats if the harness log layout changes.
    - Axioms only mentioned in warnings/errors rather than the attestation line.
    - Nested/structured axiom lists that are not a flat comma-separated bracket list.
    - Attacker-controlled `logInfo` text that happens to match the attestation
      regex exactly once while the trusted harness fails before emitting its own
      line (mitigated by term-only parsing and return-code checks, not eliminated).
    """
    no_axioms = re.findall(
        r"'?basin_target'?\s+does not depend on any axioms",
        output,
    )
    axiom_lists = re.findall(
        r"'?basin_target'?\s+depends on axioms:\s*\[(.*?)\]",
        output,
        re.DOTALL,
    )
    # Exactly one kernel attestation is required. Multiple lines can be injected
    # by untrusted metaprogram output and are therefore ambiguous, even if they
    # happen to agree.
    if len(no_axioms) + len(axiom_lists) != 1:
        return None
    if no_axioms:
        return ()
    inner = axiom_lists[0].strip()
    if not inner:
        return ()
    return tuple(part.strip() for part in inner.split(",") if part.strip())


def _detect_sorry(compile_log: str, axioms: tuple[str, ...]) -> bool:
    """Return True if the attempt used sorry / sorryAx.

    Blind spots (what this detector cannot see):
    - Custom axioms or opaque defs that act like holes without naming sorry/sorryAx.
    - sorry elaborated only inside macros/syntax that erases the warning text and axiom name.
    - Non-English or reformatted diagnostics that omit both the warning phrase and sorryAx.
    """
    if any(ax == "sorryAx" or ax.endswith(".sorryAx") or "sorryAx" in ax for ax in axioms):
        return True
    if re.search(r"declaration uses `sorry`", compile_log):
        return True
    if re.search(r"\bsorryAx\b", compile_log):
        return True
    return False


def _detect_banned_tactic(compile_log: str, axioms: tuple[str, ...], proof_body: str) -> bool:
    """Return True for prohibited proof routes or injected evaluator commands.

    Blind spots (what this detector cannot see):
    - Obfuscated spellings / unicode lookalikes of native_decide in the proof body.
    - reduceBool reached only through a helper whose name does not contain reduceBool
      and whose generated axiom name also omits native_decide/reduceBool.
    - Future Lean native-decision backends that neither emit `_native` axioms nor
      leave native_decide/reduceBool tokens in source or log text.
    - Comments containing the tokens (false positive) and string literals (false positive).
    """
    if re.search(r"\bnative_decide\b", proof_body):
        return True
    if re.search(r"\breduceBool\b", proof_body):
        return True
    # These are command syntax, not proof terms. Their presence means the raw
    # body escaped the theorem declaration and attempted to append executable
    # source. `run_tac` remains permitted inside the OS sandbox.
    if re.search(r"\brun_cmd\b", proof_body):
        return True
    if re.search(r"#eval\b", proof_body):
        return True
    if re.search(r"\bnative_decide\b", compile_log):
        return True
    if re.search(r"\breduceBool\b", compile_log):
        return True
    for ax in axioms:
        if "native_decide" in ax or "reduceBool" in ax or "._native." in ax:
            return True
    return False


def _detect_panic_or_fatal(compile_log: str) -> bool:
    """Return True if the log shows PANIC or a fatal diagnostic.

    Blind spots:
    - Soft crashes that leave no PANIC/fatal token but still corrupt kernel state.
    - Localized/reformatted runtime aborts that omit those tokens.
    """
    if re.search(r"\bPANIC\b", compile_log):
        return True
    if re.search(r"\bfatal(?:\s+error)?\b", compile_log, re.IGNORECASE):
        return True
    return False


def _axioms_outside_allowlist(axioms: tuple[str, ...]) -> tuple[str, ...]:
    """Axioms not in the Mathlib-standard allowlist.

    Blind spots (what this checker cannot see):
    - Axioms the parser failed to extract (see _parse_axioms blind spots).
    - Trust assumptions that are not reported as axioms (e.g. ofReduceBool under
      some configurations if the print line is incomplete).
    """
    return tuple(ax for ax in axioms if ax not in AXIOM_ALLOWLIST)


def _resolve_lean_env(project: Path) -> dict[str, str] | None:
    """Resolve Lean binary + LEAN_* via lake *outside* the sandbox.

    Lake package management must not run under the seatbelt (it may try network
    or mutate .lake). Returns None on failure (fail closed).
    """
    try:
        completed = subprocess.run(
            [_lake_executable(), "env", "printenv"],
            cwd=project,
            capture_output=True,
            text=True,
            timeout=60,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    if completed.returncode != 0:
        return None
    env: dict[str, str] = {}
    for line in completed.stdout.splitlines():
        if not line or "=" not in line:
            continue
        key, _, value = line.partition("=")
        env[key] = value
    lean_bin = env.get("LEAN")
    if not lean_bin or not Path(lean_bin).is_file():
        return None
    if "LEAN_PATH" not in env:
        return None
    return env


def _write_sandbox_profile(
    *,
    project: Path,
    attempt_dir: Path,
    lean_bin: Path,
    lean_sysroot: Path | None,
) -> Path:
    """Write a macOS seatbelt profile. Caller deletes the file."""
    home = str(Path.home().resolve())
    elan_home = str((Path.home() / ".elan").resolve())
    project_s = str(project.resolve())
    attempt_s = str(attempt_dir.resolve())
    lean_bin_s = str(lean_bin.resolve())
    read_allow = [
        project_s,
        elan_home,
        attempt_s,
        "/usr",
        "/System",
        "/Library",
        "/bin",
        "/sbin",
        "/opt",
        "/private/etc",
        "/etc",
        "/private/var/db/dyld",
    ]
    if lean_sysroot is not None:
        read_allow.append(str(lean_sysroot.resolve()))

    # Deduplicate while preserving order
    seen: set[str] = set()
    read_lines: list[str] = []
    for path in read_allow:
        if path not in seen:
            seen.add(path)
            read_lines.append(f'  (subpath "{path}")')

    profile = f"""(version 1)
(allow default)
(deny process-fork)
(deny process-exec)
(allow process-exec
  (literal "{lean_bin_s}")
)
(deny network*)
(deny file-write*)
(allow file-write-data
  (literal "/dev/null")
)
(deny file-read-data
  (subpath "{home}")
  (subpath "/private/var/folders")
  (subpath "/private/tmp")
  (subpath "/private/var/tmp")
  (subpath "/tmp")
  (subpath "/var/tmp")
)
(allow file-read-data
{chr(10).join(read_lines)}
  (literal "/dev/null")
  (literal "/dev/urandom")
  (literal "/dev/random")
  (literal "/dev/zero")
  (literal "/dev/tty")
)
(allow file-ioctl
  (literal "/dev/null")
  (literal "/dev/dtracehelper")
  (literal "/dev/tty")
)
"""
    handle = tempfile.NamedTemporaryFile(
        mode="w",
        encoding="utf-8",
        suffix=".sb",
        prefix="basin_sandbox_",
        dir=attempt_dir,
        delete=False,
    )
    with handle:
        handle.write(profile)
    return Path(handle.name)


def _sandbox_run_env(
    lean_env: dict[str, str],
    *,
    attempt_dir: Path,
) -> dict[str, str]:
    """Minimal env for sandboxed lean: lake-resolved LEAN_* plus a tight PATH."""
    run_env: dict[str, str] = {}
    for key in _LEAN_ENV_KEYS:
        if key in lean_env:
            run_env[key] = lean_env[key]
    lean_bin = Path(lean_env["LEAN"])
    path_parts = [str(lean_bin.parent), "/usr/bin", "/bin"]
    # Keep lake-provided PATH entries that point at package build bins (for dynlibs helpers).
    if "PATH" in lean_env:
        for part in lean_env["PATH"].split(os.pathsep):
            if part and part not in path_parts:
                path_parts.append(part)
    run_env["PATH"] = os.pathsep.join(path_parts)
    run_env.setdefault("HOME", str(Path.home()))
    # Do not expose the user's shared temp directory to untrusted Lean. The
    # attempt directory is readable scratch, but the seatbelt denies writes
    # there as it does everywhere except /dev/null.
    run_env["TMPDIR"] = str(attempt_dir)
    return run_env


def _run_sandboxed_lean(
    *,
    project: Path,
    attempt_dir: Path,
    lean_file: Path,
    lean_env: dict[str, str],
    timeout_seconds: float,
) -> subprocess.CompletedProcess[str]:
    sysroot_raw = lean_env.get("LEAN_SYSROOT")
    lean_sysroot = Path(sysroot_raw) if sysroot_raw else None
    lean_bin = Path(lean_env["LEAN"]).resolve()
    profile_path = _write_sandbox_profile(
        project=project,
        attempt_dir=attempt_dir,
        lean_bin=lean_bin,
        lean_sysroot=lean_sysroot,
    )
    cmd = [
        _SANDBOX_EXEC,
        "-f",
        str(profile_path),
        str(lean_bin),
        str(lean_file),
    ]
    try:
        return subprocess.run(
            cmd,
            cwd=project,
            capture_output=True,
            text=True,
            timeout=timeout_seconds,
            check=False,
            env=_sandbox_run_env(lean_env, attempt_dir=attempt_dir),
        )
    finally:
        profile_path.unlink(missing_ok=True)


def _reject(
    reason: str,
    *,
    compiled: bool,
    axioms: tuple[str, ...] = (),
    compile_log: str = "",
) -> VerdictResult:
    return VerdictResult(
        VerdictStatus.REJECT,
        axioms,
        compile_log,
        reason,
        compiled,
    )


def verdict(
    proposition: str,
    claimed_stance: str,
    proof_body: str,
    *,
    project_dir: str | Path,
    timeout_seconds: float = 120,
) -> VerdictResult:
    """Compile a proof body against the frozen proposition supplied by the caller.

    UNKNOWN compiles nothing and ignores any Lean text in proof_body. Result is
    REJECT with reject_reason 'unknown_stance': abstention is not earned evidence
    of P or of ¬P, so it cannot ACCEPT. (compiled=False, empty axioms/log.)

    Untrusted Lean is only executed inside a macOS seatbelt sandbox. If the
    sandbox is unavailable or setup fails, REJECT without compiling.
    """
    if claimed_stance == "UNKNOWN":
        return _reject("unknown_stance", compiled=False)
    if claimed_stance not in {"PROVABLE", "REFUTABLE"}:
        return _reject("unsupported_stance", compiled=False)

    # Fail closed before any model-controlled source touches the host compiler.
    if not _sandbox_available():
        return _reject("sandbox_unavailable", compiled=False)

    project = Path(project_dir).resolve()
    tmp_root = project / "tmp"
    tmp_root.mkdir(parents=True, exist_ok=True)

    lean_env = _resolve_lean_env(project)
    if lean_env is None:
        return _reject("sandbox_unavailable", compiled=False)

    target = proposition if claimed_stance == "PROVABLE" else f"¬ ({proposition})"
    source = _assemble_source(target=target, proof_body=proof_body)

    attempt_dir: Path | None = None
    path: Path | None = None
    try:
        attempt_dir = Path(tempfile.mkdtemp(prefix="BasinAttempt_", dir=tmp_root))
        # Unique path token retained for parallel-attempt tracking/cleanup checks.
        token = attempt_dir.name.removeprefix("BasinAttempt_")
        path = attempt_dir / f"BasinAttempt_{token}.lean"
        path.write_text(source, encoding="utf-8")

        try:
            completed = _run_sandboxed_lean(
                project=project,
                attempt_dir=attempt_dir,
                lean_file=path,
                lean_env=lean_env,
                timeout_seconds=timeout_seconds,
            )
        except subprocess.TimeoutExpired as exc:
            log = ""
            if exc.stdout:
                log += exc.stdout if isinstance(exc.stdout, str) else exc.stdout.decode()
            if exc.stderr:
                log += exc.stderr if isinstance(exc.stderr, str) else exc.stderr.decode()
            return _reject("timeout", compiled=True, compile_log=log)
        except OSError as exc:
            return _reject(
                "sandbox_unavailable",
                compiled=False,
                compile_log=str(exc),
            )

        compile_log = (completed.stdout or "") + (completed.stderr or "")

        if completed.returncode != 0:
            axioms_rc = _parse_axioms(compile_log) or ()
            return _reject(
                "compile_error",
                compiled=True,
                axioms=axioms_rc,
                compile_log=compile_log,
            )

        if _detect_panic_or_fatal(compile_log):
            axioms_panic = _parse_axioms(compile_log) or ()
            return _reject(
                "panic",
                compiled=True,
                axioms=axioms_panic,
                compile_log=compile_log,
            )

        axioms = _parse_axioms(compile_log)
        if axioms is None:
            return _reject(
                "missing_axiom_attestation",
                compiled=True,
                axioms=(),
                compile_log=compile_log,
            )

        if _detect_sorry(compile_log, axioms):
            return _reject(
                "sorry",
                compiled=True,
                axioms=axioms,
                compile_log=compile_log,
            )
        if _detect_banned_tactic(compile_log, axioms, proof_body):
            return _reject(
                "banned_tactic",
                compiled=True,
                axioms=axioms,
                compile_log=compile_log,
            )
        banned = _axioms_outside_allowlist(axioms)
        if banned:
            return _reject(
                "axiom_not_allowlisted",
                compiled=True,
                axioms=axioms,
                compile_log=compile_log,
            )
        return VerdictResult(
            VerdictStatus.ACCEPT,
            axioms,
            compile_log,
            None,
            True,
        )
    finally:
        if path is not None:
            path.unlink(missing_ok=True)
        if attempt_dir is not None:
            shutil.rmtree(attempt_dir, ignore_errors=True)
