/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue

/-!
# Positive square roots of finite-dimensional operators

Every positive endomorphism of a finite-dimensional complex Hilbert space
has exactly one positive square root. Choosing that proved unique witness
gives a positive-square-root operation with positivity, squaring and
uniqueness laws. On a Gram operator it agrees with the existing intrinsic
absolute value.

Completeness is derived internally. The ambient space may have dimension zero.
-/

set_option autoImplicit false

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- A positive endomorphism has exactly one positive square root. The public
statement uses ordinary endomorphisms and composition. -/
theorem existsUnique_positiveSquareRoot (P : H →ₗ[ℂ] H) (hP : P.IsPositive) :
    ∃! Q : H →ₗ[ℂ] H, Q.IsPositive ∧ Q.comp Q = P := by
  letI := FiniteDimensional.complete ℂ H
  have hP' : 0 ≤ P.toContinuousLinearMap :=
    (ContinuousLinearMap.nonneg_iff_isPositive _).mpr
      ((LinearMap.isPositive_toContinuousLinearMap_iff P).mpr hP)
  refine ⟨(CFC.sqrt P.toContinuousLinearMap).toLinearMap, ?_, ?_⟩
  · constructor
    · exact ((ContinuousLinearMap.nonneg_iff_isPositive _).mp
        (CFC.sqrt_nonneg P.toContinuousLinearMap)).toLinearMap
    · exact congrArg ContinuousLinearMap.toLinearMap
        (CFC.sqrt_mul_sqrt_self P.toContinuousLinearMap hP')
  · intro Q hQ
    have hQ' : 0 ≤ Q.toContinuousLinearMap :=
      (ContinuousLinearMap.nonneg_iff_isPositive _).mpr
        ((LinearMap.isPositive_toContinuousLinearMap_iff Q).mpr hQ.1)
    have hsq' : Q.toContinuousLinearMap * Q.toContinuousLinearMap =
        P.toContinuousLinearMap :=
      congrArg (fun T : H →ₗ[ℂ] H => T.toContinuousLinearMap) hQ.2
    exact (congrArg ContinuousLinearMap.toLinearMap
      (CFC.sqrt_unique hsq' hQ')).symm

/-- The unique positive square root, selected from the proved unique-existence
statement. No root-producing function is supplied as a premise. -/
noncomputable def positiveSquareRoot (P : H →ₗ[ℂ] H) (hP : P.IsPositive) :
    H →ₗ[ℂ] H :=
  (existsUnique_positiveSquareRoot P hP).exists.choose

/-- The selected square root is positive semidefinite. -/
theorem positiveSquareRoot_isPositive (P : H →ₗ[ℂ] H) (hP : P.IsPositive) :
    (positiveSquareRoot P hP).IsPositive :=
  (existsUnique_positiveSquareRoot P hP).exists.choose_spec.1

/-- Composing the selected square root with itself gives the original operator. -/
theorem positiveSquareRoot_comp_self (P : H →ₗ[ℂ] H) (hP : P.IsPositive) :
    (positiveSquareRoot P hP).comp (positiveSquareRoot P hP) = P :=
  (existsUnique_positiveSquareRoot P hP).exists.choose_spec.2

/-- Every positive square root is the selected one. -/
theorem positiveSquareRoot_unique (P : H →ₗ[ℂ] H) (hP : P.IsPositive)
    (Q : H →ₗ[ℂ] H) (hQ : Q.IsPositive) (hsq : Q.comp Q = P) :
    Q = positiveSquareRoot P hP :=
  (existsUnique_positiveSquareRoot P hP).unique ⟨hQ, hsq⟩
    ⟨positiveSquareRoot_isPositive P hP, positiveSquareRoot_comp_self P hP⟩

/-- The selected positive square root of the actual Gram operator agrees
with the existing intrinsic absolute value. -/
theorem positiveSquareRoot_adjoint_comp_self (A : H →ₗ[ℂ] H) :
    positiveSquareRoot ((LinearMap.adjoint A).comp A)
      (LinearMap.isPositive_adjoint_comp_self A) = linearMapAbs A :=
  linearMapAbs_unique A _
    (positiveSquareRoot_isPositive _ (LinearMap.isPositive_adjoint_comp_self A))
    (positiveSquareRoot_comp_self _ (LinearMap.isPositive_adjoint_comp_self A))

end NumStability
