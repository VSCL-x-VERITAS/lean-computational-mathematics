/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
# LeVeque equation (1.10): rectangle conservation and the mass rate

The recorded user interpretation of the discontinuity discussion around (1.10)
uses rectangle conservation, with the displayed mass-rate identity almost
everywhere in time for each fixed spatial interval. The exceptional null set
may depend on that interval. The source does not explicitly state this analytic
convention; the interpretation receipt preserves that ambiguity.

The time-integrated balance is retained: an almost-everywhere derivative
identity alone does not imply rectangle conservation. This wrapper reuses the
general rectangle-law temporal derivative theorem for real finite vectors.
-/

open MeasureTheory

namespace NumStability

/-- Rectangle conservation with its integrated balance and intervalwise almost-everywhere mass rate. -/
theorem leveque01_equation10_rectangleConservation_iff_integrated_and_ae_rate
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

end NumStability
