import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-! Stable Chapter 2 forwarding theorem for Exercise 2.3.5. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators
open scoped NNReal

namespace NumStability.HDP.Contract

/-- A practical form with the explicit uniform constant `c = 1 / 4`. -/
theorem hdp_02_hex_h2_d3_d5_quarter
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {δ : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) :
    μ.real {ω |
        δ * (∑ i, (p i : ℝ)) ≤
          |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
      2 * Real.exp (-(∑ i, (p i : ℝ)) * δ ^ 2 / 4) := by
  have hYi : ∀ i, Measurable (fun ω => if B i ω then (1 : ℝ) else 0) := by
    intro i
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton true))
      measurable_const measurable_const
  have hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ := by
    intro lam i
    apply Integrable.of_bound ((hYi i).const_mul lam).exp.aestronglyMeasurable
      (Real.exp |lam|)
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    by_cases hb : B i ω
    · simpa [hb] using Real.exp_le_exp.mpr (le_abs_self lam)
    · simp [hb]
  have hSMeas : Measurable
      (fun ω => ∑ i, (if B i ω then (1 : ℝ) else 0)) :=
    Finset.measurable_sum Finset.univ fun i _ => hYi i
  have hExpS : ∀ (lam : ℝ),
      Integrable (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ := by
    intro lam
    apply Integrable.of_bound (hSMeas.const_mul lam).exp.aestronglyMeasurable
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
    NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialTwoSidedQuadraticBound
      hp hB hLaw hMeas hδ0 hδ1 hExp hExpS

/-- Exercise 2.3.5, preserving the book's deliberately unnamed absolute
constant as one existential witness uniform over every finite Bernoulli
family and every relative deviation in `(0, 1]`. -/
theorem hdp_02_hex_h2_d3_d5 :
    ∃ c : ℝ, 0 < c ∧
      ∀ (ι Ω : Type*) [Fintype ι] [MeasurableSpace Ω]
        (μ : Measure Ω) [IsProbabilityMeasure μ]
        (B : ι → Ω → Bool) (p : ι → ℝ≥0) (hp : ∀ i, p i ≤ 1),
        iIndepFun B μ →
        (∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ) →
        (∀ i, Measurable (B i)) →
        ∀ δ : ℝ, 0 < δ → δ ≤ 1 →
          μ.real {ω |
              δ * (∑ i, (p i : ℝ)) ≤
                |(∑ i, (if B i ω then 1 else 0)) - ∑ i, (p i : ℝ)|} ≤
            2 * Real.exp (-(c * (∑ i, (p i : ℝ)) * δ ^ 2)) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ B p hp hB hLaw hMeas δ hδ0 hδ1
  have h := hdp_02_hex_h2_d3_d5_quarter hp hB hLaw hMeas hδ0 hδ1
  convert h using 1
  ring

end NumStability.HDP.Contract
