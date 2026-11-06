/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.TraceCoordinates
import Mathlib.Analysis.InnerProductSpace.StarOrder
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.Rpow.Basic

/-!
# Absolute values and singular values of finite-dimensional operators

The absolute value is the actual positive square root of the Gram operator.
Its sorted real eigenvalues give the full singular-value tuple, with one
entry per dimension and with zero entries retained.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- The absolute value of an operator, using the positive functional-calculus
square root on its continuous Gram operator. -/
noncomputable def linearMapAbs (A : H →ₗ[ℂ] H) : H →ₗ[ℂ] H := by
  letI := FiniteDimensional.complete ℂ H
  exact (CFC.sqrt (A.toContinuousLinearMap.adjoint * A.toContinuousLinearMap)).toLinearMap

/-- The actual absolute-value operator is positive. -/
theorem linearMapAbs_isPositive (A : H →ₗ[ℂ] H) : (linearMapAbs A).IsPositive := by
  letI := FiniteDimensional.complete ℂ H
  exact ((ContinuousLinearMap.nonneg_iff_isPositive _).mp (CFC.sqrt_nonneg _)).toLinearMap

/-- Squaring the positive absolute value gives the actual Gram operator. -/
theorem linearMapAbs_comp_self (A : H →ₗ[ℂ] H) :
    (linearMapAbs A).comp (linearMapAbs A) = (LinearMap.adjoint A).comp A := by
  letI := FiniteDimensional.complete ℂ H
  exact congrArg ContinuousLinearMap.toLinearMap
    (CFC.sqrt_mul_sqrt_self (A.toContinuousLinearMap.adjoint * A.toContinuousLinearMap)
      ((ContinuousLinearMap.nonneg_iff_isPositive _).mpr
        (ContinuousLinearMap.isPositive_adjoint_comp_self A.toContinuousLinearMap)))

/-- The absolute value is the unique positive square root of the Gram
operator, including for the zero-dimensional space. -/
theorem linearMapAbs_unique (A B : H →ₗ[ℂ] H) (hB : B.IsPositive)
    (hSq : B.comp B = (LinearMap.adjoint A).comp A) : B = linearMapAbs A := by
  letI := FiniteDimensional.complete ℂ H
  have hSq' : B.toContinuousLinearMap * B.toContinuousLinearMap =
      A.toContinuousLinearMap.adjoint * A.toContinuousLinearMap :=
    congrArg (fun S : H →ₗ[ℂ] H => S.toContinuousLinearMap) hSq
  have hB' : 0 ≤ B.toContinuousLinearMap :=
    (ContinuousLinearMap.nonneg_iff_isPositive _).mpr
      ((LinearMap.isPositive_toContinuousLinearMap_iff B).mpr hB)
  exact (congrArg ContinuousLinearMap.toLinearMap (CFC.sqrt_unique hSq' hB')).symm

/-- The singular values are the sorted eigenvalues of the actual positive
absolute value, indexed by the whole dimension. -/
noncomputable def linearMapSingularValue (A : H →ₗ[ℂ] H) :
    Fin (Module.finrank ℂ H) → ℝ :=
  (linearMapAbs_isPositive A).isSymmetric.eigenvalues rfl

/-- Every singular value is nonnegative. -/
theorem linearMapSingularValue_nonneg (A : H →ₗ[ℂ] H)
    (i : Fin (Module.finrank ℂ H)) : 0 ≤ linearMapSingularValue A i :=
  (linearMapAbs_isPositive A).nonneg_eigenvalues rfl i

/-- The full singular-value tuple is sorted in decreasing order. -/
theorem linearMapSingularValue_antitone (A : H →ₗ[ℂ] H) :
    Antitone (linearMapSingularValue A) :=
  (linearMapAbs_isPositive A).isSymmetric.eigenvalues_antitone rfl

/-- The scalar-valued Gram trace is the sum of the squares of all singular
values, counted with their full multiplicities. -/
theorem trace_adjoint_comp_self_eq_sum_singularValue_sq (A : H →ₗ[ℂ] H) :
    LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A) =
      ∑ i : Fin (Module.finrank ℂ H), ((linearMapSingularValue A i ^ 2 : ℝ) : ℂ) := by
  rw [← linearMapAbs_comp_self A]
  exact trace_comp_self_eq_sum_eigenvalues_sq _ (linearMapAbs_isPositive A).isSymmetric

end NumStability
