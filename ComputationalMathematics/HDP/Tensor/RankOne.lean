import ComputationalMathematics.HDP.Tensor.Finite
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Data.Matrix.Basic

/-!
# Rank-one finite tensors

Tensor powers and their order-two matrix realization.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Tensor

/-- The outer product of two finite real vectors. -/
def outer {m n : ℕ} (u : Fin m → ℝ) (v : Fin n → ℝ) :
    Matrix (Fin m) (Fin n) ℝ :=
  fun i j ↦ u i * v j

theorem power_apply {n : ℕ} (u : Fin n → ℝ) (k : ℕ)
    (i : Fin k → Fin n) :
    power u k i = ∏ j, u (i j) := rfl

/-- The order-two tensor power is the self outer product entrywise. -/
theorem power_two_apply {n : ℕ} (u : Fin n → ℝ)
    (i : Fin 2 → Fin n) :
    power u 2 i = outer u u (i 0) (i 1) := by
  simp [power, ofFactors, outer]

end NumStability.HDP.Tensor
