import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff
import ComputationalMathematics.HDP.Scalar.PoissonLimit
import Mathlib.Probability.HasLawExists

/-!
# Poisson moment foundations for normal approximation

Exact first and second moments, square integrability, and variance for the
real-valued Poisson law. These results provide the moment data needed to feed
the reusable i.i.d. central limit theorem into Poisson normal approximation.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Filter
open scoped ENNReal NNReal BigOperators Topology

namespace NumStability.HDP.Scalar.PoissonNormal

open NumStability.HDP.Scalar.IndependentSums.PoissonChernoff

/-- The probability-weighted first-moment series of a Poisson law sums to its
rate. -/
theorem poissonPMFReal_firstMoment_hasSum (rate : ℝ≥0) :
    HasSum (fun n : ℕ => (n : ℝ) * poissonPMFReal rate n) (rate : ℝ) := by
  let f : ℕ → ℝ := fun n => (n : ℝ) * poissonPMFReal rate n
  have hshift : HasSum (fun n : ℕ => f (n + 1)) (rate : ℝ) := by
    convert (poissonPMFRealSum rate).mul_left (rate : ℝ) using 1
    ext n
    dsimp [f]
    rw [poissonPMFReal, poissonPMFReal, Nat.factorial_succ, pow_succ]
    push_cast
    field_simp
    ring_nf
  apply (hasSum_nat_add_iff' (f := f) 1).mp
  simpa [f] using hshift

/-- The probability-weighted raw second-moment series of a Poisson law sums
to `rate ^ 2 + rate`. -/
theorem poissonPMFReal_secondMoment_hasSum (rate : ℝ≥0) :
    HasSum (fun n : ℕ => (n : ℝ) ^ 2 * poissonPMFReal rate n)
      ((rate : ℝ) ^ 2 + (rate : ℝ)) := by
  let f : ℕ → ℝ := fun n => (n : ℝ) ^ 2 * poissonPMFReal rate n
  have hplus : HasSum
      (fun n : ℕ => ((n : ℝ) + 1) * poissonPMFReal rate n)
      ((rate : ℝ) + 1) := by
    simpa [add_mul] using
      (poissonPMFReal_firstMoment_hasSum rate).add (poissonPMFRealSum rate)
  have hshift : HasSum (fun n : ℕ => f (n + 1))
      ((rate : ℝ) * ((rate : ℝ) + 1)) := by
    convert hplus.mul_left (rate : ℝ) using 1
    ext n
    dsimp [f]
    rw [poissonPMFReal, poissonPMFReal, Nat.factorial_succ, pow_succ]
    push_cast
    field_simp
    ring
  apply (hasSum_nat_add_iff' (f := f) 1).mp
  convert hshift using 1
  simp [f]
  ring

/-- The squared natural-number coordinate is integrable under every Poisson
law. -/
theorem integrable_sq_nat_poisson (rate : ℝ≥0) :
    Integrable (fun n : ℕ => (n : ℝ) ^ 2) (poissonMeasure rate) := by
  apply (integrable_exp_nat_poisson rate 2).mono'
  · fun_prop
  · filter_upwards with n
    change ‖(n : ℝ) ^ 2‖ ≤ Real.exp (2 * (n : ℝ))
    rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _)]
    have hn : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
    have h := Real.quadratic_le_exp_of_nonneg
      (show 0 ≤ 2 * (n : ℝ) by positivity)
    nlinarith

/-- Conversion of the Poisson PMF value from `ENNReal` to its defining real
mass. -/
lemma poissonPMF_toReal (rate : ℝ≥0) (n : ℕ) :
    ((poissonPMF rate) n).toReal = poissonPMFReal rate n := by
  rw [poissonPMF]
  exact ENNReal.toReal_ofReal poissonPMFReal_nonneg

