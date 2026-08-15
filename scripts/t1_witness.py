#!/usr/bin/env python3
"""ALPHA 1 — THE WITNESS ATTEMPT. Fired on Anthony's word, 2026-08-15.

Answers t1/QUESTION.md through TRUSTED verdict.py — the same gate as every
other receipt in this round. The proposition is the frozen obligation
(t1/statements.py CAP_SET_BEAT_CUBE, byte-identical to the dual-signed
receipt), stance PROVABLE, and the body is a witness term.

THE ANSWER (coordinates, since coordinates are the answer):
  W = graph of q(x,y) = x² + y² over (ℤ/3ℤ)², lifted to (ℤ/3ℤ)³:
      (0,0,0) (0,1,1) (0,2,1) (1,0,1) (1,1,2) (1,2,2) (2,0,1) (2,1,2) (2,2,2)
  Nine points, sum (0,0,0). It is a cap because in char 3
      q(a) + q(b) + q(-a-b) ≡ 2·q(a-b)   (mod 3)
  and q is anisotropic over F₃ (q(v)=0 ⇔ v=0), so a zero-sum triple on the
  graph forces a = b. Verified computationally on all 84 triples before
  this file was written; the kernel decides it independently below.

The obligation is existential: n=3, this A, with 3 ≤ 3, the AP condition,
and card > 8. The AP condition and cardinality are closed decidable goals
over Fin 3 → ZMod 3; they are discharged by `decide`, LABELED, which the
first-round synthesis allows for Round 1 controls and the result lane
(Agent 4: shadow lane for structured proof, not a Round 1 gate). No
native_decide, no ofReduceBool, no sorry.

Every attempt — ACCEPT or not — is appended to t1/witness_ledger.json.
UNKNOWN is a legitimate terminal; a REJECT is recorded, never hidden.
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO))

from t1.statements import CAP_SET_BEAT_CUBE  # noqa: E402
from verdict import verdict  # noqa: E402

PROJECT = REPO / "lean"
LEDGER = REPO / "t1" / "witness_ledger.json"

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}

# The nine points, as Lean vector literals over ZMod 3.
POINTS = [
    "![0,0,0]", "![0,1,1]", "![0,2,1]",
    "![1,0,1]", "![1,1,2]", "![1,2,2]",
    "![2,0,1]", "![2,1,2]", "![2,2,2]",
]

WITNESS_SET = "({" + ", ".join(POINTS) + "} : Finset (Fin 3 → ZMod 3))"

# The witness body: exhibit n = 3, the set, then discharge the three
# conjuncts. `decide` on the AP condition and card, labeled.
BODY = f"""⟨3, {WITNESS_SET},
  by decide,  -- 3 ≤ 3
  by decide,  -- labeled: no-3-AP over 9 named points, kernel-decided
  by decide⟩  -- labeled: card > 2^3"""


def main() -> int:
    t0 = time.time()
    r = verdict(CAP_SET_BEAT_CUBE, "PROVABLE", BODY, project_dir=PROJECT,
                timeout_seconds=600)
    wall = round(time.time() - t0, 1)
    axioms = list(r.axioms)
    accepted = r.status.value == "ACCEPT" and set(axioms) <= ALLOWED
    entry = {
        "attempt_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "authorization": "Anthony, 2026-08-15: 'go'",
        "proposition": CAP_SET_BEAT_CUBE,
        "witness_points": POINTS,
        "witness_construction": "graph of q(x,y)=x^2+y^2 over (Z/3)^2; anisotropic q + identity q(a)+q(b)+q(-a-b)=2q(a-b) mod 3",
        "body": BODY,
        "status": r.status.value,
        "reject_reason": r.reject_reason,
        "axioms": axioms,
        "axioms_within_allowlist": set(axioms) <= ALLOWED,
        "wall_seconds": wall,
        "log_tail": (r.compile_log or "")[-600:],
        "terminal": "ACCEPT" if accepted else "REJECT — recorded, not hidden",
    }
    ledger = json.loads(LEDGER.read_text()) if LEDGER.exists() else {"attempts": []}
    ledger["attempts"].append(entry)
    LEDGER.write_text(json.dumps(ledger, indent=1, ensure_ascii=False))
    print(f"status={r.status.value} reason={r.reject_reason} axioms={axioms} wall={wall}s")
    print(f"ledger -> {LEDGER} (attempt {len(ledger['attempts'])})")
    if not accepted:
        print("--- log tail ---")
        print(entry["log_tail"])
    return 0 if accepted else 1


if __name__ == "__main__":
    raise SystemExit(main())
