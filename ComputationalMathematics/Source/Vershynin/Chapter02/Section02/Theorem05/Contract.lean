import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Source-facing Chapter 2 contract for the two-sided Rademacher Hoeffding bound. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

private theorem rademacherPMF_map_neg :
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.map
        (fun x : ℝ => -x) =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF := by
  have hfair :
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF.map
          Bool.not =
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF := by
    apply PMF.ext
    intro b
    cases b <;>
      simp [NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF,
        PMF.map_apply, PMF.bernoulli_apply]
  have hfun :
      (fun x : ℝ => -x) ∘
          NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue =
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue ∘
          Bool.not := by
    funext b
    cases b <;>
      norm_num [Function.comp_apply,
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue]
  unfold NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF
  rw [PMF.map_comp, hfun, ← PMF.map_comp, hfair]

/-- Theorem 2.2.5 with the symmetric Bernoulli law as its only distributional
premise; sign symmetry and exponential integrability are consequences. -/
theorem hdp_02_hthm_h2_d2_d5_source
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {a : ι → ℝ} {t : ℝ}
    (hX : ∀ i, Measurable (X i))
    (hIndep : iIndepFun X μ)
    (hLaw : ∀ i, Measure.map (X i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure)
    (ht : 0 < t) :
    μ.real {ω | |∑ i, a i * X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (2 * ∑ i, (a i) ^ 2)) := by
  have hNegLaw : ∀ i, Measure.map (fun ω => -X i ω) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure := by
    intro i
    rw [show (fun ω => -X i ω) = (fun x : ℝ => -x) ∘ X i by rfl]
    rw [← Measure.map_map (by fun_prop) (hX i), hLaw i]
    rw [PMF.toMeasure_map (fun x : ℝ => -x)
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF (by fun_prop)]
    exact congrArg PMF.toMeasure rademacherPMF_map_neg
  have hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ := by
    intro lam i
    exact
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.integrable_exp_mul_rademacher
        (hX i) (hLaw i) lam (a i)
  by_cases hv : 0 < ∑ i, (a i) ^ 2
  · exact
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherTwoSidedHoeffding
        hX hIndep hLaw hNegLaw hExp ht hv
  · have hnonneg : 0 ≤ ∑ i, (a i) ^ 2 :=
      Finset.sum_nonneg (fun i _ => sq_nonneg (a i))
    have hzero : ∑ i, (a i) ^ 2 = 0 :=
      le_antisymm (le_of_not_gt hv) hnonneg
    rw [hzero]
    norm_num
    exact (measureReal_le_one (μ := μ)).trans (by norm_num)

end NumStability.HDP.Contract
