import ComputationalMathematics.HDP.Optimization.GrothendieckBounds

/-! Frozen proof-free signature for display (3.12). -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

set_option linter.style.nameCheck false in
def hdp_03_eq_3_12__contract_type : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ),
    (∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1) →
      ∀ x y, bilinearValue A x y ≤ ‖x‖ * ‖y‖

end NumStability.HDP.Contract
