import ComputationalMathematics.HDP.Scalar.LimitTheorems
/-! Stable source-facing contract for Equation (1.5), sample-mean variance. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the iid sample-mean variance identity. -/
theorem hdp_01_heq_h1_d5
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    (N : ℕ) (hN : 0 < N)
    {X : Fin N → Ω → ℝ}
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : Fin N⦄, i ≠ j → IndepFun (X i) (X j) μ)
    (hIdent : ∀ i, IdentDistrib (X i) (X ⟨0, hN⟩) μ μ) :
    Var[fun ω => (N : ℝ)⁻¹ * ∑ i, X i ω; μ] =
      (N : ℝ)⁻¹ * Var[X ⟨0, hN⟩; μ] :=
  NumStability.HDP.Scalar.LimitTheorems.iidSampleMeanVariance
    N hN hX hIndep hIdent

end NumStability.HDP.Contract
