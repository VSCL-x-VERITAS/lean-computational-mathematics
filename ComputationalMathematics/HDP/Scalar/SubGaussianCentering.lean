import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Centering a sub-Gaussian random variable

This module isolates the intrinsic `ψ₂`-norm form of the centering lemma.  It
keeps the universal constant outside all probability-space and random-variable
parameters, as required by the source's phrase "an absolute constant."
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar.SubGaussian

/-- A constant random variable has `ψ₂` gauge at most twice its absolute
value.  The deliberately non-optimal factor gives a short universal witness. -/
theorem psiTwoGauge_const_le_two_mul_abs
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (a : ℝ) :
    PsiTwoGauge μ (fun _ : Ω => a) ≤ ENNReal.ofReal (2 * |a|) := by
  by_cases ha : a = 0
  · subst a
    simp only [abs_zero, mul_zero, ENNReal.ofReal_zero]
    exact le_of_eq (psiTwoGauge_zero (Ω := Ω) (μ := μ))
  · apply psiTwoGauge_le_of_squarePoint
    have habs : 0 < |a| := abs_pos.mpr ha
    have hscale : 0 < 2 * |a| := by positivity
    have harg : a ^ 2 / (2 * |a|) ^ 2 = (1 / 4 : ℝ) := by
      rw [mul_pow, sq_abs]
      field_simp
      ring
    have hexp : Real.exp (1 / 4 : ℝ) ≤ 2 := by
      calc
        Real.exp (1 / 4 : ℝ) ≤ Real.exp (Real.log 2) :=
          Real.exp_le_exp.mpr (by nlinarith [Real.log_two_gt_d9])
        _ = 2 := Real.exp_log (by norm_num)
    refine ⟨measurable_const, hscale, ?_, ?_⟩
    · simp
    · simpa [harg] using hexp

/-- Intrinsic quantitative centering: subtracting the expectation preserves
sub-Gaussianity and increases the exact `ψ₂` norm by at most one fixed factor. -/
theorem centeredSubGaussianPsiTwoNorm
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hSub : IsSubGaussian μ X) :
    IsSubGaussian μ (fun ω => X ω - ∫ x, X x ∂μ) ∧
      PsiTwoNorm μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
        ENNReal.ofReal (1 + 32 * Real.exp 1) * PsiTwoNorm μ X := by
  have hX : Measurable X := hSub.1
  have hFinite : PsiTwoGauge μ X < ∞ := by
    simpa [PsiTwoNorm] using
      (isSubGaussian_iff_psiTwoNorm_finite (μ := μ) (X := X)).mp hSub
  have hGrowth := psiTwoGaugeToLpMomentGrowth hX hFinite
  have hMomentOne := hGrowth.2 1 (by norm_num : (1 : ℝ) ≤ 1)
  have hAbsInt : Integrable (fun ω => |X ω|) μ := by
    simpa using hMomentOne.1
  have hInt : Integrable X μ := by
    apply (MeasureTheory.integrable_norm_iff hX.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hAbsInt
  let m : ℝ := ∫ x, X x ∂μ
  have hMean : |m| ≤ 16 * Real.exp 1 * (PsiTwoGauge μ X).toReal := by
    have hIntegralNorm :=
      MeasureTheory.norm_integral_le_integral_norm X (μ := μ)
    dsimp [m]
    calc
      |∫ x, X x ∂μ| ≤ ∫ x, ‖X x‖ ∂μ := hIntegralNorm
      _ = ∫ x, |X x| ∂μ := by simp only [Real.norm_eq_abs]
      _ ≤ 16 * Real.exp 1 * (PsiTwoGauge μ X).toReal := by
        simpa using hMomentOne.2
  have hCenterGauge :
      PsiTwoGauge μ (fun ω => X ω - m) ≤
        ENNReal.ofReal (1 + 32 * Real.exp 1) * PsiTwoGauge μ X := by
    have hAdd := psiTwoGauge_add_le (μ := μ)
      (X := X) (Y := fun _ : Ω => -m)
    have hConst := psiTwoGauge_const_le_two_mul_abs
      (Ω := Ω) (μ := μ) (-m)
    have hMeanTwo : 2 * |-m| ≤
        (32 * Real.exp 1) * (PsiTwoGauge μ X).toReal := by
      rw [abs_neg]
      nlinarith [hMean]
    calc
      PsiTwoGauge μ (fun ω => X ω - m) ≤
          PsiTwoGauge μ X + PsiTwoGauge μ (fun _ : Ω => -m) := by
            simpa [sub_eq_add_neg] using hAdd
      _ ≤ PsiTwoGauge μ X + ENNReal.ofReal (2 * |-m|) := by
        gcongr
      _ ≤ PsiTwoGauge μ X +
          ENNReal.ofReal ((32 * Real.exp 1) * (PsiTwoGauge μ X).toReal) := by
        gcongr
      _ = ENNReal.ofReal (1 + 32 * Real.exp 1) * PsiTwoGauge μ X := by
        rw [ENNReal.ofReal_mul (by positivity : 0 ≤ 32 * Real.exp 1)]
        rw [ENNReal.ofReal_toReal (ne_of_lt hFinite)]
        have hcoef : ENNReal.ofReal (1 + 32 * Real.exp 1) =
            1 + ENNReal.ofReal (32 * Real.exp 1) := by
          rw [ENNReal.ofReal_add (by norm_num : 0 ≤ (1 : ℝ))
            (by positivity : 0 ≤ 32 * Real.exp 1)]
          norm_num
        rw [hcoef]
        ring
  have hCenterFinite :
      PsiTwoNorm μ (fun ω => X ω - m) < ∞ := by
    rw [PsiTwoNorm]
    refine lt_of_le_of_lt hCenterGauge ?_
    exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top hFinite
  have hCenterSub : IsSubGaussian μ (fun ω => X ω - m) :=
    (isSubGaussian_iff_psiTwoNorm_finite (μ := μ)
      (X := fun ω => X ω - m)).mpr hCenterFinite
  simpa [m, PsiTwoNorm] using And.intro hCenterSub hCenterGauge

/-- Uniform-constant form of the centering theorem. -/
theorem centeredSubGaussianPsiTwoNorm_uniform :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Ω → ℝ},
        IsSubGaussian μ X →
          IsSubGaussian μ (fun ω => X ω - ∫ x, X x ∂μ) ∧
          PsiTwoNorm μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
            ENNReal.ofReal C * PsiTwoNorm μ X := by
  refine ⟨1 + 32 * Real.exp 1, ?_, ?_⟩
  · nlinarith [Real.one_le_exp (by norm_num : (0 : ℝ) ≤ 1)]
  · intro Ω _ μ _ X hSub
    exact centeredSubGaussianPsiTwoNorm hSub

end NumStability.HDP.Scalar.SubGaussian
