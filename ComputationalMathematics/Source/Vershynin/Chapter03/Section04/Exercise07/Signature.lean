import ComputationalMathematics.HDP.Vector.UniformBallSubGaussian

/-! Frozen proof-free signature for Exercise 3.4.7. -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_7__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian
        (NumStability.HDP.Convex.uniformConvexBodyMeasure
          (NumStability.HDP.Vector.UniformBall.functionSqrtDimensionBall n))
        (fun i x ↦ x i) ∧
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Convex.uniformConvexBodyMeasure
          (NumStability.HDP.Vector.UniformBall.functionSqrtDimensionBall n))
        (fun i x ↦ x i) ≤ ENNReal.ofReal C

end NumStability.HDP.Contract
