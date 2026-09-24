import ComputationalMathematics.HDP.Optimization.GrothendieckBounds

/-! Frozen proof-free signature for Exercise 3.5.2(a). -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d5_d2a__contract_type : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ),
    (∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1) ↔
      ∀ x y, bilinearValue A x y ≤ ‖x‖ * ‖y‖

end NumStability.HDP.Contract
