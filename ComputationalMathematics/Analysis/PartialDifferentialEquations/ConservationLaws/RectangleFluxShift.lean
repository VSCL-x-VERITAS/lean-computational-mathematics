/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Flux shifts on the range of a rectangle solution

Adding one constant vector to the physical flux along a particular
solution leaves every oriented rectangle balance unchanged.
-/

open MeasureTheory

namespace NumStability

/-- A constant difference between two fluxes on the solution range
preserves rectangle conservation, including the boundary integrability. -/
theorem IsRectangleConservationLawSolution.of_flux_eq_add_const
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (baseFlux flux : E → E) (offset : E)
    (hbase : IsRectangleConservationLawSolution q baseFlux)
    (hflux : ∀ x t, flux (q x t) = baseFlux (q x t) + offset) :
    IsRectangleConservationLawSolution q flux := by
  rcases hbase with ⟨hspace, htime, hbalance⟩
  refine ⟨hspace, ?_, ?_⟩
  · intro x s t
    simpa only [hflux] using
      (htime x s t).add (intervalIntegrable_const (c := offset))
  · intro a b s t
    have hsame : ∀ τ,
        flux (q a τ) - flux (q b τ) =
          baseFlux (q a τ) - baseFlux (q b τ) := by
      intro τ
      rw [hflux a τ, hflux b τ]
      abel
    simpa only [hsame] using hbalance a b s t

end NumStability
