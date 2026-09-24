import ComputationalMathematics.HDP.Scalar.SubExponential.Basic
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Signature

/-!
# Vershynin Chapter 2 sub-exponential source aliases

Source-correspondence declarations extracted from the reusable scalar producer.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology ENNReal

namespace NumStability.HDP.Scalar.SubExponential
theorem remark279_contract :
    NumStability.HDP.Contract.hdp_02_hrem_h2_d7_d9__contract_type := by
  refine ⟨remark279Law, (fun x : ℝ => x), remark279Law_probability, ?_⟩
  constructor
  · rfl
  constructor
  · rfl
  constructor
  · simpa using remark279_mean
  constructor
  · simpa using remark279_second_moment
  constructor
  · simpa using remark279_local_taylor
  constructor
  · intro lam
    exact remark279_exp_mgf_lt_one
  · intro lam
    exact remark279_exp_mgf_not_integrable

end NumStability.HDP.Scalar.SubExponential

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the local Orlicz-function interface. -/
def hdp_02_hdef_horlicz_hfunction : Type :=
  NumStability.HDP.Scalar.SubExponential.OrliczFunction

/-- Stable source-facing alias for the Luxemburg/Orlicz norm-space model. -/
def hdp_02_hdef_horlicz_hnorm_hspace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
    (μ : Measure Ω) :
    NumStability.HDP.Scalar.SubExponential.OrliczNormSpaceModelData ψ μ :=
  NumStability.HDP.Scalar.SubExponential.orliczNormSpaceModel ψ μ

/-- Stable Chapter 2 alias for the centered moment-to-MGF implication. -/
theorem hdp_02_hlem_hse_hmoment_hto_hmgf
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K : ℝ} (hK : 0 < K)
    (hCenter : Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0)
    (hLp : NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X K)
    (lam : ℝ) (hsmall : |lam| ≤ (4 * Real.exp 1 * K)⁻¹) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
      (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        Real.exp (2 * (Real.exp 1 * (lam * K)) ^ 2) :=
  NumStability.HDP.Scalar.SubExponential.momentToMGF hK hCenter hLp lam hsmall

/-- Stable Chapter 2 alias for the endpoint-MGF-to-moment implication. -/
theorem hdp_02_hlem_hse_hmgf_hto_hmoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {K C : ℝ} (hK : 0 < K) (hC : 0 ≤ C)
    (hMGF : NumStability.HDP.Scalar.SubExponential.TwoSidedMGFBound μ X K C) :
    NumStability.HDP.Scalar.SubExponential.LpMomentGrowth μ X
      (2 * Real.exp C * K) :=
  NumStability.HDP.Scalar.SubExponential.mgfToMoment hK hC hMGF

/-! Stable Chapter 2 alias for Exercise 2.7.2. -/
theorem hdp_02_hex_h2_d7_d2
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubExponentialPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubExponentialProperty μ X j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subExponentialCharacterization

/-! Stable Chapter 2 alias for Exercise 2.7.3. -/
theorem hdp_02_hex_h2_d7_d3
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {α : ℝ} (hα : 0 < α) :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ i j : NumStability.HDP.Scalar.SubExponential.SubWeibullPropertyKind,
        ∀ {Ki : ℝ}, 0 < Ki →
          NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α i Ki →
            ∃ Kj : ℝ, 0 < Kj ∧ Kj ≤ C * Ki ∧
              NumStability.HDP.Scalar.SubExponential.SubWeibullProperty μ X α j Kj := by
  exact NumStability.HDP.Scalar.SubExponential.subWeibullCharacterization hα

/-! Stable Chapter 2 alias for Remark 2.7.9. -/
theorem hdp_02_hrem_h2_d7_d9 : hdp_02_hrem_h2_d7_d9__contract_type := by
  exact NumStability.HDP.Scalar.SubExponential.remark279_contract

/-! Stable Chapter 2 alias for Example 2.7.12. -/
theorem hdp_02_hexample_h2_d7_d12 :
    ∀ {Ω : Type*} [MeasurableSpace Ω]
      (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
      (μ : Measure Ω) (p : NNReal),
      0 < p →
      (∀ x : ℝ, 0 ≤ x → ψ x = x ^ (p : ℝ)) →
      (∀ X : Ω → ℝ,
        NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X =
          eLpNorm X (p : ENNReal) μ) ∧
      (∀ X : Ω → ℝ, AEStronglyMeasurable X μ →
        (NumStability.HDP.Scalar.SubExponential.orliczMember ψ μ X ↔
          MemLp X (p : ENNReal) μ)) := by
  exact NumStability.HDP.Scalar.SubExponential.powerOrliczCoincidence

/-! Stable Chapter 2 alias for Example 2.7.13. -/
theorem hdp_02_hexample_h2_d7_d13
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    NumStability.HDP.Scalar.SubExponential.orliczMember
        NumStability.HDP.Scalar.SubExponential.psiTwoOrliczFunction μ X ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞ := by
  exact NumStability.HDP.Scalar.SubExponential.psiTwoOrliczMember_iff_psiTwoMember hX

/-! Stable Chapter 2 alias for Definition 2.7.5 (sub-exponential random
variables and the sub-exponential norm).  The gauge is the canonical producer;
this alias records that finiteness of the gauge is exactly property (d) of
Proposition 2.7.1 for some positive parameter. -/
theorem hdp_02_hdef_h2_d7_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X < ∞ ↔
      ∃ K : ℝ, 0 < K ∧
        NumStability.HDP.Scalar.SubExponential.SubExponentialOnePointMGF μ X K :=
  NumStability.HDP.Scalar.SubExponential.psiOneGauge_finite_iff

/-! Stable Chapter 2 alias for display (2.21): the sub-exponential norm is the
infimum of the scales `t > 0` at which `𝔼 exp (|X| / t) ≤ 2`. -/
theorem hdp_02_heq_h2_d21
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X =
      sInf {t : ℝ≥0∞ |
        NumStability.HDP.Scalar.SubExponential.PsiOneAdmissible μ X t} :=
  rfl

/-! Stable Chapter 2 alias for Lemma 2.7.6 (sub-exponential is sub-gaussian
squared): `‖X²‖_{ψ₁} = ‖X‖²_{ψ₂}`, together with the iff form. -/
theorem hdp_02_hlem_h2_d7_d6
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} (hX : Measurable X) :
    (NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2) < ∞ ↔
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞) ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ (fun ω => X ω ^ 2) =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X ^ 2 :=
  ⟨NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_lt_top_iff hX,
    NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX⟩

