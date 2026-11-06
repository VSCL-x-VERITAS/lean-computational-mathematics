/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AbsoluteValue
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.OperatorNorm
import Mathlib.Analysis.CStarAlgebra.Matrix

/-!
# Operator norms, absolute values, and singular values

The actual operator norm agrees with the square root of the Gram operator norm.
In an orthonormal eigenbasis a symmetric operator has the norm of its full
eigenvalue tuple. For a positive operator this is its first eigenvalue whenever
that index exists. Applying these facts to the actual positive absolute value
identifies the first singular value with the original operator norm.

The space may have dimension zero. No singular value is assigned to an index
outside its dimension-length tuple.
-/

set_option autoImplicit false
open scoped Matrix.Norms.L2Operator

namespace NumStability

section RCLike

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H]
variable [InnerProductSpace 𝕜 H] [FiniteDimensional 𝕜 H]

/-- The algebraic Gram operator's actual norm recovers the operator norm by
the nonnegative real square root, including on the zero space. -/
theorem norm_toContinuousLinearMap_eq_sqrt_norm_adjoint_comp_self
    (A : H →ₗ[𝕜] H) :
    ‖A.toContinuousLinearMap‖ =
      Real.sqrt ‖((LinearMap.adjoint A).comp A).toContinuousLinearMap‖ := by
  letI := FiniteDimensional.complete 𝕜 H
  change ‖A.toContinuousLinearMap‖ =
    Real.sqrt ‖A.toContinuousLinearMap.adjoint.comp A.toContinuousLinearMap‖
  rw [ContinuousLinearMap.norm_adjoint_comp_self,
    Real.sqrt_mul_self (norm_nonneg _)]

/-- A symmetric operator's norm is the ordinary supremum norm of its full
real eigenvalue tuple, embedded in the scalar field. Empty tuples are allowed. -/
theorem norm_toContinuousLinearMap_eq_norm_eigenvalues
    (A : H →ₗ[𝕜] H) (hA : A.IsSymmetric) :
    ‖A.toContinuousLinearMap‖ =
      ‖fun i : Fin (Module.finrank 𝕜 H) => (hA.eigenvalues rfl i : 𝕜)‖ := by
  classical
  let b := hA.eigenvectorBasis (n := Module.finrank 𝕜 H) rfl
  have happly (j : Fin (Module.finrank 𝕜 H)) :
      A (b j) = (hA.eigenvalues rfl j : 𝕜) • b j :=
    hA.apply_eigenvectorBasis rfl j
  have hmatrix : LinearMap.toMatrix b.toBasis b.toBasis A =
      Matrix.diagonal (fun i => (hA.eigenvalues rfl i : 𝕜)) := by
    ext i j
    rw [LinearMap.toMatrix_apply, b.coe_toBasis, b.coe_toBasis_repr_apply,
      b.repr_apply_apply, happly, inner_smul_right]
    by_cases hij : i = j
    · subst j
      simp [b.orthonormal.norm_eq_one]
    · simp [orthonormal_iff_ite.mp b.orthonormal, hij]
  calc
    ‖A.toContinuousLinearMap‖ =
        ‖(Matrix.toEuclideanLin
          (LinearMap.toMatrix b.toBasis b.toBasis A)).toContinuousLinearMap‖ :=
      (norm_toEuclideanLin_toMatrix b b A).symm
    _ = ‖LinearMap.toMatrix b.toBasis b.toBasis A‖ :=
      (Matrix.l2_opNorm_def _).symm
    _ = ‖fun i : Fin (Module.finrank 𝕜 H) => (hA.eigenvalues rfl i : 𝕜)‖ := by
      rw [hmatrix, Matrix.l2_opNorm_diagonal]

/-- At every legal first index, a positive operator's norm is its greatest
eigenvalue. The index condition does not restrict the ambient-space parameter. -/
theorem norm_toContinuousLinearMap_eq_first_eigenvalue
    (A : H →ₗ[𝕜] H) (hA : A.IsPositive)
    (i : Fin (Module.finrank 𝕜 H)) (hi : i.val = 0) :
    ‖A.toContinuousLinearMap‖ = hA.isSymmetric.eigenvalues rfl i := by
  rw [norm_toContinuousLinearMap_eq_norm_eigenvalues A hA.isSymmetric]
  apply le_antisymm
  · apply (pi_norm_le_iff_of_nonneg (hA.nonneg_eigenvalues rfl i)).mpr
    intro j
    have hij : i ≤ j := by
      change i.val ≤ j.val
      rw [hi]
      exact Nat.zero_le _
    simpa only [RCLike.norm_ofReal,
      abs_of_nonneg (hA.nonneg_eigenvalues rfl j)] using
      hA.isSymmetric.eigenvalues_antitone rfl hij
  · simpa only [RCLike.norm_ofReal,
      abs_of_nonneg (hA.nonneg_eigenvalues rfl i)] using
      norm_le_pi_norm
        (fun j : Fin (Module.finrank 𝕜 H) => (hA.isSymmetric.eigenvalues rfl j : 𝕜)) i

end RCLike

section Complex

variable {H : Type*} [NormedAddCommGroup H]
variable [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

/-- Passing to the actual positive absolute value preserves the operator norm. -/
theorem norm_linearMapAbs (A : H →ₗ[ℂ] H) :
    ‖(linearMapAbs A).toContinuousLinearMap‖ = ‖A.toContinuousLinearMap‖ := by
  have hself : LinearMap.adjoint (linearMapAbs A) = linearMapAbs A :=
    (linearMapAbs_isPositive A).adjoint_eq
  calc
    ‖(linearMapAbs A).toContinuousLinearMap‖ =
        Real.sqrt ‖((LinearMap.adjoint (linearMapAbs A)).comp
          (linearMapAbs A)).toContinuousLinearMap‖ :=
      norm_toContinuousLinearMap_eq_sqrt_norm_adjoint_comp_self _
    _ = Real.sqrt ‖((LinearMap.adjoint A).comp A).toContinuousLinearMap‖ := by
      rw [hself, linearMapAbs_comp_self]
    _ = ‖A.toContinuousLinearMap‖ :=
      (norm_toContinuousLinearMap_eq_sqrt_norm_adjoint_comp_self A).symm

/-- The original operator norm equals the prescribed actual-absolute-value
singular value at every legal first index. No value is assigned at dimension zero. -/
theorem norm_toContinuousLinearMap_eq_first_singularValue
    (A : H →ₗ[ℂ] H) (i : Fin (Module.finrank ℂ H)) (hi : i.val = 0) :
    ‖A.toContinuousLinearMap‖ = linearMapSingularValue A i := by
  calc
    ‖A.toContinuousLinearMap‖ = ‖(linearMapAbs A).toContinuousLinearMap‖ :=
      (norm_linearMapAbs A).symm
    _ = linearMapSingularValue A i :=
      norm_toContinuousLinearMap_eq_first_eigenvalue
        (linearMapAbs A) (linearMapAbs_isPositive A) i hi

end Complex

end NumStability
