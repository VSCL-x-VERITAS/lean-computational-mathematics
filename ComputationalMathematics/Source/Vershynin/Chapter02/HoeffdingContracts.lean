import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding.Basic

/-!
# Vershynin Chapter 2 Hoeffding source aliases

Source-correspondence declarations extracted from the reusable scalar producer.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

/-! Stable source-facing alias for Theorem 2.2.2. -/
theorem hdp_02_hthm_h2_d2_d2
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (ht : 0 ≤ t) :
    μ.real {ω | ∑ i, a i * X i ω ≥ t} ≤
      Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherHoeffdingAll
    hX hIndep hLaw ht

/-! Stable source-facing alias for Theorem 2.2.5. -/
theorem hdp_02_hthm_h2_d2_d5
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (hNegLaw : ∀ i, Measure.map (fun ω => -X i ω) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ)
    (ht : 0 < t) (hv : 0 < ∑ i, (a i) ^ 2) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherTwoSidedHoeffding
    hX hIndep hLaw hNegLaw hExp ht hv

/-! Stable Chapter 2 alias for the fair-coin Hoeffding application. -/
theorem hdp_02_hex_hfair_hcoin_hhoeffding
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF.toMeasure)
    (hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam *
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue (B i ω))) μ)
    (hN : 0 < Fintype.card ι) :
    μ.real {ω | ∑ i,
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.bernoulliIndicator (B i ω) ≥
      (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      Real.exp (-(Fintype.card ι : ℝ) / 8) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairCoinHoeffding
    hB hIndep hLaw hExp hN

/-! Stable Chapter 2 alias for the bounded-variable Hoeffding theorem. -/
theorem hdp_02_hthm_h2_d2_d6
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) (hv : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.boundedIndependentHoeffding
    hX hIndep hbound ht hv

/-! Stable Chapter 2 alias for the bounded-variable proof exercise. -/
theorem hdp_02_hex_h2_d2_d7
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {m M : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, X i ω ∈ Set.Icc (m i) (M i))
    (ht : 0 < t) (hv : 0 < ∑ i, ‖M i - m i‖ ^ 2) :
    μ.real {ω | ∑ i, (X i ω - ∫ y, X i y ∂μ) ≥ t} ≤
      Real.exp (-2 * t ^ 2 / (∑ i, ‖M i - m i‖ ^ 2)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.boundedIndependentHoeffding
    hX hIndep hbound ht hv

/-! Stable Chapter 2 alias for the majority-vote amplification exercise. -/
theorem hdp_02_hex_h2_d2_d8
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {W : ι → Ω → ℝ} {δ ε : ℝ}
    (hW : ∀ i, Measurable (W i))
    (hIndep : iIndepFun W μ)
    (hbound : ∀ i, ∀ᵐ ω ∂μ, W i ω ∈ Set.Icc 0 1)
    (hmean : ∀ i, (∫ y, W i y ∂μ) ≤ 1 / 2 - δ)
    (hδ : 0 < δ) (hε0 : 0 < ε) (hε1 : ε < 1)
    (hN : 0 < Fintype.card ι)
    (hNlarge : Real.log (1 / ε) / (2 * δ ^ 2) ≤ (Fintype.card ι : ℝ)) :
    μ.real {ω | ∑ i, W i ω ≥ (Fintype.card ι : ℝ) / 2} ≤ ε :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.majorityVoteHoeffding
    hW hIndep hbound hmean hδ hε0 hε1 hN hNlarge

/-- Stable Chapter 2 alias for the centered bounded-variable Hoeffding lemma. -/
theorem hdp_02_hlem_hhoeffding_hbounded_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {a b : ℝ}
    (hX : AEMeasurable X μ)
    (hbound : ∀ᵐ ω ∂μ, X ω ∈ Set.Icc a b)
    (hmean : ∫ ω, X ω ∂μ = 0) :
    HasSubgaussianMGF X ((‖b - a‖₊ / 2) ^ 2) μ :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.hoeffdingBoundedMGF
    hX hbound hmean

theorem hdp_02_hlem_hhoeffding_hoptimization {v t : ℝ} (hv : 0 < v)
    (ht : 0 ≤ t) :
    (∀ u : ℝ, 0 ≤ u →
      -t ^ 2 / (2 * v) ≤ -u * t + u ^ 2 * v / 2) ∧
      (-(t / v) * t + (t / v) ^ 2 * v / 2 = -t ^ 2 / (2 * v)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.hoeffdingOptimization hv ht

/-- Stable Chapter 2 alias for Exercise 2.2.3. -/
theorem hdp_02_hex_h2_d2_d3 (x : ℝ) :
    Real.cosh x ≤ Real.exp (x ^ 2 / 2) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.coshLeExpHalfSq x

/-- Stable Chapter 2 alias for Exercise 2.2.10(a). -/
theorem hdp_02_hex_h2_d2_d10a {f : ℝ → ℝ}
    (hf : NumStability.HDP.Scalar.IndependentSums.Hoeffding.BoundedDensityOnNonnegative f)
    {t : ℝ} (ht : 0 < t) :
    ∫ x, Real.exp (-t * x) * f x ∂(volume : Measure ℝ) ≤ 1 / t :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.laplaceTransformLeInv hf ht

end NumStability.HDP.Contract
