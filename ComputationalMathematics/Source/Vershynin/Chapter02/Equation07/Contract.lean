import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Source-facing Chapter 2 contract for display (2.7). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Function

namespace NumStability.HDP.Contract

/-- The exponential-Markov bound for a sum of independent Bernoulli indicators,
with its MGF factored into the product of the coordinate MGFs as in (2.7). -/
theorem hdp_02_heq_h2_d7
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : iIndepFun B μ)
    (hMeas : ∀ i, Measurable (B i))
    {lam t : ℝ} (hlam : 0 < lam) :
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} ≤
      Real.exp (-(lam * t)) *
        ∏ i, ∫ ω, Real.exp (lam * (if B i ω then 1 else 0)) ∂μ := by
  let Y : ι → Ω → ℝ := fun i ω => if B i ω then 1 else 0
  let S : Ω → ℝ := fun ω => ∑ i, Y i ω
  have hY : iIndepFun Y μ := by
    let g : ∀ _ : ι, Bool → ℝ := fun _ b => if b then 1 else 0
    have h := hB.comp g (fun _ => measurable_of_finite _)
    simpa [Y, g, Function.comp_def] using h
  have hYi : ∀ i, Measurable (Y i) := by
    intro i
    exact Measurable.ite
      (measurableSet_preimage (hMeas i) (measurableSet_singleton true))
      measurable_const measurable_const
  have hExp : ∀ i, Integrable (fun ω => Real.exp (lam * Y i ω)) μ := by
    intro i
    apply Integrable.of_bound ((hYi i).const_mul lam).exp.aestronglyMeasurable
      (Real.exp |lam|)
    filter_upwards [] with ω
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    by_cases hb : B i ω
    · simpa [Y, hb] using Real.exp_le_exp.mpr (le_abs_self lam)
    · simp [Y, hb]
  have hSMeas : Measurable S := by
    exact Finset.measurable_sum Finset.univ fun i _ => hYi i
  have hExpS : Integrable (fun ω => Real.exp (lam * S ω)) μ := by
    apply Integrable.of_bound (hSMeas.const_mul lam).exp.aestronglyMeasurable
      (Real.exp (|lam| * (Fintype.card ι : ℝ)))
    filter_upwards [] with ω
    have hsum_nonneg : 0 ≤ S ω := by
      dsimp [S, Y]
      exact Finset.sum_nonneg fun _ _ => by split <;> norm_num
    have hsum_le : S ω ≤ (Fintype.card ι : ℝ) := by
      dsimp [S, Y]
      calc
        (∑ i, (if B i ω then (1 : ℝ) else 0)) ≤ ∑ _i : ι, (1 : ℝ) := by
          exact Finset.sum_le_sum fun i _ => by split <;> norm_num
        _ = (Fintype.card ι : ℝ) := by simp
    rw [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
    apply Real.exp_le_exp.mpr
    nlinarith [le_abs_self lam, neg_le_abs lam, abs_nonneg lam]
  have hmarkov :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkovUpper
      (t := t) hSMeas hlam hExpS
  have hfactor :=
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.mgfIndependentSum
      (μ := μ) lam (fun _ => 1) hY (fun i => by simpa using hExp i)
  have hfactor' :
      (∫ ω, Real.exp (lam * S ω) ∂μ) =
        ∏ i, ∫ ω, Real.exp (lam * (if B i ω then 1 else 0)) ∂μ := by
    simpa [S, Y] using hfactor
  calc
    μ.real {ω | t ≤ ∑ i, (if B i ω then 1 else 0)} =
        μ.real (S ⁻¹' Set.Ici t) := by rfl
    _ ≤ Real.exp (-(lam * t)) * (∫ ω, Real.exp (lam * S ω) ∂μ) := hmarkov
    _ = Real.exp (-(lam * t)) *
        ∏ i, ∫ ω, Real.exp (lam * (if B i ω then 1 else 0)) ∂μ := by
      rw [hfactor']

end NumStability.HDP.Contract
