import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Exercise 3.1.4(a)

The expected Euclidean norm lies within a universal multiple of `K²` of
`√n` under the hypotheses inherited from Theorem 3.1.1.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d1_d4a__contract_type : Prop :=
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
              Real.sqrt (n : ℝ) -
                    C *
                      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
                        μ X) ^ 2 ≤
                  ∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ ∧
                (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) ≤
                  Real.sqrt (n : ℝ) +
                    C *
                      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
                        μ X) ^ 2

end NumStability.HDP.Contract
