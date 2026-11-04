/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionField
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionMinimizerBound
import Mathlib.Algebra.Order.Group.MinMax

/-!
# Analytic bounds for the actual finite-action construction

The initial slope plus the sum of absolute slope jumps gives a finite global
Lipschitz constant for the actual hinge primitive. Global action minimality
then bounds the selected foot displacement and velocity. This constant is an
analytic bound and is not substituted for an encountered-wave CFL bound.
-/

noncomputable section
open scoped BigOperators

namespace NumStability

/-- A finite analytic bound from the supplied data, without a speed assertion. -/
def leveque04_burgersPrimitiveBound {N : ℕ} (old : Fin (N + 2) → ℝ) : ℝ :=
  |leveque04_burgersActionState old 0| +
    ∑ j ∈ Finset.range (N + 1),
      |leveque04_burgersActionState old (j + 1) - leveque04_burgersActionState old j|

theorem leveque04_burgersPrimitiveBound_nonneg {N : ℕ} (old : Fin (N + 2) → ℝ) :
    0 ≤ leveque04_burgersPrimitiveBound old := by
  unfold leveque04_burgersPrimitiveBound
  positivity

/-- The literal finite hinge primitive has the stated all-real Lipschitz bound.
There is no compact-support, bounded-tail or width restriction in this fact. -/
theorem leveque04_burgersInitialPrimitive_abs_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x y : ℝ) :
    |leveque04_burgersInitialPrimitive old origin width x -
      leveque04_burgersInitialPrimitive old origin width y| ≤
        leveque04_burgersPrimitiveBound old * |x - y| := by
  let q := leveque04_burgersActionState old
  let face := leveque04_burgersActionFace origin width
  have heq : leveque04_burgersInitialPrimitive old origin width x -
      leveque04_burgersInitialPrimitive old origin width y =
      q 0 * (x - y) + ∑ j ∈ Finset.range (N + 1),
        (q (j + 1) - q j) * (max (x - face j) 0 - max (y - face j) 0) := by
    unfold leveque04_burgersInitialPrimitive
    rw [show q 0 * (x - origin) +
        (∑ j ∈ Finset.range (N + 1), (q (j + 1) - q j) * max (x - face j) 0) -
        (q 0 * (y - origin) +
        ∑ j ∈ Finset.range (N + 1), (q (j + 1) - q j) * max (y - face j) 0) =
        q 0 * (x - y) +
        ((∑ j ∈ Finset.range (N + 1), (q (j + 1) - q j) * max (x - face j) 0) -
        ∑ j ∈ Finset.range (N + 1), (q (j + 1) - q j) * max (y - face j) 0) by ring]
    rw [← Finset.sum_sub_distrib]
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    ring
  have hterm (j : ℕ) :
      |(q (j + 1) - q j) * (max (x - face j) 0 - max (y - face j) 0)| ≤
        |q (j + 1) - q j| * |x - y| := by
    rw [abs_mul]
    apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
    simpa only [sub_sub_sub_cancel_right] using
      abs_max_sub_max_le_abs (x - face j) (y - face j) 0
  rw [heq]
  calc
    _ ≤ |q 0 * (x - y)| +
        |∑ j ∈ Finset.range (N + 1),
          (q (j + 1) - q j) * (max (x - face j) 0 - max (y - face j) 0)| :=
      abs_add_le _ _
    _ ≤ |q 0| * |x - y| +
        ∑ j ∈ Finset.range (N + 1), |q (j + 1) - q j| * |x - y| := by
      rw [abs_mul]
      apply add_le_add le_rfl
      exact (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum (fun j _ => hterm j))
    _ = leveque04_burgersPrimitiveBound old * |x - y| := by
      unfold leveque04_burgersPrimitiveBound
      rw [add_mul, Finset.sum_mul]

/-- The true selected global minimizing foot stays within the analytic cone. -/
theorem leveque04_burgersFiniteActionFoot_displacement_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    |x - leveque04_burgersFiniteActionFoot old origin width x time| ≤
      leveque04_burgersPrimitiveBound old * time := by
  apply quadraticAction_minimizer_displacement_le
    (leveque04_burgersInitialPrimitive old origin width)
    (leveque04_burgersPrimitiveBound old) time x
    (leveque04_burgersFiniteActionFoot old origin width x time)
    (leveque04_burgersPrimitiveBound_nonneg old) htime
    (fun y z => leveque04_burgersInitialPrimitive_abs_sub_le old origin width y z)
  intro y
  exact leveque04_burgersFiniteActionFoot_global_min old origin width x time hwidth htime y

/-- Global boundedness of the actual positive-time variational velocity.
No assertion about active waves or CFL ancestry follows from this bound. -/
theorem leveque04_burgersFiniteActionVelocity_abs_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    |leveque04_burgersFiniteActionVelocity old origin width x time| ≤
      leveque04_burgersPrimitiveBound old := by
  rw [leveque04_burgersFiniteActionVelocity, abs_div, abs_of_pos htime]
  exact (div_le_iff₀ htime).2
    (leveque04_burgersFiniteActionFoot_displacement_le old origin width x time hwidth htime)

end NumStability
