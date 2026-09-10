import ComputationalMathematics.Analysis.Probability.Gaussian.AbsoluteMoment
import ComputationalMathematics.HDP.Scalar.GaussianTails
import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeDecoupling
import Mathlib.Probability.Independence.Basic

/-!
# Finite maxima and independent Gaussian samples

This file provides the reusable finite-maximum and exact product-event
infrastructure needed for lower bounds on maxima of independent Gaussian
variables.  The asymptotic Gaussian estimate is developed separately from
these order- and independence-theoretic foundations.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Scalar.GaussianMaxima

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.GaussianTails

/-- The pointwise maximum of a nonempty finite family of real functions. -/
def finiteMaximum {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) : Ω → ℝ :=
  Finset.univ.sup' Finset.univ_nonempty X

/-- Every coordinate is bounded by the finite maximum. -/
lemma le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (i : ι) (ω : Ω) :
    X i ω ≤ finiteMaximum X ω := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.le_sup' (fun j => X j ω) (Finset.mem_univ i)

/-- A pointwise criterion for bounding a finite maximum from above. -/
lemma finiteMaximum_le
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (a : ℝ)
    (h : ∀ i, X i ω ≤ a) :
    finiteMaximum X ω ≤ a := by
  rw [finiteMaximum, Finset.sup'_apply]
  exact Finset.sup'_le Finset.univ_nonempty _ (fun i _ => h i)

/-- The maximum of a finite family of measurable real functions is
measurable. -/
lemma measurable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {X : ι → Ω → ℝ} (hX : ∀ i, Measurable (X i)) :
    Measurable (finiteMaximum X) := by
  unfold finiteMaximum
  exact Finset.measurable_sup' Finset.univ_nonempty (fun i _ => hX i)

/-- The maximum of a finite family of integrable real functions is
integrable. -/
lemma integrable_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hX : ∀ i, Integrable (X i) μ) :
    Integrable (finiteMaximum X) μ := by
  unfold finiteMaximum
  exact Finset.sup'_induction Finset.univ_nonempty X
    (p := fun f : Ω → ℝ => Integrable f μ)
    (fun _ hf _ hg => Integrable.sup hf hg) (fun i _ => hX i)

/-- A finite maximum is bounded above by the sum of the coordinate absolute
values. -/
lemma finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    finiteMaximum X ω ≤ ∑ i, |X i ω| := by
  rw [finiteMaximum, Finset.sup'_apply]
  apply Finset.sup'_le
  intro i hi
  calc
    X i ω ≤ |X i ω| := le_abs_self _
    _ ≤ ∑ j, |X j ω| := Finset.single_le_sum
      (s := Finset.univ) (f := fun j => |X j ω|)
      (fun _ _ => abs_nonneg _) hi

/-- The negative sum of the coordinate absolute values is a lower bound for
the finite maximum. -/
lemma neg_sum_abs_le_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    -(∑ i, |X i ω|) ≤ finiteMaximum X ω := by
  let i : ι := Classical.choice inferInstance
  calc
    -(∑ j, |X j ω|) ≤ -|X i ω| := by
      exact neg_le_neg (Finset.single_le_sum
        (s := Finset.univ) (f := fun j => |X j ω|)
        (fun _ _ => abs_nonneg _) (Finset.mem_univ i))
    _ ≤ X i ω := neg_abs_le _
    _ ≤ finiteMaximum X ω := le_finiteMaximum X i ω

/-- Two-sided absolute-value control for the finite maximum. -/
lemma abs_finiteMaximum_le_sum_abs
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) :
    |finiteMaximum X ω| ≤ ∑ i, |X i ω| := by
  rw [abs_le]
  exact ⟨neg_sum_abs_le_finiteMaximum X ω,
    finiteMaximum_le_sum_abs X ω⟩