/-- The mean of the real-valued Poisson law equals its rate. -/
theorem integral_id_poissonRealLaw (rate : ℝ≥0) :
    ∫ x : ℝ, x ∂NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate =
      (rate : ℝ) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    integral_map (φ := fun n : ℕ => (n : ℝ)) (f := fun x : ℝ => x)
      (measurable_of_countable _).aemeasurable
      continuous_id.aestronglyMeasurable,
      NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum]
  · simp_rw [poissonPMF_toReal]
    simpa [smul_eq_mul, mul_comm] using
      (poissonPMFReal_firstMoment_hasSum rate).tsum_eq
  · apply (integrable_exp_nat_poisson rate 1).mono'
    · fun_prop
    · filter_upwards with n
      simp only [one_mul]
      change ‖(n : ℝ)‖ ≤ Real.exp (n : ℝ)
      rw [Real.norm_eq_abs, abs_of_nonneg (Nat.cast_nonneg n)]
      have h := Real.quadratic_le_exp_of_nonneg (Nat.cast_nonneg n)
      nlinarith [sq_nonneg (n : ℝ)]

/-- The raw second moment of the real-valued Poisson law is
`rate ^ 2 + rate`. -/
theorem integral_sq_poissonRealLaw (rate : ℝ≥0) :
    ∫ x : ℝ, x ^ 2 ∂NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate =
      (rate : ℝ) ^ 2 + (rate : ℝ) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw,
    integral_map (φ := fun n : ℕ => (n : ℝ)) (f := fun x : ℝ => x ^ 2)
      (measurable_of_countable _).aemeasurable
      (continuous_id.pow 2).aestronglyMeasurable,
      NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  rw [ProbabilityTheory.poissonMeasure]
  rw [PMF.integral_eq_tsum _ _ (integrable_sq_nat_poisson rate)]
  simp_rw [poissonPMF_toReal]
  simpa [smul_eq_mul, mul_comm] using
    (poissonPMFReal_secondMoment_hasSum rate).tsum_eq

/-- The identity random variable belongs to `L²` under every real-valued
Poisson law. -/
theorem memLp_id_poissonRealLaw (rate : ℝ≥0) :
    MemLp (fun x : ℝ => x) 2
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate) := by
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw]
  rw [memLp_map_measure_iff (g := fun x : ℝ => x)
    (f := fun n : ℕ => (n : ℝ)) continuous_id.aestronglyMeasurable
      (measurable_of_countable _).aemeasurable]
  change MemLp (fun n : ℕ => (n : ℝ)) 2
    (NumStability.HDP.Scalar.LimitTheorems.poissonLaw rate)
  rw [NumStability.HDP.Scalar.LimitTheorems.poissonLaw]
  exact (memLp_two_iff_integrable_sq
    (measurable_of_countable _).aestronglyMeasurable).2
      (integrable_sq_nat_poisson rate)

/-- The variance of the real-valued Poisson law equals its rate. -/
theorem variance_id_poissonRealLaw (rate : ℝ≥0) :
    Var[fun x : ℝ => x;
      NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] =
        (rate : ℝ) := by
  let μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate
  have hId : Integrable (fun x : ℝ => x) μ :=
    (memLp_id_poissonRealLaw rate).integrable (by norm_num)
  have hSq : Integrable (fun x : ℝ => x ^ 2) μ :=
    (memLp_id_poissonRealLaw rate).integrable_sq
  have hConst : Integrable (fun _ : ℝ => (rate : ℝ) ^ 2) μ :=
    integrable_const _
  have hLin : Integrable (fun x : ℝ => (2 * (rate : ℝ)) * x) μ :=
    hId.const_mul _
  rw [variance_eq_integral (memLp_id_poissonRealLaw rate).aemeasurable,
    integral_id_poissonRealLaw]
  calc
    (∫ x : ℝ, (x - (rate : ℝ)) ^ 2 ∂μ) =
        ∫ x : ℝ, x ^ 2 - (2 * (rate : ℝ)) * x + (rate : ℝ) ^ 2 ∂μ := by
      congr 1
      funext x
      ring
    _ = (∫ x : ℝ, x ^ 2 ∂μ) -
          (2 * (rate : ℝ)) * (∫ x : ℝ, x ∂μ) + (rate : ℝ) ^ 2 := by
      have hfun :
          (fun x : ℝ => x ^ 2 - (2 * (rate : ℝ)) * x + (rate : ℝ) ^ 2) =
            (fun x : ℝ => x ^ 2) -
              (fun x : ℝ => (2 * (rate : ℝ)) * x) +
                (fun _ : ℝ => (rate : ℝ) ^ 2) := rfl
      rw [hfun]
      change (∫ x : ℝ,
          (((fun y : ℝ => y ^ 2) -
            (fun y : ℝ => (2 * (rate : ℝ)) * y)) x) +
            (fun _ : ℝ => (rate : ℝ) ^ 2) x ∂μ) = _
      rw [integral_add (hSq.sub hLin) hConst]
      simp only [Pi.sub_apply]
      rw [integral_sub hSq hLin, integral_const_mul]
      simp [μ]
    _ = (rate : ℝ) := by
      rw [show (∫ x : ℝ, x ^ 2 ∂μ) = (rate : ℝ) ^ 2 + (rate : ℝ) by
        exact integral_sq_poissonRealLaw rate,
        show (∫ x : ℝ, x ∂μ) = (rate : ℝ) by
          exact integral_id_poissonRealLaw rate]
      ring

