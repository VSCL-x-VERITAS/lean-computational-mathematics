import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Equation (3.3). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_heq_h3_d3__contract_type : Prop :=
  ∃ c : ℝ, 0 < c ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ),
      (∀ i, Measurable (X i)) →
        (∀ i,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞) →
          (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
            iIndepFun X μ →
              ∀ {t : ℝ}, 0 ≤ t →
                μ.real {ω |
                    |NumStability.vecNorm2 (fun i => X i ω) -
                      Real.sqrt (n : ℝ)| ≥ t} ≤
                  2 * Real.exp (-(c * t ^ 2 /
                    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 4))

end NumStability.HDP.Contract