/-- A finite maximum lies below a threshold exactly when every coordinate
does. -/
lemma finiteMaximum_lt_iff
    {ι Ω : Type*} [Fintype ι] [Nonempty ι]
    (X : ι → Ω → ℝ) (ω : Ω) (t : ℝ) :
    finiteMaximum X ω < t ↔ ∀ i, X i ω < t := by
  simp [finiteMaximum, Finset.sup'_apply, Finset.sup'_lt_iff]

/-- Independence turns the lower-tail event of a finite maximum into the
product of its coordinate lower-tail probabilities. -/
lemma measure_finiteMaximum_lt_eq_prod
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      ∏ i, μ {ω | X i ω < t} := by
  have hEvent : {ω | finiteMaximum X ω < t} =
      ⋂ i, {ω | X i ω < t} := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_iInter]
    exact finiteMaximum_lt_iff X ω t
  rw [hEvent]
  apply hIndep.meas_iInter
  intro i
  exact MeasurableSpace.measurableSet_comap.2
    ⟨Set.Iio t, measurableSet_Iio, rfl⟩

/-- Exact lower-tail probability of the maximum of an independent finite
standard-normal family. -/
lemma measure_finiteMaximum_lt_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ {ω | finiteMaximum X ω < t} =
      standardNormalLaw (Set.Iio t) ^ Fintype.card ι := by
  rw [measure_finiteMaximum_lt_eq_prod hIndep t]
  have hOne : ∀ i, μ {ω | X i ω < t} = standardNormalLaw (Set.Iio t) := by
    intro i
    rw [← (hLaw i).map_eq,
      Measure.map_apply_of_aemeasurable (hLaw i).aemeasurable measurableSet_Iio]
    rfl
  simp_rw [hOne]
  rw [Finset.prod_const]
  simp

/-- Real-valued form of the exact standard-normal lower-tail product. -/
lemma measureReal_finiteMaximum_lt_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ι → Ω → ℝ}
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ.real {ω | finiteMaximum X ω < t} =
      standardNormalLaw.real (Set.Iio t) ^ Fintype.card ι := by
  have h := congrArg ENNReal.toReal
    (measure_finiteMaximum_lt_of_standardNormal hLaw hIndep t)
  simpa only [Measure.real, ENNReal.toReal_pow] using h

/-- Exact upper-tail probability of the maximum of an independent finite
standard-normal family. -/
lemma measureReal_finiteMaximum_ge_of_standardNormal
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (t : ℝ) :
    μ.real {ω | t ≤ finiteMaximum X ω} =
      1 - (1 - standardNormalLaw.real (Set.Ici t)) ^ Fintype.card ι := by
  have hLowMeas : MeasurableSet {ω | finiteMaximum X ω < t} :=
    measurableSet_lt (measurable_finiteMaximum hX) measurable_const
  have hEvent : {ω | t ≤ finiteMaximum X ω} =
      {ω | finiteMaximum X ω < t}ᶜ := by
    ext ω
    simp
  rw [hEvent, measureReal_compl hLowMeas, probReal_univ,
    measureReal_finiteMaximum_lt_of_standardNormal hLaw hIndep t]
  have hTail : standardNormalLaw.real (Set.Iio t) =
      1 - standardNormalLaw.real (Set.Ici t) := by
    rw [← compl_Ici, measureReal_compl measurableSet_Ici, probReal_univ]
  rw [hTail]

