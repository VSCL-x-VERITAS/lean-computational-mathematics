/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageMidpoint
import ComputationalMathematics.Source.LeVeque.Chapter04.MidpointAverage

/-!
# LeVeque Chapter 4: midpoint error of cell averages

The scalar source API forwards to the reusable quadrature producer.
Finite-system and local uniform estimates reproduce the smooth-field
second-order claim. The explicit coefficient 1/8 is nonsharp additional
quantitative content; the trapezoidal identity is auxiliary.
-/

namespace NumStability
open MeasureTheory intervalIntegral Set
theorem leveque04_midpoint_trapezoidal_identity
    (f : ℝ → ℝ) (left right : ℝ) :
    2 * trapezoidal_integral f 2 left right -
      trapezoidal_integral f 1 left right =
        (right - left) * f ((left + right) / 2)  := by
  exact midpoint_trapezoidal_integral_identity f left right

theorem leveque04_midpointError_secondOrder
    (f : ℝ → ℝ) (left right bound : ℝ)
    (hcell : left < right)
    (hsmooth : ContDiffOn ℝ 2 f (Set.Icc left right))
    (hderiv : ∀ x,
      |iteratedDerivWithin 2 f (Set.Icc left right) x| ≤ bound) :
    |oneDimensionalCellAverage f left right -
        f ((left + right) / 2)| ≤
      (right - left) ^ 2 * bound / 8  := by
  exact cellAverage_midpoint_error_le f left right bound hcell hsmooth hderiv

def Leveque04VectorMidpointTarget : Prop :=
  (∀ (m : ℕ) (field : ℝ → Fin m → ℝ) (a b M : ℝ),
    a < b → 0 ≤ M →
    (∀ p, ContDiffOn ℝ 2 (fun x => field x p) (Icc a b)) →
    (∀ p x, |iteratedDerivWithin 2 (fun y => field y p) (Icc a b) x| ≤ M) →
    ‖oneDimensionalCellAverage field a b - field ((a+b)/2)‖ ≤
      (b-a)^2*M/8) ∧
  (∀ (m : ℕ) (field : ℝ → Fin m → ℝ) (L l r R : ℝ),
    L < l → r < R →
    (∀ p, ContDiffOn ℝ 2 (fun x => field x p) (Ioo L R)) →
    ∃ C : ℝ, 0 ≤ C ∧ ∀ a b : ℝ, l ≤ a → b ≤ r → a < b →
      ‖oneDimensionalCellAverage field a b - field ((a+b)/2)‖ ≤ C*(b-a)^2)

/-- The local finite-system midpoint contract, including a width-independent
constant and the separate derivative-dependent quantitative bound. -/
theorem leveque04_vectorMidpointSecondOrder : Leveque04VectorMidpointTarget := by
  constructor
  · intro m field a b M hab hM hsmooth hsecond
    have hint : IntervalIntegrable field volume a b :=
      (intervalIntegrable_pi_iff field a b).mpr
        (fun p => (hsmooth p).continuousOn.intervalIntegrable_of_Icc hab.le)
    exact cellAverage_midpoint_error_le_of_component_bounds field a b M hab hM hint hsmooth hsecond
  · intro m field L l r R hL hR hsmooth
    exact cellAverage_midpoint_error_uniform field L l r R hL hR hsmooth

end NumStability
