/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionMinimizerOrder

/-!
# Displacement of quadratic-action minimizers

A genuine global minimizer for a potential with a global Lipschitz bound has
displacement at most the Lipschitz constant times the positive time. This is
an analytic bound; it does not identify actual wave propagation speeds.
-/

namespace NumStability

private theorem displacement_upper
    (potential : ℝ → ℝ) (constant time x foot : ℝ)
    (htime : 0 < time)
    (hbound : ∀ z, potential z - potential foot ≤ constant * |z - foot|)
    (hmin : ∀ z, potential foot + (x - foot) ^ 2 / (2 * time) ≤
      potential z + (x - z) ^ 2 / (2 * time)) :
    x - foot ≤ constant * time := by
  by_contra hlarge
  have hgap : 0 < x - foot - constant * time := by linarith
  let z := x - constant * time
  have hz : 0 ≤ z - foot := by dsimp [z]; linarith
  have hb := hbound z
  rw [abs_of_nonneg hz] at hb
  have hc := hmin z
  have hden : 0 < 2 * time := by linarith
  have normalize (v w : ℝ) : v + w / (2 * time) =
      (2 * time * v + w) / (2 * time) := by
    field_simp [ne_of_gt htime]
  rw [normalize, normalize] at hc
  have hc' := (div_le_div_iff_of_pos_right hden).mp hc
  have hb' := mul_le_mul_of_nonneg_left hb hden.le
  have hsq : 0 < (x - foot - constant * time) ^ 2 := sq_pos_of_pos hgap
  dsimp [z] at hb' hc'
  nlinarith

/-- Every actual global quadratic-action minimizer has the sharp displacement
bound. No differentiability or minimizer-existence hypothesis is hidden here. -/
theorem quadraticAction_minimizer_displacement_le
    (potential : ℝ → ℝ) (constant time x foot : ℝ)
    (hconstant : 0 ≤ constant) (htime : 0 < time)
    (hlip : ∀ y z, |potential y - potential z| ≤ constant * |y - z|)
    (hmin : ∀ z, potential foot + (x - foot) ^ 2 / (2 * time) ≤
      potential z + (x - z) ^ 2 / (2 * time)) :
    |x - foot| ≤ constant * time := by
  have hu := displacement_upper potential constant time x foot htime
    (fun z => (le_abs_self _).trans (hlip z foot)) hmin
  have hnegmin (z : ℝ) :
      potential (-(-foot)) + ((-x) - (-foot)) ^ 2 / (2 * time) ≤
        potential (-z) + ((-x) - z) ^ 2 / (2 * time) := by
    have hleft : ((-x) - (-foot)) ^ 2 = (x - foot) ^ 2 := by ring
    have hright : ((-x) - z) ^ 2 = (x - (-z)) ^ 2 := by ring
    simpa only [neg_neg, hleft, hright] using hmin (-z)
  have hl := displacement_upper (fun z => potential (-z)) constant time (-x) (-foot) htime
    (fun z => by
      have he : |(-z) - foot| = |z - (-foot)| := by
        rw [show (-z) - foot = -(z - (-foot)) by ring, abs_neg]
      simpa only [neg_neg, he] using
        (le_abs_self (potential (-z) - potential foot)).trans (hlip (-z) foot)) hnegmin
  have hnonneg := mul_nonneg hconstant htime.le
  apply abs_le.mpr
  constructor <;> linarith [hnonneg]

/-- The corresponding selected velocity is bounded by the same analytic
constant. This theorem supplies no CFL or wave-ancestry interpretation. -/
theorem quadraticAction_minimizer_velocity_abs_le
    (potential : ℝ → ℝ) (constant time x foot : ℝ)
    (hconstant : 0 ≤ constant) (htime : 0 < time)
    (hlip : ∀ y z, |potential y - potential z| ≤ constant * |y - z|)
    (hmin : ∀ z, potential foot + (x - foot) ^ 2 / (2 * time) ≤
      potential z + (x - z) ^ 2 / (2 * time)) :
    |(x - foot) / time| ≤ constant := by
  rw [abs_div, abs_of_pos htime]
  exact (div_le_iff₀ htime).2
    (quadraticAction_minimizer_displacement_le potential constant time x foot
      hconstant htime hlip hmin)

end NumStability
