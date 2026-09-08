# Issues — chapter 1

Record book, source, or source-to-Lean issues encountered in this scope. Use stable IDs; never delete history—mark superseded or closed entries.

| ID | Source row | Category | Printed issue | Lean artifact | Relation/status | Evidence | Owner/next action |
|---|---|---|---|---|---|---|---|
| LEV-C1-DOMAIN-001 | LEV-CH01-RIEMANN-INTERFACE-FLUX; LEV-CH01-LINEAR-RIEMANN-EIGENSOLUTION | effective solution domain | Printed page 5 admits discontinuous Riemann fields; the displayed rate law on page 4 needs a careful interpretation at endpoint crossings | IsHyperbolicRiemannSolution uses IsIntegralConservationLawSolution, which requires HasDerivAt of every interval mass at every time | OPEN: suspected source-to-Lean mismatch, not yet a certified counterexample or source error | session-20260908/transport-rectangle-reuse-review.md; checked transport-rectangle-candidate.lean and final output | Root and Riemann foundation worker: construct explicit eigenmode solution with time-integrated rectangle balance; independently audit applicability before closing either row |
