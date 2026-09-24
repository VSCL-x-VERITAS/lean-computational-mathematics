import ComputationalMathematics.Analysis.MatrixAlgebra
import Mathlib.Probability.Moments.Variance

/-!
# Frozen contract signature for Exercise 3.1.6

The Euclidean norm has variance of order at most the common fourth-moment
bound for independent normalized coordinates.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d1_d6__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ) (K : ℝ),
      (∀ i, Measurable (X i)) →
        (∀ i, Integrable (fun ω => X i ω ^ 4) μ) →
          (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
            (∀ i, (∫ ω, X i ω ^ 4 ∂μ) ≤ K ^ 4) →
              iIndepFun X μ →
                variance
                    (fun ω => NumStability.vecNorm2 (fun i => X i ω)) μ ≤
                  C * K ^ 4

end NumStability.HDP.Contract
