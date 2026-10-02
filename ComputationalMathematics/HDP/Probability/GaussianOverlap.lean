import ComputationalMathematics.HDP.Probability.BinaryTesting
import Mathlib.Probability.Distributions.Gaussian.Real

/-!
# Gaussian overlap bounds for binary testing

A constant-density measure on `[-1, 1]` is a common submeasure of two
oppositely shifted unit Gaussian laws. The resulting testing bound applies to
arbitrary decision sets, without a measurability assumption.
-/

open Set MeasureTheory
open scoped ENNReal NNReal Real

namespace NumStability.HDP.Probability

open ProbabilityTheory

noncomputable def intervalCommon (a : ℝ≥0∞) : Measure ℝ :=
  volume.withDensity ((Set.Icc (-1 : ℝ) 1).indicator (fun _ ↦ a))

@[simp] theorem intervalCommon_apply_univ (a : ℝ≥0∞) :
    intervalCommon a Set.univ = 2 * a := by
  rw [intervalCommon, withDensity_apply _ MeasurableSet.univ,
    lintegral_indicator_const measurableSet_Icc]
  rw [Measure.restrict_univ]
  rw [Real.volume_Icc]
  norm_num
  rw [mul_comm (2 : ℝ≥0∞) a]
  congr 1
  exact ENNReal.ofReal_ofNat 2

theorem intervalCommon_le_gaussianReal
    (a : ℝ≥0∞) (mean : ℝ)
    (h : ∀ x ∈ Set.Icc (-1 : ℝ) 1, a ≤ gaussianPDF mean 1 x) :
    intervalCommon a ≤ gaussianReal mean 1 := by
  rw [gaussianReal_of_var_ne_zero mean one_ne_zero]
  apply withDensity_mono
  filter_upwards [] with x
  by_cases hx : x ∈ Set.Icc (-1 : ℝ) 1
  · simpa [hx] using h x hx
  · simp [hx]

theorem intervalCommon_prod_le_gaussianReal
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    (a : ℝ≥0∞) (mean : ℝ)
    (h : ∀ x ∈ Set.Icc (-1 : ℝ) 1, a ≤ gaussianPDF mean 1 x) :
    (intervalCommon a).prod nu ≤ (gaussianReal mean 1).prod nu := by
  rw [intervalCommon, gaussianReal_of_var_ne_zero mean one_ne_zero,
    prod_withDensity_left (measurable_const.indicator measurableSet_Icc),
    prod_withDensity_left (measurable_gaussianPDF mean 1)]
  apply withDensity_mono
  filter_upwards [] with z
  by_cases hz : z.1 ∈ Set.Icc (-1 : ℝ) 1
  · simpa [hz] using h z.1 hz
  · simp [hz]

@[simp] theorem intervalCommon_prod_apply_univ
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    [IsProbabilityMeasure nu] (a : ℝ≥0∞) :
    (intervalCommon a).prod nu Set.univ = 2 * a := by
  rw [Measure.prod_apply MeasurableSet.univ]
  simp

noncomputable def gaussianIntervalFloorReal (r : ℝ) : ℝ :=
  (√π)⁻¹ * (√(2 : ℝ))⁻¹ * Real.exp (-((r + 1) ^ 2) / 2)

theorem gaussianIntervalFloorReal_le_pdf_pos
    {r x : ℝ} (hr : 0 ≤ r) (hx : x ∈ Set.Icc (-1 : ℝ) 1) :
    gaussianIntervalFloorReal r ≤ gaussianPDFReal r 1 x := by
  rcases hx with ⟨hxlo, hxhi⟩
  have hsq : (x - r) ^ 2 ≤ (r + 1) ^ 2 := by nlinarith
  have hexp : Real.exp (-((r + 1) ^ 2) / 2) ≤
      Real.exp (-(x - r) ^ 2 / 2) := by
    exact Real.exp_le_exp.mpr (by nlinarith)
  have hm := mul_le_mul_of_nonneg_left hexp
    (show 0 ≤ (√π)⁻¹ * (√(2 : ℝ))⁻¹ by positivity)
  simpa [gaussianIntervalFloorReal, gaussianPDFReal] using hm

