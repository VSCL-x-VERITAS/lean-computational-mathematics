# Arbitrary source necessity and an applicability witness

This candidate starts from the previously committed source-term prerequisite
without changing its three theorems. It adds the arbitrary-source direction:
every field satisfying the actual balance equation has integral equal to the
mass derivative minus net endpoint inflow. Derivative uniqueness identifies
that arbitrary source with the previously constructed residual, so its
integrability and budget identity follow from the existing producer.

The explicit applicability witness is a scalar concentration `q(x,t)=t`,
zero transport flux, and uniform source one. The actual time and flux
derivatives satisfy the balance equation, the mass in the unit interval has
derivative one, and the source integral is nonzero. This example prevents
the source necessity argument from relying only on an unsatisfiable premise.
It is a constructed example, not a reaction law printed in the source.

The scoped searches and candidate rejections are recorded in
`source-term-reuse-review.md`. The new steps directly reuse
`HasDerivAt.unique`, `integral_internalProduction_eq_massDefect`,
`hasDerivAt_pi`, derivative rules for constants/identity, and the interval
integral of a constant. No new calculus theorem is introduced. The balance
identity retains arbitrary finite system dimension; the witness uses one component
because the selected contaminant example is scalar.

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/source-term-necessity-candidate.lean`
exited 0. All five printed closures contain only propext, Classical.choice,
and Quot.sound. The first output's unresolved nonzero-vector simplification
is preserved as a failed attempt; the final output has no errors or warnings.
Production must consolidate the copied prerequisite with one reusable owner,
not install both scratch versions. Source audit and the constant-transport
application remain required before closing the source row.
