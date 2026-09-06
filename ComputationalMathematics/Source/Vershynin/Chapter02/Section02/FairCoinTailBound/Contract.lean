import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Stable Chapter 2 forwarding declaration for the fair-coin application. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

theorem hdp_02_hbody_h2_d2_hcoin_hbound
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {B : ι → Ω → Bool}
    (hB : ∀ i, Measurable (B i))
    (hIndep : iIndepFun B μ)
    (hLaw : ∀ i, Measure.map (B i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF.toMeasure)
    (hN : 0 < Fintype.card ι) :
    μ.real {ω | ∑ i,
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.bernoulliIndicator
          (B i ω) ≥
      (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} ≤
      Real.exp (-(Fintype.card ι : ℝ) / 8) := by
  let R : ι → Ω → ℝ := fun i ω =>
    NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue (B i ω)
  have hRMeas : ∀ i, Measurable (R i) := by
    intro i
    exact (measurable_of_countable
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue).comp (hB i)
  have hRLaw : ∀ i, Measure.map (R i) μ =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure := by
    intro i
    rw [show R i =
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue ∘ B i by rfl]
    rw [← Measure.map_map
      (measurable_of_countable
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue)
      (hB i), hLaw i]
    exact PMF.toMeasure_map
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairBernoulliPMF
      (measurable_of_countable
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue)
  have hExp : ∀ (lam : ℝ) (i : ι),
      Integrable (fun ω => Real.exp (lam *
        NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherValue
          (B i ω))) μ := by
    intro lam i
    simpa only [R, one_mul] using
      NumStability.HDP.Scalar.IndependentSums.Hoeffding.integrable_exp_mul_rademacher
        (hRMeas i) (hRLaw i) lam 1
  exact NumStability.HDP.Scalar.IndependentSums.Hoeffding.fairCoinHoeffding
    hB hIndep hLaw hExp hN

end NumStability.HDP.Contract
