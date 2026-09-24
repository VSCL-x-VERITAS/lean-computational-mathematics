import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen proof-free signature for Equation (3.1). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_heq_h3_d1__contract_type : Prop :=
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
              ∀ {u : ℝ}, 0 ≤ u →
                μ.real {ω |
                    |NumStability.vecNorm2 (fun i => X i ω) ^ 2 /
                      (n : ℝ) - 1| ≥ u} ≤
                  2 * Real.exp (-(c * min (u ^ 2) u /
                    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 4 *
                      (n : ℝ)))

end NumStability.HDP.Contract
