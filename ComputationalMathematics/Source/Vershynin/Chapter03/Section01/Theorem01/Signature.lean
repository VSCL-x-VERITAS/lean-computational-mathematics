import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for Theorem 3.1.1

This proof-free signature records concentration of the Euclidean norm for a
random vector with independent sub-Gaussian coordinates and unit second
moments.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_hthm_h3_d1_d1__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {n : ℕ} [Nonempty (Fin n)]
      {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ),
      (∀ i, Measurable (X i)) →
        (∀ i,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ (X i) < ∞) →
          (∀ i, (∫ ω, X i ω ^ 2 ∂μ) = 1) →
            iIndepFun X μ →
              NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
                  (fun ω => NumStability.vecNorm2 (fun i => X i ω) -
                    Real.sqrt (n : ℝ)) ≤
                ENNReal.ofReal
                  (C *
                    (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ X) ^ 2)

end NumStability.HDP.Contract
