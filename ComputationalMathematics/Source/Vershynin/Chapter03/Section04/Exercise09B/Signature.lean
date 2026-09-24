import ComputationalMathematics.HDP.Vector.L1BallSubGaussian

/-! Frozen proof-free signature for Exercise 3.4.9(b). -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_9b__contract_type : Prop :=
  ∀ C : ℝ, 0 < C → ∃ n : ℕ, 0 < n ∧
    ENNReal.ofReal C <
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.L1Ball.uniformMeasure n
          (NumStability.HDP.Vector.L1Ball.isotropicRadius n))
        (fun i (x : Fin n → ℝ) ↦ x i)

end NumStability.HDP.Contract
