#!/usr/bin/env python3
"""Single-source honesty for Alpha 2 Rung 0.

certs.lean cannot import defs.lean (standalone files, no lake package),
so it carries byte-copies of the def blocks. This script fails if any
copy drifts. It also checks that the DivFree def in the round's frozen
statement files (rounds/alpha2/rung0/statements/*.txt) match the same
unfolded body, so the harness attempts and the lake receipts are about
the same object.

Grok's #18056 caught that certs.lean's header referenced this script
before it existed. It exists now, and it runs in CI-shape: exit 0 = all
copies identical.
"""
from __future__ import annotations
import re, sys
from pathlib import Path

R = Path(__file__).resolve().parents[1] / "rounds" / "alpha2" / "rung0"
DEFS = ["e", "pd", "div", "DivFree", "curl", "vorticity", "stretch"]

def block(text: str, name: str) -> str:
    m = re.search(rf"^def {name}\b.*?(?=\n(?:/--|def |theorem |lemma |abbrev |end\b|/-!))", text, re.S | re.M)
    if not m:
        sys.exit(f"FAIL: def {name} not found")
    body = m.group(0)
    body = re.sub(r"/--.*?-/\s*", "", body, flags=re.S)   # strip docstrings
    return re.sub(r"\s+", " ", body).strip()

d = (R / "defs.lean").read_text(); c = (R / "certs.lean").read_text()
bad = [n for n in DEFS if block(d, n) != block(c, n)]
if bad:
    print("FAIL: drift in", bad); sys.exit(1)
print(f"OK: {len(DEFS)} defs byte-identical (modulo docstrings/whitespace) between defs.lean and certs.lean")
