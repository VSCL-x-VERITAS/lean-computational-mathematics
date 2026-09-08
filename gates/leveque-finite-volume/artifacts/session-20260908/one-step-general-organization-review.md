# One-step current-data organization review

The new reusable owner is `ComputationalMathematics.Logic.Function.RangeFactorization`.
Its statement is about functions and actual ranges, and it imports only Mathlib.
It composes `Function.Surjective.hasRightInverse` with
`Set.rangeFactorization_surjective`; the existing full-codomain factorization
requires a nonempty output and is not the exact producer for this domain.

`ComputationalMathematics.Source.LeVeque.Chapter01.OneStepCurrentData` is one thin
source correspondence. It uses the same dependence predicate by unfolding
`Function.FactorsThrough` and forwards to the reusable theorem. The existing
finite numerical-field model remains available as a distinct specialization;
no second proof of this general range theorem was introduced. The scratch
bridges and boundary examples remain evidence, not production owners.

The Chapter 1 aggregate imports the new source wrapper and thereby reaches its
reusable dependency. Both new declarations resolve under the pinned native
toolchain, using only `Classical.choice` and `Quot.sound`. Their introduction
commit is `7707ce2ecade640cbacc8f5fe08ad3bd7c3213a3`.
The exact two-file input and actual declaration/build receipts are recorded in
`one-step-general-production-verification.json`. Fresh full layout, tier,
compatibility, hygiene, organization, and build scans remain required.
