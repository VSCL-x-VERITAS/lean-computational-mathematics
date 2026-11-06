/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue
import Mathlib.Analysis.Matrix.Normed

/-!
# The intrinsic Frobenius norm of a finite-dimensional operator

The function is defined by the full singular-value sum, using the eigenvalues
of the actual positive absolute value. Its trace and every-orthonormal-basis
coordinate formulas identify it with the existing matrix Frobenius norm.
-/

set_option autoImplicit false
open scoped BigOperators Matrix.Norms.Frobenius

namespace NumStability

variable {H ι : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- The Frobenius norm, defined intrinsically from all singular values. -/
noncomputable def linearMapFrobenius (A : H →ₗ[ℂ] H) : ℝ :=
  Real.sqrt (∑ i : Fin (Module.finrank ℂ H), linearMapSingularValue A i ^ 2)

/-- The squared intrinsic Frobenius norm is the full singular-square sum. -/
theorem linearMapFrobenius_sq (A : H →ₗ[ℂ] H) :
    linearMapFrobenius A ^ 2 =
      ∑ i : Fin (Module.finrank ℂ H), linearMapSingularValue A i ^ 2 := by
  rw [linearMapFrobenius, Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)]

/-- The actual scalar-valued Gram trace is the embedded Frobenius square. -/
theorem trace_adjoint_comp_self_eq_frobenius_sq (A : H →ₗ[ℂ] H) :
    LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A) =
      ((linearMapFrobenius A ^ 2 : ℝ) : ℂ) := by
  rw [linearMapFrobenius_sq, Complex.ofReal_sum]
  exact trace_adjoint_comp_self_eq_sum_singularValue_sq A

/-- The full singular-square definition equals the square root of the
real part of the actual Gram trace. -/
theorem linearMapFrobenius_eq_sqrt_re_trace (A : H →ₗ[ℂ] H) :
    linearMapFrobenius A =
      Real.sqrt (LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)).re := by
  rw [trace_adjoint_comp_self_eq_frobenius_sq, Complex.ofReal_re]
  exact (Real.sqrt_sq (show 0 ≤ linearMapFrobenius A from Real.sqrt_nonneg _)).symm

variable [Fintype ι] [DecidableEq ι]

/-- Every orthonormal coordinate matrix gives the same full entry-square
formula, with no chosen-coordinate restriction. -/
theorem linearMapFrobenius_eq_sqrt_sum_matrix_norm_sq (A : H →ₗ[ℂ] H)
    (b : OrthonormalBasis ι ℂ H) :
    linearMapFrobenius A =
      Real.sqrt (∑ i, ∑ j, ‖LinearMap.toMatrix b.toBasis b.toBasis A i j‖ ^ 2) := by
  rw [linearMapFrobenius_eq_sqrt_re_trace,
    trace_adjoint_comp_self_eq_sum_matrix_norm_sq A b]
  rfl

/-- The intrinsic Frobenius norm agrees with Mathlib's existing matrix
Frobenius norm in every supplied orthonormal basis. -/
theorem linearMapFrobenius_eq_matrix_frobenius_norm (A : H →ₗ[ℂ] H)
    (b : OrthonormalBasis ι ℂ H) :
    linearMapFrobenius A = ‖LinearMap.toMatrix b.toBasis b.toBasis A‖ := by
  rw [linearMapFrobenius_eq_sqrt_sum_matrix_norm_sq A b,
    Matrix.frobenius_norm_def, Real.sqrt_eq_rpow]
  simp only [Real.rpow_two]

/-- The intrinsic Frobenius norm is nonnegative. -/
theorem linearMapFrobenius_nonneg (A : H →ₗ[ℂ] H) : 0 ≤ linearMapFrobenius A :=
  Real.sqrt_nonneg _

/-- The intrinsic Frobenius norm is definite, including in dimension zero. -/
theorem linearMapFrobenius_eq_zero_iff (A : H →ₗ[ℂ] H) :
    linearMapFrobenius A = 0 ↔ A = 0 := by
  classical
  let b := stdOrthonormalBasis ℂ H
  rw [linearMapFrobenius_eq_matrix_frobenius_norm A b, norm_eq_zero]
  constructor
  · intro h
    apply (LinearMap.toMatrix b.toBasis b.toBasis).injective
    simpa only [map_zero] using h
  · intro h
    rw [h, map_zero]

/-- Absolute scalar homogeneity of the intrinsic Frobenius norm. -/
theorem linearMapFrobenius_smul (c : ℂ) (A : H →ₗ[ℂ] H) :
    linearMapFrobenius (c • A) = ‖c‖ * linearMapFrobenius A := by
  classical
  let b := stdOrthonormalBasis ℂ H
  rw [linearMapFrobenius_eq_matrix_frobenius_norm (c • A) b, map_smul, norm_smul,
    linearMapFrobenius_eq_matrix_frobenius_norm A b]

/-- Triangle inequality for the full singular-value Frobenius definition. -/
theorem linearMapFrobenius_add_le (A B : H →ₗ[ℂ] H) :
    linearMapFrobenius (A + B) ≤ linearMapFrobenius A + linearMapFrobenius B := by
  classical
  let b := stdOrthonormalBasis ℂ H
  rw [linearMapFrobenius_eq_matrix_frobenius_norm (A + B) b, map_add,
    linearMapFrobenius_eq_matrix_frobenius_norm A b,
    linearMapFrobenius_eq_matrix_frobenius_norm B b]
  exact norm_add_le _ _

end NumStability
