# Current-tree candidates for the next source-equation audits

The ten metadata successors below refer to unchanged producers already in
the integrated mathematical baseline `9e2225705fed906b1120d55105d607baabef57c9`.
The metadata helper checked each owner exists at that commit and is unchanged.
It copies no historical judgments and retains the immutable selected source
locators. Current source reads inspected every listed wrapper and the relevant
reusable definitions. The already completed Chapter 1 declaration/axiom run
resolved all of these public names; source correspondence still needs fresh
isolated audit roles.

| Source object | Selected existing producer | Scope requiring independent audit |
| --- | --- | --- |
| Equation (1.7) | `leveque01_equation07_pressureWave`, `LinearAcousticsSolution.pressureSecondOrderWaveAt` | Actual second derivatives, mixed-partial equality, and positive material constants. |
| Equation (1.9) | `leveque01_equation09_quasilinearForm`, `conservationLaw_iff_quasilinearAt` | Actual flux derivative and spatial slice derivative; no Jacobian free of the flux. |
| Linear-flux specialization | `leveque01_linearFlux_specializesEquation01`, `conservationLaw_constantLinearFlux_iff` | Spatial differentiability is explicit because a singular matrix can hide a nonsmooth state. |
| Contaminant advection flux | `leveque01_advectionLinearFlux_fromMassConservation`, `integralConservationLaw_implies_pointwise` | Source conservation-to-advection direction, scalar/component bridge, interchange and continuity hypotheses. |
| Smooth integral-to-differential implication | `leveque01_integralLaw_impliesDifferentialLaw_of_smooth`, `integralConservationLaw_implies_pointwise` | Classical smooth regime; must not certify discontinuous endpoint crossings. |
| Cell-average definition | `leveque01_finiteVolumeCellAverage_spec`, `oneDimensionalCellAverage_isCellAverage` | Positive cell width, genuine integrability, and one-dimensional source scope. |
| Conservative finite-volume update | `leveque01_finiteVolumeFluxUpdate_sourceContract`, `sum_finiteVolumeCellTotalBalance` | Actual volume averages, neighbor-local flux, approximation tolerance, abstract mesh and boundary cancellation; no particular high-order method. |
| Equation (1.11) | `leveque01_equation11_characterization`, `isRiemannData_iff_exists_valueAtOrigin` | Exact two-state data with a free origin value; equation-plus-data definition is now separate. |
| Dimensional splitting | `leveque01_dimensionalSplitting_sourceContract`, `coordinateFractionalSweep_executes` | Coordinate coverage, permitted sweep/fraction choices, rectangular or logically rectangular grid, and actual meaning of the solve structure. |
| Heterogeneous averaging | `leveque01_heterogeneousMaterialCellAverage_sourceContract`, `CellMaterialAveragingRule` | Model-selected averaging rather than a forced arithmetic mean; locality/constants axioms and the differing-cell premise require careful effective-domain audit. |

Current project searches used the exact reusable names in the table across
`ComputationalMathematics/Analysis/PartialDifferentialEquations`. Pinned Mathlib
analysis/measure searches used `quasilinear`, `RiemannData`, `finiteVolume`,
`OperatorSplitting`, and `Acoustics`. The `quasilinear` matches in
`Analysis/Convex/Quasiconvex.lean` concern functions both quasiconvex and
quasiconcave, not PDE linearization, and were rejected. No replacement of the
selected integrated PDE producers was warranted by those scoped searches.
This is not evidence of global semantic absence or a new proof of any source
claim. Reusing these producers avoids a second implementation while the
audit may still require target revisions or applicability evidence.