theorem gaussianIntervalFloorReal_le_pdf_neg
    {r x : ℝ} (hr : 0 ≤ r) (hx : x ∈ Set.Icc (-1 : ℝ) 1) :
    gaussianIntervalFloorReal r ≤ gaussianPDFReal (-r) 1 x := by
  rcases hx with ⟨hxlo, hxhi⟩
  have hsq : (x - (-r)) ^ 2 ≤ (r + 1) ^ 2 := by nlinarith
  have hexp : Real.exp (-((r + 1) ^ 2) / 2) ≤
      Real.exp (-(x - (-r)) ^ 2 / 2) := by
    exact Real.exp_le_exp.mpr (by nlinarith)
  have hm := mul_le_mul_of_nonneg_left hexp
    (show 0 ≤ (√π)⁻¹ * (√(2 : ℝ))⁻¹ by positivity)
  simpa [gaussianIntervalFloorReal, gaussianPDFReal] using hm

noncomputable def gaussianIntervalFloor (r : ℝ) : ℝ≥0∞ :=
  ENNReal.ofReal (gaussianIntervalFloorReal r)

theorem gaussianIntervalFloorReal_nonneg (r : ℝ) :
    0 ≤ gaussianIntervalFloorReal r := by
  unfold gaussianIntervalFloorReal
  positivity

@[simp] theorem gaussianIntervalFloor_toReal (r : ℝ) :
    (gaussianIntervalFloor r).toReal = gaussianIntervalFloorReal r := by
  rw [gaussianIntervalFloor, ENNReal.toReal_ofReal]
  exact gaussianIntervalFloorReal_nonneg r

theorem intervalCommon_floor_le_gaussianReal_pos {r : ℝ} (hr : 0 ≤ r) :
    intervalCommon (gaussianIntervalFloor r) ≤ gaussianReal r 1 := by
  apply intervalCommon_le_gaussianReal
  intro x hx
  exact ENNReal.ofReal_le_ofReal
    (gaussianIntervalFloorReal_le_pdf_pos hr hx)

theorem intervalCommon_floor_le_gaussianReal_neg {r : ℝ} (hr : 0 ≤ r) :
    intervalCommon (gaussianIntervalFloor r) ≤ gaussianReal (-r) 1 := by
  apply intervalCommon_le_gaussianReal
  intro x hx
  exact ENNReal.ofReal_le_ofReal
    (gaussianIntervalFloorReal_le_pdf_neg hr hx)

/-- Oppositely shifted unit Gaussians, with any common probability-valued side
information, have a positive binary-testing overlap.  The decision set need not
be measurable. -/
theorem gaussianReal_prod_binaryTestingError_lower
    {S : Type*} [MeasurableSpace S] (nu : Measure S) [SFinite nu]
    [IsProbabilityMeasure nu] {r : ℝ} (hr : 0 ≤ r)
    (decision : Set (ℝ × S)) :
    2 * gaussianIntervalFloor r ≤
      (gaussianReal r 1).prod nu decisionᶜ +
        (gaussianReal (-r) 1).prod nu decision := by
  rw [← intervalCommon_prod_apply_univ nu (gaussianIntervalFloor r)]
  simpa only [compl_compl] using
    commonMeasure_univ_le_add_compl
      ((gaussianReal r 1).prod nu) ((gaussianReal (-r) 1).prod nu)
      ((intervalCommon (gaussianIntervalFloor r)).prod nu) decisionᶜ
      (intervalCommon_prod_le_gaussianReal nu _ _ fun x hx ↦
        ENNReal.ofReal_le_ofReal (gaussianIntervalFloorReal_le_pdf_pos hr hx))
      (intervalCommon_prod_le_gaussianReal nu _ _ fun x hx ↦
        ENNReal.ofReal_le_ofReal (gaussianIntervalFloorReal_le_pdf_neg hr hx))

end NumStability.HDP.Probability