/-! Stable Chapter 2 alias for the `ψ₁` half of Example 2.7.13: the Luxemburg
gauge of the Orlicz function `exp x - 1` is the sub-exponential norm. -/
theorem hdp_02_hexample_h2_d7_d13_hpsi1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    NumStability.HDP.Scalar.SubExponential.orliczGauge
        NumStability.HDP.Scalar.SubExponential.psiOneOrliczFunction μ X =
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge μ X :=
  NumStability.HDP.Scalar.SubExponential.psiOneOrliczGauge_eq_psiOneGauge hX

/-! Stable Chapter 2 alias for Lemma 2.7.7 (product of sub-gaussians is
sub-exponential): if `X` and `Y` are sub-gaussian then `XY` is sub-exponential
and `‖XY‖_{ψ₁} ≤ ‖X‖_{ψ₂} ‖Y‖_{ψ₂}`. -/
theorem hdp_02_hlem_h2_d7_d7
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ}
    (hX : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X < ∞)
    (hY : NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y < ∞) :
    NumStability.HDP.Scalar.SubExponential.PsiOneGauge
        μ (fun ω => X ω * Y ω) < ∞ ∧
      NumStability.HDP.Scalar.SubExponential.PsiOneGauge
          μ (fun ω => X ω * Y ω) ≤
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X *
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ Y :=
  ⟨NumStability.HDP.Scalar.SubExponential.psiOneGauge_mul_lt_top hX hY,
    NumStability.HDP.Scalar.SubExponential.psiOneGauge_mul_le hX hY⟩

end NumStability.HDP.Contract
