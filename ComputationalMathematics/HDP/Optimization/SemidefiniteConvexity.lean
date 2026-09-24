import ComputationalMathematics.HDP.Optimization.SemidefiniteProgram
import Mathlib.Analysis.Convex.Basic
import Mathlib.Data.Real.StarOrdered

/-!
# Convexity of finite semidefinite programs

The positive-semidefinite constraint and the affine equality constraints are
preserved by convex combinations, so every finite semidefinite program has a
convex feasible set.
-/

namespace NumStability.HDP.Optimization

open Set

theorem matrixInner_add {n : ℕ} (A X Y : Matrix (Fin n) (Fin n) ℝ) :
    matrixInner A (X + Y) = matrixInner A X + matrixInner A Y := by
  simp [matrixInner, mul_add, Finset.sum_add_distrib]

theorem matrixInner_smul {n : ℕ} (a : ℝ) (A X : Matrix (Fin n) (Fin n) ℝ) :
    matrixInner A (a • X) = a * matrixInner A X := by
  simp [matrixInner, Finset.mul_sum, mul_left_comm]

namespace SemidefiniteProgram

/-- The feasible matrices of a finite semidefinite program form a convex set. -/
theorem feasibleSet_convex {n m : ℕ} (P : SemidefiniteProgram n m) :
    Convex ℝ {X : Matrix (Fin n) (Fin n) ℝ | P.Feasible X} := by
  rw [convex_iff_add_mem]
  rintro X ⟨hXpsd, hXeq⟩ Y ⟨hYpsd, hYeq⟩ a b ha hb hab
  constructor
  · exact (hXpsd.smul ha).add (hYpsd.smul hb)
  · intro i
    rw [matrixInner_add, matrixInner_smul, matrixInner_smul, hXeq i, hYeq i]
    rw [← add_mul, hab, one_mul]

end SemidefiniteProgram

end NumStability.HDP.Optimization