/-- A one-threshold lower bound for the expectation of a finite maximum.  The
single-coordinate absolute moment controls every possible negative value of
the maximum. -/
lemma threshold_mul_measureReal_sub_integral_abs_le_integral_finiteMaximum
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ] {X : ι → Ω → ℝ}
    (hMeas : ∀ i, Measurable (X i))
    (hInt : ∀ i, Integrable (X i) μ) (i : ι) (t : ℝ) :
    t * μ.real {ω | t ≤ finiteMaximum X ω} -
        ∫ ω, |X i ω| ∂μ ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let A : Set Ω := {ω | t ≤ finiteMaximum X ω}
  have hA : MeasurableSet A :=
    measurableSet_le measurable_const (measurable_finiteMaximum hMeas)
  have hLeftInt : Integrable
      (fun ω => A.indicator (fun _ => t) ω - |X i ω|) μ :=
    ((integrable_const t).indicator hA).sub (hInt i).abs
  have hMaxInt : Integrable (finiteMaximum X) μ :=
    integrable_finiteMaximum hInt
  have hPoint : ∀ ω, A.indicator (fun _ => t) ω - |X i ω| ≤
      finiteMaximum X ω := by
    intro ω
    by_cases hω : ω ∈ A
    · rw [Set.indicator_of_mem hω]
      exact (sub_le_self _ (abs_nonneg _)).trans hω
    · simp only [Set.indicator, hω, if_false, zero_sub]
      exact (neg_abs_le (X i ω)).trans (le_finiteMaximum X i ω)
  calc
    t * μ.real {ω | t ≤ finiteMaximum X ω} -
        ∫ ω, |X i ω| ∂μ =
        ∫ ω, A.indicator (fun _ => t) ω - |X i ω| ∂μ := by
      rw [integral_sub ((integrable_const t).indicator hA) (hInt i).abs,
        integral_indicator_const t hA]
      simp only [smul_eq_mul, A]
      ring
    _ ≤ ∫ ω, finiteMaximum X ω ∂μ :=
      integral_mono hLeftInt hMaxInt hPoint

/-- The absolute first moment of the standard-normal law. -/
def standardNormalAbsMean : ℝ :=
  ∫ x : ℝ, |x| ∂standardNormalLaw

lemma standardNormalAbsMean_nonneg : 0 ≤ standardNormalAbsMean := by
  unfold standardNormalAbsMean
  exact integral_nonneg_of_ae (ae_of_all _ fun x => abs_nonneg x)

/-- Integrability transported from the standard-normal law. -/
lemma integrable_of_hasLaw_standardNormal
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hX : Measurable X) (hLaw : HasLaw X standardNormalLaw μ) :
    Integrable X μ := by
  have hStd : Integrable (fun y : ℝ => y) standardNormalLaw := by
    rw [standardNormalLaw]
    have hm : MemLp (fun y : ℝ => y) (1 : ENNReal)
        (ProbabilityTheory.gaussianReal 0 1) := by
      simpa only [id_eq] using
        (ProbabilityTheory.memLp_id_gaussianReal
          (μ := (0 : ℝ)) (v := (1 : ℝ≥0)) (1 : ℝ≥0))
    exact hm.integrable (by norm_num)
  simpa only [Function.id_comp] using
    (hLaw.measurePreserving hX).integrable_comp_of_integrable hStd

/-- The absolute first moment is invariant under transport from a
standard-normal law. -/
lemma integral_abs_eq_standardNormalAbsMean
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {X : Ω → ℝ}
    (hLaw : HasLaw X standardNormalLaw μ) :
    (∫ ω, |X ω| ∂μ) = standardNormalAbsMean := by
  simpa only [Function.comp_apply, standardNormalAbsMean] using
    hLaw.integral_comp (by fun_prop :
      AEStronglyMeasurable (fun x : ℝ => |x|) standardNormalLaw)

/-- The exact maximum-tail product converts the one-threshold expectation
bound into a standard-normal expression. -/
lemma standardNormalMaximum_expectation_ge_threshold
    {ι Ω : Type*} [Fintype ι] [Nonempty ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : ι → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) (i : ι) (t : ℝ) :
    t * (1 - (1 - standardNormalLaw.real (Set.Ici t)) ^ Fintype.card ι) -
        standardNormalAbsMean ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  have hInt : ∀ j, Integrable (X j) μ := fun j =>
    integrable_of_hasLaw_standardNormal (hX j) (hLaw j)
  have h := threshold_mul_measureReal_sub_integral_abs_le_integral_finiteMaximum
    hX hInt i t
  rw [measureReal_finiteMaximum_ge_of_standardNormal hX hLaw hIndep t,
    integral_abs_eq_standardNormalAbsMean (hLaw i)] at h
  exact h

