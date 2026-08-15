#!/usr/bin/env python3
"""round.py — the round runner, generalized from Alpha 1.

Alpha 1 was run through four hand-written scripts with the statement
hardcoded in each. That is fine for a first round and wrong for a second:
freeze-before-touch only holds if freezing is trivial, and the discipline
only reproduces if it is the default path. This runner takes a ROUND
DIRECTORY and does the sequence for any question:

  rounds/<name>/QUESTION.md      the informal question (frozen object)
  rounds/<name>/statement.txt    the Lean Prop term verdict.py must elaborate
  rounds/<name>/attempts/*.txt   proof bodies, one per file, tried in order

Subcommands:
  freeze <round>     hash QUESTION.md + statement.txt, write FREEZE.json,
                     refuse if a FREEZE.json already exists with different hashes
  elaborate <round>  push statement through verdict.py with a dummy body;
                     PASS = type mismatch (elaborates) with universe_error false
  attempt <round>    run every attempts/*.txt through verdict.py in order,
                     stop at first ACCEPT within the axiom allowlist, append
                     EVERY attempt to attempts_ledger.json (dead-ends kept)
  status <round>     print the scoreboard

Hard rules carried from Alpha 1 (t1/RESULT.md scope, synthesis gates):
  - proposition passed to verdict.py is BYTE-IDENTICAL to statement.txt
  - axiom allowlist {propext, Classical.choice, Quot.sound}; sorryAx,
    native_decide, ofReduceBool in body or axioms = fail
  - the ledger records what happened, never what was hoped
  - UNKNOWN is a legitimate terminal: `attempt` exiting nonzero with a
    full ledger IS the round's honest no-result

Nothing here touches corpus/pairs.jsonl or makes a model call.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO))
from verdict import verdict  # noqa: E402

PROJECT = REPO / "lean"
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
BANNED_IN_BODY = ("native_decide", "ofReduceBool", "sorry")


def sha(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def rdir(name: str) -> Path:
    d = REPO / "rounds" / name
    if not d.is_dir():
        sys.exit(f"no such round: {d}")
    return d


def cmd_freeze(a) -> int:
    d = rdir(a.round)
    q, s = d / "QUESTION.md", d / "statement.txt"
    for f in (q, s):
        if not f.exists():
            sys.exit(f"missing {f.name}")
    new = {"question_sha256": sha(q), "statement_sha256": sha(s),
           "statement": s.read_text().strip(),
           "frozen_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
    fz = d / "FREEZE.json"
    if fz.exists():
        old = json.loads(fz.read_text())
        if (old["question_sha256"], old["statement_sha256"]) != (new["question_sha256"], new["statement_sha256"]):
            print("REFUSED: FREEZE.json exists and the frozen hashes differ. Frozen means frozen.")
            print(f"  frozen  Q={old['question_sha256'][:16]} S={old['statement_sha256'][:16]}")
            print(f"  current Q={new['question_sha256'][:16]} S={new['statement_sha256'][:16]}")
            return 2
        print(f"already frozen, unchanged: Q={old['question_sha256'][:16]} S={old['statement_sha256'][:16]}")
        return 0
    fz.write_text(json.dumps(new, indent=1, ensure_ascii=False))
    print(f"FROZEN {a.round}: Q={new['question_sha256'][:16]} S={new['statement_sha256'][:16]} -> {fz.name}")
    return 0


def _frozen_statement(d: Path) -> str:
    fz = d / "FREEZE.json"
    if not fz.exists():
        sys.exit("not frozen — run `round.py freeze` first; the statement must be hashed before anything touches it")
    f = json.loads(fz.read_text())
    # Byte-level drift check against the frozen hash, not normalized text:
    # the first draft compared .strip()'d strings and let a trailing-space
    # tamper through `elaborate` with a PASS. Caught in the runner's own
    # tamper test before it was trusted. Frozen means the bytes.
    if sha(d / "statement.txt") != f["statement_sha256"]:
        sys.exit("statement.txt bytes differ from FREEZE.json hash — refuse to run against an unfrozen statement")
    return f["statement"]


def cmd_elaborate(a) -> int:
    d = rdir(a.round)
    prop = _frozen_statement(d)
    r = verdict(prop, "PROVABLE", "True.intro", project_dir=PROJECT, timeout_seconds=300)
    log = r.compile_log or ""
    universe_error = "undefined universe" in log or "universe level" in log
    elaborated = r.status.value == "REJECT" and r.reject_reason == "compile_error" and "Type mismatch" in log
    out = {"status": r.status.value, "reject_reason": r.reject_reason, "elaborated": elaborated,
           "universe_error": universe_error, "log_tail": log[-500:]}
    (d / "elaborate_receipt.json").write_text(json.dumps(out, indent=1, ensure_ascii=False))
    verdict_word = "PASS — harness sees the statement" if elaborated and not universe_error else "FAIL"
    print(f"elaborate {a.round}: {verdict_word} (status={r.status.value}, universe_error={universe_error})")
    return 0 if elaborated and not universe_error else 1


def cmd_attempt(a) -> int:
    d = rdir(a.round)
    prop = _frozen_statement(d)
    bodies = sorted((d / "attempts").glob("*.txt")) if (d / "attempts").is_dir() else []
    if not bodies:
        sys.exit("no attempts/*.txt — write a proof body first")
    lp = d / "attempts_ledger.json"
    ledger = json.loads(lp.read_text()) if lp.exists() else {"round": a.round, "attempts": []}
    accepted = None
    for b in bodies:
        body = b.read_text()
        banned = [t for t in BANNED_IN_BODY if t in body]
        t0 = time.time()
        if banned:
            r_status, r_reason, axioms, log = "REFUSED", f"banned_in_body:{','.join(banned)}", [], ""
        else:
            r = verdict(prop, "PROVABLE", body, project_dir=PROJECT, timeout_seconds=a.timeout)
            r_status, r_reason, axioms, log = r.status.value, r.reject_reason, list(r.axioms), (r.compile_log or "")
        clean = r_status == "ACCEPT" and set(axioms) <= ALLOWED
        entry = {"attempt_file": b.name, "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                 "status": r_status, "reject_reason": r_reason, "axioms": axioms,
                 "axioms_within_allowlist": set(axioms) <= ALLOWED, "wall_seconds": round(time.time() - t0, 1),
                 "log_tail": log[-500:], "terminal": "ACCEPT" if clean else "not accepted — recorded"}
        ledger["attempts"].append(entry)
        lp.write_text(json.dumps(ledger, indent=1, ensure_ascii=False))
        print(f"  {b.name}: {r_status} {r_reason or ''} axioms={axioms} {entry['wall_seconds']}s")
        if clean:
            accepted = b.name
            break
    if accepted:
        print(f"ACCEPT via {accepted}. Ledger: {lp.name} ({len(ledger['attempts'])} attempts recorded)")
        return 0
    print(f"NO ACCEPT. {len(ledger['attempts'])} attempts recorded in {lp.name}. This is a legitimate UNKNOWN terminal if the ledger is complete.")
    return 1


def cmd_status(a) -> int:
    d = rdir(a.round)
    fz = d / "FREEZE.json"; er = d / "elaborate_receipt.json"; lp = d / "attempts_ledger.json"
    print(f"round: {a.round}")
    print(f"  frozen:     {'yes  Q=' + json.loads(fz.read_text())['question_sha256'][:16] if fz.exists() else 'NO'}")
    if er.exists():
        e = json.loads(er.read_text()); print(f"  elaborates: {'yes' if e['elaborated'] and not e['universe_error'] else 'NO'}")
    else:
        print("  elaborates: not run")
    if lp.exists():
        L = json.loads(lp.read_text())["attempts"]
        acc = [x for x in L if x["terminal"] == "ACCEPT"]
        print(f"  attempts:   {len(L)} recorded, {'ACCEPT via ' + acc[0]['attempt_file'] if acc else 'no accept yet'}")
    else:
        print("  attempts:   none")
    return 0


def main() -> int:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    for name, fn in (("freeze", cmd_freeze), ("elaborate", cmd_elaborate), ("attempt", cmd_attempt), ("status", cmd_status)):
        sp = sub.add_parser(name); sp.add_argument("round"); sp.set_defaults(fn=fn)
        if name == "attempt":
            sp.add_argument("--timeout", type=int, default=600)
    a = p.parse_args()
    return a.fn(a)


if __name__ == "__main__":
    raise SystemExit(main())
