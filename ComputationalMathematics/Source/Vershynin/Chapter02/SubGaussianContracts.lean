import ComputationalMathematics.HDP.Scalar.SubGaussian.Basic
import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise09.Signature
/-!
# Vershynin Chapter 2 sub-Gaussian source aliases

Source-correspondence declarations extracted from the reusable scalar producer.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open Filter
open scoped Topology BigOperators NNReal ENNReal

namespace NumStability.HDP.Contract

/-! Stable Chapter 2 alias for the Gaussian `ψ₂` example. -/
theorem hdp_02_hexample_h2_d5_d8a :
    ∃ C : ℝ, 0 < C ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
          (ProbabilityTheory.gaussianReal 0 1) id ≤ ENNReal.ofReal C ∧
        ∀ σ : ℝ, 0 ≤ σ →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
            (ProbabilityTheory.gaussianReal 0
              (⟨σ ^ 2, sq_nonneg σ⟩ : ℝ≥0)) id ≤
          ENNReal.ofReal (C * σ) := by
  refine ⟨2, by norm_num, ?_⟩
  simpa using
    NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_le_two_mul

/-! Stable Chapter 2 alias for Proposition 2.5.2. -/
theorem hdp_02_hprop_h2_d5_d2 :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianCharacterization_absolute

