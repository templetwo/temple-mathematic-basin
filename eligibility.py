"""Deep-mutation eligibility predicate, committed so it can be audited.

§5 prescribes, for a calibration pass landing ABOVE the band, "add mutations
that break a deep invariant rather than a surface inequality." All seven
operators in `mutate.py` are local text substitutions; none touches a
hypothesis. The natural deep-invariant site in this corpus is therefore a
NAMED HYPOTHESIS BINDER — dropping `hp : p.Prime` from a statement produces
something false for a reason rather than by a token swap.

This file exists because the count it produces was first computed on
2026-08-11 by a regex typed inline into a shell command and never committed,
which is precisely the failure §13 records about the corpus harvester: an
uncommitted tool produced a load-bearing number and the number outlived the
tool. The predicate below is that regex, verbatim, so the number can be
re-derived and disagreed with.

DETECTOR, NOT AN OPERATOR. Nothing here mutates a statement or feeds
`mutate.py`. It reports where a deep mutation COULD apply. Applicability is
not efficacy: a hardened mutant must also stay mathematically false, stay
certifiable, and actually move an arm's committed stance, and this predicate
speaks to none of those.

KNOWN BIAS, stated because a detector whose blind spot is undocumented is not
auditable: `_HYPOTHESIS_BINDER` requires the binder NAME to begin with `h`.
That is a Mathlib naming convention, not a rule of the language. A hypothesis
bound as `(prime_p : p.Prime)` is invisible to it. `coverage_gap` reports how
many binders the predicate declines, so the size of that blind spot is a
measured quantity rather than an assumption — it is a diagnostic on this
predicate, NOT a rival eligibility rule, and `H` is computed from
`hypothesis_binder_sites` alone.

MEASURED, 2026-08-11, against the 105-parent corpus: the predicate finds 20
sites across 16 parents, and `coverage_gap` declines 52 binders of which ZERO
are Prop-like. Every declined binder is an ordinary typed variable — `(n : ℕ)`,
`(x : ℝ)`. On this corpus the h-prefix bias costs nothing. That is a fact about
this corpus, not about the convention: a future parent naming a hypothesis
without the prefix would still be missed, so re-run the gap check whenever
parents are added.
"""

from __future__ import annotations

import re

# The predicate as first used, unchanged. Matches a parenthesised or braced
# binder whose name begins with `h`, capturing name and type.
_HYPOTHESIS_BINDER = re.compile(r"[({]\s*(h[A-Za-z0-9_]*)\s*:\s*([^)}]+)[)}]")

# Any parenthesised/braced binder carrying a colon, regardless of name. Used
# ONLY to measure what the predicate above declines.
_ANY_BINDER = re.compile(r"[({]\s*([A-Za-z_][A-Za-z0-9_']*)\s*:\s*([^)}]+)[)}]")


def hypothesis_binder_sites(statement: str) -> list[tuple[str, str]]:
    """(name, type) for each named hypothesis binder. One deep-mutation site
    each: the binder can be dropped, and the result is false for a reason."""
    return [(n, t.strip()) for n, t in _HYPOTHESIS_BINDER.findall(statement)]


def is_eligible(statement: str) -> bool:
    """Whether a parent admits at least one deep-invariant mutation site."""
    return bool(hypothesis_binder_sites(statement))


def coverage_gap(statement: str) -> list[tuple[str, str]]:
    """Binders `_ANY_BINDER` sees that `_HYPOTHESIS_BINDER` declines, i.e. the
    predicate's blind spot on this statement. Diagnostic only — never an
    eligibility rule. A binder here is not evidence of a hypothesis; most are
    ordinary typed variables like `(n : ℕ)`."""
    taken = {n for n, _ in _HYPOTHESIS_BINDER.findall(statement)}
    return [(n, t.strip()) for n, t in _ANY_BINDER.findall(statement) if n not in taken]
