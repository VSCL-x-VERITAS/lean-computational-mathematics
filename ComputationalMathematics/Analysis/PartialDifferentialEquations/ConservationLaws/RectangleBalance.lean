/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Rectangle balance with internal production

Only bounded-interval integrability is required. Internal production has no sign
constraint. The defining identity uses time-integrated production and boundary exchange.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Finite mass and boundary exchange, together with spatially integrated
production and its time integral, on all oriented bounded rectangles. -/
def IsRectangleBalanceLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) (production : ℝ → ℝ → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  (∀ a b t, IntervalIntegrable (fun x => production x t) volume a b) ∧
  (∀ a b s t, IntervalIntegrable (fun τ => ∫ x in a..b, production x τ) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      (∫ τ in s..t, flux (q a τ) - flux (q b τ)) +
        ∫ τ in s..t, ∫ x in a..b, production x τ

namespace IsRectangleBalanceLawSolution

variable {q : ℝ → ℝ → E} {flux : E → E} {production : ℝ → ℝ → E}

/-- The source contribution is the mass change after boundary inflow is removed. -/
theorem integrated_source_eq_mass_defect
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) -
        ∫ τ in s..t, flux (q a τ) - flux (q b τ) := by
  rw [h.2.2.2.2 a b s t]
  abel

theorem rectangle_conservation_iff_source_integral_zero
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    ((∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, flux (q a τ) - flux (q b τ)) ↔
        (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  rw [h.2.2.2.2 a b s t, add_eq_left]

/-- Homogeneous conservation is exactly zero net production on every rectangle,
provided the supplied fields satisfy the actual balance law. -/
theorem conservation_iff_source_integrals_zero
    (h : IsRectangleBalanceLawSolution q flux production) :
    IsRectangleConservationLawSolution q flux ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  constructor
  · intro hc a b s t
    exact (h.rectangle_conservation_iff_source_integral_zero a b s t).mp (hc.2.2 a b s t)
  · intro hz
    exact ⟨h.1, h.2.1, fun a b s t =>
      (h.rectangle_conservation_iff_source_integral_zero a b s t).mpr (hz a b s t)⟩

/-- Failure of homogeneous conservation forces an actual nonzero rectangle
source integral, rather than only a source value at an isolated point. -/
theorem not_conservation_iff_exists_nonzero_source_integral
    (h : IsRectangleBalanceLawSolution q flux production) :
    ¬ IsRectangleConservationLawSolution q flux ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) ≠ 0 := by
  rw [h.conservation_iff_source_integrals_zero]
  push_neg
  rfl

/-- Every source field realizing these same mass and flux fields has the same
integrated contribution on each rectangle; no pointwise uniqueness is claimed. -/
theorem integrated_source_unique {other : ℝ → ℝ → E}
    (h : IsRectangleBalanceLawSolution q flux production)
    (hother : IsRectangleBalanceLawSolution q flux other) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ∫ τ in s..t, ∫ x in a..b, other x τ := by
  rw [h.integrated_source_eq_mass_defect, hother.integrated_source_eq_mass_defect]

end IsRectangleBalanceLawSolution

theorem isRectangleBalanceLawSolution_zero_iff (q : ℝ → ℝ → E) (flux : E → E) :
    IsRectangleBalanceLawSolution q flux (fun _ _ => 0) ↔
      IsRectangleConservationLawSolution q flux := by
  constructor
  · intro h
    exact h.conservation_iff_source_integrals_zero.mpr (by simp)
  · rintro ⟨hq, hf, hb⟩
    refine ⟨hq, hf, ?_, ?_, ?_⟩
    · intros
      exact intervalIntegrable_const
    · intros
      simp only [intervalIntegral.integral_zero]
      exact intervalIntegrable_const
    · simpa using hb

end NumStability
