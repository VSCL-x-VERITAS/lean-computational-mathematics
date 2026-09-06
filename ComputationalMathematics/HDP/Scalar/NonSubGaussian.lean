import ComputationalMathematics.HDP.Scalar.SubExponential
import ComputationalMathematics.HDP.Scalar.SubGaussian
import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff

/-!
# Obstructions to sub-Gaussianity

This module develops reusable exponential-integrability consequences of a
finite `ψ₂` gauge and applies them uniformly to positive-rate exponential
laws, positive-shape/scale Pareto laws, arbitrary-location positive-scale
Cauchy laws, and positive-rate Poisson laws.  These are the distributional
obstructions needed for Exercise 2.5.9.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Filter
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.SubGaussian

/-- A one-point exponential-square bound at any positive scale implies
integrability of every linear exponential moment. -/
theorem integrable_exp_mul_of_squarePoint
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ := by
  let c : ℝ := Real.exp ((lam * K / 2) ^ 2)
  have hDom : Integrable
      (fun ω => c * Real.exp (X ω ^ 2 / K ^ 2)) μ :=
    hPoint.2.2.1.const_mul c
  refine hDom.mono' ?_ ?_
  · exact (measurable_const.mul hPoint.1).exp.aestronglyMeasurable
  filter_upwards [] with ω
  have hYoung : lam * X ω ≤ X ω ^ 2 / K ^ 2 + (lam * K / 2) ^ 2 := by
    have hK0 : K ≠ 0 := ne_of_gt hPoint.2.1
    rw [← sub_nonneg]
    convert sq_nonneg (X ω / K - lam * K / 2) using 1
    field_simp [hK0]
    ring
  have hExp := Real.exp_le_exp.mpr hYoung
  rw [Real.exp_add] at hExp
  simpa [c, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _), mul_comm] using hExp

