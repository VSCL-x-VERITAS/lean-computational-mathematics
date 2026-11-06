/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot

/-!
# Singular values from the positive square root of the Gram operator

The complete ordered eigenvalue tuple of the selected positive Gram square root
equals the intrinsic singular-value tuple. The equality retains multiplicities,
zero singular values, and the empty tuple in dimension zero. It lets downstream
proofs use either of these two constructions without choosing an eigenbasis or
adding a nonzero-dimension assumption.
-/

set_option autoImplicit false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- The full ordered Gram-root eigenvalue tuple is the singular-value tuple. -/
theorem positiveSquareRoot_adjoint_comp_self_eigenvalues (A : H →ₗ[ℂ] H) :
    (positiveSquareRoot_isPositive ((LinearMap.adjoint A).comp A)
      (LinearMap.isPositive_adjoint_comp_self A)).isSymmetric.eigenvalues rfl =
      linearMapSingularValue A := by
  let eig : { T : H →ₗ[ℂ] H // T.IsPositive } → Fin (Module.finrank ℂ H) → ℝ :=
    fun T => T.property.isSymmetric.eigenvalues rfl
  have hroot :
      (⟨positiveSquareRoot ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A),
        positiveSquareRoot_isPositive _ (LinearMap.isPositive_adjoint_comp_self A)⟩ :
          { T : H →ₗ[ℂ] H // T.IsPositive }) =
        ⟨linearMapAbs A, linearMapAbs_isPositive A⟩ :=
    Subtype.ext (positiveSquareRoot_adjoint_comp_self A)
  exact congrArg eig hroot

end NumStability
