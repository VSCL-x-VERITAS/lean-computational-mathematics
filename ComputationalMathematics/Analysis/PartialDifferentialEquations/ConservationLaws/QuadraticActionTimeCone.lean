/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FootThresholds
import Mathlib.Tactic.Ring

/-!
# Time cones for actual quadratic-action minimizers and label boundaries

Comparing the two actual minimization inequalities at different positive
times shows that minimizing feet cannot cross when the observations are
separated by more than K times the time difference. Here K is a genuine
Lipschitz bound for the initial potential. The induced threshold-shift lemmas
then control both label boundaries. No PDE or propagation certificate is used;
this analytic K does not replace an encountered-wave bound S.
-/

namespace NumStability

private theorem minimizer_twoPoint_comparison (potential : ℝ → ℝ)
    (time x foot other : ℝ) (htime : 0 < time)
    (hmin : potential foot + (x - foot) ^ 2 / (2 * time) ≤
      potential other + (x - other) ^ 2 / (2 * time)) :
    (potential foot - potential other) * time ≤
      (foot - other) * (x - (foot + other) / 2) := by
  have hs : potential foot - potential other ≤
      ((x - other) ^ 2 - (x - foot) ^ 2) / (2 * time) := by
    rw [sub_div]
    linarith
  have hm := (le_div_iff₀ (by positivity : 0 < 2 * time)).mp hs
  nlinarith

/-- Cross-time order follows from the true minima and the initial potential
bound alone, including all choices among tied global minimizing feet. -/
theorem quadraticAction_minimizers_timeCone_ordered
    (potential : ℝ → ℝ) (constant s t x₁ x₂ y₁ y₂ : ℝ)
    (hs : 0 < s) (ht : 0 < t)
    (hbound : ∀ y z, |potential y - potential z| ≤ constant * |y - z|)
    (hmin₁ : ∀ y, potential y₁ + (x₁ - y₁) ^ 2 / (2 * s) ≤
      potential y + (x₁ - y) ^ 2 / (2 * s))
    (hmin₂ : ∀ y, potential y₂ + (x₂ - y₂) ^ 2 / (2 * t) ≤
      potential y + (x₂ - y) ^ 2 / (2 * t))
    (hcone : constant * |t - s| < x₂ - x₁) : y₁ ≤ y₂ := by
  by_contra hn
  have hd : 0 < y₁ - y₂ := sub_pos.mpr (lt_of_not_ge hn)
  have hfirst := minimizer_twoPoint_comparison potential s x₁ y₁ y₂ hs (hmin₁ y₂)
  have hsecond := minimizer_twoPoint_comparison potential t x₂ y₂ y₁ ht (hmin₂ y₁)
  have hcross : (y₁ - y₂) * (x₂ - x₁) ≤
      (potential y₁ - potential y₂) * (t - s) := by nlinarith
  have hb := hbound y₁ y₂
  rw [abs_of_pos hd] at hb
  have hprod : (potential y₁ - potential y₂) * (t - s) ≤
      constant * (y₁ - y₂) * |t - s| := by
    calc
      _ ≤ |(potential y₁ - potential y₂) * (t - s)| := le_abs_self _
      _ = |potential y₁ - potential y₂| * |t - s| := abs_mul _ _
      _ ≤ _ := mul_le_mul_of_nonneg_right hb (abs_nonneg _)
  have hfinal : x₂ - x₁ ≤ constant * |t - s| := by
    apply (mul_le_mul_iff_right₀ hd).mp
    nlinarith [hcross, hprod]
  exact (not_le_of_gt hcone) hfinal

theorem footThresholdLeft_sub_le_of_timeCone
    (foot₁ foot₂ : ℝ → ℝ) (label bound₁ bound₂ distance : ℝ)
    (hmono₂ : Monotone foot₂)
    (hclose₁ : ∀ x, |x - foot₁ x| ≤ bound₁)
    (hclose₂ : ∀ x, |x - foot₂ x| ≤ bound₂)
    (hcone : ∀ x y, distance < y - x → foot₁ x ≤ foot₂ y) :
    footThresholdLeft foot₂ label - footThresholdLeft foot₁ label ≤ distance := by
  by_contra hn
  have hgap : distance < footThresholdLeft foot₂ label - footThresholdLeft foot₁ label := lt_of_not_ge hn
  let δ := (footThresholdLeft foot₂ label - footThresholdLeft foot₁ label - distance) / 3
  let x := footThresholdLeft foot₁ label + δ
  let y := footThresholdLeft foot₂ label - δ
  have hx : footThresholdLeft foot₁ label < x := by dsimp [x, δ]; linarith
  have hy : y < footThresholdLeft foot₂ label := by dsimp [y, δ]; linarith
  have hxy : distance < y - x := by dsimp [y, x, δ]; linarith
  have hfirst := label_le_foot_of_leftThreshold_lt foot₁ label bound₁ x hclose₁ hx
  have hsecond := foot_lt_label_of_lt_leftThreshold foot₂ label bound₂ y hmono₂ hclose₂ hy
  have horder := hcone x y hxy
  linarith

theorem footThresholdRight_sub_le_of_timeCone
    (foot₁ foot₂ : ℝ → ℝ) (label bound₁ bound₂ distance : ℝ)
    (hmono₁ : Monotone foot₁)
    (hclose₁ : ∀ x, |x - foot₁ x| ≤ bound₁)
    (hclose₂ : ∀ x, |x - foot₂ x| ≤ bound₂)
    (hcone : ∀ x y, distance < y - x → foot₁ x ≤ foot₂ y) :
    footThresholdRight foot₂ label - footThresholdRight foot₁ label ≤ distance := by
  by_contra hn
  have hgap : distance < footThresholdRight foot₂ label - footThresholdRight foot₁ label := lt_of_not_ge hn
  let δ := (footThresholdRight foot₂ label - footThresholdRight foot₁ label - distance) / 3
  let x := footThresholdRight foot₁ label + δ
  let y := footThresholdRight foot₂ label - δ
  have hx : footThresholdRight foot₁ label < x := by dsimp [x, δ]; linarith
  have hy : y < footThresholdRight foot₂ label := by dsimp [y, δ]; linarith
  have hxy : distance < y - x := by dsimp [y, x, δ]; linarith
  have hfirst := label_lt_foot_of_rightThreshold_lt foot₁ label bound₁ x hmono₁ hclose₁ hx
  have hsecond := foot_le_label_of_lt_rightThreshold foot₂ label bound₂ y hclose₂ hy
  have horder := hcone x y hxy
  linarith

end NumStability
