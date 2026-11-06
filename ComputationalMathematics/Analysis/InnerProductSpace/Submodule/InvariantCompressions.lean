/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.Submodule.OrthogonalBlocks

/-!
# Invariance and orthogonal compressions

An operator preserves a subspace exactly when its compression from that
subspace to the orthogonal complement vanishes. If both orthogonal summands
are invariant, the four-block reconstruction reduces to its diagonal blocks.
All compressions use actual subtype inclusions and their adjoints. The ambient
space is finite-dimensional over an `RCLike` field; the zero space and zero or
full submodules are included without a completeness hypothesis.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H]
  [InnerProductSpace 𝕜 H] [FiniteDimensional 𝕜 H]

private theorem subtype_adjoint_eq_zero_iff (M : Submodule 𝕜 H) (x : H) :
    LinearMap.adjoint M.subtype x = 0 ↔ x ∈ Mᗮ := by
  constructor
  · intro h
    apply (M.mem_orthogonal' x).mpr
    intro y hy
    have hi := LinearMap.adjoint_inner_left M.subtype (⟨y, hy⟩ : M) x
    simpa only [h, inner_zero_left, Submodule.subtype_apply] using hi.symm
  · intro h
    apply ext_inner_right 𝕜
    intro y
    rw [LinearMap.adjoint_inner_left, inner_zero_left]
    exact (M.mem_orthogonal' x).mp h y y.property

/-- The compression from `M` into `Mᗮ` vanishes exactly when `A` preserves `M`.
There is no assumption that either orthogonal summand is nonzero. -/
theorem orthogonal_compression_eq_zero_iff_invariant (M : Submodule 𝕜 H)
    (A : H →ₗ[𝕜] H) :
    (LinearMap.adjoint Mᗮ.subtype).comp (A.comp M.subtype) = 0 ↔
      ∀ x ∈ M, A x ∈ M := by
  letI : IsUniformAddGroup M := M.toAddSubgroup.isUniformAddGroup
  letI : CompleteSpace M := FiniteDimensional.complete 𝕜 M
  constructor
  · intro h x hx
    have hz : LinearMap.adjoint Mᗮ.subtype (A x) = 0 := by
      simpa only [LinearMap.comp_apply, Submodule.subtype_apply,
        LinearMap.zero_apply] using LinearMap.congr_fun h (⟨x, hx⟩ : M)
    have hm := (subtype_adjoint_eq_zero_iff Mᗮ (A x)).mp hz
    simpa only [Submodule.orthogonal_orthogonal] using hm
  · intro h
    apply LinearMap.ext
    intro x
    change LinearMap.adjoint Mᗮ.subtype (A (x : H)) = 0
    exact (subtype_adjoint_eq_zero_iff Mᗮ (A x)).mpr
      (M.le_orthogonal_orthogonal (h x x.property))

/-- When both orthogonal summands are invariant, the actual action is the sum
of its two diagonal compressions. -/
theorem orthogonal_blocks_diagonal_of_invariant (M : Submodule 𝕜 H)
    (A : H →ₗ[𝕜] H) (hM : ∀ x ∈ M, A x ∈ M)
    (hN : ∀ x ∈ Mᗮ, A x ∈ Mᗮ) (u : M) (v : Mᗮ) :
    A (M.subtype u + Mᗮ.subtype v) =
      M.subtype (((LinearMap.adjoint M.subtype).comp (A.comp M.subtype)) u) +
      Mᗮ.subtype (((LinearMap.adjoint Mᗮ.subtype).comp (A.comp Mᗮ.subtype)) v) := by
  have hD := (orthogonal_compression_eq_zero_iff_invariant M A).mpr hM
  have hC : (LinearMap.adjoint M.subtype).comp (A.comp Mᗮ.subtype) = 0 := by
    apply LinearMap.ext
    intro v
    change LinearMap.adjoint M.subtype (A (v : H)) = 0
    exact (subtype_adjoint_eq_zero_iff M (A v)).mpr (hN v v.property)
  simpa only [hC, hD, LinearMap.zero_apply, add_zero, zero_add] using
    orthogonal_blocks_reconstruct M A u v

end NumStability
