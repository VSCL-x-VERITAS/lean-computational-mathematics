import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.Probability.Independence.Basic
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Theorem 2.6.2. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

def hdp_02_hthm_h2_d6_d2__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} {K : ι → ℝ}
    (hX : ∀ i,
      NumStability.HDP.Scalar.SubGaussian.SubGaussianLinearMGF μ (X i) (K i))
    (hIndep : iIndepFun X μ)
    (hEnergy : 0 < ∑ i, K i ^ 2)
    {t : ℝ} (ht : 0 ≤ t),
    μ.real {ω | |∑ i, X i ω| ≥ t} ≤
      2 * Real.exp (-t ^ 2 / (4 * ∑ i, K i ^ 2))

end NumStability.HDP.Contract
