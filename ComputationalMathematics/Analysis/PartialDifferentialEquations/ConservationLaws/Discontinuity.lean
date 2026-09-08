/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
# Discontinuity and classical conservation-law predicates

Rectangle conservation gives temporal mass differentiation almost everywhere
on each fixed interval. Spatial state discontinuity prevents state derivatives
and quasilinear classical solutionhood. The conservative residual is excluded
only when the spatial composed flux is discontinuous.
-/

open MeasureTheory

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- Any finite-vector rectangle solution has a mass derivative almost everywhere
on each fixed spatial interval. A spatial state discontinuity excludes its
spatial derivative and every quasilinear classical residual at that point.
The exceptional null set in time may depend on the spatial interval. -/
theorem IsRectangleConservationLawSolution.discontinuity_comparison
    {q : ℝ → ℝ → ι → ℝ} {flux : (ι → ℝ) → ι → ℝ}
    (hrectangle : IsRectangleConservationLawSolution q flux)
    {x t : ℝ} (hjump : ¬ ContinuousAt (fun ξ => q ξ t) x) :
    (∀ a b, ∀ᵐ τ, HasDerivAt (fun s => ∫ ξ in a..b, q ξ s)
      (flux (q a τ) - flux (q b τ)) τ) ∧
    (∀ qx, ¬ HasDerivAt (fun ξ => q ξ t) qx x) ∧
    (¬ DifferentiableAt ℝ (fun ξ => q ξ t) x) ∧
    (∀ fluxDerivative : (ι → ℝ) → ((ι → ℝ) →L[ℝ] (ι → ℝ)),
      ¬ IsQuasilinearConservationLawSolutionAt q fluxDerivative x t) := by
  refine ⟨hrectangle.hasDerivAt_mass_ae, ?_, ?_, ?_⟩
  · intro qx hqx
    exact hjump hqx.continuousAt
  · intro hdiff
    exact hjump hdiff.continuousAt
  · intro fluxDerivative hclassical
    obtain ⟨qt, qx, _, hqx, _⟩ := hclassical
    exact hjump hqx.continuousAt

/-- The conservative residual requires differentiability of the composed flux.
Noncontinuity of that composition, not merely of the state, excludes it. -/
theorem not_conservationLawSolutionAt_of_flux_not_continuousAt
    {q : ℝ → ℝ → ι → ℝ} {flux : (ι → ℝ) → ι → ℝ}
    {x t : ℝ} (hflux : ¬ ContinuousAt (fun ξ => flux (q ξ t)) x) :
    ¬ IsConservationLawSolutionAt q flux x t := by
  rintro ⟨qt, fluxx, _, hfluxx, _⟩
  exact hflux hfluxx.continuousAt

end NumStability
