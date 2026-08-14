#!/usr/bin/env python3
"""Single-source honesty check for t1/iscap_iff.lean.

iscap_iff.lean is self-contained (standalone t1 files cannot import one
another without a lake package), so it carries byte-copies of the two
blind def-blocks and the frozen term's condition. This script fails if
any copy drifts from its source of truth:

  IsCapA      <- t1/iscap_a.lean       (commitment af6e583b...)
  IsCapB      <- t1/iscap_b.lean       (commitment 731cc87a...)
  IsCapFrozen <- t1/cap_set_beat_cube.lean's cap condition (dual-signed)

Exit 0 = all copies byte-identical (whitespace-normalized for the
frozen condition, which is embedded in a larger term). Anything else
is a drift and a round failure.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

T1 = Path(__file__).resolve().parents[1] / "t1"


def def_block(path: Path, name: str) -> str:
    text = path.read_text()
    m = re.search(rf"^def {name}.*?(?=\n\n|\n/--|\ninstance|\ntheorem|\nlemma|\nprivate)",
                  text, re.S | re.M)
    if not m:
        sys.exit(f"FAIL: def {name} not found in {path.name}")
    return m.group(0).strip()


def norm(s: str) -> str:
    return re.sub(r"\s+", " ", s.strip())


iff_text = (T1 / "iscap_iff.lean").read_text()
failures = []

for name, src in [("IsCapA", "iscap_a.lean"), ("IsCapB", "iscap_b.lean")]:
    source = def_block(T1 / src, name)
    copy = def_block(T1 / "iscap_iff.lean", name)
    if source != copy:
        failures.append(f"{name}: copy in iscap_iff.lean drifted from {src}")

# Frozen condition: the AP clause inside cap_set_beat_cube.lean must appear,
# whitespace-normalized, inside IsCapFrozen's body.
frozen_src = (T1 / "cap_set_beat_cube.lean").read_text()
m = re.search(r"\(∀ a ∈ A.*?2 : ℕ\) • b\)", frozen_src, re.S)
if not m:
    sys.exit("FAIL: cap condition not found in cap_set_beat_cube.lean")
cond = norm(m.group(0)[1:-1])  # strip outer parens
frozen_copy = norm(def_block(T1 / "iscap_iff.lean", "IsCapFrozen").split(":=", 1)[1])
if cond != frozen_copy:
    failures.append("IsCapFrozen: body drifted from cap_set_beat_cube.lean's condition")

if failures:
    print("\n".join("FAIL: " + f for f in failures))
    sys.exit(1)
print("OK: IsCapA, IsCapB byte-identical to sources; IsCapFrozen matches the frozen term's condition")
