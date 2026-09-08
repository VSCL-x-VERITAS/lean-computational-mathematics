# Current-tree searches, first increment

Session `codex-start-1-v5-0-1-20260908`, 2026-09-08. Current mathematical tree:
integrated main `9e2225705fed906b1120d55105d607baabef57c9`, work HEAD
`c5110fa68d0dc140cafe2809fea44ef1adf6e944` with gate/ledger-only changes.
Pinned Mathlib checkout: `e8ea1afc32790ce1d4e1a4e45cc412ba9388716b`.

Search tool: `rg` over current ComputationalMathematics and pinned Mathlib
source, followed by direct source reads. A native focused build is running;
no candidate is counted as audited reuse until it resolves and a current
independent audit is accepted. Old checkpoint branches were not imported.

| Source rows or prerequisite | Query terms | Candidates and disposition |
|---|---|---|
| SCALAR-HYPERBOLICITY | hyperbolic, scalar, eigenbasis, scalarEquation_isHyperbolic | Existing `NumStability.leveque01_scalarEquation_isHyperbolic` in canonical Source/LeVeque/Chapter01/ScalarHyperbolicity.lean is the intended integrated producer. Its one-by-one matrix criterion covers every real speed, including zero. Avoid a second scalar proof. |
| HYPERBOLIC-MATRIX-DEFINITION | hyperbolic, linearlyIndependent, independent_real_eigenvectors | Existing `NumStability.isRealHyperbolicMatrix_iff_independent_real_eigenvectors` in Analysis/PartialDifferentialEquations/Hyperbolicity.lean and thin `leveque01_hyperbolicMatrixDefinition` wrapper. Intended audited reuse, with the Fin m and zero-dimensional convention checked explicitly. |
| EIGENBASIS-UNIQUE-DECOMPOSITION | eigenbasis, exists_unique_eigenbasis_decomposition, equivFun_symm_apply | Existing reusable `IsRealHyperbolicMatrix.exists_unique_eigenbasis_decomposition` and `leveque01_hyperbolicMatrix_uniqueEigenbasisDecomposition` wrapper. Reuse the unique-coordinate construction, not a new proof. |
| Independent eigenvector family to basis | basisOfPiSpaceOfLinearIndependent, coe_basisOfPiSpaceOfLinearIndependent | Exact Mathlib declarations in LinearAlgebra/FiniteDimensional/Lemmas.lean:248 and :258 underpin the existing reusable producer. |
| Basis reconstruction and uniqueness | equivFun_symm_apply, basisFun_apply, of_subsingleton, linearIndependent_unique_iff | `Module.Basis.equivFun_symm_apply` in Basis/Defs.lean:239 and `LinearIndependent.of_subsingleton` in LinearIndependent/Defs.lean:869 are suitable supporting API. The latter alone is insufficient for the full hyperbolicity/source conclusion. |
| Competing hyperbolicity meanings | def/theorem Hyperbolic, IsDiagonalizable, diagonalizable | Mathlib Matrix/GeneralLinearGroup/FinTwo.lean `IsHyperbolic` classifies a two-by-two general-linear element by discriminant and does not match the arbitrary real eigenbasis predicate. Reject as a replacement. Hyperbolic trigonometric and geometric results are unrelated name matches. |
| Reopened (1.1), (1.5), (1.8), (1.10) | constantCoefficientSystemResidual, linearAcoustics, conservationLawResidual, IntegralConservationLaw | Existing ConstantCoefficientLinearSystem, LinearAcoustics, ConservationLaw, and IntegralConservationLaw modules supply candidate definitions. They require definition-correspondence audit; a solution-certificate projection is not accepted as a replacement claim. |
| New exact acoustics conservation row | linearAcoustics, constantLinearFlux, conservationLaw | Existing Source/LeVeque/Chapter01/AcousticsConservationForm.lean is a candidate wrapper over the integrated linear-flux result. Its exact contract is still to resolve. |
| Linear Riemann construction and ray-zero definition | Riemann, rayZero, hyperbolic | Existing FiniteVolume/RiemannData.lean and RiemannInterface.lean expose data/solution structures. No construction or ray-zero equivalence has yet been selected; a certified-solver premise is not evidence that a solver has been constructed. |
| Second-order classification, one-step definition, nonconservative/source-term claims, splitting | SecondOrder/hyperbolic, oneStep, wave.equation, balance.law, dimensionalSplitting | LinearAcousticsWaveEquation and OperatorSplitting are candidate context; they do not alone establish second-order classification, arbitrary one-step dependence, or the new qualitative claims. No compatible final producer selected. Review the four UNCLASSIFIED claims before implementation. |

These are documented searches, not proof of global semantic absence. Two
navigation guesses (HyperbolicMatrix.lean/EigenbasisDecomposition.lean) were
absent; both declarations actually reside in Hyperbolicity.lean. A guessed PDE
root and Basis/Pi.lean path were also absent, so those failed path probes are
not negative semantic evidence; successful searches used the actual Analysis
and LinearAlgebra paths. Further row-specific searches and Lean resolution
remain required before subsequent implementations.

## Resolved hyperbolicity prerequisites and next transport rows

The native focused build of canonical and compatibility ScalarHyperbolicity
and Hyperbolicity modules completed with exit code 0 (2064 jobs). The subsequent
declaration/axiom check also exited 0; its exact input and output are retained
as `hyperbolicity-declaration-checks.lean` and
`hyperbolicity-declaration-checks.txt`. All five inspected public theorems use
only `propext`, `Classical.choice`, and `Quot.sound`. This establishes Lean
resolution; fresh semantic audit decisions remain separate.

Further actual current-tree `rg` queries used
`isOneDimensionalSpecialization|scalarAdvection_iff|linearAdvection.*iff|oneWayWave|scalarHyperbolic`
over canonical PDE, LeVeque source, and pinned Mathlib Analysis files. Direct
reads selected the following integrated declarations for new audits:

| Row | Selected declaration and supporting producer | Rejected substitution |
| --- | --- | --- |
| EQ-1.2-ADVECTION | `NumStability.leveque01_equation02_isOneDimensionalSpecialization`; the existing componentwise derivative bridge uses `hasDerivAt_pi`, `scalarAsOneComponentSystem`, and `constantCoefficientScalarMatrix`. | A theorem asserting that every unconstrained field solves advection is false; the selected source object is the scalar equation form and specialization. |
| EQ-1.4-ONE-WAY-WAVE | `NumStability.leveque01_equation04_scalarHyperbolicOneWayModel`; reuses scalar hyperbolicity, `travelingWave_isLinearAdvectionSolutionAt`, and `travelingWave_at_translated_point`. | A direction-free residual omits the source's positive speed and rightward interpretation; no new scalar proof is needed. |
| ADVECTION-WAVE-IDENTITY | `NumStability.leveque01_advectionWaveIdentity`; both source abbreviations refer to the same `IsLinearAdvectionSolutionAt`. | A new independent wave predicate or duplicate transport proof would add redundant ownership. |

New task metadata retains each historical source locator and uses the current
canonical owner module. Historical source contexts and decisions are not copied
as judgments. The new metadata writer verifies the target is present and unchanged
at the integrated baseline. No source equation is counted as reused by this search.
