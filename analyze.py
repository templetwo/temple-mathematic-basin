"""Aggregation rule and E1. Nothing that is not a frozen estimand.

This file is the ONE place the 3-of-4 commit rule lives (spec §6, §10):
an arm holds a committed stance on an item iff 3 or 4 of its four samples
agree on the same stance in {PROVABLE, REFUTABLE, UNKNOWN}; anything else —
including agreement diluted by MALFORMED samples — is UNKNOWN. MALFORMED is
a protocol failure, not a stance, and can never contribute to agreement.

Certified stance per sample: an ACCEPT earns the claimed stance; a REJECT,
an abstention, or a MALFORMED sample earns UNKNOWN — a proof that does not
check earns nothing (spec §7: certified stance is what the evidence earns
at the acceptance surface).

Implemented estimands, P2 scope (the rest arrive with their phases, E2-E5
at P7): E1 per-arm accuracy, claimed and certified, per stratum; per-arm
consistency (all four samples agree); malformed / abstention rates.

Model-string discipline: any (run_id, arm) whose served strings drifted is
excluded from every number and reported (spec §6: invalidated, not patched).

Run identity (V0 debt 1, 2026-08-12): a runs/*.jsonl file may hold several
run_ids — a smoke run beside the real one. Aggregates pool across run_ids by
default (the long-standing contract), but the pooling can no longer be
silent: the output carries a top-level "run_ids" count, and --run-id filters
to a single run so every number in the record can be reproduced by the tool
that made it. The recorded P4 gate is `--run-id 2026-08-11T07:49:50Z` on
runs/2026-08-11.jsonl; without the filter that file reports 68 pooled items,
a figure that appears nowhere in the record.
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

from arms import STANCES

REPO_ROOT = Path(__file__).resolve().parent
SAMPLES_PER_ITEM = 4


def committed_stance(sample_stances: list[str]) -> str:
    """The 3-of-4 rule. Input: stance_claimed (or certified) for one item."""
    counts = Counter(s for s in sample_stances if s in STANCES)
    for stance, n in counts.items():
        if n >= 3:
            return stance
    return "UNKNOWN"


def certified_sample_stance(record: dict) -> str:
    if record["kernel_result"] == "ACCEPT" and record["stance_claimed"] in STANCES:
        return record["stance_claimed"]
    return "UNKNOWN"


def load_records(paths: list[Path]) -> list[dict]:
    records = []
    for path in paths:
        with path.open(encoding="utf-8") as fh:
            records.extend(json.loads(line) for line in fh if line.strip())
    return records


def split_drifted(records: list[dict]) -> tuple[list[dict], list[str]]:
    """Exclude any (run_id, arm) whose served model string was not constant."""
    served: dict[tuple[str, str], set] = defaultdict(set)
    for r in records:
        served[(r["run_id"], r["arm"])].add(r["model_string_served"])
    drifted = {k for k, v in served.items() if len({s for s in v if s is not None}) > 1}
    kept = [r for r in records if (r["run_id"], r["arm"]) not in drifted]
    return kept, [f"{run_id}/{arm}" for run_id, arm in sorted(drifted)]


def report(records: list[dict]) -> dict:
    kept, drifted = split_drifted(records)
    # Group by run as well as item: the four samples of an item belong to one
    # run (spec §10 — run_id is in the schema for this). Without run_id a
    # smoke run plus a full run over the same items would merge into 8-sample
    # groups and silently vanish from every estimand.
    by_run_item: dict[tuple[str, str, str, str], list[dict]] = defaultdict(list)
    for r in kept:
        by_run_item[(r["run_id"], r["arm"], r["stratum"], r["item_id"])].append(r)

    run_ids = Counter(r["run_id"] for r in records)
    out: dict = {"run_ids": dict(sorted(run_ids.items())),
                 "drift_excluded": drifted, "incomplete_groups": [], "arms": {}}
    per_arm: dict[tuple[str, str], dict] = defaultdict(
        lambda: {"items": 0, "claimed_correct": 0, "certified_correct": 0,
                 "consistent": 0, "samples": 0, "malformed": 0, "abstained": 0,
                 "commit_claimed": 0, "commit_certified": 0}
    )
    for (run_id, arm_name, stratum, item_id), samples in sorted(by_run_item.items()):
        samples = sorted(samples, key=lambda r: r["sample_idx"])
        if len(samples) != SAMPLES_PER_ITEM:
            out["incomplete_groups"].append(
                {"run_id": run_id, "arm": arm_name, "item_id": item_id,
                 "samples": len(samples)}
            )
            continue
        ground_truth = samples[0]["ground_truth"]
        claimed = committed_stance([r["stance_claimed"] for r in samples])
        certified = committed_stance([certified_sample_stance(r) for r in samples])
        agg = per_arm[(arm_name, stratum)]
        agg["items"] += 1
        agg["claimed_correct"] += claimed == ground_truth
        agg["certified_correct"] += certified == ground_truth
        agg["commit_claimed"] += claimed != "UNKNOWN"
        agg["commit_certified"] += certified != "UNKNOWN"
        stances = {r["stance_claimed"] for r in samples}
        agg["consistent"] += len(stances) == 1 and stances <= set(STANCES)
        agg["samples"] += len(samples)
        agg["malformed"] += sum(r["stance_claimed"] == "MALFORMED" for r in samples)
        agg["abstained"] += sum(r["stance_claimed"] == "UNKNOWN" for r in samples)

    for (arm_name, stratum), agg in sorted(per_arm.items()):
        n = agg["items"]
        out["arms"][f"{arm_name}/{stratum}"] = {
            "items": n,
            "E1_claimed_accuracy": round(agg["claimed_correct"] / n, 4) if n else None,
            "E1_certified_accuracy": round(agg["certified_correct"] / n, 4) if n else None,
            "commit_rate_claimed": round(agg["commit_claimed"] / n, 4) if n else None,
            "commit_rate_certified": round(agg["commit_certified"] / n, 4) if n else None,
            "consistency": round(agg["consistent"] / n, 4) if n else None,
            "malformed_rate": round(agg["malformed"] / agg["samples"], 4) if agg["samples"] else None,
            "abstention_rate": round(agg["abstained"] / agg["samples"], 4) if agg["samples"] else None,
        }
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="runs/*.jsonl (default: all)")
    parser.add_argument(
        "--run-id",
        help="restrict every number to one run_id; without it, aggregates "
        "pool across every run_id present and say so on stderr",
    )
    args = parser.parse_args()
    paths = [Path(p) for p in args.paths] or sorted((REPO_ROOT / "runs").glob("*.jsonl"))
    if not paths:
        print("no run records found", file=sys.stderr)
        return 1
    records = load_records(paths)
    if args.run_id:
        records = [r for r in records if r["run_id"] == args.run_id]
        if not records:
            print(f"no records for run_id {args.run_id}", file=sys.stderr)
            return 1
    else:
        present = sorted({r["run_id"] for r in records})
        if len(present) > 1:
            print(
                "WARNING: pooling %d run_ids (%s); numbers below match no "
                "single run — pass --run-id to reproduce a recorded figure"
                % (len(present), ", ".join(present)),
                file=sys.stderr,
            )
    print(json.dumps(report(records), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
