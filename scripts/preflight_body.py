#!/usr/bin/env python3
"""Pre-flight for attempt bodies — phase 2 #10 (grok #18249).

The Lean 4.32.2 unusedSimpArgs linter PANICs (TryThis.getIndentAndColumn,
UTF-8 offset) when formatting a hint inside a long single-line body, and
verdict.py correctly fail-closes on any PANIC even with clean axioms. It has
cost three attempts this round (r0-C2 first pass, r0-ns-C1, and earlier).

This is a SEAT-SIDE pre-flight, deliberately NOT in round.py: round.py is a
registered artifact and adding Lean-invoking logic there would re-register
the prereg for a linter workaround. Run before staging an attempt:

    python3 scripts/preflight_body.py rounds/<name>/attempts/NN.txt

It compiles the body via lake against a stub statement and reports any
'simp argument is unused' warnings and any PANIC, so the seat strips them
BEFORE the attempt hits the harness. Exit 0 = clean. It does not touch the
ledger and is not part of the round.
"""
import re, subprocess, sys, tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
body_path = Path(sys.argv[1])
body = body_path.read_text()
# find the round's frozen statement to compile against the REAL target
rd = body_path.parent.parent
import json
stmt = json.loads((rd / "FREEZE.json").read_text())["statement"] if (rd / "FREEZE.json").exists() else None
if stmt is None:
    sys.exit("no FREEZE.json — preflight needs the frozen statement")
src = f"import Mathlib\nset_option maxHeartbeats 1000000\ntheorem preflight_target : {stmt} := {body}\n"
with tempfile.NamedTemporaryFile("w", suffix=".lean", dir=REPO / "lean" / "tmp", delete=False) as f:
    f.write(src); tmp = f.name
r = subprocess.run(["lake", "env", "lean", tmp], cwd=REPO / "lean", capture_output=True, text=True, timeout=600)
log = r.stdout + r.stderr
unused = re.findall(r"This simp argument is unused:\s*\n\s*(\S+)", log)
panic = "PANIC" in log
errors = [l for l in log.splitlines() if ": error" in l]
print(f"unused simp args: {unused or 'none'}")
print(f"PANIC: {panic}")
print(f"errors: {len(errors)}")
for e in errors[:5]: print("  ", e[:140])
sys.exit(0 if (not unused and not panic and not errors) else 1)
