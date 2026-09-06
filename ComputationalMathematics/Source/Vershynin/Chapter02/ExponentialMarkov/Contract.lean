import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-! Stable Chapter 2 forwarding declaration for exponential Markov. -/

noncomputable section

open MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

theorem hdp_02_hlem_hexponential_hmarkov
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S)
    {lam t : ℝ} (hlam : 0 < lam)
    (hExp : Integrable (fun ω => Real.exp (lam * S ω)) μ)
    (hExpNeg : Integrable (fun ω => Real.exp (lam * (-S ω))) μ) :
    (μ.real (S ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * S ω) ∂μ)) ∧
      (μ.real ((fun ω => -S ω) ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * (-S ω)) ∂μ)) :=
  NumStability.HDP.Scalar.IndependentSums.Hoeffding.exponentialMarkov
    hS hlam hExp hExpNeg

end NumStability.HDP.Contract
