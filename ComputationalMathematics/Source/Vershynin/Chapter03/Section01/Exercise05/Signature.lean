import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.Probability.Moments.Variance

/-!
# Frozen contract signature for Exercise 3.1.5

The variance of the Euclidean norm is bounded by a universal multiple of
the fourth power of the maximum coordinate `ψ₂` gauge.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d1_d5__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ),
      (∀ i, Measurable (X i)) →
        (∀ i,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞) →
          (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
            iIndepFun X μ →
              variance
                  (fun ω => NumStability.vecNorm2 (fun i => X i ω)) μ ≤
                C *
                  (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
                    μ X) ^ 4

end NumStability.HDP.Contract