/-- A one-point exponential-square bound gives a quadratic upper bound for
the (not necessarily centered) MGF. -/
theorem integral_exp_mul_le_of_squarePoint
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ} {K : ℝ}
    (hPoint : SubGaussianSquarePoint μ X K) (lam : ℝ) :
    (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
      2 * Real.exp ((lam * K / 2) ^ 2) := by
  let c : ℝ := Real.exp ((lam * K / 2) ^ 2)
  have hLinear : Integrable (fun ω => Real.exp (lam * X ω)) μ :=
    integrable_exp_mul_of_squarePoint hPoint lam
  have hDom : Integrable
      (fun ω => c * Real.exp (X ω ^ 2 / K ^ 2)) μ :=
    hPoint.2.2.1.const_mul c
  have hPointwise : ∀ ω,
      Real.exp (lam * X ω) ≤ c * Real.exp (X ω ^ 2 / K ^ 2) := by
    intro ω
    have hK0 : K ≠ 0 := ne_of_gt hPoint.2.1
    have hYoung : lam * X ω ≤
        X ω ^ 2 / K ^ 2 + (lam * K / 2) ^ 2 := by
      rw [← sub_nonneg]
      convert sq_nonneg (X ω / K - lam * K / 2) using 1
      field_simp [hK0]
      ring
    have hExp := Real.exp_le_exp.mpr hYoung
    rw [Real.exp_add] at hExp
    simpa [c, mul_comm] using hExp
  calc
    (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
        ∫ ω, c * Real.exp (X ω ^ 2 / K ^ 2) ∂μ :=
      MeasureTheory.integral_mono hLinear hDom hPointwise
    _ = c * ∫ ω, Real.exp (X ω ^ 2 / K ^ 2) ∂μ := by
      rw [integral_const_mul]
    _ ≤ c * 2 := mul_le_mul_of_nonneg_left hPoint.2.2.2 (Real.exp_pos _).le
    _ = 2 * Real.exp ((lam * K / 2) ^ 2) := by simp [c, mul_comm]

/-- Finite exact `ψ₂` gauge implies existence of every real MGF, without a
centering hypothesis. -/
theorem psiTwoGauge_integrable_exp_mul
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) (lam : ℝ) :
    Integrable (fun ω => Real.exp (lam * X ω)) μ := by
  by_cases hGaugeZero : PsiTwoGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hFun : (fun ω => Real.exp (lam * X ω)) =ᵐ[μ]
        (fun _ω : Ω => (1 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω]
    exact (integrable_const (1 : ℝ)).congr hFun.symm
  · have hGaugePos : 0 < PsiTwoGauge μ X := bot_lt_iff_ne_bot.mpr hGaugeZero
    exact integrable_exp_mul_of_squarePoint
      (psiTwoGauge_squarePoint_of_pos hX hFinite hGaugePos) lam

private lemma exponentialPDF_measurable (rate : ℝ) :
    Measurable (ProbabilityTheory.exponentialPDF rate) := by
  unfold ProbabilityTheory.exponentialPDF
  exact (ProbabilityTheory.measurable_exponentialPDFReal rate).ennreal_ofReal

/-- For a positive exponential rate, the ordinary MGF is nonintegrable from
that rate onward. -/
theorem not_integrable_exp_mul_expMeasure
    {rate lam : ℝ} (hrate : 0 < rate) (hl : rate ≤ lam) :
    ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure rate) := by
  intro h
  have hpdf := exponentialPDF_measurable rate
  have hbase : Integrable
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF rate x).toReal) volume := by
    change Integrable (fun x : ℝ => Real.exp (lam * x))
      (volume.withDensity (ProbabilityTheory.exponentialPDF rate)) at h
    exact (integrable_withDensity_iff hpdf
      (by filter_upwards [] with x; exact ENNReal.coe_lt_top)).1 h
  have hprod : IntegrableOn
      (fun x : ℝ => Real.exp (lam * x) *
        (ProbabilityTheory.exponentialPDF rate x).toReal) (Set.Ioi (0 : ℝ)) volume :=
    hbase.integrableOn
  have hscaled : IntegrableOn
      (fun x : ℝ => rate⁻¹ *
        (Real.exp (lam * x) * (ProbabilityTheory.exponentialPDF rate x).toReal))
      (Set.Ioi (0 : ℝ)) volume := hprod.const_mul rate⁻¹
  have hexp : IntegrableOn (fun x : ℝ => Real.exp ((lam - rate) * x))
      (Set.Ioi (0 : ℝ)) volume := by
    apply hscaled.congr_fun
    · intro x hx
      have hx0 : 0 ≤ x := le_of_lt hx
      simp [ProbabilityTheory.exponentialPDF,
        ProbabilityTheory.exponentialPDFReal, ProbabilityTheory.gammaPDFReal,
        hx0, hrate.le]
      rw [ENNReal.toReal_ofReal]
      · calc
          rate⁻¹ * (Real.exp (lam * x) *
              (rate * Real.exp (-(rate * x)))) =
              Real.exp (lam * x) * Real.exp (-(rate * x)) := by
                field_simp [hrate.ne']
          _ = Real.exp ((lam - rate) * x) := by
                rw [← Real.exp_add]
                congr 1
                ring
      · positivity
    · exact measurableSet_Ioi
  have hconst : IntegrableOn (fun _ : ℝ => (1 : ℝ))
      (Set.Ioi (0 : ℝ)) volume := by
    apply hexp.integrable.mono'
    · fun_prop
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx
      rw [Real.norm_eq_abs, abs_one]
      exact Real.one_le_exp (mul_nonneg (sub_nonneg.mpr hl) (le_of_lt hx))
  exact not_integrableOn_Ioi_rpow 0 (by simpa using hconst)

/-- Every positive-rate exponential distribution is not sub-Gaussian. -/
theorem exponentialPsiTwoGauge_eq_top_of_pos (rate : ℝ) (hrate : 0 < rate) :
    PsiTwoGauge (expMeasure rate) id = ∞ := by
  letI : IsProbabilityMeasure (expMeasure rate) :=
    isProbabilityMeasure_expMeasure hrate
  by_contra hnot
  have hFinite : PsiTwoGauge (expMeasure rate) id < ∞ :=
    (lt_top_iff_ne_top).2 hnot
  have hIntegrable := psiTwoGauge_integrable_exp_mul
    (μ := expMeasure rate) (X := id) measurable_id hFinite rate
  exact not_integrable_exp_mul_expMeasure hrate (le_refl rate) hIntegrable

/-- The rate-one specialization of `exponentialPsiTwoGauge_eq_top_of_pos`. -/
theorem exponentialPsiTwoGauge_eq_top :
    PsiTwoGauge (expMeasure 1) id = ∞ :=
  exponentialPsiTwoGauge_eq_top_of_pos 1 (by norm_num)

/-- The positive exponential is not integrable under the standard Cauchy
law. -/
theorem not_integrable_exp_cauchyOne :
    ¬ Integrable (fun x : ℝ => Real.exp x)
      (Probability.cauchyMeasure 0 1) := by
  intro hExp
  have hPos : Integrable (fun x : ℝ => max x 0)
      (Probability.cauchyMeasure 0 1) := by
    refine hExp.mono' (by fun_prop) ?_
    filter_upwards [] with x
    rw [Real.norm_of_nonneg (le_max_right x 0)]
    by_cases hx : 0 ≤ x
    · rw [max_eq_left hx]
      exact (le_add_of_nonneg_right zero_le_one).trans
        (Real.add_one_le_exp x)
    · rw [max_eq_right (le_of_not_ge hx)]
      exact (Real.exp_pos x).le
  exact Preliminaries.not_integrable_cauchy_pos hPos

/-- The standard Cauchy distribution is not sub-Gaussian: its `ψ₂` gauge is
infinite. -/
theorem cauchyPsiTwoGauge_eq_top :
    PsiTwoGauge (Probability.cauchyMeasure 0 1) id = ∞ := by
  by_contra hnot
  have hFinite : PsiTwoGauge (Probability.cauchyMeasure 0 1) id < ∞ :=
    (lt_top_iff_ne_top).2 hnot
  have hExp : Integrable (fun x : ℝ => Real.exp x)
      (Probability.cauchyMeasure 0 1) := by
    simpa using psiTwoGauge_integrable_exp_mul
      (μ := Probability.cauchyMeasure 0 1) (X := id)
      measurable_id hFinite 1
  exact not_integrable_exp_cauchyOne hExp

/-- A Cauchy location-scale law, realized as the affine image of the standard
Cauchy law. -/
noncomputable def cauchyLocationScaleMeasure (loc : ℝ) (scale : ℝ≥0) : Measure ℝ :=
  (Probability.cauchyMeasure 0 1).map
    (fun x : ℝ => loc + (scale : ℝ) * x)

/-- Every affine Cauchy law with positive scale is not sub-Gaussian. -/
theorem cauchyLocationScalePsiTwoGauge_eq_top
    (loc : ℝ) (scale : ℝ≥0) (hscale : 0 < scale) :
    PsiTwoGauge (cauchyLocationScaleMeasure loc scale) id = ∞ := by
  letI : IsProbabilityMeasure (cauchyLocationScaleMeasure loc scale) := by
    exact Measure.isProbabilityMeasure_map
      (measurable_const.add (measurable_const.mul measurable_id)).aemeasurable
  by_contra hnot
  have hFinite : PsiTwoGauge (cauchyLocationScaleMeasure loc scale) id < ∞ :=
    (lt_top_iff_ne_top).2 hnot
  let lam : ℝ := ((scale : ℝ))⁻¹
  have hMapped : Integrable (fun y : ℝ => Real.exp (lam * y))
      (cauchyLocationScaleMeasure loc scale) := by
    simpa using psiTwoGauge_integrable_exp_mul
      (μ := cauchyLocationScaleMeasure loc scale) (X := id)
      measurable_id hFinite lam
  have hComp : Integrable (fun x : ℝ =>
      Real.exp (lam * (loc + (scale : ℝ) * x)))
      (Probability.cauchyMeasure 0 1) := by
    simpa [cauchyLocationScaleMeasure, Function.comp_def] using
      hMapped.comp_measurable
        (measurable_const.add (measurable_const.mul measurable_id))
  have hScaled := hComp.const_mul (Real.exp (-(lam * loc)))
  have hExp : Integrable (fun x : ℝ => Real.exp x)
      (Probability.cauchyMeasure 0 1) := by
    refine hScaled.congr ?_
    filter_upwards [] with x
    rw [← Real.exp_add]
    congr 1
    dsimp [lam]
    have hs0 : (scale : ℝ) ≠ 0 := by exact_mod_cast ne_of_gt hscale
    field_simp [hs0]
    ring
  exact not_integrable_exp_cauchyOne hExp

/-- A positive-shape/scale Pareto law, realized as the scaled exponential of
a positive-rate exponential random variable. -/
noncomputable def paretoMeasure (shape scale : ℝ≥0) : Measure ℝ :=
  (expMeasure (shape : ℝ)).map (fun x : ℝ => (scale : ℝ) * Real.exp x)

/-- The scale-one, shape-one Pareto law. -/
noncomputable def paretoOneMeasure : Measure ℝ :=
  (expMeasure 1).map Real.exp

instance paretoOneMeasure_isProbabilityMeasure :
    IsProbabilityMeasure paretoOneMeasure := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    isProbabilityMeasure_expMeasure (by norm_num)
  exact Measure.isProbabilityMeasure_map Real.measurable_exp.aemeasurable

/-- The double exponential is not integrable under the rate-one exponential
law.  This is the linear-MGF obstruction for the shape-one Pareto law. -/
theorem not_integrable_exp_exp_expMeasure :
    ¬ Integrable (fun x : ℝ => Real.exp (Real.exp x)) (expMeasure 1) := by
  intro hDouble
  have hSingle : Integrable (fun x : ℝ => Real.exp x) (expMeasure 1) := by
    refine hDouble.mono' (by fun_prop) ?_
    filter_upwards [] with x
    rw [Real.norm_of_nonneg (Real.exp_pos x).le]
    exact Real.exp_le_exp.mpr
      ((le_add_of_nonneg_right zero_le_one).trans (Real.add_one_le_exp x))
  exact SubExponential.remark279_exp_mgf_not_integrable
    (by norm_num : (1 : ℝ) ≤ 1) (by simpa using hSingle)

/-- The scale-one, shape-one Pareto distribution is not sub-Gaussian: its
`ψ₂` gauge is infinite. -/
theorem paretoOnePsiTwoGauge_eq_top :
    PsiTwoGauge paretoOneMeasure id = ∞ := by
  by_contra hnot
  have hFinite : PsiTwoGauge paretoOneMeasure id < ∞ :=
    (lt_top_iff_ne_top).2 hnot
  have hParetoExp : Integrable (fun x : ℝ => Real.exp x) paretoOneMeasure := by
    simpa using psiTwoGauge_integrable_exp_mul
      (μ := paretoOneMeasure) (X := id) measurable_id hFinite 1
  have hDouble : Integrable (fun x : ℝ => Real.exp (Real.exp x))
      (expMeasure 1) := by
    simpa [paretoOneMeasure, Function.comp_def] using
      hParetoExp.comp_measurable Real.measurable_exp
  exact not_integrable_exp_exp_expMeasure hDouble

/-- Every Pareto law with positive shape and scale is not sub-Gaussian. -/
theorem paretoPsiTwoGauge_eq_top
    (shape scale : ℝ≥0) (hshape : 0 < shape) (hscale : 0 < scale) :
    PsiTwoGauge (paretoMeasure shape scale) id = ∞ := by
  letI : IsProbabilityMeasure (expMeasure (shape : ℝ)) :=
    isProbabilityMeasure_expMeasure (by exact_mod_cast hshape)
  letI : IsProbabilityMeasure (paretoMeasure shape scale) := by
    exact Measure.isProbabilityMeasure_map
      (measurable_const.mul Real.measurable_exp).aemeasurable
  by_contra hnot
  have hFinite : PsiTwoGauge (paretoMeasure shape scale) id < ∞ :=
    (lt_top_iff_ne_top).2 hnot
  let lam : ℝ := (shape : ℝ) / (scale : ℝ)
  have hPareto : Integrable (fun y : ℝ => Real.exp (lam * y))
      (paretoMeasure shape scale) := by
    simpa using psiTwoGauge_integrable_exp_mul
      (μ := paretoMeasure shape scale) (X := id) measurable_id hFinite lam
  have hDouble : Integrable (fun x : ℝ =>
      Real.exp ((shape : ℝ) * Real.exp x)) (expMeasure (shape : ℝ)) := by
    have hComp := hPareto.comp_measurable
      (measurable_const.mul Real.measurable_exp)
    have hComp' : Integrable (fun x : ℝ =>
        Real.exp (lam * ((scale : ℝ) * Real.exp x)))
        (expMeasure (shape : ℝ)) := by
      simpa [paretoMeasure, Function.comp_def] using hComp
    refine hComp'.congr ?_
    filter_upwards [] with x
    congr 1
    dsimp [lam]
    field_simp [show (scale : ℝ) ≠ 0 by exact_mod_cast ne_of_gt hscale]
  have hSingle : Integrable (fun x : ℝ => Real.exp ((shape : ℝ) * x))
      (expMeasure (shape : ℝ)) := by
    refine hDouble.mono' (by fun_prop) ?_
    filter_upwards [] with x
    rw [Real.norm_of_nonneg (Real.exp_pos _).le]
    apply Real.exp_le_exp.mpr
    by_cases hx : 0 ≤ x
    · exact mul_le_mul_of_nonneg_left
        ((le_add_of_nonneg_right zero_le_one).trans (Real.add_one_le_exp x))
        (by positivity)
    · exact (mul_nonpos_of_nonneg_of_nonpos (by positivity) (le_of_not_ge hx)).trans
        (by positivity)
  exact not_integrable_exp_mul_expMeasure
    (by exact_mod_cast hshape) (le_refl (shape : ℝ)) hSingle