/-- A positive universal lower bound for the expected number of threshold
exceedances in the large-logarithm regime. -/
def gaussianMaximumTailConstant : ℝ :=
  (Real.sqrt (2 * Real.pi))⁻¹ / 2

lemma gaussianMaximumTailConstant_pos : 0 < gaussianMaximumTailConstant := by
  unfold gaussianMaximumTailConstant
  positivity

/-- Above threshold two, the lower Mills coefficient dominates half of its
leading reciprocal term. -/
lemma half_inv_le_millsCoefficient {t : ℝ} (ht : 2 ≤ t) :
    1 / (2 * t) ≤ 1 / t - 1 / t ^ 3 := by
  have ht0 : 0 < t := by linarith
  field_simp
  nlinarith

lemma sqrt_log_le_exp_half_log {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    Real.sqrt (Real.log (N : ℝ)) ≤
      Real.exp (Real.log (N : ℝ) / 2) := by
  let t := Real.sqrt (Real.log (N : ℝ))
  have hLog0 : 0 ≤ Real.log (N : ℝ) := le_trans (by norm_num) hLog
  have htSq : t ^ 2 = Real.log (N : ℝ) := Real.sq_sqrt hLog0
  have hBase := Real.add_one_le_exp (t ^ 2 / 2)
  change t ≤ Real.exp (Real.log (N : ℝ) / 2)
  rw [← htSq]
  exact le_trans (by nlinarith [sq_nonneg (t - 1)]) hBase

/-- Proposition 2.1.2 implies that, at threshold `sqrt (log N)`, `N` times
the one-coordinate upper-tail probability stays above a positive universal
constant once `log N ≥ 4`. -/
lemma gaussianMaximumTailConstant_le_card_mul_tail
    {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    gaussianMaximumTailConstant ≤
      (N : ℝ) * standardNormalLaw.real
        (Set.Ici (Real.sqrt (Real.log (N : ℝ)))) := by
  let t := Real.sqrt (Real.log (N : ℝ))
  have hLog0 : 0 ≤ Real.log (N : ℝ) := le_trans (by norm_num) hLog
  have htSq : t ^ 2 = Real.log (N : ℝ) := Real.sq_sqrt hLog0
  have ht : 2 ≤ t := by
    rw [show (2 : ℝ) = Real.sqrt 4 by norm_num]
    exact Real.sqrt_le_sqrt hLog
  have ht0 : 0 < t := by linarith
  have hNpos : 0 < (N : ℝ) := by
    by_contra h
    have hNzero : (N : ℝ) = 0 := le_antisymm (le_of_not_gt h) (by positivity)
    rw [hNzero, Real.log_zero] at hLog
    norm_num at hLog
  have hNexp : (N : ℝ) = Real.exp (t ^ 2) := by
    rw [htSq, Real.exp_log hNpos]
  have hRatio : 1 ≤ (N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2) := by
    have hExp : t ≤ Real.exp (t ^ 2 / 2) := by
      simpa only [t, htSq] using sqrt_log_le_exp_half_log hLog
    have hIdentity : t ^ 2 + (-(t ^ 2) / 2) = t ^ 2 / 2 := by ring
    calc
      1 ≤ Real.exp (t ^ 2 / 2) / t :=
        (le_div_iff₀ ht0).2 (by simpa using hExp)
      _ = Real.exp (t ^ 2 / 2) * (1 / t) := by ring
      _ = (Real.exp (t ^ 2) * Real.exp (-(t ^ 2) / 2)) *
          (1 / t) := by rw [← Real.exp_add, hIdentity]
      _ = (N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2) := by
        rw [hNexp]
        ring
  have hMills := (standardNormalTail_bounds t ht0).1
  have hCoeff :
      (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / (2 * t)) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Set.Ici t) := by
    exact (mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_right (half_inv_le_millsCoefficient ht)
        (Real.exp_pos _).le) (by positivity)).trans hMills
  calc
    gaussianMaximumTailConstant =
        gaussianMaximumTailConstant * 1 := by ring
    _ ≤ gaussianMaximumTailConstant *
        ((N : ℝ) * (1 / t) * Real.exp (-(t ^ 2) / 2)) :=
      mul_le_mul_of_nonneg_left hRatio gaussianMaximumTailConstant_pos.le
    _ = (N : ℝ) *
        ((Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / (2 * t)) * Real.exp (-(t ^ 2) / 2))) := by
      unfold gaussianMaximumTailConstant
      ring
    _ ≤ (N : ℝ) * standardNormalLaw.real (Set.Ici t) := by
      exact mul_le_mul_of_nonneg_left hCoeff (by positivity)

