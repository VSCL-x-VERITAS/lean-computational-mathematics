/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.QR.Uniqueness
import Mathlib.Analysis.Complex.Order
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.PosDef

/-!
# Uniqueness of normalized triangular Gram factors

Upper-triangular complex matrices with nonnegative real diagonal are uniquely
determined by a positive-definite Gram matrix. Positive definiteness forces
their scalar determinants to be units and their diagonal entries to be strictly
positive. The remaining argument is uniqueness of positively normalized QR.

The empty matrix is included: its scalar determinant is one, even though the
empty matrix ring itself has zero equal to one.
-/

set_option autoImplicit false
open scoped BigOperators ComplexOrder Matrix

namespace NumStability

private theorem matrix_columns_orthonormal {n : ℕ} (U : Matrix (Fin n) (Fin n) ℂ)
    (hU : Uᴴ * U = 1) :
    Orthonormal ℂ (fun j => WithLp.toLp 2 (fun i => U i j)) := by
  apply orthonormal_iff_ite.mpr
  intro i j
  have h := congrArg (fun M : Matrix (Fin n) (Fin n) ℂ => M i j) hU
  simpa only [PiLp.inner_apply, PiLp.toLp_apply, RCLike.inner_apply',
    Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.one_apply] using h

private theorem matrix_column_mul {n : ℕ} (A B : Matrix (Fin n) (Fin n) ℂ)
    (j : Fin n) :
    WithLp.toLp 2 (fun i => (A * B) i j) =
      ∑ k, B k j • WithLp.toLp 2 (fun i => A i k) := by
  simp_rw [← WithLp.toLp_smul]
  rw [← WithLp.toLp_sum]
  apply congrArg (WithLp.toLp 2)
  ext i
  simp [Matrix.mul_apply, Finset.sum_apply, mul_comm]

private theorem strict_diagonal_of_unit_det {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ)
    (hM : M.BlockTriangular id)
    (hd : ∀ i, ∃ d : ℝ, 0 ≤ d ∧ M i i = (d : ℂ)) (hdet : IsUnit M.det) :
    ∀ i, ∃ d : ℝ, 0 < d ∧ M i i = (d : ℂ) := by
  intro i
  obtain ⟨d, hd, he⟩ := hd i
  have hprod : (∏ k, M k k) ≠ 0 := by
    rw [← Matrix.det_of_upperTriangular hM]
    exact hdet.ne_zero
  have hentry : M i i ≠ 0 := (Finset.prod_ne_zero_iff.mp hprod) i (Finset.mem_univ i)
  have hd0 : d ≠ 0 := by
    intro h
    apply hentry
    simpa only [h, Complex.ofReal_zero] using he
  exact ⟨d, lt_of_le_of_ne hd (Ne.symm hd0), he⟩

/-- A positive-definite Gram matrix has at most one upper-triangular factor
whose diagonal entries are embedded nonnegative real numbers. Invertibility
and strict diagonal positivity are consequences, including for the empty size.
-/
theorem upperTriangular_gram_unique_of_posDef {n : ℕ}
    (S T : Matrix (Fin n) (Fin n) ℂ)
    (hS : S.BlockTriangular id) (hT : T.BlockTriangular id)
    (hSd : ∀ i, ∃ d : ℝ, 0 ≤ d ∧ S i i = (d : ℂ))
    (hTd : ∀ i, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ))
    (hGram : Sᴴ * S = Tᴴ * T) (hPD : (Sᴴ * S).PosDef) : S = T := by
  classical
  have det_unit (M : Matrix (Fin n) (Fin n) ℂ) (hM : (Mᴴ * M).PosDef) :
      IsUnit M.det := by
    have h := (Matrix.isUnit_iff_isUnit_det _).mp hM.isUnit
    rw [Matrix.det_mul] at h
    exact isUnit_of_mul_isUnit_right h
  have hdetS := det_unit S hPD
  have hdetT := det_unit T (hGram ▸ hPD)
  have hSpos := strict_diagonal_of_unit_det S hS hSd hdetS
  have hTpos := strict_diagonal_of_unit_det T hT hTd hdetT
  let U : Matrix (Fin n) (Fin n) ℂ := S * T⁻¹
  have hUT : U * T = S := by
    dsimp [U]
    rw [Matrix.mul_assoc, Matrix.nonsing_inv_mul T hdetT, Matrix.mul_one]
  have hU : Uᴴ * U = 1 := by
    dsimp [U]
    calc
      (S * T⁻¹)ᴴ * (S * T⁻¹) = (T⁻¹)ᴴ * (Sᴴ * S) * T⁻¹ := by
        rw [Matrix.conjTranspose_mul]
        simp only [Matrix.mul_assoc]
      _ = (T⁻¹)ᴴ * (Tᴴ * T) * T⁻¹ := by rw [hGram]
      _ = (T * T⁻¹)ᴴ * (T * T⁻¹) := by
        rw [Matrix.conjTranspose_mul]
        simp only [Matrix.mul_assoc]
      _ = 1 := by rw [Matrix.mul_nonsing_inv T hdetT]; simp
  let X : Fin n → EuclideanSpace ℂ (Fin n) := fun j => WithLp.toLp 2 (fun i => S i j)
  let Q : Fin n → EuclideanSpace ℂ (Fin n) := fun j => WithLp.toLp 2 (fun i => U i j)
  let E : Fin n → EuclideanSpace ℂ (Fin n) := fun j =>
    WithLp.toLp 2 (fun i => (1 : Matrix (Fin n) (Fin n) ℂ) i j)
  have hQ : Orthonormal ℂ Q := matrix_columns_orthonormal U hU
  have hE : Orthonormal ℂ E := matrix_columns_orthonormal 1 (by simp)
  have hXT (j : Fin n) : X j = ∑ i, T i j • Q i := by
    change WithLp.toLp 2 (fun i => S i j) = _
    rw [← hUT]
    exact matrix_column_mul U T j
  have hXS (j : Fin n) : X j = ∑ i, S i j • E i := by
    simpa only [Matrix.one_mul] using matrix_column_mul 1 S j
  exact (qr_unique_of_pos_diagonal X Q E T S hQ hE hXT hXS
    (fun _ _ h => hT h) (fun _ _ h => hS h) hTpos hSpos).2.symm

end NumStability