/-! Stable Chapter 2 alias for the gauge-facing characterization theorem. -/
theorem hdp_02_hthm_hpsi2_hnorm_hcharacterizations
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ∀ {K : ℝ}, 0 < K →
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K →
            NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
              ENNReal.ofReal (C * K)) ∧
      (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
        ((∃ K : ℝ, 0 < K ∧
          NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) ↔
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoGaugeCharacterizations hCenter

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Proposition 2.6.1.  The exact source-facing alias below now exposes intrinsic
`ψ₂` norms and one universally quantified absolute constant. -/
theorem hdp_02_hprop_h2_d6_d1_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2) :
    ∃ C : ℝ, 1 ≤ C ∧
      NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
          (fun ω => ∑ i, X i ω) .linearMGF
          (Real.sqrt (∑ i, K i ^ 2)) ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => ∑ i, X i ω) ≤
        ENNReal.ofReal (C * Real.sqrt (∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSum
    hX hIndep hEnergy

/-! Stable Chapter 2 alias for Proposition 2.6.1. -/
theorem hdp_02_hprop_h2_d6_d1 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
              (fun ω => ∑ i, X i ω) ∧
            (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                (fun ω => ∑ i, X i ω)).toReal ^ 2 ≤
              C * ∑ i,
                (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (X i)).toReal ^ 2 :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianSumPsiTwo

/-! Compatibility alias for the earlier scale-parametric MGF formulation of
Theorem 2.6.2.  The exact source-facing alias below uses intrinsic `ψ₂` norms
and quantifies one universal positive constant before the family. -/
theorem hdp_02_hthm_h2_d6_d2_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTail
    hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.2. -/
theorem hdp_02_hthm_h2_d6_d2 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ∑ i,
                  (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                    (X i)).toReal ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentCenteredSubGaussianTailPsiTwo

/-! Compatibility alias for the earlier common-MGF-scale formulation of
Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3_mgfScale
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ℝ}
    (hK : 0 < K)
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) K)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    {a : ι → ℝ}
    (hEnergy : 0 < ∑ i, a i ^ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * K ^ 2 * ∑ i, a i ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTail
    hK hX hIndep hEnergy ht

/-! Stable Chapter 2 alias for Theorem 2.6.3. -/
theorem hdp_02_hthm_h2_d6_d3 :
    ∃ c : ℝ, 0 < c ∧
      ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : ι → Ω → ℝ},
        (∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
        (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
        ProbabilityTheory.iIndepFun X μ →
        ∀ (a : ι → ℝ) {t : ℝ}, 0 ≤ t →
          μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
            2 * Real.exp
              (-(c * t ^ 2 /
                ((NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2 *
                  ∑ i, a i ^ 2))) :=
  NumStability.HDP.Scalar.SubGaussian.independentWeightedCenteredSubGaussianTailPsiTwo

/-! Stable Chapter 2 alias for Lemma 2.6.8. -/
theorem hdp_02_hlem_h2_d6_d8
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind)
    {K : ℝ} (hK : 0 < K)
    (hProp : NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K) :
    ∃ C : ℝ, 1 ≤ C ∧
      Integrable X μ ∧
      ∃ K' : ℝ, 0 < K' ∧ K' ≤ C * K ∧
        NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ
            (fun ω => X ω - ∫ x, X x ∂μ) .squarePoint K' ∧
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
            (fun ω => X ω - ∫ x, X x ∂μ) ≤
          ENNReal.ofReal (C * K) :=
  NumStability.HDP.Scalar.SubGaussian.centeredSubGaussian i hK hProp

/-! Stable Chapter 2 alias for Remark 2.5.3. -/
theorem hdp_02_hrem_h2_d5_d3 (A : ℝ) (hA : 1 < A) :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            i ≠ .linearMGF → j ≠ .linearMGF → ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ i j : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
            ∀ {Ki : ℝ}, 0 < Ki →
              NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                  μ X A i Ki →
                ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
                  NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyWithThreshold
                    μ X A j Kj) :=
  NumStability.HDP.Scalar.SubGaussian.subGaussianThresholdCharacterization_absolute A hA

/-! Stable Chapter 2 rendering of Definition 2.5.6.  It names the class using
any of the equivalent uncentered properties (i)--(iv) and identifies its
finite `ψ₂` norm with the displayed positive-scale infimum. -/
theorem hdp_02_hdef_h2_d5_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (_hX : Measurable X) :
    (∀ i : NumStability.HDP.Scalar.SubGaussian.SubGaussianPropertyKind,
      i ≠ .linearMGF →
        (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X ↔
          ∃ K : ℝ, 0 < K ∧
            NumStability.HDP.Scalar.SubGaussian.SubGaussianProperty μ X i K)) ∧
      (NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X →
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X < ∞ ∧
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X =
            sInf {t : ℝ≥0∞ |
              NumStability.HDP.Scalar.SubGaussian.PsiTwoAdmissible μ X t}) := by
  constructor
  · intro i hi
    exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_property i hi
  · intro hSub
    constructor
    · exact
        NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hSub
    · rfl

/-! Stable Chapter 2 alias for Exercise 2.5.7: the exact ψ₂ norm on the
measurable finite-gauge quotient modulo a.e. equality. -/
theorem hdp_02_hex_h2_d5_d7
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ x, 0 ≤ NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) ∧
      NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ 0 = 0 ∧
      (∀ x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x = 0 ↔
          x = 0) ∧
      (∀ x y,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (x + y) ≤
          NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x +
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ y) ∧
      (∀ (c : ℝ) x,
        NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ (c • x) =
          |c| *
            NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm μ x) :=
  NumStability.HDP.Scalar.SubGaussian.psiTwoQuotientNorm_isNorm μ

/-! Stable Chapter 2 alias for the essentially bounded `ψ₂` estimate. -/
theorem hdp_02_hexample_h2_d5_d8c
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ} {B : ℝ}
    (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ≤
      ENNReal.ofReal (B / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge hX hB hBound

/-! Stable Chapter 2 alias for the exact Rademacher `ψ₂` gauge. -/
theorem hdp_02_hexample_h2_d5_d8b :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
        NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id =
      ENNReal.ofReal (1 / Real.sqrt (Real.log 2)) :=
  NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoGauge_exact

/-! Stable Chapter 2 alias for the standard-normal `Lᵖ` moment formula. -/
theorem hdp_02_hex_h2_d5_d1 (p : ℝ) (hp : 1 ≤ p) :
    (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
      (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalLpNorm p hp

/-! Stable Chapter 2 alias for the standard-normal square-MGF example. -/
theorem hdp_02_hex_h2_d5_d5a (lam : ℝ) :
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1)) :=
  NumStability.HDP.Scalar.SubGaussian.standardNormalSquareMGF lam

/-! Stable Chapter 2 alias for the tail-to-moment direction. -/
theorem hdp_02_hlem_hsg_htail_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hX : Measurable X) (hK : 0 < K)
    (hTail : ∀ t : ℝ, 0 ≤ t →
      μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2)) :
    NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X
      (8 * Real.exp 1 * K) :=
  NumStability.HDP.Scalar.SubGaussian.tailToLpMomentGrowth hX hK hTail

