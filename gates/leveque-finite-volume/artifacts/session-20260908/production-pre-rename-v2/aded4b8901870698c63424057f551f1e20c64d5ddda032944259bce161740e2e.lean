/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Tactic

/-!
# The normalized Huber function and its derivative

The primitive of the clipped identity is convex and C1, with a quadratic core
and affine outer branches. Both clipping points have the asserted derivative.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

/-- The clipped characteristic speed. -/
def huberSlope (q : ℝ) : ℝ := min 1 (max (-1) q)

/-- Defining the flux as the primitive of the continuous slope gives its C1 regularity
without assuming a derivative at either clipping point. Explicit formulas are proved below. -/
def huberFlux (q : ℝ) : ℝ := ∫ z in (0 : ℝ)..q, huberSlope z

theorem huberSlope_continuous : Continuous huberSlope :=
  continuous_const.min (continuous_const.max continuous_id)

theorem huberSlope_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberSlope q = q := by
  rw [huberSlope, max_eq_right (abs_le.mp hq).1, min_eq_right (abs_le.mp hq).2]

theorem huberSlope_of_ge {q : ℝ} (hq : 1 ≤ q) : huberSlope q = 1 := by
  simp only [huberSlope, min_eq_left (le_trans hq (le_max_right _ _))]

theorem huberSlope_of_le {q : ℝ} (hq : q ≤ -1) : huberSlope q = -1 := by
  simp only [huberSlope, max_eq_left hq]
  norm_num

theorem hasDerivAt_huberFlux (q : ℝ) : HasDerivAt huberFlux (huberSlope q) q :=
  intervalIntegral.integral_hasDerivAt_right
    (huberSlope_continuous.intervalIntegrable _ _)
    huberSlope_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    huberSlope_continuous.continuousAt

theorem huberFlux_contDiff_one : ContDiff ℝ 1 huberFlux := by
  rw [contDiff_one_iff_deriv]
  refine ⟨fun q => (hasDerivAt_huberFlux q).differentiableAt, ?_⟩
  have heq : deriv huberFlux = huberSlope := funext fun q => (hasDerivAt_huberFlux q).deriv
  rw [heq]
  exact huberSlope_continuous

theorem huberFlux_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberFlux q = q ^ 2 / 2 := by
  have heq : (∫ z in (0 : ℝ)..q, huberSlope z) = ∫ z in (0 : ℝ)..q, z := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [] with z hz
    apply huberSlope_of_abs_le
    have hb : z ∈ Ioc (min 0 q) (max 0 q) := hz
    have hlo : -1 ≤ min 0 q := le_min (by norm_num) (abs_le.mp hq).1
    have hhi : max 0 q ≤ 1 := max_le (by norm_num) (abs_le.mp hq).2
    exact abs_le.mpr ⟨by linarith [hb.1], by linarith [hb.2]⟩
  simpa only [huberFlux, integral_id, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true,
    zero_pow, sub_zero] using heq

theorem huberFlux_of_ge {q : ℝ} (hq : 1 ≤ q) : huberFlux q = q - 1 / 2 := by
  have heq : (∫ z in (1 : ℝ)..q, huberSlope z) = q - 1 := by
    calc
      _ = ∫ _ in (1 : ℝ)..q, (1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc (1 : ℝ) q := by simpa only [uIoc_of_le hq] using hz
        exact huberSlope_of_ge hz'.1.le
      _ = q - 1 := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 1)
    (huberSlope_continuous.intervalIntegrable 1 q)
  have hbase : huberFlux 1 = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := 1) (by norm_num)
  change huberFlux 1 + (∫ z in (1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_of_le {q : ℝ} (hq : q ≤ -1) : huberFlux q = -q - 1 / 2 := by
  have heq : (∫ z in (-1 : ℝ)..q, huberSlope z) = -(q + 1) := by
    calc
      _ = ∫ _ in (-1 : ℝ)..q, (-1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc q (-1 : ℝ) := by simpa only [uIoc_of_ge hq] using hz
        exact huberSlope_of_le hz'.2
      _ = -(q + 1) := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 (-1))
    (huberSlope_continuous.intervalIntegrable (-1) q)
  have hbase : huberFlux (-1) = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := -1) (by norm_num)
  change huberFlux (-1) + (∫ z in (-1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_formula (q : ℝ) :
    huberFlux q = if |q| ≤ 1 then q ^ 2 / 2 else |q| - 1 / 2 := by
  split_ifs with hq
  · exact huberFlux_of_abs_le hq
  · rcases lt_or_gt_of_ne (show q ≠ 0 by intro h; simp [h] at hq) with hneg | hpos
    · rw [abs_of_neg hneg] at hq ⊢
      exact huberFlux_of_le (by linarith)
    · rw [abs_of_pos hpos] at hq ⊢
      exact huberFlux_of_ge (by linarith)

theorem huberFlux_not_linear : ¬ ∃ c : ℝ, ∀ q, huberFlux q = c * q := by
  rintro ⟨c, hc⟩
  have h₁ := hc 1
  have h₂ := hc 2
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 1)] at h₁
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 2)] at h₂
  norm_num at h₁ h₂
  linarith

theorem huberFlux_convex : ConvexOn ℝ univ huberFlux := by
  apply Monotone.convexOn_univ_of_deriv (fun x => (hasDerivAt_huberFlux x).differentiableAt)
  have hm : Monotone huberSlope := monotone_const.min (monotone_const.max monotone_id)
  simpa only [funext (fun x => (hasDerivAt_huberFlux x).deriv)] using hm

/-- The Huber function is not affine, so its conservation law is nonlinear. -/
theorem huberFlux_not_affine : ¬ ∃ a b : ℝ, ∀ q, huberFlux q = a * q + b := by
  rintro ⟨a, b, h⟩
  have hb : b = 0 := by simpa [huberFlux] using (h 0).symm
  apply huberFlux_not_linear
  exact ⟨a, fun q => by simpa [hb] using h q⟩

end

end NumStability
