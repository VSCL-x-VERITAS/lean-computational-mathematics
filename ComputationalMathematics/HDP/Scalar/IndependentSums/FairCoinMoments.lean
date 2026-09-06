import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding
import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Moments of a fair-coin count

Reusable moment identities for a finite family of independent fair Bernoulli
indicators.  This isolates the elementary foundation used in the motivating
example at the start of Chapter 2 from the later concentration bounds.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.FairCoinMoments

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- The expectation of the canonical fair Bernoulli indicator is `1 / 2`. -/
theorem fairBernoulliPMF_indicator_mean :
    ∫ b, bernoulliIndicator b ∂fairBernoulliPMF.toMeasure = (1 / 2 : ℝ) := by
  rw [PMF.integral_eq_sum]
  simp [fairBernoulliPMF, bernoulliIndicator, PMF.bernoulli_apply]

/-- The variance of the canonical fair Bernoulli indicator is `1 / 4`. -/
theorem fairBernoulliPMF_indicator_variance :
    Var[bernoulliIndicator; fairBernoulliPMF.toMeasure] = (1 / 4 : ℝ) := by
  rw [variance_eq_integral (measurable_of_countable _).aemeasurable]
  rw [fairBernoulliPMF_indicator_mean, PMF.integral_eq_sum]
  simp [fairBernoulliPMF, bernoulliIndicator, PMF.bernoulli_apply]
  norm_num

/-- A finite sum of independent fair Bernoulli indicators has mean `N / 2`
and variance `N / 4`, where `N` is the cardinality of the index type. -/
theorem fairBernoulliSum_mean_variance
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ = fairBernoulliPMF.toMeasure) :
    (∫ ω, ∑ i, bernoulliIndicator (B i ω) ∂μ) =
        (Fintype.card ι : ℝ) / 2 ∧
      Var[fun ω ↦ ∑ i, bernoulliIndicator (B i ω); μ] =
        (Fintype.card ι : ℝ) / 4 := by
  let X : ι → Ω → ℝ := fun i ω ↦ bernoulliIndicator (B i ω)
  have hXmeas : ∀ i, Measurable (X i) := by
    intro i
    exact (measurable_of_countable bernoulliIndicator).comp (hB i)
  have hXmem : ∀ i, MemLp (X i) 2 μ := by
    intro i
    refine MemLp.of_bound (hXmeas i).aestronglyMeasurable 1 ?_
    filter_upwards [] with ω
    cases h : B i ω <;> simp [X, bernoulliIndicator, h]
  have hXmean : ∀ i, ∫ ω, X i ω ∂μ = (1 / 2 : ℝ) := by
    intro i
    rw [← integral_map (hB i).aemeasurable
      (measurable_of_countable bernoulliIndicator).aestronglyMeasurable]
    rw [hLaw i]
    exact fairBernoulliPMF_indicator_mean
  have hXvar : ∀ i, Var[X i; μ] = (1 / 4 : ℝ) := by
    intro i
    change Var[bernoulliIndicator ∘ B i; μ] = (1 / 4 : ℝ)
    rw [← variance_map (measurable_of_countable bernoulliIndicator).aemeasurable
      (hB i).aemeasurable]
    rw [hLaw i]
    exact fairBernoulliPMF_indicator_variance
  have hXindep : iIndepFun X μ := by
    have h := hIndep.comp (fun _ b ↦ bernoulliIndicator b)
      (fun _ ↦ measurable_of_countable bernoulliIndicator)
    simpa [X, Function.comp_def] using h
  have hXpair : Pairwise (fun i j ↦ X i ⟂ᵢ[μ] X j) := by
    intro i j hij
    exact hXindep.indepFun hij
  constructor
  · change (∫ ω, ∑ i, X i ω ∂μ) = _
    rw [integral_finset_sum]
    · simp_rw [hXmean]
      simp [div_eq_mul_inv]
    · intro i _
      exact (hXmem i).integrable (by norm_num)
  · change Var[fun ω ↦ ∑ i, X i ω; μ] = _
    have hfun : (fun ω ↦ ∑ i, X i ω) = ∑ i, X i := by
      funext ω
      simp
    rw [hfun, NumStability.HDP.Scalar.LimitTheorems.independentVarianceSum hXmem hXpair]
    simp_rw [hXvar]
    simp [div_eq_mul_inv]

end NumStability.HDP.Scalar.IndependentSums.FairCoinMoments
