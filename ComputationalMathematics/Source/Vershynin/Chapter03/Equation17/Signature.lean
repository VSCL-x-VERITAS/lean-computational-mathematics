import ComputationalMathematics.HDP.Optimization.GrothendieckSymmetric

/-! Frozen proof-free signature for display (3.17). -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

set_option linter.style.nameCheck false in
def hdp_03_eq_3_17__contract_type : Prop :=
  ∀ (K : ℝ), IsGrothendieckConstant.{u} K →
    ∀ {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ),
      A.IsSymm →
        (A.PosSemidef ∨ ∀ i, A i i = 0) →
          (∀ x, IsSignVector x → |bilinearValue A x x| ≤ 1) →
            ∀ (E : Type u) [NormedAddCommGroup E] [InnerProductSpace ℝ E],
              ∀ (x y : Fin n → E),
                (∀ i, ‖x i‖ = 1) → (∀ j, ‖y j‖ = 1) →
                  |innerBilinearValue A x y| ≤ 2 * K

end NumStability.HDP.Contract
