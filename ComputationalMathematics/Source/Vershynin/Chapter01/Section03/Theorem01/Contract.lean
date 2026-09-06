import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-! Stable Chapter 1 forwarding declaration for the strong law. -/

noncomputable section

open MeasureTheory Filter
open ProbabilityTheory
open scoped BigOperators Function

namespace NumStability.HDP.Contract

theorem hdp_01_hthm_h1_d3_d1
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ℕ → Ω → ℝ}
    (hInt : Integrable (X 0) μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, Tendsto
      (fun n : ℕ => (∑ i ∈ Finset.range n, X i ω) / n) atTop
      (nhds (∫ ω, X 0 ω ∂μ)) :=
  NumStability.HDP.Scalar.LimitTheorems.strongLaw hInt hIndep hIdent

end NumStability.HDP.Contract
