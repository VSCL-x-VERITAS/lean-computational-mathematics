import ComputationalMathematics.HDP.Graph.RandomizedRounding

/-! Frozen proof-free signature for display (3.26). -/

namespace NumStability.HDP.Contract

open scoped InnerProductSpace

set_option linter.style.nameCheck false in
def hdp_03_eq_3_26__contract_type : Prop :=
  ∀ {n : ℕ} (X : NumStability.HDP.Optimization.UnitVectorFamily n)
      (g : EuclideanSpace ℝ (Fin n)) (i : Fin n),
    ((NumStability.HDP.Graph.hyperplaneRounding X g i).value =
        (if ⟪(X i : EuclideanSpace ℝ (Fin n)), g⟫_ℝ < 0 then (-1 : ℝ) else 1)) ∧
      (⟪(X i : EuclideanSpace ℝ (Fin n)), g⟫_ℝ ≠ 0 →
        (NumStability.HDP.Graph.hyperplaneRounding X g i).value =
          Real.sign ⟪(X i : EuclideanSpace ℝ (Fin n)), g⟫_ℝ)

end NumStability.HDP.Contract
