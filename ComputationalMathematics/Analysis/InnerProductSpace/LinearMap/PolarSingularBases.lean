/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Polar

/-!
# Singular bases from supplied polar factors

A supplied full unitary-times-positive factorization determines singular
bases whose left basis is the image of the right basis under that very unitary.
The right basis diagonalizes the positive factor with the prescribed intrinsic
singular-value tuple, including its zero entries and multiplicities.

The construction uses the existing identification of the positive factor with
the fixed absolute value, its spectral basis, and an orthonormal-basis map.
It does not normalize images of zero singular vectors or choose a new polar
unitary. Singular operators and the zero-dimensional space are included.
-/

set_option autoImplicit false

namespace NumStability

/-- A supplied polar factorization gives full singular bases, retaining the
supplied unitary as the exact map from right basis to left basis. -/
theorem exists_singular_bases_of_unitary_positive_factorization
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A U P : H →ₗ[ℂ] H)
    (hU : U ∈ unitary (H →ₗ[ℂ] H)) (hP : P.IsPositive)
    (hA : A = U.comp P) :
    ∃ q w : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
      (∀ i, P (q i) = (linearMapSingularValue A i : ℂ) • q i) ∧
      (∀ i, w i = U (q i)) ∧
      ∀ i j, inner ℂ (w i) (A (q j)) =
        if i = j then (linearMapSingularValue A j : ℂ) else 0 := by
  classical
  have hPabs : P = linearMapAbs A :=
    (positive_polar_factor_eq_positiveSquareRoot A U P hU hP hA).trans
      (positiveSquareRoot_adjoint_comp_self A)
  let q : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H :=
    (linearMapAbs_isPositive A).isSymmetric.eigenvectorBasis rfl
  have heig (i : Fin (Module.finrank ℂ H)) :
      P (q i) = (linearMapSingularValue A i : ℂ) • q i := by
    rw [hPabs]
    exact (linearMapAbs_isPositive A).isSymmetric.apply_eigenvectorBasis rfl i
  have hUl : (LinearMap.adjoint U).comp U = LinearMap.id :=
    (Unitary.mem_iff.mp hU).1
  have hUr : U.comp (LinearMap.adjoint U) = LinearMap.id :=
    (Unitary.mem_iff.mp hU).2
  have hinner (x y : H) : inner ℂ (U x) (U y) = inner ℂ x y := by
    calc
      inner ℂ (U x) (U y) = inner ℂ x (U.adjoint (U y)) :=
        (LinearMap.adjoint_inner_right U x (U y)).symm
      _ = inner ℂ x y := congrArg (fun z => inner ℂ x z)
        (congrArg (fun T : H →ₗ[ℂ] H => T y) hUl)
  let e : H ≃ₗᵢ[ℂ] H := LinearIsometryEquiv.ofLinearIsometry
    (U.isometryOfInner hinner) U.adjoint hUr hUl
  refine ⟨q, q.map e, heig, ?_, ?_⟩
  · intro i
    rfl
  · intro i j
    change inner ℂ (U (q i)) (A (q j)) = _
    conv_lhs => rw [hA]
    rw [LinearMap.comp_apply, heig j, map_smul, inner_smul_right, hinner]
    rw [orthonormal_iff_ite.mp q.orthonormal i j]
    split_ifs <;> simp

end NumStability
