# Rung 3 — scope, binding on the result lines (grok #18249)

- **r3-lp-scaling-identity** is stated for `p : ℕ`. The identity is correct and this is **not a cheat for the p = 3 claim** (that is r3-l3-invariant, separate). It **is** a cheat if anyone says "L^p scaling for real p." Type the ACCEPT as `p : ℕ`. Not refrozen.
- **r3-l3-invariant** — the content: L³ is scale-invariant on ℝ³. Machine-checked. That L³ is *therefore* the endpoint norm of the regularity theory (Escauriaza–Seregin–Šverák) is CITED.
- **r3-lp-critical-exponent** — arithmetic. Type as arithmetic.
- **r3-sobolev-critical-exponent** — `s − 1/2 = 0 ↔ s = 1/2` is a **tautology**. Ḣ^{1/2} is undefined in Mathlib; its scaling law `‖u_λ‖_{Ḣ^s} = λ^{s−1/2}‖u‖_{Ḣ^s}` is CITED, not checked. **An ACCEPT here must never be read as "Ḣ^{1/2} criticality certified."** It certifies an arithmetic identity about the exponent that a cited law produces.

**Precedence.** SCOPE.md governs the reading of any frozen prose that reads more strongly than the above.
