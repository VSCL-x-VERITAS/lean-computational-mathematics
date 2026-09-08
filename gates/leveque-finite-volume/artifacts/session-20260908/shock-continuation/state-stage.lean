import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Tactic

/-! Scratch construction of a nonlinear scalar conservation law whose smooth initial
data evolve into a stationary compressive jump. Source closure and entropy interpretation
require independent review; no desired balance identity is assumed in these definitions. -/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.ShockContinuation

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

#print axioms huberFlux_contDiff_one
#print axioms huberFlux_formula
#print axioms huberFlux_not_linear

/-- The central primitive, with division interpreted in the ambient real field. -/
def centralPotential (x t : ℝ) : ℝ := (-x ^ 2 / 2) / (1 - t)

/-- The outer primitive, also used after the central interval collapses. -/
def outerPotential (x t : ℝ) : ℝ := -x ^ 2 / 2 - t * |x| + t / 2 - t ^ 2 / 2

/-- Right trace is selected at the stationary interface. -/
def outerState (x t : ℝ) : ℝ := if x < 0 then t - x else -t - x

def shockPotential (x t : ℝ) : ℝ :=
  if t < 1 - |x| then centralPotential x t else outerPotential x t

def shockState (x t : ℝ) : ℝ :=
  if t < 1 - |x| then -x / (1 - t) else outerState x t

theorem shockState_initial (x : ℝ) : shockState x 0 = -x := by
  simp only [shockState, outerState]
  split_ifs <;> simp

theorem shockState_initial_smooth : ContDiff ℝ ⊤ (fun x => shockState x 0) := by
  simp only [shockState_initial]
  exact contDiff_id.neg

theorem shockState_after {t : ℝ} (ht : 1 ≤ t) (x : ℝ) :
    shockState x t = outerState x t := by
  simp only [shockState, if_neg (show ¬ t < 1 - |x| by linarith [abs_nonneg x])]

theorem central_flux {x t : ℝ} (h : t < 1 - |x|) :
    huberFlux (-x / (1 - t)) = (-x / (1 - t)) ^ 2 / 2 := by
  apply huberFlux_of_abs_le
  have hr : 0 < 1 - t := by linarith [abs_nonneg x]
  rw [abs_div, abs_neg, abs_of_pos hr]
  exact (div_le_one hr).mpr (by linarith)

theorem outer_flux {x t : ℝ} (h : 1 - |x| ≤ t) :
    huberFlux (outerState x t) = t + |x| - 1 / 2 := by
  by_cases hx : x < 0
  · rw [outerState, if_pos hx, abs_of_neg hx] at *
    rw [huberFlux_of_ge (by linarith : 1 ≤ t - x)]
    ring
  · rw [outerState, if_neg hx, abs_of_nonneg (le_of_not_gt hx)] at *
    rw [huberFlux_of_le (by linarith : -t - x ≤ -1)]
    ring

theorem stationary_shock_flux_and_speeds {t : ℝ} (ht : 1 ≤ t) :
    huberFlux t = huberFlux (-t) ∧ huberSlope t = 1 ∧ huberSlope (-t) = -1 := by
  refine ⟨?_, huberSlope_of_ge ht, huberSlope_of_le (by linarith)⟩
  rw [huberFlux_of_ge ht, huberFlux_of_le (by linarith : -t ≤ -1)]
  ring

/-- The primitive values match on the boundary of the central region. -/
theorem potential_match {x t : ℝ} (h : t = 1 - |x|) :
    centralPotential x t = outerPotential x t := by
  by_cases hx : x = 0
  · subst x
    simp only [abs_zero, sub_zero] at h
    subst t
    norm_num [centralPotential, outerPotential]
    rfl
  have ha : 0 < |x| := abs_pos.mpr hx
  have hr : 1 - t ≠ 0 := by linarith
  have hsq : |x| ^ 2 = x ^ 2 := sq_abs x
  dsimp [centralPotential, outerPotential]
  field_simp
  nlinarith [sq_nonneg (|x| - (1 - t))]

/-- A genuine discontinuity is present at every time at or after collapse. -/
theorem shockState_not_continuous_after {t : ℝ} (ht : 1 ≤ t) :
    ¬ ContinuousAt (fun x => shockState x t) 0 := by
  intro hc
  have hleft : Tendsto (fun x => shockState x t) (𝓝[<] 0) (𝓝 t) := by
    have hh : Tendsto (fun x : ℝ => t - x) (𝓝[<] 0) (𝓝 t) := by
      have hlinear : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[<] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, mem_Iio.mp hx, if_pos]
  have hboth := tendsto_nhds_unique hleft hc.continuousWithinAt.tendsto
  simp only [shockState_after ht, outerState, lt_self_iff_false, if_false, sub_zero] at hboth
  linarith

#print axioms shockState_initial_smooth
#print axioms stationary_shock_flux_and_speeds
#print axioms potential_match
#print axioms shockState_not_continuous_after


end
end NumStability.ShockContinuation
