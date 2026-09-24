import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Exercise 3.1.4(b)

For dimension-uniform coordinate `ψ₂` scale, the expectation gap in part (a)
vanishes at the explicit rate `O(K⁴ / √n)`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d1_d4b__contract_type : Prop :=
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
              0 ≤ Real.sqrt (n : ℝ) -
                  (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) ∧
                Real.sqrt (n : ℝ) -
                    (∫ ω, NumStability.vecNorm2 (fun i => X i ω) ∂μ) ≤
                  C *
                      (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
                        μ X) ^ 4 /
                    Real.sqrt (n : ℝ)

end NumStability.HDP.Contract
