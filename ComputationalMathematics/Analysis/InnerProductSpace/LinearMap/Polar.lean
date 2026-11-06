/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.SingularBases
import Mathlib.Algebra.Star.Unitary
import Mathlib.Analysis.InnerProductSpace.Positive

/-!
# Polar factorizations of finite-dimensional operators

Every positive factor in a unitary-times-positive factorization is the fixed
positive square root of the Gram operator. Conversely, every endomorphism of
a finite-dimensional complex inner-product space admits a full unitary factor
with its prescribed absolute value on the right.

The unitary extension matches the existing full singular bases, including
zero singular-value positions. No invertibility, normality or positive-dimension
hypothesis is needed. These statements concern ordinary linear endomorphisms;
no source-specific result or coordinate correspondence is assumed.
-/

set_option autoImplicit false

open scoped ComplexOrder

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
variable [FiniteDimensional ℂ H]

/-- The positive factor of a unitary-times-positive factorization is the fixed
positive square root of the Gram operator. -/
theorem positive_polar_factor_eq_positiveSquareRoot
    (A U P : H →ₗ[ℂ] H) (hU : U ∈ unitary (H →ₗ[ℂ] H))
    (hP : P.IsPositive) (hA : A = U.comp P) :
    P = positiveSquareRoot ((LinearMap.adjoint A).comp A)
      (LinearMap.isPositive_adjoint_comp_self A) := by
  have hUt : (LinearMap.adjoint U).comp U = LinearMap.id :=
    (Unitary.mem_iff.mp hU).1
  have hsq : P.comp P = (LinearMap.adjoint A).comp A := by
    calc
      P.comp P = P.adjoint.comp ((U.adjoint.comp U).comp P) := by
        rw [hUt, hP.1.adjoint_eq, LinearMap.id_comp]
      _ = (U.comp P).adjoint.comp (U.comp P) := by
        rw [LinearMap.adjoint_comp]
        simp only [LinearMap.comp_assoc]
      _ = A.adjoint.comp A := by rw [← hA]
  exact positiveSquareRoot_unique _ (LinearMap.isPositive_adjoint_comp_self A) P hP hsq

/-- Every finite-dimensional operator has a full unitary factor multiplying
its prescribed absolute value, including singular operators and dimension zero. -/
theorem exists_unitary_comp_linearMapAbs (A : H →ₗ[ℂ] H) :
    ∃ U : H →ₗ[ℂ] H,
      U ∈ unitary (H →ₗ[ℂ] H) ∧ A = U.comp (linearMapAbs A) := by
  classical
  obtain ⟨q, w, hcoeff⟩ := exists_orthonormalBases_inner_eq_singularValue A
  let e := q.equiv w (Equiv.refl _)
  let U : H →ₗ[ℂ] H := e.toLinearMap
  let P : H →ₗ[ℂ] H := e.symm.toLinearMap.comp A
  have hU : U ∈ unitary (H →ₗ[ℂ] H) := by
    rw [Unitary.mem_iff]
    constructor
    · change (LinearMap.adjoint e.toLinearMap).comp e.toLinearMap = LinearMap.id
      rw [LinearIsometryEquiv.adjoint_toLinearMap_eq_symm]
      ext x
      exact e.symm_apply_apply x
    · change e.toLinearMap.comp (LinearMap.adjoint e.toLinearMap) = LinearMap.id
      rw [LinearIsometryEquiv.adjoint_toLinearMap_eq_symm]
      ext x
      exact e.apply_symm_apply x
  have hmat : LinearMap.toMatrix q.toBasis q.toBasis P =
      Matrix.diagonal (fun j => (linearMapSingularValue A j : ℂ)) := by
    ext i j
    rw [LinearMap.toMatrix_apply, q.coe_toBasis_repr_apply, q.repr_apply_apply]
    change inner ℂ (q i) (e.symm (A (q j))) = _
    rw [← e.inner_map_eq_flip, OrthonormalBasis.equiv_apply_basis]
    by_cases hij : i = j
    · subst j
      simpa using hcoeff i i
    · simpa [hij] using hcoeff i j
  have hP : P.IsPositive := by
    apply (LinearMap.posSemidef_toMatrix_iff q).mp
    rw [hmat]
    exact Matrix.PosSemidef.diagonal fun j =>
      Complex.zero_le_real.mpr (linearMapSingularValue_nonneg A j)
  have hA : A = U.comp P := by
    ext x
    exact (e.apply_symm_apply (A x)).symm
  have hPabs : P = linearMapAbs A :=
    (positive_polar_factor_eq_positiveSquareRoot A U P hU hP hA).trans
      (positiveSquareRoot_adjoint_comp_self A)
  exact ⟨U, hU, hPabs ▸ hA⟩

end NumStability
