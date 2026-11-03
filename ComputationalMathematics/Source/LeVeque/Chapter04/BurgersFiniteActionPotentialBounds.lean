/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionBounds

/-!
# Uniform initial-potential bounds

The actual finite action potential lies between its initial primitive and that
primitive minus a spatially uniform multiple of time. This estimates the
potential itself; it is not a trace or a weak PDE theorem for its velocity.
-/

namespace NumStability

/-- Testing the true global minimum at the observation point gives the upper bound. -/
theorem leveque04_burgersFiniteActionPotential_le_initial {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    leveque04_burgersFiniteActionPotential old origin width x time ≤
      leveque04_burgersInitialPrimitive old origin width x := by
  simpa only [sub_self, zero_pow (by norm_num : 2 ≠ 0), zero_div, add_zero] using
    leveque04_burgersFiniteActionPotential_le old origin width x time hwidth htime x

/-- Completing a square against the actual primitive's Lipschitz bound gives
a spatially uniform lower bound for every positive time. -/
theorem leveque04_burgersInitialPrimitive_sub_le_actionPotential {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (htime : 0 < time) :
    leveque04_burgersInitialPrimitive old origin width x -
        leveque04_burgersPrimitiveBound old ^ 2 * time / 2 ≤
      leveque04_burgersFiniteActionPotential old origin width x time := by
  let foot := leveque04_burgersFiniteActionFoot old origin width x time
  let K := leveque04_burgersPrimitiveBound old
  let D := |x - foot|
  have hlip : leveque04_burgersInitialPrimitive old origin width x -
      leveque04_burgersInitialPrimitive old origin width foot ≤ K * D :=
    (le_abs_self _).trans
      (leveque04_burgersInitialPrimitive_abs_sub_le old origin width x foot)
  have hden : 0 < 2 * time := by linarith
  have hquadratic : K * D ≤ D ^ 2 / (2 * time) + K ^ 2 * time / 2 := by
    rw [show D ^ 2 / (2 * time) + K ^ 2 * time / 2 =
        (D ^ 2 + K ^ 2 * time ^ 2) / (2 * time) by
      field_simp [ne_of_gt htime]
      ]
    apply (le_div_iff₀ hden).2
    nlinarith [sq_nonneg (D - K * time)]
  have hDsquare : D ^ 2 = (x - foot) ^ 2 := sq_abs (x - foot)
  rw [hDsquare] at hquadratic
  change leveque04_burgersInitialPrimitive old origin width x - K ^ 2 * time / 2 ≤
    leveque04_burgersInitialPrimitive old origin width foot + (x - foot) ^ 2 / (2 * time)
  linarith

/-- Uniform control of the actual potential's deviation from its initial
primitive. This does not assert a corresponding initial trace for the velocity. -/
theorem leveque04_burgersFiniteActionPotential_abs_sub_initial_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    |leveque04_burgersFiniteActionPotential old origin width x time -
        leveque04_burgersInitialPrimitive old origin width x| ≤
      leveque04_burgersPrimitiveBound old ^ 2 * time / 2 := by
  have hu := leveque04_burgersFiniteActionPotential_le_initial old origin width x time hwidth htime
  have hl := leveque04_burgersInitialPrimitive_sub_le_actionPotential old origin width x time htime
  have hnonneg : 0 ≤ leveque04_burgersPrimitiveBound old ^ 2 * time / 2 := by positivity
  apply abs_le.mpr
  constructor <;> linarith

end NumStability
