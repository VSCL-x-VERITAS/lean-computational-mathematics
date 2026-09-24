import ComputationalMathematics.HDP.Optimization.SignQuadratic
import ComputationalMathematics.HDP.Optimization.VectorQuadratic
import Mathlib.Data.Real.Sign

/-!
# Hyperplane rounding labels

This file defines the deterministic labeling obtained after a hyperplane normal
has been sampled. Zero inner products receive the positive label; for a
nondegenerate Gaussian sample that tie has probability zero.
-/

namespace NumStability.HDP.Graph

open scoped InnerProductSpace

noncomputable section

/-- The two-valued sign used for hyperplane rounding, with zero assigned to the
positive side. -/
def hyperplaneSign {n : ℕ} (u g : EuclideanSpace ℝ (Fin n)) :
    NumStability.HDP.Optimization.Sign :=
  if ⟪u, g⟫_ℝ < 0 then .neg else .pos

@[simp] theorem hyperplaneSign_value {n : ℕ}
    (u g : EuclideanSpace ℝ (Fin n)) :
    (hyperplaneSign u g).value = if ⟪u, g⟫_ℝ < 0 then -1 else 1 := by
  unfold hyperplaneSign
  split <;> rfl

theorem hyperplaneSign_value_eq_real_sign {n : ℕ}
    (u g : EuclideanSpace ℝ (Fin n)) (h : ⟪u, g⟫_ℝ ≠ 0) :
    (hyperplaneSign u g).value = Real.sign ⟪u, g⟫_ℝ := by
  by_cases hneg : ⟪u, g⟫_ℝ < 0
  · simp [hyperplaneSign, hneg, Real.sign_of_neg hneg]
  · have hpos : 0 < ⟪u, g⟫_ℝ := lt_of_le_of_ne (le_of_not_gt hneg) (Ne.symm h)
    simp [hyperplaneSign, hneg, Real.sign_of_pos hpos]

/-- Label every vector by the side of the hyperplane normal to `g` on which it
lies. -/
def hyperplaneRounding {n : ℕ}
    (X : NumStability.HDP.Optimization.UnitVectorFamily n)
    (g : EuclideanSpace ℝ (Fin n)) :
    NumStability.HDP.Optimization.SignVector n :=
  fun i ↦ hyperplaneSign (X i) g

@[simp] theorem hyperplaneRounding_apply {n : ℕ}
    (X : NumStability.HDP.Optimization.UnitVectorFamily n)
    (g : EuclideanSpace ℝ (Fin n)) (i : Fin n) :
    hyperplaneRounding X g i = hyperplaneSign (X i) g :=
  rfl

end

end NumStability.HDP.Graph
