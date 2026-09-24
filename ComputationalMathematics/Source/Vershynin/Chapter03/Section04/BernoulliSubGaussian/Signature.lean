import ComputationalMathematics.HDP.Vector.BernoulliSubGaussian

/-! Frozen proof-free signature for the Section 3.4.1 Bernoulli example. -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_4_bernoulli_subgaussian__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian
        (NumStability.HDP.Vector.Bernoulli.discreteCubeMeasure n)
        (fun i x ↦ x i) ∧
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.Bernoulli.discreteCubeMeasure n)
        (fun i x ↦ x i) ≤ ENNReal.ofReal C

end NumStability.HDP.Contract
