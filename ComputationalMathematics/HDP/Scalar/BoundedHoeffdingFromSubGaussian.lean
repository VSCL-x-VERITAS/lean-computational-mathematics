import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Bounded Hoeffding bounds from the weighted sub-Gaussian theorem

This module records the reduction requested in Exercise 2.6.4.  Each centered
bounded variable is normalized by the width of its essential range, Hoeffding's
lemma supplies a uniform linear-MGF scale, and Theorem 2.6.3 is applied with the
range widths as coefficients.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.BoundedHoeffdingFromSubGaussian

open NumStability.HDP.Scalar.SubGaussian

/-- A centered variable normalized by the width of an almost-sure interval.
The zero-width branch is defined to be zero. -/
def normalizedCentered
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (m M : ℝ) : Ω → ℝ :=
  fun ω =>
    if M = m then 0
    else (X ω - ∫ y, X y ∂μ) / ‖M - m‖

/-- Hoeffding's lemma puts every nontrivially normalized bounded centered
variable into the common linear-MGF class of scale one. -/
theorem normalizedCentered_subGaussianLinearMGF
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {m M : ℝ}
    (hX : Measurable X)
    (hbound : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc m M) :
    SubGaussianLinearMGF μ (normalizedCentered μ X m M) 1 := by
  by_cases hMm : M = m
  · have hfun : normalizedCentered μ X m M = fun _ => 0 := by
      funext ω
      simp [normalizedCentered, hMm]
    refine ⟨?_, by norm_num, ?_, ?_, ?_⟩
    · rw [hfun]
      exact measurable_const
    · rw [hfun]
      simp
    · rw [hfun]
      simp
    · intro lam
      refine ⟨?_, ?_⟩
      · rw [hfun]
        simp
      · rw [hfun]
        simp
        positivity
  · have hw : ‖M - m‖ ≠ 0 := by
      simpa [norm_eq_zero, sub_eq_zero] using hMm
    have hwpos : 0 < ‖M - m‖ := lt_of_le_of_ne (norm_nonneg _) (Ne.symm hw)
    have hcenter := ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc
      (μ := μ) hX.aemeasurable hbound
    have hcenterInt : Integrable (fun ω => X ω - ∫ y, X y ∂μ) μ :=
      hcenter.integrable
    have hfun : normalizedCentered μ X m M =
        fun ω => (X ω - ∫ y, X y ∂μ) / ‖M - m‖ := by
      funext ω
      simp [normalizedCentered, hMm]
    refine ⟨?_, by norm_num, ?_, ?_, ?_⟩
    · rw [hfun]
      exact (hX.sub measurable_const).div_const ‖M - m‖
    · rw [hfun]
      simpa [div_eq_mul_inv, mul_comm] using
        hcenterInt.const_mul (‖M - m‖)⁻¹
    · have hXInt : Integrable X μ :=
        Integrable.of_mem_Icc m M hX.aemeasurable hbound
      rw [hfun]
      simp only [div_eq_mul_inv]
      rw [integral_mul_const]
      simp [integral_sub hXInt (integrable_const _)]
    · intro lam
      have hExp := hcenter.integrable_exp_mul (lam / ‖M - m‖)
      have hMgf := hcenter.mgf_le (lam / ‖M - m‖)
      refine ⟨?_, ?_⟩
      · convert hExp using 1
        funext ω
        simp [normalizedCentered, hMm, div_eq_mul_inv]
        ring
      · calc
          (∫ ω, Real.exp (lam * normalizedCentered μ X m M ω) ∂μ) =
              ProbabilityTheory.mgf
                (fun ω => X ω - ∫ y, X y ∂μ) μ
                (lam / ‖M - m‖) := by
                  simp only [ProbabilityTheory.mgf]
                  congr 1
                  funext ω
                  simp [normalizedCentered, hMm, div_eq_mul_inv]
                  ring
          _ ≤ Real.exp
              (((((‖M - m‖₊ / 2) ^ 2 : ℝ≥0) : ℝ) *
                (lam / ‖M - m‖) ^ 2) / 2) := hMgf
          _ = Real.exp (lam ^ 2 / 8) := by
            congr 1
            simp only [NNReal.coe_pow, NNReal.coe_div, coe_nnnorm,
              NNReal.coe_ofNat]
            field_simp [hw]
            ring
          _ ≤ Real.exp (1 ^ 2 * lam ^ 2) := by
            apply Real.exp_le_exp.mpr
            nlinarith [sq_nonneg lam]

