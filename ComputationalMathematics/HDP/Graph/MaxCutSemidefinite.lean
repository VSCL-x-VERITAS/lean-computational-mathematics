import ComputationalMathematics.HDP.Optimization.VectorQuadratic
import Mathlib.Combinatorics.SimpleGraph.AdjMatrix

/-!
# The vector semidefinite relaxation of maximum cut

This file packages the objective in display (3.25) as a constant plus the
existing unit-vector quadratic objective.
-/

namespace NumStability.HDP.Graph

open scoped BigOperators InnerProductSpace

noncomputable section

/-- The maximum-cut relaxation objective at a family of unit vectors. -/
def maxCutSemidefiniteValue {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) : ℝ :=
  (1 / 4 : ℝ) * ∑ i, ∑ j,
    A i j * (1 - ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ)

/-- The constant part of the maximum-cut relaxation objective. -/
def maxCutSemidefiniteConstant {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  (1 / 4 : ℝ) * ∑ i, ∑ j, A i j

/-- The matrix whose unit-vector quadratic objective is the nonconstant part
of the maximum-cut relaxation. -/
def maxCutSemidefiniteMatrix {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  (-1 / 4 : ℝ) • A

theorem maxCutSemidefiniteValue_eq {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    maxCutSemidefiniteValue A X =
      maxCutSemidefiniteConstant A +
        NumStability.HDP.Optimization.vectorQuadraticValue
          (maxCutSemidefiniteMatrix A) X := by
  simp only [maxCutSemidefiniteValue, maxCutSemidefiniteConstant,
    maxCutSemidefiniteMatrix, NumStability.HDP.Optimization.vectorQuadraticValue,
    Matrix.smul_apply, smul_eq_mul, mul_sub, Finset.sum_sub_distrib]
  ring_nf
  congr 1
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  rw [Finset.sum_mul]

/-- The optimal value of the vector semidefinite relaxation. -/
noncomputable def maxCutSemidefiniteMaximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  maxCutSemidefiniteConstant A +
    NumStability.HDP.Optimization.vectorQuadraticMaximum
      (maxCutSemidefiniteMatrix A)

theorem maxCutSemidefiniteValue_le_maximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    maxCutSemidefiniteValue A X ≤ maxCutSemidefiniteMaximum A := by
  rw [maxCutSemidefiniteValue_eq, maxCutSemidefiniteMaximum]
  exact add_le_add_right
    (NumStability.HDP.Optimization.vectorQuadraticValue_le_maximum
      (maxCutSemidefiniteMatrix A) X) _

theorem exists_maxCutSemidefiniteValue_eq_maximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      maxCutSemidefiniteValue A X = maxCutSemidefiniteMaximum A := by
  obtain ⟨X, hX⟩ :=
    NumStability.HDP.Optimization.exists_vectorQuadraticValue_eq_maximum
      (maxCutSemidefiniteMatrix A)
  refine ⟨X, ?_⟩
  rw [maxCutSemidefiniteValue_eq, maxCutSemidefiniteMaximum, hX]

/-- The maximum-cut vector objective attains a greatest value for every finite
dimension, including the zero-vertex case.  The existing named maximum handles
positive dimensions; in dimension zero the unique empty family is optimal. -/
theorem exists_maxCutSemidefiniteValue_isGreatest {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      ∀ Y : NumStability.HDP.Optimization.UnitVectorFamily n,
        maxCutSemidefiniteValue A Y ≤ maxCutSemidefiniteValue A X := by
  cases n with
  | zero =>
      let X : NumStability.HDP.Optimization.UnitVectorFamily 0 :=
        fun i ↦ Fin.elim0 i
      refine ⟨X, ?_⟩
      intro Y
      simp [maxCutSemidefiniteValue]
  | succ n =>
      letI : Nonempty (Fin (n + 1)) := inferInstance
      obtain ⟨X, hX⟩ := exists_maxCutSemidefiniteValue_eq_maximum A
      refine ⟨X, fun Y ↦ ?_⟩
      rw [hX]
      exact maxCutSemidefiniteValue_le_maximum A Y

/-- A maximizing family for the maximum-cut vector relaxation in every finite
dimension. -/
noncomputable def maxCutSemidefiniteOptimizer {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) :
    NumStability.HDP.Optimization.UnitVectorFamily n :=
  Classical.choose (exists_maxCutSemidefiniteValue_isGreatest A)

/-- The optimal value of the maximum-cut vector relaxation, including for the
empty graph. -/
noncomputable def maxCutSemidefiniteOptimalValue {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  maxCutSemidefiniteValue A (maxCutSemidefiniteOptimizer A)

theorem maxCutSemidefiniteValue_le_optimalValue {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    maxCutSemidefiniteValue A X ≤ maxCutSemidefiniteOptimalValue A := by
  exact (Classical.choose_spec (exists_maxCutSemidefiniteValue_isGreatest A)) X

theorem exists_maxCutSemidefiniteValue_eq_optimalValue {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ X : NumStability.HDP.Optimization.UnitVectorFamily n,
      maxCutSemidefiniteValue A X = maxCutSemidefiniteOptimalValue A :=
  ⟨maxCutSemidefiniteOptimizer A, rfl⟩

end

end NumStability.HDP.Graph
