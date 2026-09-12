import ComputationalMathematics.HDP.Scalar.SubExponential
import ComputationalMathematics.HDP.Scalar.PoissonNormal
import ComputationalMathematics.Analysis.FiniteProbability

/-!
# Canonical sub-exponential distributions

Reusable distribution-level facts for the exponential and Poisson examples in
Vershynin, Example 2.7.8.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.SubExponentialExamples

open NumStability.HDP.Scalar.SubExponential

/-- An exponential law of positive rate `λ` is the push-forward of the
rate-one law by division by `λ`. -/
theorem map_div_expMeasure_one {lambda : ℝ} (hlambda : 0 < lambda) :
    Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1) = expMeasure lambda := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  letI : IsProbabilityMeasure (expMeasure lambda) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure hlambda
  apply Measure.ext_of_Iic
  intro x
  rw [Measure.map_apply (by fun_prop) measurableSet_Iic]
  have hpre : (fun y : ℝ ↦ y / lambda) ⁻¹' Iic x = Iic (lambda * x) := by
    ext y
    simp only [mem_preimage, mem_Iic]
    constructor <;> intro h
    · exact (div_le_iff₀' hlambda).1 h
    · exact (div_le_iff₀' hlambda).2 h
  rw [hpre, ← ProbabilityTheory.ofReal_cdf (expMeasure 1) (lambda * x),
    ← ProbabilityTheory.ofReal_cdf (expMeasure lambda) x]
  congr 1
  rw [ProbabilityTheory.cdf_expMeasure_eq (by norm_num),
    ProbabilityTheory.cdf_expMeasure_eq hlambda]
  by_cases hx : 0 ≤ x
  · rw [if_pos hx, if_pos (mul_nonneg hlambda.le hx)]
    congr 2
    ring
  · rw [if_neg hx, if_neg]
    exact not_le_of_gt (mul_neg_of_pos_of_neg hlambda (lt_of_not_ge hx))

/-- The rate-one exponential law is supported on the nonnegative half-line. -/
lemma expMeasure_one_ae_nonneg : ∀ᵐ x : ℝ ∂expMeasure 1, 0 ≤ x := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  rw [ae_iff]
  have hIic : expMeasure 1 (Iic (0 : ℝ)) = 0 := by
    rw [← ProbabilityTheory.ofReal_cdf (expMeasure 1) 0,
      ProbabilityTheory.cdf_expMeasure_eq (by norm_num)]
    simp
  apply measure_mono_null _ hIic
  intro x hx
  exact le_of_lt (lt_of_not_ge hx)

/-- With the book's threshold `E exp(|X|/K) ≤ 2`, the identity variable
under the rate-one exponential law has exact `ψ₁` gauge `2`. -/
theorem psiOneGauge_id_expMeasure_one :
    PsiOneGauge (expMeasure 1) (fun x : ℝ ↦ x) = 2 := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  have habs (K : ℝ) :
      (fun x : ℝ ↦ Real.exp (|x| / K)) =ᵐ[expMeasure 1]
        (fun x : ℝ ↦ Real.exp (K⁻¹ * x)) := by
    filter_upwards [expMeasure_one_ae_nonneg] with x hx
    rw [abs_of_nonneg hx]
    congr 1
    ring
  have htwo : PsiOneAdmissible (expMeasure 1) (fun x : ℝ ↦ x) 2 := by
    have hMGF := remark279_exp_mgf_lt_one (lam := (2 : ℝ)⁻¹) (by norm_num)
    have hEq := habs 2
    refine ⟨measurable_id, by norm_num, by norm_num, ?_, ?_⟩
    · change Integrable (fun x : ℝ ↦ Real.exp (|x| / 2)) (expMeasure 1)
      exact hMGF.1.congr hEq.symm
    · change (∫ x : ℝ, Real.exp (|x| / 2) ∂expMeasure 1) ≤ 2
      rw [integral_congr_ae hEq, hMGF.2]
      norm_num
  apply le_antisymm
  · exact sInf_le htwo
  · apply le_sInf
    intro t ht
    rcases ht with ⟨_, ht0, htTop, hInt, hBound⟩
    have hK : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
    rw [← ENNReal.ofReal_toReal htTop]
    rw [show (2 : ℝ≥0∞) = ENNReal.ofReal 2 by norm_num]
    apply ENNReal.ofReal_le_ofReal
    by_contra hnot
    have hKlt : t.toReal < 2 := lt_of_not_ge hnot
    have hEq := habs t.toReal
    have hMGFInt : Integrable (fun x : ℝ ↦ Real.exp ((t.toReal)⁻¹ * x))
        (expMeasure 1) := hInt.congr hEq
    by_cases hKone : t.toReal ≤ 1
    · have hInvOne : 1 ≤ (t.toReal)⁻¹ := by
        exact (one_le_inv₀ hK).2 hKone
      exact (remark279_exp_mgf_not_integrable hInvOne) hMGFInt
    · have hOneK : 1 < t.toReal := lt_of_not_ge hKone
      have hInvLt : (t.toReal)⁻¹ < 1 := by
        rw [inv_lt_one₀ hK]
        exact hOneK
      have hMGF := remark279_exp_mgf_lt_one hInvLt
      have hBound' : (1 - (t.toReal)⁻¹)⁻¹ ≤ 2 := by
        rw [← hMGF.2, ← integral_congr_ae hEq]
        exact hBound
      have hDen : 0 < t.toReal - 1 := sub_pos.mpr hOneK
      have hFormula : (1 - (t.toReal)⁻¹)⁻¹ =
          t.toReal / (t.toReal - 1) := by
        field_simp [hK.ne', hDen.ne']
      have hTooLarge : 2 < t.toReal / (t.toReal - 1) := by
        rw [lt_div_iff₀ hDen]
        linarith
      rw [hFormula] at hBound'
      exact (not_lt_of_ge hBound') hTooLarge

/-- The exponential law of rate `λ > 0` has exact `ψ₁` gauge `2 / λ` in
the normalization of Definition 2.7.5. -/
theorem psiOneGauge_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    PsiOneGauge (expMeasure lambda) (fun x : ℝ ↦ x) =
      ENNReal.ofReal (2 / lambda) := by
  rw [← map_div_expMeasure_one hlambda,
    psiOneGauge_map (by fun_prop : Measurable (fun x : ℝ ↦ x / lambda))]
  have hfun : (fun x : ℝ ↦ x / lambda) = (fun x : ℝ ↦ lambda⁻¹ * x) := by
    funext x
    ring
  rw [hfun, psiOneGauge_smul_of_pos (inv_pos.mpr hlambda),
    psiOneGauge_id_expMeasure_one]
  rw [show (2 : ℝ≥0∞) = ENNReal.ofReal 2 by norm_num,
    ← ENNReal.ofReal_mul (inv_nonneg.mpr hlambda.le)]
  congr 1
  field_simp

private lemma expMeasure_one_pdf_measurable :
    Measurable (ProbabilityTheory.exponentialPDF 1) := by
  unfold ProbabilityTheory.exponentialPDF
  exact (ProbabilityTheory.measurable_exponentialPDFReal 1).ennreal_ofReal

/-- The identity is integrable under the rate-one exponential law. -/
lemma integrable_id_expMeasure_one :
    Integrable (fun x : ℝ ↦ x) (expMeasure 1) := by
  change Integrable (fun x : ℝ ↦ x)
    (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
  rw [integrable_withDensity_iff expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  have hIoi : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x) (Ioi 0) volume := by
    apply (Real.GammaIntegral_convergent (s := 2) (by norm_num)).congr_fun
    · intro x hx
      change Real.exp (-x) * x ^ ((2 : ℝ) - 1) = Real.exp (-x) * x
      rw [show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_one]
    · exact measurableSet_Ioi
  have hIci : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x) (Ici 0) volume :=
    (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
  have hIndicator : Integrable
      ((Ici (0 : ℝ)).indicator (fun x : ℝ ↦ Real.exp (-x) * x)) volume :=
    hIci.integrable_indicator measurableSet_Ici
  apply hIndicator.congr
  filter_upwards with x
  by_cases hx : 0 ≤ x
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
    rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
    ring
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]

/-- The mean of the rate-one exponential law is one. -/
theorem integral_id_expMeasure_one :
    (∫ x : ℝ, x ∂expMeasure 1) = 1 := by
  change (∫ x : ℝ, x ∂volume.withDensity
    (ProbabilityTheory.exponentialPDF 1)) = 1
  rw [integral_withDensity_eq_integral_toReal_smul expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have hfun : (fun x : ℝ ↦ (ProbabilityTheory.exponentialPDF 1 x).toReal * x) =
      (Ici (0 : ℝ)).indicator (fun x : ℝ ↦ x * Real.exp (-x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
  rw [hfun, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  have hIntegral := Real.integral_rpow_mul_exp_neg_mul_Ioi
    (a := 2) (r := 1) (by norm_num) (by norm_num)
  calc
    (∫ t : ℝ in Ioi 0, t * Real.exp (-t)) =
        ∫ t : ℝ in Ioi 0, t ^ ((2 : ℝ) - 1) * Real.exp (-(1 * t)) := by
          apply setIntegral_congr_fun measurableSet_Ioi
          intro t ht
          change t * Real.exp (-t) =
            t ^ ((2 : ℝ) - 1) * Real.exp (-(1 * t))
          rw [show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_one]
          ring
    _ = (1 / (1 : ℝ)) ^ (2 : ℝ) * Real.Gamma 2 := hIntegral
    _ = 1 := by
      have hGamma : Real.Gamma 2 = 1 := by
        convert Real.Gamma_nat_eq_factorial 1 using 1 <;> norm_num
      rw [hGamma]
      norm_num

/-- The squared identity is integrable under the rate-one exponential law. -/
lemma integrable_sq_id_expMeasure_one :
    Integrable (fun x : ℝ ↦ x ^ 2) (expMeasure 1) := by
  change Integrable (fun x : ℝ ↦ x ^ 2)
    (volume.withDensity (ProbabilityTheory.exponentialPDF 1))
  rw [integrable_withDensity_iff expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  have hIoi : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x ^ 2) (Ioi 0) volume := by
    apply (Real.GammaIntegral_convergent (s := 3) (by norm_num)).congr_fun
    · intro x hx
      change Real.exp (-x) * x ^ ((3 : ℝ) - 1) = Real.exp (-x) * x ^ 2
      rw [show (3 : ℝ) - 1 = 2 by norm_num, Real.rpow_two]
    · exact measurableSet_Ioi
  have hIci : IntegrableOn (fun x : ℝ ↦ Real.exp (-x) * x ^ 2) (Ici 0) volume :=
    (integrableOn_Ici_iff_integrableOn_Ioi).2 hIoi
  have hIndicator : Integrable
      ((Ici (0 : ℝ)).indicator (fun x : ℝ ↦ Real.exp (-x) * x ^ 2)) volume :=
    hIci.integrable_indicator measurableSet_Ici
  apply hIndicator.congr
  filter_upwards with x
  by_cases hx : 0 ≤ x
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
    rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
    ring
  · simp [ProbabilityTheory.exponentialPDF,
      ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]

/-- The raw second moment of the rate-one exponential law is two. -/
theorem integral_sq_id_expMeasure_one :
    (∫ x : ℝ, x ^ 2 ∂expMeasure 1) = 2 := by
  change (∫ x : ℝ, x ^ 2 ∂volume.withDensity
    (ProbabilityTheory.exponentialPDF 1)) = 2
  rw [integral_withDensity_eq_integral_toReal_smul expMeasure_one_pdf_measurable
    (by filter_upwards [] with x; exact ENNReal.coe_lt_top)]
  simp_rw [smul_eq_mul]
  have hfun :
      (fun x : ℝ ↦ (ProbabilityTheory.exponentialPDF 1 x).toReal * x ^ 2) =
        (Ici (0 : ℝ)).indicator (fun x : ℝ ↦ x ^ 2 * Real.exp (-x)) := by
    funext x
    by_cases hx : 0 ≤ x
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
      rw [ENNReal.toReal_ofReal (le_of_lt (Real.exp_pos (-x)))]
      ring
    · simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal, hx]
  rw [hfun, integral_indicator measurableSet_Ici, integral_Ici_eq_integral_Ioi]
  have hIntegral := Real.integral_rpow_mul_exp_neg_mul_Ioi
    (a := 3) (r := 1) (by norm_num) (by norm_num)
  calc
    (∫ t : ℝ in Ioi 0, t ^ 2 * Real.exp (-t)) =
        ∫ t : ℝ in Ioi 0, t ^ ((3 : ℝ) - 1) * Real.exp (-(1 * t)) := by
          apply setIntegral_congr_fun measurableSet_Ioi
          intro t ht
          change t ^ 2 * Real.exp (-t) =
            t ^ ((3 : ℝ) - 1) * Real.exp (-(1 * t))
          rw [show (3 : ℝ) - 1 = 2 by norm_num, Real.rpow_two]
          ring
    _ = (1 / (1 : ℝ)) ^ (3 : ℝ) * Real.Gamma 3 := hIntegral
    _ = 2 := by
      have hGamma : Real.Gamma 3 = 2 := by
        convert Real.Gamma_nat_eq_factorial 2 using 1 <;> norm_num
      rw [hGamma]
      norm_num

/-- The mean of an exponential law of rate `λ > 0` is `1 / λ`. -/
theorem integral_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    (∫ x : ℝ, x ∂expMeasure lambda) = 1 / lambda := by
  rw [← map_div_expMeasure_one hlambda,
    integral_map (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))
      (by fun_prop : AEStronglyMeasurable (fun x : ℝ ↦ x)
        (Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1)))]
  rw [integral_div, integral_id_expMeasure_one]

/-- The raw second moment of an exponential law of rate `λ > 0` is
`2 / λ²`. -/
theorem integral_sq_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    (∫ x : ℝ, x ^ 2 ∂expMeasure lambda) = 2 / lambda ^ 2 := by
  rw [← map_div_expMeasure_one hlambda,
    integral_map (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))
      (by fun_prop : AEStronglyMeasurable (fun x : ℝ ↦ x ^ 2)
        (Measure.map (fun x : ℝ ↦ x / lambda) (expMeasure 1)))]
  have hfun : (fun x : ℝ ↦ (x / lambda) ^ 2) =
      (fun x : ℝ ↦ lambda⁻¹ ^ 2 * x ^ 2) := by
    funext x
    field_simp
  rw [hfun, integral_const_mul, integral_sq_id_expMeasure_one]
  field_simp

/-- The identity belongs to `L²` under every positive-rate exponential law. -/
theorem memLp_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    MemLp (fun x : ℝ ↦ x) 2 (expMeasure lambda) := by
  refine (memLp_two_iff_integrable_sq
    (f := fun x : ℝ ↦ x) measurable_id.aestronglyMeasurable).2 ?_
  rw [← map_div_expMeasure_one hlambda]
  apply (integrable_map_measure (by fun_prop)
    (by fun_prop : AEMeasurable (fun x : ℝ ↦ x / lambda) (expMeasure 1))).2
  have h := integrable_sq_id_expMeasure_one.const_mul (lambda⁻¹ ^ 2)
  apply h.congr
  filter_upwards with x
  dsimp [Function.comp_def]
  field_simp

/-- The variance of an exponential law of rate `λ > 0` is `1 / λ²`. -/
theorem variance_id_expMeasure {lambda : ℝ} (hlambda : 0 < lambda) :
    Var[fun x : ℝ ↦ x; expMeasure lambda] = 1 / lambda ^ 2 := by
  letI : IsProbabilityMeasure (expMeasure lambda) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure hlambda
  rw [variance_eq_sub (memLp_id_expMeasure hlambda)]
  change (∫ x : ℝ, x ^ 2 ∂expMeasure lambda) -
    (∫ x : ℝ, x ∂expMeasure lambda) ^ 2 = 1 / lambda ^ 2
  rw [integral_sq_id_expMeasure hlambda, integral_id_expMeasure hlambda]
  field_simp [hlambda.ne']
  ring

/-- The natural-number coordinate under every Poisson law has finite `ψ₁`
gauge.  The proof reuses the exact Poisson MGF and an existing scalar
exponential remainder bound. -/
theorem psiOneGauge_natCast_poisson_lt_top (rate : ℝ≥0) :
    PsiOneGauge (ProbabilityTheory.poissonMeasure rate)
      (fun n : ℕ ↦ (n : ℝ)) < ∞ := by
  let r : ℝ := rate
  let K : ℝ := 4 * Real.exp 1 * (r + 1)
  let s : ℝ := K⁻¹
  have hr0 : 0 ≤ r := by positivity
  have hr1 : 0 < r + 1 := by positivity
  have hK : 0 < K := by
    dsimp [K]
    positivity
  have hKone : 1 ≤ K := by
    dsimp [K]
    nlinarith [Real.exp_one_gt_two]
  have hs : 0 < s := by
    dsimp [s]
    positivity
  have hsOne : s ≤ 1 := by
    dsimp [s]
    exact (inv_le_one₀ hK).2 hKone
  have hExpS : Real.exp s ≤ Real.exp 1 := Real.exp_le_exp.mpr hsOne
  have hRem : Real.exp s - 1 ≤ s * Real.exp 1 :=
    (NumStability.real_exp_sub_one_le_mul_exp s).trans
      (mul_le_mul_of_nonneg_left hExpS hs.le)
  have hExponent : r * (Real.exp s - 1) ≤ 1 / 4 := by
    calc
      r * (Real.exp s - 1) ≤ r * (s * Real.exp 1) :=
        mul_le_mul_of_nonneg_left hRem hr0
      _ = r / (4 * (r + 1)) := by
        dsimp [s, K]
        field_simp [Real.exp_ne_zero]
      _ ≤ 1 / 4 := by
        rw [div_le_iff₀ (by positivity : (0 : ℝ) < 4 * (r + 1))]
        nlinarith
  have hfun : (fun n : ℕ ↦ Real.exp (|(n : ℝ)| / K)) =
      (fun n : ℕ ↦ Real.exp (s * (n : ℝ))) := by
    funext n
    rw [abs_of_nonneg (Nat.cast_nonneg n)]
    congr 1
    simp [s, div_eq_mul_inv, mul_comm]
  apply (psiOneGauge_finite_iff).2
  refine ⟨K, hK, measurable_of_countable _, hK, ?_, ?_⟩
  · rw [hfun]
    exact NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.integrable_exp_nat_poisson
      rate s
  · rw [hfun,
      NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonMgfExact]
    calc
      Real.exp (r * (Real.exp s - 1)) ≤ Real.exp (1 / 4) :=
        Real.exp_le_exp.mpr hExponent
      _ ≤ Real.exp (Real.log 2) := by
        apply Real.exp_le_exp.mpr
        linarith [Real.log_two_gt_d9]
      _ = 2 := Real.exp_log (by norm_num)

/-- Every real-valued Poisson distribution is sub-exponential. -/
theorem psiOneGauge_id_poissonRealLaw_lt_top (rate : ℝ≥0) :
    PsiOneGauge
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (fun x : ℝ ↦ x) < ∞ := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    psiOneGauge_map (measurable_of_countable (fun n : ℕ ↦ (n : ℝ)))]
  exact psiOneGauge_natCast_poisson_lt_top rate

end NumStability.HDP.Scalar.SubExponentialExamples
