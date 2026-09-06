import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-! Stable source-facing contract for the independent finite-sum variance identity. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

theorem hdp_01_hlem_hindependent_hvariance_hsum
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsFiniteMeasure μ]
    {X : ι → Ω → ℝ} (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ∀ ⦃i j : ι⦄, i ≠ j → IndepFun (X i) (X j) μ) :
    Var[∑ i, X i; μ] = ∑ i, Var[X i; μ] :=
  NumStability.HDP.Scalar.LimitTheorems.independentVarianceSum hX hIndep

end NumStability.HDP.Contract
