/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Almost-everywhere congruence for rectangle conservation

Spatial changes on null sets preserve cell integrals. Boundary fluxes
must also agree almost everywhere in time at every fixed spatial face
for the rectangle balance to survive.
-/

open MeasureTheory

namespace NumStability

/-- A rectangle conservation solution remains one after spatial
almost-everywhere changes, provided its physical flux agrees almost
everywhere in time at each fixed boundary point. -/
theorem rectangleSolution_congr_ae
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q q' : ℝ → ℝ → E) (flux : E → E)
    (hq : IsRectangleConservationLawSolution q flux)
    (hspace : ∀ t, ∀ᵐ x ∂volume, q x t = q' x t)
    (hface : ∀ x, ∀ᵐ τ ∂volume,
      flux (q x τ) = flux (q' x τ)) :
    IsRectangleConservationLawSolution q' flux := by
  refine ⟨?_, ?_, ?_⟩
  · intro a b t
    exact (hq.1 a b t).congr_ae (ae_restrict_of_ae (hspace t))
  · intro x s t
    exact (hq.2.1 x s t).congr_ae (ae_restrict_of_ae (hface x))
  · intro a b s t
    have hspaceIntegral (τ : ℝ) :
        (∫ x in a..b, q' x τ) = ∫ x in a..b, q x τ := by
      apply intervalIntegral.integral_congr_ae
      filter_upwards [hspace τ] with x hx _
      exact hx.symm
    calc
      (∫ x in a..b, q' x t) - (∫ x in a..b, q' x s) =
          (∫ x in a..b, q x t) - (∫ x in a..b, q x s) := by
        rw [hspaceIntegral t, hspaceIntegral s]
      _ = ∫ τ in s..t, (flux (q a τ) - flux (q b τ)) :=
        hq.2.2 a b s t
      _ = ∫ τ in s..t, (flux (q' a τ) - flux (q' b τ)) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [hface a, hface b] with τ ha hb _
        rw [ha, hb]

end NumStability
