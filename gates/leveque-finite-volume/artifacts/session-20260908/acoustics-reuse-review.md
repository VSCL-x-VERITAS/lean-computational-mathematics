# Acoustics and eigenmode reuse candidates

Current-tree searches used `linearAcoustics`, `acoustic.*(mode|wave|matrix)`,
`hasDerivAt_pi`, `HasDerivAt.add`, `HasDerivAt.sub`, `sq_sqrt`, `sqrt_pos`,
and matrix `mulVec`/`vecCons` terms. They covered the canonical project
library and the pinned Mathlib derivative, matrix-notation, and real-square-root
modules. Direct reads inspected the actual source owners listed below.
A Windows `rg` path wildcard and two guessed eigenmode filenames failed;
successful follow-ups used `rg --files` and the actual owners. Those failed
navigation probes are not negative mathematical evidence.

| Source object | Selected integrated producer or outstanding obligation |
| --- | --- |
| (1.5) equation definition | `IsLinearAcousticsSolutionAt` exposes four scalar derivatives and both displayed residuals. The existing theorem `leveque01_equation05_linearAcoustics` projects a certificate, so it is not selected for the reopened definition row. A correspondence statement on independently supplied pressure, velocity, coefficients, and point remains to be added and audited. |
| (1.6) matrix form | `leveque01_equation06_acousticsMatrixForm` directly reuses `linearAcoustics_matrixForm_iff`. The producer uses Mathlib `hasDerivAt_pi` and finite matrix component arithmetic. Avoid a second matrix-form proof. |
| Right acoustic mode | `leveque01_acousticsRightMode` reuses the right-invariant derivative theorem and `Real.sqrt_pos`/`Real.sq_sqrt`. The global solution certificate must be reviewed as an effective-domain assumption, not accepted by its name. |
| Left acoustic mode | `leveque01_acousticsLeftMode` similarly reuses the left-invariant theorem and traveling-wave construction. Preserve the printed q2/w2 discrepancy for independent adjudication; do not silently normalize the source. |
| Acoustic two-wave decomposition | Existing `leveque01_acousticsTwoWaveDecomposition` gives the two forward scalar equations. Its target does not explicitly reconstruct pressure and velocity from the two waves. Independent audit must decide whether this omits source content; no row is closed by identifying the candidate. |
| Eigenvalues as wave speeds | `leveque01_eigenvaluesAreWaveSpeeds` reuses `eigenmodeTravelingWave_isConstantCoefficientSolutionAt`. It shows one eigenmode solves the system at its translation speed. It does not on its own supply a general solution decomposition or a Riemann construction. |
| Acoustic eigenvalues | `leveque01_acousticsMatrixEigenvalues` supplies two nonzero eigenvectors, the -c/+c eigenvector identities, and their translated-profile solutions. Its reusable matrix identities already exist in `LinearAcoustics.lean`. |

Mathlib matrix-notation lemmas implement finite matrix action but do not replace
the PDE matrix-form correspondence. Derivative addition/subtraction and square-root
identities are prerequisites, not source-row conclusions. These are scoped
candidate searches, not proof of global semantic absence. Fresh audits are still
required; all inspected public declarations resolved in the retained 47-theorem
chapter declaration/axiom check.
