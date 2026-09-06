import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-! Source-facing Chapter 2 contract for Exercise 2.3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Contract

/-- The lower-tail Chernoff bound with boundedness-derived exponential
integrability, rather than proof-internal integrability assumptions. -/
theorem hdp_02_hex_h2_d3_d2_source
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ} (ht : 0 < t) (htμ : t < ∑ i, (p i : ℝ)) :
    μ.real {ω | ∑ i, (if B i ω then 1 else 0) ≤ t} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let lam : ℝ := Real.log ((∑ i, (p i : ℝ)) / t)
  have hYi : ∀ i, Measurable (fun ω => if B i ω then (1 : ℝ) else 0) := by
    intro i
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton true))
      measurable_const measurable_const
  have hExp : ∀ i, Integrable
      (fun ω => Real.exp ((-lam) * (if B i ω then 1 else 0))) μ := by
    intro i
    apply Integrable.of_bound ((hYi i).const_mul (-lam)).exp.aestronglyMeasurable
      (Real.exp |lam|)
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    by_cases hb : B i ω
    · simpa [hb] using Real.exp_le_exp.mpr (neg_le_abs lam)
    · simpa [hb] using Real.one_le_exp (abs_nonneg lam)
  have hSMeas : Measurable
      (fun ω => ∑ i, (if B i ω then (1 : ℝ) else 0)) :=
    Finset.measurable_sum Finset.univ fun i _ => hYi i
  have hExpS : Integrable
      (fun ω => Real.exp (lam * (-∑ i, (if B i ω then 1 else 0)))) μ := by
    apply Integrable.of_bound (hSMeas.neg.const_mul lam).exp.aestronglyMeasurable
      (Real.exp (|lam| * (Fintype.card ι : ℝ)))
    filter_upwards [] with ω
    have hsum_nonneg : 0 ≤ ∑ i, (if B i ω then (1 : ℝ) else 0) :=
      Finset.sum_nonneg fun _ _ => by split <;> norm_num
    have hsum_le : (∑ i, (if B i ω then (1 : ℝ) else 0)) ≤
        (Fintype.card ι : ℝ) := by
      calc
        (∑ i, (if B i ω then (1 : ℝ) else 0)) ≤ ∑ _i : ι, (1 : ℝ) := by
          exact Finset.sum_le_sum fun i _ => by split <;> norm_num
        _ = (Fintype.card ι : ℝ) := by simp
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    apply Real.exp_le_exp.mpr
    nlinarith [le_abs_self lam, neg_le_abs lam, abs_nonneg lam]
  exact
    NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialLowerChernoffBound
      hp hB hLaw hMeas (by simpa [lam] using hExp) ht htμ
        (by simpa [lam] using hExpS)

end NumStability.HDP.Contract
