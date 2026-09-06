import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-! Source-facing Chapter 2 contract for Theorem 2.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Contract

/-- Theorem 2.3.1 without proof-internal integrability assumptions and with the
zero-mean Bernoulli family included. -/
theorem hdp_02_hthm_h2_d3_d1_source
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool} {p : ι → ℝ≥0}
    (hp : ∀ i, p i ≤ 1)
    (hB : iIndepFun B μ)
    (hLaw : ∀ i, HasLaw (B i) (PMF.bernoulli (p i) (hp i)).toMeasure μ)
    (hMeas : ∀ i, Measurable (B i))
    {t : ℝ} (ht : ∑ i, (p i : ℝ) < t) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(∑ i, (p i : ℝ))) *
        ((Real.exp 1 * (∑ i, (p i : ℝ)) / t) ^ t) := by
  let mean : ℝ := ∑ i, (p i : ℝ)
  have hmean_nonneg : 0 ≤ mean := by
    dsimp [mean]
    exact Finset.sum_nonneg fun i _ => NNReal.coe_nonneg (p i)
  by_cases hmean : 0 < mean
  · let lam : ℝ := Real.log (t / mean)
    have hExp : ∀ i, Integrable
        (fun ω => Real.exp (lam * (if B i ω then 1 else 0))) μ := by
      intro i
      have hYi : Measurable (fun ω => if B i ω then (1 : ℝ) else 0) :=
        Measurable.ite
          (measurableSet_preimage (hMeas i) (measurableSet_singleton true))
          measurable_const measurable_const
      apply Integrable.of_bound ((hYi.const_mul lam).exp.aestronglyMeasurable)
        (Real.exp |lam|)
      filter_upwards [] with ω
      rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
      by_cases hb : B i ω
      · simpa [hb] using Real.exp_le_exp.mpr (le_abs_self lam)
      · simpa [hb] using Real.one_le_exp (abs_nonneg lam)
    have hExpS : Integrable
        (fun ω => Real.exp (lam * ∑ i, (if B i ω then 1 else 0))) μ := by
      have hSMeas : Measurable
          (fun ω => ∑ i, (if B i ω then (1 : ℝ) else 0)) := by
        exact Finset.measurable_sum Finset.univ fun i _ =>
          Measurable.ite
            (measurableSet_preimage (hMeas i) (measurableSet_singleton true))
            measurable_const measurable_const
      apply Integrable.of_bound ((hSMeas.const_mul lam).exp.aestronglyMeasurable)
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
    have hcore :=
      NumStability.HDP.Scalar.IndependentSums.Chernoff.poissonBinomialChernoffBound
        hp hB hLaw hMeas (t := t)
          (by simpa [lam, mean] using hExp) (by simpa [mean] using ht)
          (by simpa [mean] using hmean) (by simpa [lam, mean] using hExpS)
    simpa [mean] using hcore
  · have hmean0 : mean = 0 := le_antisymm (le_of_not_gt hmean) hmean_nonneg
    have ht0 : 0 < t := by linarith
    have hp0 : ∀ i, p i = 0 := by
      intro i
      have hle : (p i : ℝ) ≤ mean := by
        dsimp [mean]
        exact Finset.single_le_sum (fun j _ => NNReal.coe_nonneg (p j)) (Finset.mem_univ i)
      have hcoe : (p i : ℝ) = 0 :=
        le_antisymm (by linarith) (NNReal.coe_nonneg (p i))
      exact_mod_cast hcoe
    have hfalse : ∀ i, ∀ᵐ ω ∂μ, B i ω = false := by
      intro i
      apply ((hLaw i).ae_iff (p := fun b : Bool => b = false)
        (measurable_of_finite _)).2
      rw [ae_iff]
      have hset : {b : Bool | ¬b = false} = {true} := by
        ext b
        cases b <;> simp
      rw [hset,
        (PMF.bernoulli (p i) (hp i)).toMeasure_apply_singleton true
          (measurableSet_singleton true)]
      simp [hp0 i, PMF.bernoulli_apply]
    have hall : ∀ᵐ ω ∂μ, ∀ i, B i ω = false := ae_all_iff.2 hfalse
    have hevent : {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} =ᵐ[μ] (∅ : Set Ω) := by
      filter_upwards [hall] with ω hω
      have hs : (∑ i, (if B i ω then (1 : ℝ) else 0)) = 0 := by simp [hω]
      change (t ≤ ∑ i, (if B i ω then (1 : ℝ) else 0)) = False
      rw [hs]
      simp [ht0]
    rw [measureReal_congr hevent]
    simp only [measureReal_empty]
    positivity

end NumStability.HDP.Contract