/-- The two-sided Hoeffding-type estimate obtained by applying the weighted
sub-Gaussian tail theorem to normalized centered variables. -/
theorem boundedIndependentTwoSidedFromSubGaussian
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 ≤ t)
    (hWidth : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | |∑ i, (X i ω - ∫ y, X i y ∂μ)| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, ‖M i - m i‖ ^ 2)) := by
  let width : ι → ℝ := fun i => ‖M i - m i‖
  let Y : ι → Ω → ℝ := fun i => normalizedCentered μ (X i) (m i) (M i)
  have hY : ∀ i, SubGaussianLinearMGF μ (Y i) 1 := by
    intro i
    simpa [Y] using normalizedCentered_subGaussianLinearMGF
      (μ := μ) (hX i) (hbound i)
  have hIndepY : iIndepFun Y μ := by
    have hcomp := hIndep.comp
      (fun i x =>
        if M i = m i then 0
        else (x - ∫ y, X i y ∂μ) / width i)
      (fun i => by
        by_cases hMm : M i = m i
        · simp [hMm]
        · simp [hMm]
          fun_prop)
    simpa [Y, width, normalizedCentered, Function.comp_def] using hcomp
  have hTail := independentWeightedCenteredSubGaussianTail
    (μ := μ) (X := Y) (K := 1) (a := width) (t := t)
    (by norm_num) hY hIndepY (by simpa [width] using hWidth) ht
  have hcoord : ∀ i,
      (fun ω => width i * Y i ω) =ᵐ[μ]
        (fun ω => X i ω - ∫ y, X i y ∂μ) := by
    intro i
    by_cases hw : width i = 0
    · have hMm : M i = m i := by
        have : M i - m i = 0 := norm_eq_zero.mp (by simpa [width] using hw)
        linarith
      have hconst : X i =ᵐ[μ] fun _ => m i := by
        filter_upwards [hbound i] with ω hω
        exact le_antisymm (by simpa [hMm] using hω.2) hω.1
      have hmean : (∫ y, X i y ∂μ) = m i := by
        rw [integral_congr_ae hconst]
        simp
      filter_upwards [hconst] with ω hω
      simp [Y, normalizedCentered, width, hw, hω, hmean]
    · have hMm : M i ≠ m i := by
        intro h
        apply hw
        simp [width, h]
      exact Filter.Eventually.of_forall fun ω => by
        simp only [Y, normalizedCentered, hMm, if_false, width]
        exact mul_div_cancel₀ _ (by simpa [width] using hw)
  have hsum :
      (fun ω => ∑ i, width i * Y i ω) =ᵐ[μ]
        (fun ω => ∑ i, (X i ω - ∫ y, X i y ∂μ)) := by
    filter_upwards [Filter.eventually_all.2 hcoord] with ω hω
    exact Finset.sum_congr rfl fun i hi => hω i
  have hevent :
      {ω | |∑ i, width i * Y i ω| ≥ t} =ᵐ[μ]
        {ω | |∑ i, (X i ω - ∫ y, X i y ∂μ)| ≥ t} :=
    hsum.fun_comp fun z => |z| ≥ t
  calc
    μ.real {ω | |∑ i, (X i ω - ∫ y, X i y ∂μ)| ≥ t} =
        μ.real {ω | |∑ i, width i * Y i ω| ≥ t} := by
          exact congrArg ENNReal.toReal (measure_congr hevent.symm)
    _ ≤ 2 * Real.exp (-t ^ 2 / (4 * 1 ^ 2 * ∑ i, width i ^ 2)) := hTail
    _ = 2 * Real.exp (-t ^ 2 / (4 * ∑ i, ‖M i - m i‖ ^ 2)) := by
      simp [width]

/-- Exercise 2.6.4: a Hoeffding-type one-sided bound deduced from Theorem
2.6.3, with an explicit absolute constant in the exponent. -/
theorem boundedIndependentHoeffdingFromSubGaussian
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, ‖M i - m i‖ ^ 2)) := by
  let widthEnergy : ℝ := ∑ i, ‖M i - m i‖ ^ 2
  have hWidthNonneg : 0 ≤ widthEnergy := by
    dsimp [widthEnergy]
    exact Finset.sum_nonneg fun i _ => sq_nonneg ‖M i - m i‖
  by_cases hWidthZero : widthEnergy = 0
  · have hProb :
        μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤ 1 := by
      rw [Measure.real_def]
      exact ENNReal.toReal_mono ENNReal.one_ne_top prob_le_one
    calc
      μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤ 1 := hProb
      _ ≤ 2 * Real.exp (-t ^ 2 / (4 * ∑ i, ‖M i - m i‖ ^ 2)) := by
        simp [widthEnergy] at hWidthZero
        simp [hWidthZero]
  · have hWidth : 0 < ∑ i, ‖M i - m i‖ ^ 2 := by
      change 0 < widthEnergy
      exact lt_of_le_of_ne hWidthNonneg (Ne.symm hWidthZero)
    have hmono :
        μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
          μ.real {ω | |∑ i, (X i ω - ∫ y, X i y ∂μ)| ≥ t} := by
      rw [Measure.real_def, Measure.real_def]
      exact ENNReal.toReal_mono (measure_ne_top _ _)
        (measure_mono fun ω hω => by
          change t ≤ ∑ i, (X i ω - ∫ y, X i y ∂μ) at hω
          change t ≤ |∑ i, (X i ω - ∫ y, X i y ∂μ)|
          exact hω.trans (le_abs_self _))
    exact hmono.trans
      (boundedIndependentTwoSidedFromSubGaussian hX hIndep hbound ht hWidth)

end NumStability.HDP.Scalar.BoundedHoeffdingFromSubGaussian