/-- Stable Chapter 2 alias for the moment-to-square-MGF implication. -/
theorem hdp_02_hlem_hsg_hmoment_hto_hsquare_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hLp : NumStability.HDP.Scalar.SubGaussian.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
      (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤
        Real.exp (4 * Real.exp 1 * (lam * K) ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.momentToSquareMGF hK hLp lam hsmall

/-- Stable Chapter 2 alias for the square-MGF-to-MGF implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {C : ℝ} (hC : 0 ≤ C)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hSquare : NumStability.HDP.Scalar.SubGaussian.SquareMGFLocal μ X C)
    (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp ((C + 1 / 2) * lam ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToMGF hC hCenter hSquare lam

/-! Stable Chapter 2 alias for the square-MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hsquare_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : Integrable (fun ω => Real.exp (X ω ^ 2 / K ^ 2)) μ ∧
      (∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ) ≤ 2)
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / K ^ 2) :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for the global square-MGF boundedness exercise. -/
theorem hdp_02_hex_h2_d5_d5b
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 ≤ K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam ^ 2 * X ω ^ 2)) μ ∧
        (∫ ω, Real.exp (lam ^ 2 * X ω ^ 2) ∂μ) ≤ Real.exp (K * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) (hthreshold : K < t ^ 2) :
    μ.real {ω | |X ω| ≥ t} = 0 :=
  NumStability.HDP.Scalar.SubGaussian.squareMGFGlobalTailZero
    hX hK hMGF ht hthreshold

/-! Stable Chapter 2 alias for the all-parameter MGF-to-tail implication. -/
theorem hdp_02_hlem_hsg_hmgf_hto_htail
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Measurable X) (hK : 0 < K)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2))
    {t : ℝ} (ht : 0 ≤ t) :
    μ.real {ω | |X ω| ≥ t} ≤ 2 * Real.exp (-t ^ 2 / (4 * K ^ 2)) :=
  NumStability.HDP.Scalar.SubGaussian.mgfToTail hX hK hMGF ht

/-! Stable Chapter 2 alias for Exercise 2.5.4. -/
theorem hdp_02_hex_h2_d5_d4
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ}
    (hX : Integrable X μ)
    (hMGF : ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤ Real.exp (K ^ 2 * lam ^ 2)) :
    (∫ ω, X ω ∂μ) = 0 :=
  NumStability.HDP.Scalar.SubGaussian.mgfBoundForcesMeanZero hX hMGF

/-! Stable Chapter 2 alias for Exercise 2.6.9. -/
theorem hdp_02_hex_h2_d6_d9 : hdp_02_hex_h2_d6_d9__contract_type := by
  simpa [hdp_02_hex_h2_d6_d9__contract_type,
    NumStability.HDP.Scalar.SubGaussian.exercise269Law,
    NumStability.HDP.Scalar.SubGaussian.exercise269Mean,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoNorm,
    NumStability.HDP.Scalar.SubGaussian.twoPointPsiTwoAdmissible] using
    NumStability.HDP.Scalar.SubGaussian.exercise269_counterexample

/-! Stable Chapter 2 alias for the `L²` interpolation estimate. -/
theorem hdp_02_hlem_hlp_hextrapolation
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {Z : Ω → ℝ}
    (hZ1 : MemLp Z 1 μ) (hZ3 : MemLp Z 3 μ) :
    (∫ ω, |Z ω| ^ (2 : ℝ) ∂μ) ^ (1 / 2 : ℝ) ≤
      (∫ ω, |Z ω| ∂μ) ^ (1 / 4 : ℝ) *
        (∫ ω, |Z ω| ^ (3 : ℕ) ∂μ) ^ (1 / 4 : ℝ) :=
  NumStability.HDP.Scalar.SubGaussian.lpExtrapolation hZ1 hZ3

end NumStability.HDP.Contract
