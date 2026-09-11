import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm

/-!
# Frozen contract signature for Exercise 2.6.6

This proof-free target states the `p = 1` Khintchine inequality. The explicit
positive lower coefficient depends only on the common maximal `psi₂` scale.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d6__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
      [MeasurableSpace Ω] {μ : Measure Ω}
      [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
      (∀ i,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, Var[X i; μ] = 1) →
      iIndepFun X μ →
      ∀ (a : ι → ℝ),
        let K :=
          NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
        let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
        let A := Real.sqrt (∑ i, a i ^ 2)
        0 < (C * (1 + K))⁻¹ ^ 3 ∧
          (C * (1 + K))⁻¹ ^ 3 * A ≤ lpNorm S 1 μ ∧
          lpNorm S 1 μ ≤ A

end NumStability.HDP.Contract
