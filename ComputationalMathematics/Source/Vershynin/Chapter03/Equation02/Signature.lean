import Mathlib.Data.Real.Basic

/-! Frozen proof-free signature for Equation (3.2). -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_heq_h3_d2__contract_type : Prop :=
  ∀ {z δ : ℝ},
    0 ≤ z →
      0 ≤ δ →
        δ ≤ |z - 1| →
          max δ (δ ^ 2) ≤ |z ^ 2 - 1|

end NumStability.HDP.Contract
