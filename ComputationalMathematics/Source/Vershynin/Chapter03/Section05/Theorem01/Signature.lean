import ComputationalMathematics.HDP.Optimization.GrothendieckKrivine

/-! Frozen proof-free signature for Theorem 3.5.1 (Grothendieck's
inequality). -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

set_option linter.style.nameCheck false in
def hdp_03_thm_3_5_1__contract_type : Prop :=
  ∃ K : ℝ, K ≤ (1783 : ℝ) / 1000 ∧
    ∀ (m n : ℕ) (A : Matrix (Fin (m + 1)) (Fin (n + 1)) ℝ),
      (∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1) →
        UniversalUnitBound.{u} A K

end NumStability.HDP.Contract
