import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm

/-!
# Frozen contract signature for Exercise 2.6.5

This proof-free target states the `p ≥ 2` Khintchine inequality with the
source's unit-variance, centering, independence, and common maximal `psi₂`
scale assumptions.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d5__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {ι Ω : Type*} [Fintype ι] [Nonempty ι]
      [MeasurableSpace Ω] {μ : Measure Ω}
      [IsProbabilityMeasure μ] {X : ι → Ω → ℝ},
      (∀ i,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i)) →
      (∀ i, Integrable (X i) μ ∧ (∫ ω, X i ω ∂μ) = 0) →
      (∀ i, Var[X i; μ] = 1) →
      iIndepFun X μ →
      ∀ (a : ι → ℝ) (p : ℝ), 2 ≤ p →
        Real.sqrt (∑ i, a i ^ 2) ≤
            lpNorm (fun ω => ∑ i, a i * X i ω)
              (ENNReal.ofReal p) μ ∧
        lpNorm (fun ω => ∑ i, a i * X i ω)
            (ENNReal.ofReal p) μ ≤
          C *
            NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X *
            Real.sqrt p * Real.sqrt (∑ i, a i ^ 2)

end NumStability.HDP.Contract
