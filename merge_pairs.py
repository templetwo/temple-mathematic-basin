"""Merge certified mutants from a subset run back into the corpus.

A deep-cap or exclusion run (mutate.py --pairs <subset>) works on a slice of
corpus/pairs.jsonl so the run does not pay to re-attempt parents whose
candidates are already exhausted. Its output is a subset file carrying the
same pair_ids. This merges that subset back.

The merge is deliberately narrow. It replaces a corpus line only when the
subset carries a certified mutant the corpus lacks, and it refuses outright
if the subset would change a parent, drop a mutant, or introduce a pair_id
the corpus does not already hold. Nothing is edited in place: the corpus is
rewritten from the merged list, and the refusal cases exit non-zero before
any write happens.

    python3 merge_pairs.py --subset <path> [--pairs corpus/pairs.jsonl] [--dry-run]
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent


def load(path: Path) -> list[dict]:
    with path.open(encoding="utf-8") as fh:
        return [json.loads(line) for line in fh if line.strip()]


def merge(corpus: list[dict], subset: list[dict]) -> tuple[list[dict], list[str], list[str]]:
    """Return (merged, adopted_ids, refusals). Refusals are fatal; a non-empty
    refusal list means the caller must not write."""
    by_id = {p["pair_id"]: p for p in corpus}
    refusals: list[str] = []
    adopted: list[str] = []
    updates: dict[str, dict] = {}

    for sub in subset:
        pid = sub["pair_id"]
        cur = by_id.get(pid)
        if cur is None:
            refusals.append(f"{pid}: not present in corpus — subset must be a slice, not a source of new parents")
            continue
        if sub["parent"] != cur["parent"]:
            refusals.append(f"{pid}: parent differs between subset and corpus — refusing, parents are frozen after P1")
            continue
        if cur.get("mutant") and not sub.get("mutant"):
            refusals.append(f"{pid}: corpus holds a certified mutant the subset lost — refusing to regress")
            continue
        if not sub.get("mutant"):
            continue  # still a shortfall; nothing to adopt, not an error
        if cur.get("mutant"):
            continue  # already certified; a swap belongs to rebalance, not merge
        cert = sub["mutant"].get("certificate") or {}
        if cert.get("kernel_result") != "ACCEPT":
            refusals.append(f"{pid}: mutant carries no ACCEPT certificate — refusing")
            continue
        updates[pid] = sub
        adopted.append(pid)

    merged = [updates.get(p["pair_id"], p) for p in corpus]
    return merged, adopted, refusals


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--subset", required=True, help="subset file written by a mutate.py run")
    parser.add_argument("--pairs", default=str(REPO_ROOT / "corpus" / "pairs.jsonl"))
    parser.add_argument("--dry-run", action="store_true", help="report the merge, write nothing")
    args = parser.parse_args()

    pairs_path = Path(args.pairs)
    corpus = load(pairs_path)
    subset = load(Path(args.subset))

    before = sum(1 for p in corpus if p.get("mutant"))
    merged, adopted, refusals = merge(corpus, subset)

    if refusals:
        for line in refusals:
            print(f"REFUSED {line}", file=sys.stderr)
        return 2

    after = sum(1 for p in merged if p.get("mutant"))
    print(f"certified mutants: {before} -> {after} (+{len(adopted)})")
    if adopted:
        print(f"adopted: {', '.join(adopted)}")
    for pid in adopted:
        pair = next(p for p in merged if p["pair_id"] == pid)
        print(f"  {pid} via {pair['mutation_op']}")

    if args.dry_run:
        print("dry run — corpus not written")
        return 0

    with pairs_path.open("w", encoding="utf-8") as fh:
        for pair in merged:
            fh.write(json.dumps(pair, ensure_ascii=False) + "\n")
    print(f"wrote {len(merged)} pairs to {pairs_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