/-- The fixed positive probability extracted from the threshold product. -/
def gaussianMaximumHitConstant : ℝ :=
  1 - Real.exp (-gaussianMaximumTailConstant)

lemma gaussianMaximumHitConstant_pos : 0 < gaussianMaximumHitConstant := by
  unfold gaussianMaximumHitConstant
  have hExp : Real.exp (-gaussianMaximumTailConstant) < 1 :=
    Real.exp_lt_one_iff.mpr (neg_neg_of_pos gaussianMaximumTailConstant_pos)
  linarith

/-- The probability that at least one coordinate exceeds `sqrt (log N)` is
bounded below by a positive universal constant in the large-logarithm
regime. -/
lemma gaussianMaximumHitConstant_le_tail_factor
    {N : ℕ} (hLog : 4 ≤ Real.log (N : ℝ)) :
    gaussianMaximumHitConstant ≤
      1 - (1 - standardNormalLaw.real
        (Set.Ici (Real.sqrt (Real.log (N : ℝ))))) ^ N := by
  let p : ℝ := standardNormalLaw.real
    (Set.Ici (Real.sqrt (Real.log (N : ℝ))))
  have hp1 : p ≤ 1 := by
    exact measureReal_le_one
  have hPow : (1 - p) ^ N ≤ Real.exp (-((N : ℝ) * p)) :=
    NumStability.HDP.Scalar.IndependentSums.Chernoff.one_sub_pow_le_exp_neg_nat_mul
      hp1 N
  have hNp : gaussianMaximumTailConstant ≤ (N : ℝ) * p :=
    gaussianMaximumTailConstant_le_card_mul_tail hLog
  have hExp : Real.exp (-((N : ℝ) * p)) ≤
      Real.exp (-gaussianMaximumTailConstant) :=
    Real.exp_le_exp.mpr (neg_le_neg hNp)
  unfold gaussianMaximumHitConstant
  dsimp [p] at hPow hExp ⊢
  linarith

