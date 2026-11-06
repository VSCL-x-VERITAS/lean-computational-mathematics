/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Decomposition
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Diagonal
import Mathlib.LinearAlgebra.Matrix.Block

/-!
# Upper-triangular factors of complex Gram matrices

Every complex square matrix has the same Gram matrix as an upper-triangular
matrix with nonnegative real diagonal. Completed Gram–Schmidt supplies the
factor even when the columns are dependent: a zero residual gives a zero
diagonal coefficient. Empty matrices are included.
-/

set_option autoImplicit false
open scoped Matrix

namespace NumStability

/-- Every complex Gram matrix admits an upper-triangular Gram factor whose
diagonal entries are embedded nonnegative reals, including singular and empty
matrices. -/
theorem exists_upperTriangular_gram_factor {n : ℕ}
    (B : Matrix (Fin n) (Fin n) ℂ) :
    ∃ R : Matrix (Fin n) (Fin n) ℂ,
      R.BlockTriangular id ∧
        (∀ i, ∃ d : ℝ, 0 ≤ d ∧ R i i = (d : ℂ)) ∧
        Rᴴ * R = Bᴴ * B := by
  classical
  let f : Fin n → EuclideanSpace ℂ (Fin n) := fun j => WithLp.toLp 2 (fun i => B i j)
  have hdim : Module.finrank ℂ (EuclideanSpace ℂ (Fin n)) = Fintype.card (Fin n) :=
    finrank_euclideanSpace
  let e := EuclideanSpace.basisFun (Fin n) ℂ
  let b := InnerProductSpace.gramSchmidtOrthonormalBasis hdim f
  let R := b.toBasis.toMatrix f
  let U := e.toBasis.toMatrix b
  have hR (i j : Fin n) : R i j = inner ℂ (b i) (f j) := by
    simp only [R, Module.Basis.toMatrix_apply, b.coe_toBasis_repr_apply,
      b.repr_apply_apply]
  have hUR : U * R = B := by
    calc
      U * R = e.toBasis.toMatrix f := e.toBasis.toMatrix_mul_toMatrix b.toBasis f
      _ = B := by
        ext i j
        simp [Module.Basis.toMatrix_apply, e, f,
          OrthonormalBasis.coe_toBasis_repr_apply]
  have hU : Uᴴ * U = 1 := e.toMatrix_orthonormalBasis_conjTranspose_mul_self b
  refine ⟨R, ?_, ?_, ?_⟩
  · intro i j hij
    rw [hR]
    exact (gramSchmidtNormed_decomposition hdim f).1 i j hij
  · intro i
    refine ⟨‖InnerProductSpace.gramSchmidt ℂ f i‖, norm_nonneg _, ?_⟩
    rw [hR]
    exact inner_gramSchmidtOrthonormalBasis_input hdim f i
  · calc
      Rᴴ * R = (U * R)ᴴ * (U * R) := by
        rw [Matrix.conjTranspose_mul]
        calc
          Rᴴ * R = Rᴴ * (Uᴴ * U) * R := by rw [hU, Matrix.mul_one]
          _ = Rᴴ * Uᴴ * (U * R) := by simp only [Matrix.mul_assoc]
      _ = Bᴴ * B := by rw [hUR]

end NumStability
