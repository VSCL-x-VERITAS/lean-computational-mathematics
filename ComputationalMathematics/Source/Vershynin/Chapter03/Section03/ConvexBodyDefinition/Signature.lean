import ComputationalMathematics.HDP.Convex.Body

/-! Frozen signature for the convex-body definition in Section 3.3.5. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_convex_body_def__contract_type : Prop :=
  ∀ (n : ℕ) (K : Set (Fin n → ℝ)),
    NumStability.HDP.Convex.IsConvexBody K ↔
      Convex ℝ K ∧ Bornology.IsBounded K ∧ (interior K).Nonempty

end NumStability.HDP.Contract
