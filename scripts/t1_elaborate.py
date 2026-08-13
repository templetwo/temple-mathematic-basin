#!/usr/bin/env python3
"""Trusted-path T1 readiness: run candidate terms through verdict.py.

This seat (mbp-grok agent) cannot nest sandbox-exec. Run from Terminal or
mbp-claude. Exit 0 only if the cap-set target type-mismatches a dummy proof
(so the type elaborated) and does not die on an undefined universe parameter.

No model call. No pairs.jsonl write.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO))

from t1.statements import CAP_SET_BEAT_CUBE, UNIVERSE_CONTROL  # noqa: E402
from verdict import verdict  # noqa: E402

PROJECT = REPO / "lean"
OUT = REPO / "t1" / "elaborate_receipt.json"


def _run(name: str, proposition: str) -> dict:
    result = verdict(
        proposition,
        "PROVABLE",
        "True.intro",
        project_dir=PROJECT,
        timeout_seconds=180,
    )
    log = result.compile_log or ""
    return {
        "name": name,
        "status": result.status.value,
        "reject_reason": result.reject_reason,
        "compiled": result.compiled,
        "axioms": list(result.axioms),
        "universe_error": "undefined universe" in log,
        "sandbox_denied": "sandbox_apply" in log or result.reject_reason
        in {"sandbox_unavailable"},
        "log_tail": log[-800:],
    }


def main() -> int:
    rows = [
        _run("cap_set_beat_cube", CAP_SET_BEAT_CUBE),
        _run("universe_control", UNIVERSE_CONTROL),
    ]
    cap, uni = rows
    # Success: dummy proof rejected after compile, and not a universe pin hit.
    cap_ok = (
        cap["status"] == "REJECT"
        and cap["compiled"] is True
        and cap["reject_reason"] == "compile_error"
        and not cap["universe_error"]
        and not cap["sandbox_denied"]
    )
    receipt = {
        "ok": cap_ok,
        "note": "dummy body True.intro must fail; universe_error must be false on cap_set",
        "results": rows,
    }
    OUT.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipt, indent=2))
    return 0 if cap_ok else 2


if __name__ == "__main__":
    raise SystemExit(main())
