import ComputationalMathematics.HDP.Optimization.GrothendieckRelaxationGuarantee

/-! Frozen proof-free signature for Theorem 3.5.6. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

set_option linter.style.nameCheck false in
def hdp_03_thm_3_5_6__contract_type : Prop :=
  ∀ (K : ℝ), IsGrothendieckConstant.{0} K →
    ∀ {n : ℕ} [Nonempty (Fin n)] (A : Matrix (Fin n) (Fin n) ℝ),
      A.IsSymm → A.PosSemidef →
        signQuadraticMaximum A ≤ vectorQuadraticMaximum A ∧
          vectorQuadraticMaximum A ≤ 2 * K * signQuadraticMaximum A

end NumStability.HDP.Contract
