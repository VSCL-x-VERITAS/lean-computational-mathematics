import ComputationalMathematics.Analysis.MatrixAlgebra
import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic

/-! Frozen proof-free signature for the expected squared norm identity on printed page 42. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_1_norm_square_mean__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
    (X : Fin n → Ω → ℝ),
    iIndepFun X μ →
      (∀ i, Measurable (X i)) →
        (∀ i, NumStability.HDP.Scalar.Preliminaries.expectation μ (X i) = 0) →
          (∀ i, NumStability.HDP.Scalar.Preliminaries.variance μ (X i) = 1) →
            NumStability.HDP.Scalar.Preliminaries.expectation μ
              (fun ω => NumStability.vecNorm2Sq (fun i => X i ω)) = n

end NumStability.HDP.Contract
