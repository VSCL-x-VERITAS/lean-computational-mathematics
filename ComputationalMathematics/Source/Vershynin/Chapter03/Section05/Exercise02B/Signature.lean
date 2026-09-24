import ComputationalMathematics.HDP.Optimization.GrothendieckHilbert

/-! Frozen proof-free signature for Exercise 3.5.2(b). -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d5_d2b__contract_type : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) (K : ℝ),
    0 ≤ K →
      (UniversalUnitBound.{u} A K ↔ UniversalPiNormBound.{u} A K)

end NumStability.HDP.Contract
