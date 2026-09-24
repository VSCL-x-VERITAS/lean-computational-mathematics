import ComputationalMathematics.HDP.Kernel.PositiveSemidefinite

/-! Frozen proof-free signature for the Section 3.7.1 positive-semidefinite
kernel definition. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_7_psd_kernel_def__contract_type : Prop :=
  ∀ {X : Type} (K : X → X → ℝ),
    NumStability.HDP.Kernel.IsPositiveSemidefinite K ↔
      ∀ (N : ℕ) (u : Fin N → X),
        Matrix.PosSemidef (fun i j ↦ K (u i) (u j))

end NumStability.HDP.Contract
