/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.OrthogonalCompletion
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.SingularValueRank

/-!
# Singular bases of finite-dimensional operators

Every endomorphism of a finite-dimensional complex inner-product space has
full right and left orthonormal bases in which its coefficients are the
prescribed singular values on the diagonal and zero off the diagonal.
The singular values are the eigenvalues of the fixed positive absolute value,
including every zero and multiplicity in the dimension-length tuple.

The right basis is a spectral basis of the absolute value. Its images under
the operator are orthogonal, and completing those images provides the left
basis, including the zero singular-value positions. No invertibility,
normality, or positive-dimension hypothesis is needed.
-/

set_option autoImplicit false

namespace NumStability

/-- Full singular bases for the prescribed intrinsic singular-value tuple,
including the zero slots. No singular bases or transport identities are
supplied as premises. -/
theorem exists_orthonormalBases_inner_eq_singularValue
    {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H) :
    ∃ q w : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
      ∀ i j : Fin (Module.finrank ℂ H),
        inner ℂ (w i) (A (q j)) =
          if i = j then (linearMapSingularValue A j : ℂ) else 0 := by
  classical
  let q : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H :=
    (linearMapAbs_isPositive A).isSymmetric.eigenvectorBasis rfl
  have heig (j : Fin (Module.finrank ℂ H)) :
      linearMapAbs A (q j) = (linearMapSingularValue A j : ℂ) • q j :=
    (linearMapAbs_isPositive A).isSymmetric.apply_eigenvectorBasis rfl j
  have hGram (j : Fin (Module.finrank ℂ H)) :
      LinearMap.adjoint A (A (q j)) =
        (linearMapSingularValue A j : ℂ) ^ 2 • q j := by
    calc
      LinearMap.adjoint A (A (q j)) = linearMapAbs A (linearMapAbs A (q j)) :=
        (congrArg (fun T : H →ₗ[ℂ] H => T (q j)) (linearMapAbs_comp_self A)).symm
      _ = (linearMapSingularValue A j : ℂ) ^ 2 • q j := by
        rw [heig, map_smul, heig, smul_smul, pow_two]
  let f : Fin (Module.finrank ℂ H) → H := fun j => A (q j)
  have hf : Pairwise fun i j => inner ℂ (f i) (f j) = 0 := by
    intro i j hij
    change inner ℂ (A (q i)) (A (q j)) = 0
    calc
      inner ℂ (A (q i)) (A (q j)) =
          inner ℂ (q i) (LinearMap.adjoint A (A (q j))) :=
        (LinearMap.adjoint_inner_right A (q i) (A (q j))).symm
      _ = (linearMapSingularValue A j : ℂ) ^ 2 * inner ℂ (q i) (q j) := by
        rw [hGram, inner_smul_right]
      _ = 0 := by rw [q.orthonormal.2 hij, mul_zero]
  have hnorm (j : Fin (Module.finrank ℂ H)) : ‖f j‖ = linearMapSingularValue A j := by
    change ‖A (q j)‖ = linearMapSingularValue A j
    rw [← norm_linearMapAbs_apply A (q j), heig, norm_smul,
      q.norm_eq_one, mul_one, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (linearMapSingularValue_nonneg A j)]
  obtain ⟨w, hw⟩ := exists_orthonormalBasis_inner_eq_norm_of_orthogonal rfl f hf
  refine ⟨q, w, ?_⟩
  intro i j
  simpa only [hnorm j] using hw i j

end NumStability
