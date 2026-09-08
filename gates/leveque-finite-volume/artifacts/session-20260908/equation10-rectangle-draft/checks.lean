/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump

/-!
# Draft: equation (1.10) with the recorded discontinuity interpretation

Rectangle conservation is the adopted solution predicate. Its finite-interval
integrability and time-integrated balance imply the displayed mass-rate identity
almost everywhere for each fixed spatial interval. The exceptional set may
depend on the interval. This draft does not assert a source-audit verdict.
-/

open MeasureTheory

namespace NumStability.Equation10RectangleDraft

theorem rectangleConservation_iff_integrated_and_ae_rate
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ) :
    IsRectangleConservationLawSolution q flux ↔
      (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
      (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
      (∀ a b s t,
        (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
          ∫ τ in s..t, (flux (q a τ) - flux (q b τ))) ∧
      (∀ a b, ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
        (flux (q a t) - flux (q b t)) t) := by
  constructor
  · intro h
    exact ⟨h.1, h.2.1, h.2.2, h.hasDerivAt_mass_ae⟩
  · intro h
    exact ⟨h.1, h.2.1, h.2.2.1⟩

end NumStability.Equation10RectangleDraft

#check NumStability.Equation10RectangleDraft.rectangleConservation_iff_integrated_and_ae_rate
#print axioms NumStability.Equation10RectangleDraft.rectangleConservation_iff_integrated_and_ae_rate
#check NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
#print axioms NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
#check NumStability.exists_discontinuous_rectangle_field
#print axioms NumStability.exists_discontinuous_rectangle_field
