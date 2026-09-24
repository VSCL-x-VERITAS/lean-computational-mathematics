import Mathlib.LinearAlgebra.Matrix.PosDef

/-!
# Finite semidefinite programs

This file packages a linear objective, finitely many affine equality
constraints, and positive-semidefinite feasibility for real square matrices.
-/

namespace NumStability.HDP.Optimization

open scoped BigOperators

/-- The Frobenius inner product of two finite real matrices. -/
def matrixInner {n : ℕ} (A X : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  ∑ i, ∑ j, A i j * X i j

/-- Data of a finite real semidefinite program with equality constraints. -/
structure SemidefiniteProgram (n m : ℕ) where
  objective : Matrix (Fin n) (Fin n) ℝ
  constraint : Fin m → Matrix (Fin n) (Fin n) ℝ
  target : Fin m → ℝ

namespace SemidefiniteProgram

/-- A matrix is feasible when it is positive semidefinite and satisfies every
affine equality constraint. -/
def Feasible {n m : ℕ} (P : SemidefiniteProgram n m)
    (X : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  X.PosSemidef ∧ ∀ i, matrixInner (P.constraint i) X = P.target i

/-- The value of the program's linear objective at a matrix. -/
def value {n m : ℕ} (P : SemidefiniteProgram n m)
    (X : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  matrixInner P.objective X

/-- A feasible matrix is optimal for the maximization problem when it
dominates the objective value of every feasible matrix. -/
def IsMaximizer {n m : ℕ} (P : SemidefiniteProgram n m)
    (X : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  P.Feasible X ∧ ∀ Y, P.Feasible Y → P.value Y ≤ P.value X

/-- A feasible matrix is optimal for the corresponding minimization problem. -/
def IsMinimizer {n m : ℕ} (P : SemidefiniteProgram n m)
    (X : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  P.Feasible X ∧ ∀ Y, P.Feasible Y → P.value X ≤ P.value Y

/-- Replace the objective by its negative, leaving the feasible set unchanged. -/
def negateObjective {n m : ℕ} (P : SemidefiniteProgram n m) :
    SemidefiniteProgram n m where
  objective := -P.objective
  constraint := P.constraint
  target := P.target

@[simp] theorem negateObjective_feasible_iff {n m : ℕ}
    (P : SemidefiniteProgram n m) (X : Matrix (Fin n) (Fin n) ℝ) :
    P.negateObjective.Feasible X ↔ P.Feasible X :=
  Iff.rfl

@[simp] theorem negateObjective_value {n m : ℕ}
    (P : SemidefiniteProgram n m) (X : Matrix (Fin n) (Fin n) ℝ) :
    P.negateObjective.value X = -P.value X := by
  simp [negateObjective, value, matrixInner]

theorem isMaximizer_negateObjective_iff_isMinimizer {n m : ℕ}
    (P : SemidefiniteProgram n m) (X : Matrix (Fin n) (Fin n) ℝ) :
    P.negateObjective.IsMaximizer X ↔ P.IsMinimizer X := by
  constructor
  · rintro ⟨hX, hmax⟩
    refine ⟨hX, fun Y hY ↦ ?_⟩
    have h := hmax Y hY
    simpa using (neg_le_neg h)
  · rintro ⟨hX, hmin⟩
    refine ⟨hX, fun Y hY ↦ ?_⟩
    simpa using (neg_le_neg (hmin Y hY))

end SemidefiniteProgram

end NumStability.HDP.Optimization