/-- A finite sum of independent real-valued Poisson variables is Poisson with
the sum of the rates. This is the finite-sum law bridge between the reusable
Poisson and i.i.d. central-limit APIs. -/
theorem hasLaw_sum_poissonRealLaw
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (rate : ι → ℝ≥0)
    (hX : ∀ i, HasLaw (X i)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (rate i)) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) :
    HasLaw (fun ω => ∑ i, X i ω)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (∑ i, rate i)) μ := by
  have hMeas : ∀ i, AEMeasurable (X i) μ := fun i => (hX i).aemeasurable
  have hsum_eq : (∑ i, X i) = fun ω => ∑ i, X i ω := by
    funext ω
    simp
  refine { aemeasurable := ?_, map_eq := ?_ }
  · exact Finset.univ.aemeasurable_fun_sum fun i _ => hMeas i
  · rw [← hsum_eq]
    apply Measure.ext_of_charFun
    calc
      MeasureTheory.charFun (μ.map (∑ i, X i)) =
          ∏ i, MeasureTheory.charFun (μ.map (X i)) := by
        exact hIndep.charFun_map_sum_eq_prod hMeas
      _ = ∏ i, MeasureTheory.charFun
          (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (rate i)) := by
        congr 1
        funext i
        rw [(hX i).map_eq]
      _ = MeasureTheory.charFun
          (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw (∑ i, rate i)) := by
        funext t
        simp only [Finset.prod_apply]
        simp_rw [NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw_charFun]
        rw [← Complex.exp_sum]
        congr 1
        push_cast
        rw [Finset.sum_mul]

/-- The reusable i.i.d. CLT specialized to a sequence of rate-one real
Poisson variables. -/
theorem tendsto_probabilityLaw_normalized_poissonOne_iid
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ)
    (hX : ∀ i, HasLaw (X i)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) :
    Tendsto (fun n => NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
        (NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X 1 1 n)
        (NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum_memLp
          X 1 1 (fun i => by
            have hp := memLp_id_poissonRealLaw 1
            rw [← (hX i).map_eq] at hp
            simpa [Function.comp_def] using
              (memLp_map_measure_iff continuous_id.aestronglyMeasurable
                (hX i).aemeasurable).1 hp) n).aemeasurable)
      atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  have hMem : ∀ i, MemLp (X i) 2 μ := by
    intro i
    have hp := memLp_id_poissonRealLaw 1
    rw [← (hX i).map_eq] at hp
    simpa [Function.comp_def] using
      (memLp_map_measure_iff continuous_id.aestronglyMeasurable
        (hX i).aemeasurable).1 hp
  have hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ :=
    fun i => (hX i).identDistrib (hX 0)
  have hMean : ∫ ω, X 0 ω ∂μ = (1 : ℝ) := by
    rw [(hX 0).integral_eq, integral_id_poissonRealLaw]
    norm_num
  have hVariance : Var[X 0; μ] = (1 : ℝ) ^ 2 := by
    rw [(hX 0).variance_eq]
    change Var[(fun x : ℝ => x);
      NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1] = (1 : ℝ) ^ 2
    rw [variance_id_poissonRealLaw]
    norm_num
  simpa only using
    (NumStability.HDP.Scalar.LimitTheorems.tendsto_probabilityLaw_normalizedIidSum
      X 1 1 (by norm_num) hMem hIndep hIdent hMean hVariance)