/-- Every positive-rate Poisson distribution is not sub-Gaussian: the exact
Poisson MGF grows faster than the quadratic upper bound forced by any finite
`ψ₂` gauge. -/
theorem poissonPsiTwoGauge_eq_top (rate : ℝ≥0) (hrate : 0 < rate) :
    PsiTwoGauge (ProbabilityTheory.poissonMeasure rate)
      (fun n : ℕ => (n : ℝ)) = ∞ := by
  let r : ℝ := rate
  have hr : 0 < r := by exact_mod_cast hrate
  by_contra hnot
  have hFinite : PsiTwoGauge (ProbabilityTheory.poissonMeasure rate)
      (fun n : ℕ => (n : ℝ)) < ∞ := (lt_top_iff_ne_top).2 hnot
  obtain ⟨K, hK, hPoint⟩ := (psiTwoGauge_finite_iff.mp hFinite)
  let C : ℝ := (r + 1 + K ^ 2 / 4) / r
  obtain ⟨s, hsGrowth, hsOne⟩ :=
    ((tendsto_atTop.1 (Real.tendsto_exp_div_pow_atTop 2) (C + 1)).and
      (eventually_ge_atTop (1 : ℝ))).exists
  have hRatio : C < Real.exp s / s ^ 2 :=
    (lt_add_one C).trans_le hsGrowth
  have hsSq : 1 ≤ s ^ 2 := by nlinarith
  have hsSqPos : 0 < s ^ 2 := zero_lt_one.trans_le hsSq
  have hExp : C * s ^ 2 < Real.exp s :=
    (lt_div_iff₀ hsSqPos).mp hRatio
  have hrExp : r * (C * s ^ 2) < r * Real.exp s :=
    mul_lt_mul_of_pos_left hExp hr
  have hRC : r * C = r + 1 + K ^ 2 / 4 := by
    dsimp [C]
    field_simp [ne_of_gt hr]
  have hCoeff : 0 ≤ r + 1 := by positivity
  have hScale : r + 1 ≤ s ^ 2 * (r + 1) := by
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hsSq hCoeff
  have hBeforeExp : r + 1 + (s * K / 2) ^ 2 < r * Real.exp s := by
    calc
      r + 1 + (s * K / 2) ^ 2 ≤
          s ^ 2 * (r + 1 + K ^ 2 / 4) := by nlinarith
      _ = r * (C * s ^ 2) := by rw [← hRC]; ring
      _ < r * Real.exp s := hrExp
  have hExponent :
      1 + (s * K / 2) ^ 2 < r * (Real.exp s - 1) := by
    nlinarith
  have hStrict :
      2 * Real.exp ((s * K / 2) ^ 2) <
        Real.exp (r * (Real.exp s - 1)) := by
    calc
      2 * Real.exp ((s * K / 2) ^ 2) <
          Real.exp 1 * Real.exp ((s * K / 2) ^ 2) :=
        mul_lt_mul_of_pos_right Real.exp_one_gt_two (Real.exp_pos _)
      _ = Real.exp (1 + (s * K / 2) ^ 2) := by rw [Real.exp_add]
      _ < Real.exp (r * (Real.exp s - 1)) :=
        Real.exp_lt_exp.mpr hExponent
  have hUpper := integral_exp_mul_le_of_squarePoint hPoint s
  rw [IndependentSums.PoissonChernoff.poissonMgfExact] at hUpper
  exact (not_lt_of_ge hUpper) hStrict

end NumStability.HDP.Scalar.SubGaussian
