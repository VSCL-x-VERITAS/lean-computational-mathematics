import ComputationalMathematics.HDP.Optimization.SemidefiniteConvexity

/-! Frozen proof-free signature for the convexity discussion after Definition 3.5.4. -/

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_5_sdp_convex__contract_type : Prop :=
  ∀ {n m : ℕ} (P : NumStability.HDP.Optimization.SemidefiniteProgram n m),
    Convex ℝ {X : Matrix (Fin n) (Fin n) ℝ | P.Feasible X} ∧
      (∀ X Y, P.value (X + Y) = P.value X + P.value Y) ∧
      ∀ (a : ℝ) X, P.value (a • X) = a * P.value X

end NumStability.HDP.Contract