/-- The standardized real Poisson law at a nonnegative rate. At rate zero the
normalizing map is identically zero; that endpoint is irrelevant to the
`atTop` limit. -/
noncomputable def standardizedPoissonLaw (rate : ℝ≥0) : ProbabilityMeasure ℝ :=
  (NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure
    rate).map (by fun_prop : AEMeasurable
      (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw
        rate))

/-- Exact characteristic function of the standardized real Poisson law. -/
theorem standardizedPoissonLaw_charFun (rate : ℝ≥0) (t : ℝ) :
    MeasureTheory.charFun (standardizedPoissonLaw rate : Measure ℝ) t =
      Complex.exp ((rate : ℂ) *
        (Complex.exp ((((t / Real.sqrt (rate : ℝ)) : ℝ) : ℂ) * Complex.I) - 1 -
          (((t / Real.sqrt (rate : ℝ)) : ℝ) : ℂ) * Complex.I)) := by
  let a : ℝ := (Real.sqrt (rate : ℝ))⁻¹
  have hscale :=
    NumStability.HDP.Scalar.LimitTheorems.charFun_probabilityLaw_const_mul
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (fun x : ℝ => x - (rate : ℝ)) (by fun_prop) a t
  have hcenter :=
    NumStability.HDP.Scalar.LimitTheorems.charFun_probabilityLaw_sub_const
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      id (by fun_prop) (rate : ℝ) (a * t)
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => a * (x - (rate : ℝ)))) t =
    MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => x - (rate : ℝ))) (a * t) at hscale
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => x - (rate : ℝ))) (a * t) =
    MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map id) (a * t) *
        Complex.exp (-(((a * t : ℝ) : ℂ) * (rate : ℂ)) * Complex.I) at hcenter
  change MeasureTheory.charFun
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))) t = _
  rw [show (Real.sqrt (rate : ℝ))⁻¹ = a by rfl, hscale, hcenter]
  simp only [Measure.map_id, NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw_charFun]
  rw [← Complex.exp_add]
  congr 1
  dsimp [a]
  push_cast
  ring_nf

