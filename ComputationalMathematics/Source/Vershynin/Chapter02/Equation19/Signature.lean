import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Frozen contract signature for Equation (2.19)

This file is intentionally proof-free. The semantic theorem and stable source
alias are checked against this exact proposition by the contract wrapper.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_heq_h2_d19__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ},
    MemLp X 2 μ →
      eLpNorm (fun ω => X ω - ∫ x, X x ∂μ) 2 μ ≤ eLpNorm X 2 μ

end NumStability.HDP.Contract
