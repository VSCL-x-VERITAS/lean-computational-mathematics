import ComputationalMathematics.HDP.Optimization.GrothendieckBipartiteSDP

/-! Frozen proof-free signature for Exercise 3.5.7. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

set_option linter.style.nameCheck false in
def hdp_03_hex_h3_d5_d7__contract_type : Prop :=
  ∀ {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ),
    (∀ (k : ℕ) (X : Fin m → EuclideanSpace ℝ (Fin k))
        (Y : Fin n → EuclideanSpace ℝ (Fin k)),
      (∀ i, ‖X i‖ = 1) → (∀ j, ‖Y j‖ = 1) →
        ∃ M : Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ,
          IsCorrelationMatrixOn M ∧
            bipartiteUnitGram X Y = M ∧
              bipartiteSemidefiniteValue A M = innerBilinearValue A X Y) ∧
    (∀ M : Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ,
      IsCorrelationMatrixOn M →
        ∃ X : Fin m → EuclideanSpace ℝ (Sum (Fin m) (Fin n)),
          ∃ Y : Fin n → EuclideanSpace ℝ (Sum (Fin m) (Fin n)),
            (∀ i, ‖X i‖ = 1) ∧ (∀ j, ‖Y j‖ = 1) ∧
              bipartiteUnitGram X Y = M ∧
                bipartiteSemidefiniteValue A M = innerBilinearValue A X Y)

end NumStability.HDP.Contract
