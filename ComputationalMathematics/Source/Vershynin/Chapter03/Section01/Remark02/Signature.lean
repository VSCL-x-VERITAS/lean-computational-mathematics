import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Remark 3.1.2

The remark's high-probability shell statement is quantified at probability
`0.99`, and its exact moment premise is recorded as the mean identity for the
squared Euclidean norm.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hrem_h3_d1_d2__contract_type : Prop :=
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
              (μ.real {ω |
                  |NumStability.vecNorm2 (fun i => X i ω) -
                    Real.sqrt (n : ℝ)| ≥
                      C *
                        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
                          μ X) ^ 2} ≤
                    (1 / 100 : ℝ)) ∧
                (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω) ∂μ) = n

end NumStability.HDP.Contract
