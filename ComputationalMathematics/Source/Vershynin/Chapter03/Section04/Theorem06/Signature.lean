import ComputationalMathematics.HDP.Vector.SphericalSubGaussian

/-! Frozen proof-free signature for Theorem 3.4.6. -/

noncomputable section

open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_thm_3_4_6__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian
        (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
        (fun i x ↦ x i) ∧
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
        (fun i x ↦ x i) ≤ ENNReal.ofReal C

end NumStability.HDP.Contract