/-- The expected maximum of two independent standard normals is exactly
`1 / sqrt π`. -/
lemma expectation_max_two_standardNormal
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X Y : Ω → ℝ}
    (hX : Measurable X) (hY : Measurable Y)
    (hLawX : HasLaw X standardNormalLaw μ)
    (hLawY : HasLaw Y standardNormalLaw μ)
    (hIndep : IndepFun X Y μ) :
    (∫ ω, max (X ω) (Y ω) ∂μ) = 1 / Real.sqrt Real.pi := by
  have hPair : HasLaw (fun ω => (X ω, Y ω))
      (standardNormalLaw.prod standardNormalLaw) μ := by
    refine ⟨(hX.prodMk hY).aemeasurable, ?_⟩
    rw [(indepFun_iff_map_prod_eq_prod_map_map
      hX.aemeasurable hY.aemeasurable).1 hIndep,
      hLawX.map_eq, hLawY.map_eq]
  have hMeanX : (∫ ω, X ω ∂μ) = 0 := by
    rw [hLawX.integral_eq, standardNormalLaw]
    exact ProbabilityTheory.integral_id_gaussianReal
  have hMeanY : (∫ ω, Y ω ∂μ) = 0 := by
    rw [hLawY.integral_eq, standardNormalLaw]
    exact ProbabilityTheory.integral_id_gaussianReal
  have hAbsDiff : (∫ ω, |X ω - Y ω| ∂μ) =
      2 / Real.sqrt Real.pi := by
    have h := hPair.integral_comp (by fun_prop :
      AEStronglyMeasurable (fun p : ℝ × ℝ => |p.1 - p.2|)
        (standardNormalLaw.prod standardNormalLaw))
    rw [standardNormalLaw, NumStability.integral_abs_standardGaussian_difference] at h
    simpa only [Function.comp_apply] using h
  have hXInt := integrable_of_hasLaw_standardNormal hX hLawX
  have hYInt := integrable_of_hasLaw_standardNormal hY hLawY
  have hDiffInt : Integrable (fun ω => |X ω - Y ω|) μ :=
    (hXInt.sub hYInt).abs
  calc
    (∫ ω, max (X ω) (Y ω) ∂μ) =
        ∫ ω, (1 / 2 : ℝ) * (X ω + Y ω + |X ω - Y ω|) ∂μ := by
      apply integral_congr_ae
      filter_upwards [] with ω
      rcases le_total (X ω) (Y ω) with hXY | hYX
      · rw [max_eq_right hXY, abs_of_nonpos (sub_nonpos.mpr hXY)]
        ring
      · rw [max_eq_left hYX, abs_of_nonneg (sub_nonneg.mpr hYX)]
        ring
    _ = (1 / 2 : ℝ) *
        ((∫ ω, X ω ∂μ) + (∫ ω, Y ω ∂μ) +
          ∫ ω, |X ω - Y ω| ∂μ) := by
      rw [integral_const_mul]
      congr 1
      let D : Ω → ℝ := fun ω => |X ω - Y ω|
      change (∫ ω, ((X + Y) + D) ω ∂μ) = _
      calc
        (∫ ω, ((X + Y) + D) ω ∂μ) =
            (∫ ω, (X + Y) ω ∂μ) + ∫ ω, D ω ∂μ := by
          simpa using integral_add (hXInt.add hYInt) hDiffInt
        _ = (∫ ω, X ω ∂μ) + (∫ ω, Y ω ∂μ) +
            ∫ ω, |X ω - Y ω| ∂μ := by
          rw [show (∫ ω, (X + Y) ω ∂μ) =
            (∫ ω, X ω ∂μ) + ∫ ω, Y ω ∂μ by
              simpa only [Pi.add_apply] using integral_add hXInt hYInt]
    _ = 1 / Real.sqrt Real.pi := by
      rw [hMeanX, hMeanY, hAbsDiff]
      ring