/-- The family of all standardized Poisson laws is tight. -/
theorem isTight_standardizedPoissonLaw :
    IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) |
        p ∈ Set.range standardizedPoissonLaw} := by
  apply
    NumStability.HDP.Scalar.LimitTheorems.isTight_probabilityMeasure_range_of_variance_le_one
      standardizedPoissonLaw
  · intro rate
    change MemLp (fun x : ℝ => x) 2
      ((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ))))
    rw [memLp_map_measure_iff
      (f := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (g := fun x : ℝ => x) continuous_id.aestronglyMeasurable (by fun_prop)]
    simpa [Function.comp_def] using
      ((memLp_id_poissonRealLaw rate).sub (memLp_const (rate : ℝ))).const_mul
        (Real.sqrt (rate : ℝ))⁻¹
  · intro rate
    change ∫ x : ℝ,
      x ∂((NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))) = 0
    rw [integral_map
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (φ := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (f := fun x : ℝ => x) (by fun_prop) continuous_id.aestronglyMeasurable]
    have hInt : Integrable (fun x : ℝ => x)
        (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate) :=
      (memLp_id_poissonRealLaw rate).integrable (by norm_num)
    rw [integral_const_mul, integral_sub hInt (integrable_const _),
      integral_id_poissonRealLaw]
    simp
  · intro rate
    change Var[(fun x : ℝ => x);
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))] ≤ 1
    change Var[id;
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate).map
        (fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))] ≤ 1
    rw [variance_id_map
      (X := fun x : ℝ => (Real.sqrt (rate : ℝ))⁻¹ * (x - (rate : ℝ)))
      (μ := NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate)
      (by fun_prop)]
    rw [variance_const_mul]
    rw [show Var[(fun x : ℝ => x - (rate : ℝ));
        NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] =
      Var[(fun x : ℝ => x);
        NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw rate] by
      exact variance_sub_const continuous_id.aestronglyMeasurable (rate : ℝ)]
    rw [variance_id_poissonRealLaw]
    by_cases hr : rate = 0
    · simp [hr]
    · have hrp : 0 < (rate : ℝ) := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hr)
      have hs : (Real.sqrt (rate : ℝ)) ^ 2 = (rate : ℝ) :=
        Real.sq_sqrt hrp.le
      rw [inv_pow]
      field_simp [Real.sqrt_ne_zero'.mpr hrp]
      nlinarith

/-- Pointwise convergence of the characteristic functions of standardized
Poisson laws to the standard normal characteristic function. -/
theorem tendsto_standardizedPoissonLaw_charFun (t : ℝ) :
    Tendsto (fun rate : ℝ≥0 =>
      MeasureTheory.charFun (standardizedPoissonLaw rate : Measure ℝ) t)
      atTop (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
  by_cases ht : t = 0
  · subst t
    simp
  · let u : ℝ≥0 → ℝ := fun rate => t / Real.sqrt (rate : ℝ)
    have hcoe : Tendsto (fun rate : ℝ≥0 => (rate : ℝ)) atTop atTop :=
      NNReal.tendsto_coe_atTop.mpr tendsto_id
    have hsqrt : Tendsto (fun rate : ℝ≥0 => Real.sqrt (rate : ℝ)) atTop atTop :=
      Real.tendsto_sqrt_atTop.comp hcoe
    have hu : Tendsto u atTop (𝓝 0) :=
      tendsto_const_nhds.div_atTop hsqrt
    have hune : ∀ᶠ rate : ℝ≥0 in atTop, u rate ≠ 0 := by
      filter_upwards [eventually_gt_atTop (0 : ℝ≥0)] with rate hrate
      exact div_ne_zero ht
        (Real.sqrt_ne_zero'.mpr (NNReal.coe_pos.mpr hrate))
    have huWithin : Tendsto u atTop (𝓝[≠] 0) :=
      tendsto_nhdsWithin_iff.mpr ⟨hu, by simpa using hune⟩
    have hquot : Tendsto
        (fun rate : ℝ≥0 =>
          (Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
            ((u rate : ℝ) : ℂ) * Complex.I) / ((u rate : ℝ) : ℂ) ^ 2)
        atTop (𝓝 (-(1 : ℂ) / 2)) := by
      simpa using
        (NumStability.HDP.Scalar.LimitTheorems.tendsto_cexp_scaled_remainder_div_sq
          1).comp huWithin
    have hscale : Tendsto
        (fun rate : ℝ≥0 => (rate : ℂ) * ((u rate : ℝ) : ℂ) ^ 2)
        atTop (𝓝 ((t : ℂ) ^ 2)) := by
      refine tendsto_const_nhds.congr' ?_
      filter_upwards [eventually_gt_atTop (0 : ℝ≥0)] with rate hrate
      have hsqrt_sq : (Real.sqrt (rate : ℝ)) ^ 2 = (rate : ℝ) :=
        Real.sq_sqrt (NNReal.coe_nonneg rate)
      have hsqrt_sq_c : (Real.sqrt (rate : ℝ) : ℂ) ^ 2 = (rate : ℂ) := by
        exact_mod_cast hsqrt_sq
      have hratec : (rate : ℂ) ≠ 0 := by
        exact_mod_cast (pos_iff_ne_zero.mp hrate)
      dsimp [u]
      push_cast
      rw [div_pow, hsqrt_sq_c]
      field_simp [hratec]
    have hprod := hquot.mul hscale
    have hexponent : Tendsto
        (fun rate : ℝ≥0 => (rate : ℂ) *
          (Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
            ((u rate : ℝ) : ℂ) * Complex.I))
        atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
      have hprod' : Tendsto
          (fun rate : ℝ≥0 =>
            ((Complex.exp (((u rate : ℝ) : ℂ) * Complex.I) - 1 -
                ((u rate : ℝ) : ℂ) * Complex.I) /
              ((u rate : ℝ) : ℂ) ^ 2) *
            ((rate : ℂ) * ((u rate : ℝ) : ℂ) ^ 2))
          atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
        convert hprod using 1
        ring
      refine hprod'.congr' ?_
      filter_upwards [hune] with rate hurate
      have huratec : ((u rate : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hurate
      field_simp [huratec]
    have hexp :=
      (Complex.continuous_exp.tendsto (-((t : ℂ) ^ 2) / 2)).comp hexponent
    simpa only [standardizedPoissonLaw_charFun] using hexp

/-- **Poisson normal approximation.** As the real Poisson rate tends to
infinity, the centered and variance-normalized laws converge weakly to the
standard normal law. -/
theorem tendsto_standardizedPoissonLaw :
    Tendsto standardizedPoissonLaw atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let Q : ProbabilityMeasure ℝ :=
    ⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw, inferInstance⟩
  apply
    NumStability.HDP.Scalar.LimitTheorems.tendsto_probabilityMeasure_of_charFun_tendsto_of_tight
      standardizedPoissonLaw Q isTight_standardizedPoissonLaw
  intro t
  simpa [Q, NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw_charFun] using
    tendsto_standardizedPoissonLaw_charFun t

/-- The standardized Poisson law along positive natural-number rates. -/
noncomputable def standardizedPoissonNaturalLaw (n : ℕ) : ProbabilityMeasure ℝ :=
  standardizedPoissonLaw ((n + 1 : ℕ) : ℝ≥0)

/-- The standardized Poisson laws at positive natural rates converge weakly
to the standard normal law, by the i.i.d. central limit theorem. -/
theorem tendsto_standardizedPoissonNaturalLaw :
    Tendsto standardizedPoissonNaturalLaw atTop
      (𝓝 (⟨NumStability.HDP.Scalar.LimitTheorems.standardNormalLaw,
        inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  classical
  obtain ⟨Ω, mΩ, μ, X, hXmeas, hXlaw, hIndep, hμ⟩ :=
    ProbabilityTheory.exists_iid ℕ
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw 1)
  letI : MeasurableSpace Ω := mΩ
  letI : IsProbabilityMeasure μ := hμ
  have hclt := tendsto_probabilityLaw_normalized_poissonOne_iid X hXlaw hIndep
  apply hclt.congr'
  filter_upwards with n
  have hsum : HasLaw (fun ω => ∑ i : Fin (n + 1), X i.1 ω)
      (NumStability.HDP.Scalar.LimitTheorems.poissonRealLaw
        ((n + 1 : ℕ) : ℝ≥0)) μ := by
    simpa using hasLaw_sum_poissonRealLaw
      (fun i : Fin (n + 1) => X i.1) (fun _ => (1 : ℝ≥0))
      (fun i => hXlaw i.1)
      (hIndep.precomp (g := fun i : Fin (n + 1) => i.1) Fin.val_injective)
  let f : ℝ → ℝ := fun x =>
    (Real.sqrt (n + 1 : ℝ))⁻¹ * (x - (n + 1 : ℝ))
  have hnorm :
      NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum X 1 1 n =
        f ∘ (fun ω => ∑ i : Fin (n + 1), X i.1 ω) := by
    funext ω
    simp only [NumStability.HDP.Scalar.LimitTheorems.normalizedIidSum, f,
      Function.comp_apply, one_mul, Finset.sum_sub_distrib, Finset.sum_const,
      Finset.card_fin, nsmul_eq_mul]
    push_cast
    ring
  apply ProbabilityMeasure.toMeasure_injective
  simp only [NumStability.HDP.Scalar.LimitTheorems.probabilityLaw,
    standardizedPoissonNaturalLaw, standardizedPoissonLaw,
    NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure,
    ProbabilityMeasure.map, ProbabilityMeasure.coe_mk]
  rw [show (fun x : ℝ =>
      (Real.sqrt ((((n + 1 : ℕ) : ℝ≥0) : ℝ)))⁻¹ *
        (x - ((((n + 1 : ℕ) : ℝ≥0) : ℝ)))) = f by
    funext x
    dsimp [f]
    norm_num]
  rw [hnorm, ← AEMeasurable.map_map_of_aemeasurable
    (by fun_prop : AEMeasurable f
      (μ.map (fun ω => ∑ i : Fin (n + 1), X i.1 ω))) hsum.aemeasurable,
    hsum.map_eq]

end NumStability.HDP.Scalar.PoissonNormal
