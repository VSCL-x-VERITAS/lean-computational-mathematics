import Mathlib.LinearAlgebra.BilinearForm.Properties
import Mathlib.LinearAlgebra.Matrix.BilinearForm
import Mathlib.Data.Real.Basic

/-!
# Finite real frames

This module defines frame bounds and tight frames for finite families of real
coordinate vectors. It characterizes the exact Parseval identity by the sum of
the family's rank-one matrices.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Vector.Frame

/-- A finite real family has lower and upper frame bounds `A` and `B` when the
bounds are positive and its squared analysis coefficients satisfy the
corresponding approximate Parseval inequalities. -/
def IsFrameWithBounds {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (A B : ℝ) : Prop :=
  0 < A ∧ 0 < B ∧ ∀ x : Fin n → ℝ,
    A * ∑ j, (x j) ^ 2 ≤ ∑ i, (u i ⬝ᵥ x) ^ 2 ∧
      ∑ i, (u i ⬝ᵥ x) ^ 2 ≤ B * ∑ j, (x j) ^ 2

/-- A finite real family is a frame when it admits positive lower and upper
frame bounds. -/
def IsFrame {N n : ℕ} (u : Fin N → Fin n → ℝ) : Prop :=
  ∃ A B : ℝ, IsFrameWithBounds u A B

/-- The exact Parseval identity for a finite real family with bound `A`. -/
def HasTightFrameIdentity {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (A : ℝ) : Prop :=
  ∀ x : Fin n → ℝ, ∑ i, (u i ⬝ᵥ x) ^ 2 = A * ∑ j, (x j) ^ 2

/-- A finite real tight frame: a positive frame bound together with the exact
Parseval identity. -/
def IsTightFrame {N n : ℕ} (u : Fin N → Fin n → ℝ) (A : ℝ) : Prop :=
  0 < A ∧ HasTightFrameIdentity u A

theorem isTightFrame_iff_isFrameWithBounds_same {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (A : ℝ) :
    IsTightFrame u A ↔ IsFrameWithBounds u A A := by
  constructor
  · rintro ⟨hA, hExact⟩
    refine ⟨hA, hA, fun x => ?_⟩
    rw [hExact x]
    exact ⟨le_rfl, le_rfl⟩
  · rintro ⟨hA, _hA', hBounds⟩
    refine ⟨hA, fun x => ?_⟩
    exact le_antisymm (hBounds x).2 (hBounds x).1

private theorem toBilin'_isSymm_of_matrix_isSymm
    {n : ℕ} {M : Matrix (Fin n) (Fin n) ℝ} (hM : M.IsSymm) :
    (Matrix.toBilin' M).IsSymm := by
  constructor
  intro x y
  rw [Matrix.toBilin'_apply, Matrix.toBilin'_apply]
  calc
    (∑ i, ∑ j, x i * M i j * y j) =
        ∑ j, ∑ i, x i * M i j * y j := Finset.sum_comm
    _ = ∑ j, ∑ i, y j * M j i * x i := by
      apply Finset.sum_congr rfl
      intro j _
      apply Finset.sum_congr rfl
      intro i _
      rw [← hM.apply i j]
      ring
    _ = ∑ i, ∑ j, y i * M i j * x j := rfl

private theorem sum_vecMulVec_isSymm {N n : ℕ} (u : Fin N → Fin n → ℝ) :
    (∑ i, Matrix.vecMulVec (u i) (u i)).IsSymm := by
  rw [Matrix.IsSymm]
  ext j k
  rw [Matrix.transpose_apply]
  simp only [Matrix.sum_apply, Matrix.vecMulVec_apply]
  apply Finset.sum_congr rfl
  intro i _
  ring

private theorem dotProduct_sum_vecMulVec_mulVec {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (x : Fin n → ℝ) :
    x ⬝ᵥ Matrix.mulVec (∑ i, Matrix.vecMulVec (u i) (u i)) x =
      ∑ i, (u i ⬝ᵥ x) ^ 2 := by
  rw [Matrix.sum_mulVec, dotProduct_sum]
  apply Finset.sum_congr rfl
  intro i _
  rw [Matrix.vecMulVec_mulVec, dotProduct_smul, dotProduct_comm]
  rw [MulOpposite.smul_eq_mul_unop, MulOpposite.unop_op]
  rw [dotProduct_comm]
  ring

private theorem dotProduct_smul_one_mulVec {n : ℕ} (A : ℝ) (x : Fin n → ℝ) :
    x ⬝ᵥ Matrix.mulVec (A • (1 : Matrix (Fin n) (Fin n) ℝ)) x =
      A * ∑ j, (x j) ^ 2 := by
  rw [Matrix.smul_mulVec, Matrix.one_mulVec, dotProduct_smul]
  simp only [smul_eq_mul, dotProduct, pow_two]

/-- Exact Parseval equality is equivalent to the rank-one matrix identity. -/
theorem hasTightFrameIdentity_iff_sum_vecMulVec {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (A : ℝ) :
    HasTightFrameIdentity u A ↔
      ∑ i, Matrix.vecMulVec (u i) (u i) =
        A • (1 : Matrix (Fin n) (Fin n) ℝ) := by
  let S : Matrix (Fin n) (Fin n) ℝ := ∑ i, Matrix.vecMulVec (u i) (u i)
  let T : Matrix (Fin n) (Fin n) ℝ := A • 1
  constructor
  · intro h
    have hdiag : ∀ x : Fin n → ℝ,
        Matrix.toBilin' S x x = Matrix.toBilin' T x x := by
      intro x
      rw [Matrix.toBilin'_apply', Matrix.toBilin'_apply']
      rw [show S = ∑ i, Matrix.vecMulVec (u i) (u i) from rfl,
        dotProduct_sum_vecMulVec_mulVec]
      rw [show T = A • (1 : Matrix (Fin n) (Fin n) ℝ) from rfl,
        dotProduct_smul_one_mulVec]
      exact h x
    have hS : S.IsSymm := by
      change (∑ i, Matrix.vecMulVec (u i) (u i)).IsSymm
      exact sum_vecMulVec_isSymm u
    have hT : T.IsSymm := by
      change (A • (1 : Matrix (Fin n) (Fin n) ℝ)).IsSymm
      exact Matrix.isSymm_one.smul A
    have hforms : Matrix.toBilin' S = Matrix.toBilin' T :=
      LinearMap.BilinForm.ext_of_isSymm
        (toBilin'_isSymm_of_matrix_isSymm hS)
        (toBilin'_isSymm_of_matrix_isSymm hT) hdiag
    exact Matrix.toBilin'.injective hforms
  · intro hM x
    rw [← dotProduct_sum_vecMulVec_mulVec u x, hM,
      dotProduct_smul_one_mulVec]

/-- A tight frame is equivalently a positive bound together with the rank-one
matrix identity. -/
theorem isTightFrame_iff_pos_and_sum_vecMulVec {N n : ℕ}
    (u : Fin N → Fin n → ℝ) (A : ℝ) :
    IsTightFrame u A ↔
      0 < A ∧
        ∑ i, Matrix.vecMulVec (u i) (u i) =
          A • (1 : Matrix (Fin n) (Fin n) ℝ) := by
  simp only [IsTightFrame, hasTightFrameIdentity_iff_sum_vecMulVec]

/-- With positivity supplied, the tight-frame predicate is equivalent to the
matrix identity. -/
theorem isTightFrame_iff_sum_vecMulVec {N n : ℕ}
    (u : Fin N → Fin n → ℝ) {A : ℝ} (hA : 0 < A) :
    IsTightFrame u A ↔
      ∑ i, Matrix.vecMulVec (u i) (u i) =
        A • (1 : Matrix (Fin n) (Fin n) ℝ) := by
  rw [isTightFrame_iff_pos_and_sum_vecMulVec]
  simp [hA]

end NumStability.HDP.Vector.Frame