/-- Every finite standard-normal maximum with at least two coordinates
dominates the exact two-coordinate expected maximum. -/
lemma expectation_finiteMaximum_standardNormal_ge_pair
    {N : ℕ} [Nonempty (Fin N)] (hN : 2 ≤ N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    1 / Real.sqrt Real.pi ≤ ∫ ω, finiteMaximum X ω ∂μ := by
  let i : Fin N := ⟨0, by omega⟩
  let j : Fin N := ⟨1, by omega⟩
  have hij : i ≠ j := by
    intro h
    have := congrArg Fin.val h
    norm_num [i, j] at this
  have hPairInt : Integrable (fun ω => max (X i ω) (X j ω)) μ :=
    (integrable_of_hasLaw_standardNormal (hX i) (hLaw i)).sup
      (integrable_of_hasLaw_standardNormal (hX j) (hLaw j))
  have hMaxInt : Integrable (finiteMaximum X) μ :=
    integrable_finiteMaximum (fun k =>
      integrable_of_hasLaw_standardNormal (hX k) (hLaw k))
  rw [← expectation_max_two_standardNormal (hX i) (hX j)
    (hLaw i) (hLaw j) (hIndep.indepFun hij)]
  apply integral_mono hPairInt hMaxInt
  intro ω
  exact max_le (le_finiteMaximum X i ω) (le_finiteMaximum X j ω)

/-- The large-logarithm estimate before absorbing the finite absolute-moment
loss. -/
lemma expectation_finiteMaximum_standardNormal_ge_affine
    {N : ℕ} [Nonempty (Fin N)]
    (hLog : 4 ≤ Real.log (N : ℝ))
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumHitConstant * Real.sqrt (Real.log (N : ℝ)) -
        standardNormalAbsMean ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let i : Fin N := Classical.choice inferInstance
  have hThreshold := standardNormalMaximum_expectation_ge_threshold
    hX hLaw hIndep i (Real.sqrt (Real.log (N : ℝ)))
  have hFactor := gaussianMaximumHitConstant_le_tail_factor hLog
  have hSqrt : 0 ≤ Real.sqrt (Real.log (N : ℝ)) := Real.sqrt_nonneg _
  rw [mul_comm gaussianMaximumHitConstant]
  exact (sub_le_sub_right
    (mul_le_mul_of_nonneg_left hFactor hSqrt) standardNormalAbsMean).trans
      (by simpa only [Fintype.card_fin] using hThreshold)

/-- A positive universal constant for the lower bound on independent
standard-normal maxima. -/
def gaussianMaximumLowerConstant : ℝ :=
  min ((1 / Real.sqrt Real.pi) / 2)
    (((1 / Real.sqrt Real.pi) * gaussianMaximumHitConstant) /
      ((1 / Real.sqrt Real.pi) + standardNormalAbsMean))

lemma gaussianMaximumLowerConstant_pos : 0 < gaussianMaximumLowerConstant := by
  let a : ℝ := 1 / Real.sqrt Real.pi
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : 0 < gaussianMaximumHitConstant := gaussianMaximumHitConstant_pos
  have hd : 0 ≤ standardNormalAbsMean := standardNormalAbsMean_nonneg
  have hden : 0 < a + standardNormalAbsMean := by linarith
  unfold gaussianMaximumLowerConstant
  exact lt_min (div_pos ha (by norm_num)) (div_pos (mul_pos ha hb) hden)

/-- Sharp-order lower bound for the expected signed maximum of `N ≥ 2`
independent standard-normal variables. -/
theorem expectation_finiteMaximum_standardNormal_ge_sqrt_log
    {N : ℕ} [Nonempty (Fin N)] (hN : 2 ≤ N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  let x : ℝ := Real.sqrt (Real.log (N : ℝ))
  let a : ℝ := 1 / Real.sqrt Real.pi
  let b : ℝ := gaussianMaximumHitConstant
  let d : ℝ := standardNormalAbsMean
  have hx : 0 ≤ x := Real.sqrt_nonneg _
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : 0 < b := by exact gaussianMaximumHitConstant_pos
  have hd : 0 ≤ d := by exact standardNormalAbsMean_nonneg
  have hden : 0 < a + d := by linarith
  have hBase : a ≤ ∫ ω, finiteMaximum X ω ∂μ := by
    exact expectation_finiteMaximum_standardNormal_ge_pair hN hX hLaw hIndep
  have hCsmall : gaussianMaximumLowerConstant ≤ a / 2 := by
    exact min_le_left _ _
  have hCmain : gaussianMaximumLowerConstant ≤ a * b / (a + d) := by
    exact min_le_right _ _
  by_cases hLog : 4 ≤ Real.log (N : ℝ)
  · have hAffine : b * x - d ≤ ∫ ω, finiteMaximum X ω ∂μ := by
      exact expectation_finiteMaximum_standardNormal_ge_affine hLog hX hLaw hIndep
    have hCombine : a * b / (a + d) * x ≤ max a (b * x - d) := by
      by_cases hbx : b * x ≤ a + d
      · calc
          a * b / (a + d) * x = a * (b * x) / (a + d) := by ring
          _ ≤ a := by
            apply (div_le_iff₀ hden).2
            exact mul_le_mul_of_nonneg_left hbx ha.le
          _ ≤ max a (b * x - d) := le_max_left _ _
      · have hbx' : a + d < b * x := lt_of_not_ge hbx
        have hprod : 0 ≤ d * (b * x - (a + d)) :=
          mul_nonneg hd (sub_nonneg.mpr hbx'.le)
        calc
          a * b / (a + d) * x = (a * b * x) / (a + d) := by ring
          _ ≤ b * x - d := by
            apply (div_le_iff₀ hden).2
            nlinarith
          _ ≤ max a (b * x - d) := le_max_right _ _
    calc
      gaussianMaximumLowerConstant * x ≤
          (a * b / (a + d)) * x :=
        mul_le_mul_of_nonneg_right hCmain hx
      _ ≤ max a (b * x - d) := hCombine
      _ ≤ ∫ ω, finiteMaximum X ω ∂μ := max_le hBase hAffine
  · have hLogLe : Real.log (N : ℝ) ≤ 4 := le_of_not_ge hLog
    have hxLe : x ≤ 2 := by
      dsimp [x]
      calc
        Real.sqrt (Real.log (N : ℝ)) ≤ Real.sqrt 4 :=
          Real.sqrt_le_sqrt hLogLe
        _ = 2 := by norm_num
    calc
      gaussianMaximumLowerConstant * x ≤ (a / 2) * x :=
        mul_le_mul_of_nonneg_right hCsmall hx
      _ ≤ a := by nlinarith
      _ ≤ ∫ ω, finiteMaximum X ω ∂μ := hBase

/-- Positive-cardinality form, including the source's trivial single-variable
endpoint. -/
theorem expectation_finiteMaximum_standardNormal_ge_sqrt_log_of_pos
    {N : ℕ} [Nonempty (Fin N)] (hN : 0 < N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Fin N → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hLaw : ∀ i, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun X μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, finiteMaximum X ω ∂μ := by
  by_cases hOne : N = 1
  · subst N
    have hMax : finiteMaximum X = X 0 := by
      funext ω
      rw [finiteMaximum, Finset.sup'_apply]
      simp
    have hMean : (∫ ω, X 0 ω ∂μ) = 0 := by
      rw [(hLaw 0).integral_eq, standardNormalLaw]
      exact ProbabilityTheory.integral_id_gaussianReal
    rw [hMax, hMean]
    norm_num
  · exact expectation_finiteMaximum_standardNormal_ge_sqrt_log
      (by omega) hX hLaw hIndep

/-- The signed maximum of the first `N` members of a sequence, totalized by
zero only at the empty prefix. -/
def prefixMaximum {Ω : Type*} (X : ℕ → Ω → ℝ) (N : ℕ) : Ω → ℝ :=
  if hN : 0 < N then
    letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
    finiteMaximum (fun i : Fin N => X i)
  else
    fun _ => 0

lemma prefixMaximum_eq_finiteMaximum
    {Ω : Type*} (X : ℕ → Ω → ℝ) {N : ℕ} (hN : 0 < N) :
    letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
    prefixMaximum X N = finiteMaximum (fun i : Fin N => X i) := by
  simp [prefixMaximum, hN]

/-- Sequence-indexed form of the sharp-order lower bound. -/
theorem expectation_prefixMaximum_standardNormal_ge_sqrt_log
    {N : ℕ} (hN : 0 < N)
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : ℕ → Ω → ℝ}
    (hX : ∀ i : Fin N, Measurable (X i))
    (hLaw : ∀ i : Fin N, HasLaw (X i) standardNormalLaw μ)
    (hIndep : iIndepFun (fun i : Fin N => X i) μ) :
    gaussianMaximumLowerConstant * Real.sqrt (Real.log (N : ℝ)) ≤
      ∫ ω, prefixMaximum X N ω ∂μ := by
  letI : Nonempty (Fin N) := ⟨⟨0, hN⟩⟩
  rw [prefixMaximum_eq_finiteMaximum X hN]
  exact expectation_finiteMaximum_standardNormal_ge_sqrt_log_of_pos
    hN hX hLaw hIndep

end NumStability.HDP.Scalar.GaussianMaxima
