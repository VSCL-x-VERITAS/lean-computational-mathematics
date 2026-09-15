import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm

/-!
# Frozen formalizer-supplied contract for Exercise 2.6.7

The source asks the reader to state a version for `0 < p < 2`. This proof-free
target chooses the natural two-sided extension of Exercise 2.6.6, with an
explicit positive lower coefficient depending only on `K` and `p`.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d7__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
      [MeasurableSpace Ω] {μ : Measure Ω}
      [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
      (∀ i,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, Var[X i; μ] = 1) →
      iIndepFun X μ →
      ∀ (a : ι → ℝ) (p : ℝ), 0 < p → p < 2 →
        let K :=
          NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X
        let S : Ω → ℝ := fun ω => ∑ i, a i * X i ω
        let A := Real.sqrt (∑ i, a i ^ 2)
        let c := (C * (1 + K)) ^ (-(3 * (2 - p) / p))
        0 < c ∧ c * A ≤ lpNorm S (ENNReal.ofReal p) μ ∧
          lpNorm S (ENNReal.ofReal p) μ ≤ A

end NumStability.HDP.Contract
