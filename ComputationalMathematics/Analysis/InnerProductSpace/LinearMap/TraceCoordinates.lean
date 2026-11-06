/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Trace

/-!
# Traces of squares and Gram operators in orthonormal coordinates

These identities retain the scalar-valued trace. Finite sums range over a
whole orthonormal basis or the full multiplicity-counted eigenvalue tuple,
including empty bases.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H ι : Type*} [RCLike 𝕜] [NormedAddCommGroup H]
variable [InnerProductSpace 𝕜 H] [FiniteDimensional 𝕜 H]

/-- The trace of the square of a symmetric operator is the sum of the
squares of all its real eigenvalues, counted with multiplicity. -/
theorem trace_comp_self_eq_sum_eigenvalues_sq (B : H →ₗ[𝕜] H)
    (hB : B.IsSymmetric) :
    LinearMap.trace 𝕜 H (B.comp B) =
      ∑ i : Fin (Module.finrank 𝕜 H), ((hB.eigenvalues rfl i ^ 2 : ℝ) : 𝕜) := by
  classical
  let b := hB.eigenvectorBasis rfl
  have hEig (i : Fin (Module.finrank 𝕜 H)) :
      B (b i) = (hB.eigenvalues rfl i : 𝕜) • b i :=
    hB.apply_eigenvectorBasis rfl i
  rw [LinearMap.trace_eq_sum_inner _ b]
  apply Finset.sum_congr rfl
  intro i _
  simp only [LinearMap.comp_apply, hEig, map_smul, inner_smul_right,
    inner_self_eq_norm_sq_to_K, b.norm_eq_one, RCLike.ofReal_one, one_pow, mul_one]
  simp only [pow_two, RCLike.ofReal_mul]

variable [Fintype ι]

/-- The actual Gram trace is the scalar embedding of the squared image
norms in any finite orthonormal basis. -/
theorem trace_adjoint_comp_self_eq_sum_norm_sq (A : H →ₗ[𝕜] H)
    (b : OrthonormalBasis ι 𝕜 H) :
    LinearMap.trace 𝕜 H ((LinearMap.adjoint A).comp A) =
      ∑ i, ((‖A (b i)‖ ^ 2 : ℝ) : 𝕜) := by
  classical
  rw [LinearMap.trace_eq_sum_inner _ b]
  apply Finset.sum_congr rfl
  intro i _
  rw [LinearMap.comp_apply, LinearMap.adjoint_inner_right, inner_self_eq_norm_sq_to_K]
  exact (RCLike.ofReal_pow _ _).symm

variable [DecidableEq ι]

/-- The complex or real Gram trace equals the full squared-modulus entry
sum in every orthonormal coordinate system. -/
theorem trace_adjoint_comp_self_eq_sum_matrix_norm_sq (A : H →ₗ[𝕜] H)
    (b : OrthonormalBasis ι 𝕜 H) :
    LinearMap.trace 𝕜 H ((LinearMap.adjoint A).comp A) =
      ((∑ i, ∑ j, ‖LinearMap.toMatrix b.toBasis b.toBasis A i j‖ ^ 2 : ℝ) : 𝕜) := by
  classical
  rw [trace_adjoint_comp_self_eq_sum_norm_sq A b, ← RCLike.ofReal_sum]
  congr 1
  symm
  simp_rw [LinearMap.toMatrix_apply, b.coe_toBasis, b.coe_toBasis_repr_apply,
    b.repr_apply_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro j _
  exact b.sum_sq_norm_inner_right (A (b j))

end NumStability
