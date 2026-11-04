# Actual-mean spectrum support

The additive support modules introduced on 2026-10-26 keep the displayed
block-constant matrix separate from the true mean of the loopless stochastic
block model. They do not change the interpretation or acceptance of a numbered
source claim.

`Analysis.Eigenvalues.Multiplicity` supplies three reusable bridges: counting a
spectral value by eigenspace dimension even when that value is absent, and
transporting eigenspaces and their dimensions between matrix coordinate
functions and the Euclidean realization. It imports only Mathlib and reuses
the existing symmetric spectral theorem.

`Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.ActualSpectrum`
composes the existing actual-expectation equality, diagonal correction,
community zero-sum kernel and nonzero-signal spectrum APIs. Its seven results
identify the mean matrix, residual eigenspace and dimension, residual-value
existence, symmetry, sorted residual multiplicity and complete signed spectrum.
The two signal values can coincide at `q = 0`. The residual value `-p` has
multiplicity `2*k-2` and is absent for singleton communities.

The existing `BalancedFinSBM` ordered-eigenvalue and positive-gap producers
remain canonical for the flattened `Fin (2*k)` representation. Their positive
`q` premise is preserved. The new product-indexed complete-spectrum interface
also covers `q = 0`; it adds no second spectral decomposition or population
definition.

Independent static review covered all ten declarations through eight lenses
and requested no changes. Separate-module compilation and a canonical-only
import check passed, including the exact complete-spectrum interface. All ten
declarations reported only `propext`, `Classical.choice` and `Quot.sound`.
These checks do not constitute source-faithfulness acceptance, whole-unit
organization closure or publication.
