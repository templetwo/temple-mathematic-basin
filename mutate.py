"""Mutation operators + refutation certification (spec §5, §12 P3).

Mutation is SCRIPTED, never model-generated: a model-generated mutant shares
priors with the arms and contaminates the stratum (spec §5). Every operator
is a deterministic text-level transformation of the parent statement; the
operator that produced each item is recorded, because §7 stratifies by it.

Certification is the same acceptance surface the arms face: a candidate
mutant M is certified REFUTABLE only when a proof of ¬(M) survives
verdict(M, "REFUTABLE", body) for some body in a fixed, deterministic tactic
ladder. A mutant that is still TRUE cannot be certified — no proof of its
negation exists — so it lands in rejected.jsonl with the ladder's receipts.
That is the P3 redteam property, and it holds by construction rather than by
detection.

Statement well-formedness is separated from refutation failure by a `sorry`
probe: verdict(M, "REFUTABLE", "sorry") rejecting with reason "sorry" proves
¬(M) elaborates; rejecting with "compile_error" means the mutation produced
a malformed statement (reason: malformed_statement).

One certified mutant per parent enters pairs.jsonl (multiple mutants from
one parent produce clustered observations — spec §5); candidates are tried
in deterministic operator-priority order and the first certification wins.
Every failed candidate is receipted in rejected.jsonl. Nothing is silently
capped: a parent that exhausts its candidates without certification is
reported in the summary as a shortfall.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path

from verdict import verdict

REPO_ROOT = Path(__file__).resolve().parent

# Deterministic proof ladder for ¬(M). Ordered cheap-first; `decide` last
# because it can burn its whole timeout. push_neg+use covers ∀-statements
# needing a small counterexample witness.
REFUTATION_LADDER = (
    "by norm_num",
    "by simp",
    "by intro h; simp_all",
    "by omega",
    "by grind",
    "by push_neg; use 0; norm_num",
    "by push_neg; use 0; simp",
    "by push_neg; use 1; norm_num",
    "by push_neg; use 1; simp",
    "by push_neg; use 2; norm_num",
    "by decide",
)

CERTIFY_TIMEOUT_SECONDS = 60


# --- operators ---------------------------------------------------------------
# Each operator: (name, fn). fn(statement) -> list of mutant statements, one
# per application site, in left-to-right site order. Pure text, deterministic.

_NUMERAL = re.compile(r"(?<![\w.])(\d+)(?![\w.])")
# `=` that is a bare equality: not `:=`, `=>`, `==`, `≠`, `<=`, `>=`, `!=`.
_BARE_EQ = re.compile(r"(?<![:<>=!≠])=(?![>=])")

_SWAPS_INEQ_STRICTNESS = [("≤", "<"), ("<", "≤"), ("≥", ">"), (">", "≥")]
# Negation-class swaps: on a TRUE parent these produce a mutant that is false
# BY CONSTRUCTION (the swapped relation is the negation of the original), so
# certification needs only one witness, not luck about whether truth broke.
_SWAPS_NEGATE_REL = [("≤", ">"), (">", "≤"), ("<", "≥"), ("≥", "<"), ("∈", "∉"), ("∉", "∈"), ("⊆", "⊈")]
_SWAPS_MONO = [
    ("StrictMonoOn", "StrictAntiOn"), ("StrictAntiOn", "StrictMonoOn"),
    ("StrictMono", "StrictAnti"), ("StrictAnti", "StrictMono"),
    ("Monotone", "Antitone"), ("Antitone", "Monotone"),
]
_SWAPS_LATTICE = [
    ("Set.Ici", "Set.Iic"), ("Set.Iic", "Set.Ici"),
    ("Set.Ioi", "Set.Iio"), ("Set.Iio", "Set.Ioi"),
    ("min", "max"), ("max", "min"), ("⊓", "⊔"), ("⊔", "⊓"),
    ("∩", "∪"), ("∪", "∩"),
]


def _sites(statement: str, needle: str) -> list[int]:
    out, start = [], 0
    while (i := statement.find(needle, start)) != -1:
        out.append(i)
        start = i + 1
    return out


def _swap_at_one_site(statement: str, swaps: list[tuple[str, str]]) -> list[str]:
    """Apply each (old, new) swap at each site independently, longest-first so
    e.g. StrictMonoOn is never partially rewritten by the StrictMono rule."""
    mutants = []
    claimed: set[tuple[int, int]] = set()
    for old, new in sorted(swaps, key=lambda p: -len(p[0])):
        for i in _sites(statement, old):
            span = (i, i + len(old))
            if any(s < span[1] and span[0] < e for s, e in claimed):
                continue
            claimed.add(span)
            mutants.append(statement[:i] + new + statement[i + len(old):])
    return mutants


def op_perturb_constant(statement: str) -> list[str]:
    mutants = []
    for m in _NUMERAL.finditer(statement):
        value = int(m.group(1))
        for delta in (1, -1):
            if value + delta < 0:
                continue
            mutants.append(
                statement[: m.start(1)] + str(value + delta) + statement[m.end(1):]
            )
    return mutants


def op_flip_strictness(statement: str) -> list[str]:
    return _swap_at_one_site(statement, _SWAPS_INEQ_STRICTNESS)


def op_negate_relation(statement: str) -> list[str]:
    return _swap_at_one_site(statement, _SWAPS_NEGATE_REL)


def op_eq_to_ne(statement: str) -> list[str]:
    mutants = []
    for m in _BARE_EQ.finditer(statement):
        mutants.append(statement[: m.start()] + "≠" + statement[m.end():])
    return mutants


def op_flip_monotonicity(statement: str) -> list[str]:
    return _swap_at_one_site(statement, _SWAPS_MONO)


def op_lattice_swap(statement: str) -> list[str]:
    return _swap_at_one_site(statement, _SWAPS_LATTICE)


def op_drop_negation(statement: str) -> list[str]:
    stripped = statement.strip()
    if stripped.startswith("¬"):
        return [stripped[1:].strip().removeprefix("(").removesuffix(")").strip()
                if stripped[1:].strip().startswith("(") and stripped.endswith(")")
                else stripped[1:].strip()]
    return []


# Priority order: guaranteed-false mutations first (negation-class swaps and
# drop_negation are false by construction on a true parent, so certification
# succeeds or fails on ladder power alone), then deep-invariant breaks, then
# surface perturbations whose mutants are only sometimes false. If P4
# calibration finds the corpus too easy, harden here (spec §5).
from typing import Callable

OPERATORS: tuple[tuple[str, Callable[[str], list[str]]], ...] = (
    ("drop_negation", op_drop_negation),
    ("negate_relation", op_negate_relation),
    ("eq_to_ne", op_eq_to_ne),
    ("flip_monotonicity", op_flip_monotonicity),
    ("lattice_swap", op_lattice_swap),
    ("perturb_constant", op_perturb_constant),
    ("flip_strictness", op_flip_strictness),
)


def candidates_for(
    statement: str, per_parent_cap: int, exclude_ops: frozenset[str] = frozenset()
) -> list[tuple[str, str]]:
    """(operator, mutant_statement) in deterministic priority order, deduped,
    never equal to the parent, capped at per_parent_cap. exclude_ops supports
    the histogram rebalance pass (no operator may dominate the corpus)."""
    out: list[tuple[str, str]] = []
    seen = {statement}
    for op_name, fn in OPERATORS:
        if op_name in exclude_ops:
            continue
        for mutant in fn(statement):
            if mutant in seen:
                continue
            seen.add(mutant)
            out.append((op_name, mutant))
            if len(out) >= per_parent_cap:
                return out
    return out


# --- certification -----------------------------------------------------------

def parent_powered_rungs(
    op_name: str, parent_proof: str, parent_statement: str
) -> tuple[str, ...]:
    """Refutation attempts built from the parent's own certified proof.

    A negation-class mutant is false because the parent is true, so its
    refutation IS the parent theorem: for drop_negation the target ¬(mutant)
    is definitionally the parent statement; for negate_relation/eq_to_ne,
    push_neg reduces ¬(mutant) to the parent (witnessed at a point when
    quantified). These rungs are op-conditional so they never burn compiles
    on candidates they cannot help."""
    ascribed = f"(({parent_proof}) : ({parent_statement}))"
    if op_name == "drop_negation":
        return (parent_proof,)
    if op_name in ("negate_relation", "eq_to_ne"):
        return (
            f"by push_neg\nexact {ascribed}",
            f"by push_neg\nexact ⟨0, {ascribed} 0⟩",
            f"by push_neg\nexact ⟨0, 0, {ascribed} 0 0⟩",
            f"by push_neg\nexact ⟨1, {ascribed} 1⟩",
        )
    return ()


def certify_refutable(
    statement: str,
    *,
    project_dir: Path,
    ladder: tuple[str, ...] = REFUTATION_LADDER,
    extra_rungs: tuple[str, ...] = (),
    timeout_seconds: float = CERTIFY_TIMEOUT_SECONDS,
) -> dict:
    """Certify one candidate. extra_rungs are tried FIRST (parent-powered
    refutations are near-certain wins when they apply). Returns
    {certified, refutation_body?, axioms?, wall_ms?, reason?, attempts:[...]}.
    """
    attempts: list[dict] = []

    probe = verdict(statement, "REFUTABLE", "sorry",
                    project_dir=project_dir, timeout_seconds=timeout_seconds)
    if probe.reject_reason != "sorry":
        return {
            "certified": False,
            "reason": "malformed_statement",
            "attempts": [{"body": "sorry", "reject_reason": probe.reject_reason}],
        }

    for body in extra_rungs + ladder:
        start = time.monotonic()
        result = verdict(statement, "REFUTABLE", body,
                         project_dir=project_dir, timeout_seconds=timeout_seconds)
        wall_ms = int((time.monotonic() - start) * 1000)
        if result.status.value == "ACCEPT":
            return {
                "certified": True,
                "refutation_body": body,
                "axioms": list(result.axioms),
                "wall_ms": wall_ms,
            }
        attempts.append({"body": body, "reject_reason": result.reject_reason})
    return {"certified": False, "reason": "refutation_not_found", "attempts": attempts}


# --- pairing run -------------------------------------------------------------

def mutate_corpus(
    pairs: list[dict],
    *,
    project_dir: Path,
    per_parent_cap: int,
    lean_workers: int,
    lean_toolchain: str,
    mathlib_commit: str,
    exclude_ops: frozenset[str] = frozenset(),
    refill: bool = False,
    log=print,
) -> tuple[list[dict], list[dict]]:
    """Fill the mutant side of each pair. Returns (updated_pairs, rejected).
    refill=True re-attempts pairs that already carry a mutant (rebalance)."""

    def work(pair: dict) -> tuple[dict, list[dict]]:
        parent = pair["parent"]
        if pair.get("mutant") and not refill:
            return pair, []
        rejected_here: list[dict] = []
        for op_name, mutant_stmt in candidates_for(
            parent["statement"], per_parent_cap, exclude_ops
        ):
            outcome = certify_refutable(
                mutant_stmt,
                project_dir=project_dir,
                extra_rungs=parent_powered_rungs(
                    op_name, parent["proof_body"], parent["statement"]
                ),
            )
            if outcome["certified"]:
                number = pair["pair_id"]
                pair = pair | {
                    "mutation_op": op_name,
                    "mutant": {
                        "item_id": f"refutable_{number}",
                        "stratum": "REFUTABLE",
                        "ground_truth": "REFUTABLE",
                        "statement": mutant_stmt,
                        "refutation_body": outcome["refutation_body"],
                        "certificate": {
                            "kernel_result": "ACCEPT",
                            "axioms": outcome["axioms"],
                            "lean_toolchain": lean_toolchain,
                            "mathlib_commit": mathlib_commit,
                            "verified_at": datetime.now(timezone.utc).isoformat(
                                timespec="seconds"
                            ),
                            "wall_ms": outcome["wall_ms"],
                        },
                        "mutation_op": op_name,
                    },
                }
                log(f"  certified {number} via {op_name}")
                return pair, rejected_here
            rejected_here.append({
                "parent_item_id": parent["item_id"],
                "pair_id": pair["pair_id"],
                "mutation_op": op_name,
                "statement": mutant_stmt,
                "reason": outcome["reason"],
                "attempts": outcome["attempts"],
                "rejected_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
            })
        log(f"  SHORTFALL {pair['pair_id']}: no candidate certified "
            f"({len(rejected_here)} tried)")
        return pair, rejected_here

    with ThreadPoolExecutor(max_workers=lean_workers) as pool:
        outcomes = list(pool.map(work, pairs))

    updated = [pair for pair, _ in outcomes]
    rejected = [r for _, rs in outcomes for r in rs]
    return updated, rejected


def op_histogram(pairs: list[dict]) -> dict[str, int]:
    from collections import Counter

    return dict(Counter(p["mutation_op"] for p in pairs if p.get("mutant")))


def rebalance(
    pairs: list[dict],
    *,
    cap_share: float,
    log=print,
    **mutate_kwargs,
) -> tuple[list[dict], list[dict]]:
    """Best-effort operator-diversity enforcement: while any operator holds
    more than cap_share of certified mutants, re-certify its latest pairs
    under exclusion of every at-cap operator. A pair is swapped ONLY if the
    retry certifies — a certified pair is never sacrificed to the histogram.
    Deterministic; terminates when every over-cap pair has been attempted."""
    rejected_all: list[dict] = []
    attempted: set[str] = set()
    while True:
        certified = [p for p in pairs if p.get("mutant")]
        if not certified:
            return pairs, rejected_all
        cap_count = int(cap_share * len(certified))
        hist = op_histogram(pairs)
        over = {op for op, n in hist.items() if n > cap_count}
        candidates = [
            p for p in certified
            if p["mutation_op"] in over and p["pair_id"] not in attempted
        ]
        if not over or not candidates:
            return pairs, rejected_all
        target = max(candidates, key=lambda p: p["pair_id"])
        attempted.add(target["pair_id"])
        log(f"rebalance: retrying {target['pair_id']} "
            f"(op {target['mutation_op']} over {cap_share:.0%} cap)")
        redone, rejected = mutate_corpus(
            [target], exclude_ops=frozenset(over), refill=True,
            log=log, **mutate_kwargs,
        )
        rejected_all.extend(rejected)
        new = redone[0]
        if new.get("mutant") and new["mutation_op"] not in over:
            pairs = [new if p["pair_id"] == new["pair_id"] else p for p in pairs]
            log(f"rebalance: {new['pair_id']} swapped to {new['mutation_op']}")
        else:
            log(f"rebalance: {target['pair_id']} kept {target['mutation_op']} "
                "(no alternative certified)")


def main() -> int:
    from sweep import pinned_mathlib_commit, pinned_toolchain

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pairs", default=str(REPO_ROOT / "corpus" / "pairs.jsonl"))
    parser.add_argument("--rejected", default=str(REPO_ROOT / "corpus" / "rejected.jsonl"))
    parser.add_argument("--limit", type=int, default=None, help="first N parents (pilot)")
    parser.add_argument("--from-id", default=None,
                        help="only attempt parents with pair_id >= this (skip known shortfall)")
    parser.add_argument("--per-parent-cap", type=int, default=5)
    parser.add_argument("--lean-workers", type=int, default=4)
    parser.add_argument("--cap-share", type=float, default=0.35,
                        help="max share of certified mutants any one operator may hold")
    parser.add_argument("--no-rebalance", action="store_true")
    args = parser.parse_args()

    pairs_path = Path(args.pairs)
    with pairs_path.open(encoding="utf-8") as fh:
        pairs = [json.loads(line) for line in fh if line.strip()]
    todo = pairs if args.limit is None else pairs[: args.limit]
    if args.from_id is not None:
        todo = [p for p in todo if p["pair_id"] >= args.from_id]

    # Warm the pinned Lake environment serially (README protocol).
    warm = verdict("True", "PROVABLE", "by trivial", project_dir=REPO_ROOT / "lean")
    if warm.status.value != "ACCEPT":
        print(f"lean environment warmup failed: {warm.reject_reason}", file=sys.stderr)
        return 2

    mutate_kwargs = dict(
        project_dir=REPO_ROOT / "lean",
        per_parent_cap=args.per_parent_cap,
        lean_workers=args.lean_workers,
        lean_toolchain=pinned_toolchain(),
        mathlib_commit=pinned_mathlib_commit(),
    )
    updated, rejected = mutate_corpus(todo, **mutate_kwargs)
    if not args.no_rebalance:
        updated, rejected_rb = rebalance(
            updated, cap_share=args.cap_share, **mutate_kwargs
        )
        rejected += rejected_rb
    updated_by_id = {p["pair_id"]: p for p in updated}
    updated = [updated_by_id.get(p["pair_id"], p) for p in pairs]

    with pairs_path.open("w", encoding="utf-8") as fh:
        for pair in updated:
            fh.write(json.dumps(pair, ensure_ascii=False) + "\n")
    with Path(args.rejected).open("a", encoding="utf-8") as fh:
        for row in rejected:
            fh.write(json.dumps(row, ensure_ascii=False) + "\n")

    certified = sum(1 for p in updated if p.get("mutant"))
    shortfall = [p["pair_id"] for p in updated if not p.get("mutant")]
    print(f"pairs with certified mutant: {certified}/{len(updated)}; "
          f"rejected candidates receipted: {len(rejected)}")
    print(f"operator histogram: {op_histogram(updated)}")
    if shortfall:
        print(f"SHORTFALL parents (no certified mutant): {shortfall}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
