/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Coordinates
import Mathlib.Analysis.Complex.Order
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.LinearAlgebra.Matrix.PosDef

/-!
# Positive-definite matrices of Hermitian operators

In every supplied finite orthonormal basis, the matrix of a Hermitian operator
is positive definite exactly when its real quadratic form is strictly positive
on nonzero vectors. Empty bases and the zero-dimensional space are included.
-/

set_option autoImplicit false
open scoped ComplexOrder

namespace NumStability

variable {H ι : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [FiniteDimensional ℂ H] [Fintype ι] [DecidableEq ι]

/-- Strict positivity of a Hermitian operator's real quadratic form is
equivalent to positive definiteness of its matrix in any supplied finite ONB. -/
theorem posDef_toMatrix_iff_re_inner_pos (b : OrthonormalBasis ι ℂ H)
    (A : H →ₗ[ℂ] H) (hA : A = LinearMap.adjoint A) :
    (LinearMap.toMatrix b.toBasis b.toBasis A).PosDef ↔
      ∀ x : H, x ≠ 0 → 0 < (inner ℂ x (A x)).re := by
  have hSym : A.IsSymmetric := (LinearMap.eq_adjoint_iff A A).mp hA
  have hM : (LinearMap.toMatrix b.toBasis b.toBasis A).IsHermitian := by
    change (LinearMap.toMatrix b.toBasis b.toBasis A).conjTranspose =
      LinearMap.toMatrix b.toBasis b.toBasis A
    rw [← LinearMap.toMatrix_adjoint, ← hA]
  have hquad (x : H) : (0 : ℂ) < inner ℂ x (A x) ↔
      0 < (inner ℂ x (A x)).re := by
    rw [← hSym.coe_re_inner_self_apply x]
    exact Complex.real_lt_real
  rw [Matrix.posDef_iff_dotProduct_mulVec]
  constructor
  · rintro ⟨_, hpos⟩ x hx
    have hc : b.toBasis.equivFun x ≠ 0 := by
      intro hz
      apply hx
      apply b.toBasis.equivFun.injective
      simpa using hz
    have hp := hpos hc
    rw [star_dotProduct_toMatrix_mulVec_eq_inner] at hp
    exact (hquad x).mp hp
  · intro hpos
    refine ⟨hM, ?_⟩
    intro z hz
    have hx : b.toBasis.equivFun.symm z ≠ 0 := by
      intro hx
      apply hz
      have h := congrArg b.toBasis.equivFun hx
      simpa using h
    have hp := (hquad (b.toBasis.equivFun.symm z)).mpr (hpos _ hx)
    rw [← star_dotProduct_toMatrix_mulVec_eq_inner b A (b.toBasis.equivFun.symm z)] at hp
    simpa only [LinearEquiv.apply_symm_apply] using hp

end NumStability
