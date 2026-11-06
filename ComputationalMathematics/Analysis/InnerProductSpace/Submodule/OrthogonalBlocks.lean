/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint

/-!
# Orthogonal subspace compressions

For submodules `X` and `Y`, the fixed compression of `A` from `Y` to `X` is
`(LinearMap.adjoint X.subtype).comp (A.comp Y.subtype)`. The adjoint of a
submodule inclusion is its orthogonal projection.

The four compressions associated with `M` and its orthogonal complement
reconstruct the original operator. Compositions are computed by summing over
the two intermediate summands, and taking adjoints transposes the blocks.
The results hold over any `RCLike` field on a finite-dimensional inner product
space, including the zero space and zero or full submodules.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H]
  [InnerProductSpace 𝕜 H] [FiniteDimensional 𝕜 H]

private theorem subtype_adjoint_decompose (M : Submodule 𝕜 H) (x : H) :
    M.subtype (LinearMap.adjoint M.subtype x) +
      Mᗮ.subtype (LinearMap.adjoint Mᗮ.subtype x) = x := by
  letI : IsUniformAddGroup M := M.toAddSubgroup.isUniformAddGroup
  letI : CompleteSpace M := FiniteDimensional.complete 𝕜 M
  have hM : LinearMap.adjoint M.subtype x = M.orthogonalProjection x := by
    apply ext_inner_right 𝕜
    intro y
    simp only [LinearMap.adjoint_inner_left,
      Submodule.inner_orthogonalProjection_eq_of_mem_right, Submodule.subtype_apply]
  have hN : LinearMap.adjoint Mᗮ.subtype x = Mᗮ.orthogonalProjection x := by
    apply ext_inner_right 𝕜
    intro y
    simp only [LinearMap.adjoint_inner_left,
      Submodule.inner_orthogonalProjection_eq_of_mem_right, Submodule.subtype_apply]
  rw [hM, hN]
  exact M.starProjection_add_starProjection_orthogonal x

/-- The four genuine orthogonal subspace compressions reconstruct the action
on the sum of a vector in each orthogonal summand. -/
theorem orthogonal_blocks_reconstruct (M : Submodule 𝕜 H)
    (A : H →ₗ[𝕜] H) (u : M) (v : Mᗮ) :
    A (M.subtype u + Mᗮ.subtype v) =
      M.subtype (((LinearMap.adjoint M.subtype).comp (A.comp M.subtype)) u +
        ((LinearMap.adjoint M.subtype).comp (A.comp Mᗮ.subtype)) v) +
      Mᗮ.subtype (((LinearMap.adjoint Mᗮ.subtype).comp (A.comp M.subtype)) u +
        ((LinearMap.adjoint Mᗮ.subtype).comp (A.comp Mᗮ.subtype)) v) := by
  simpa only [LinearMap.comp_apply, map_add] using
    (subtype_adjoint_decompose M (A (M.subtype u + Mᗮ.subtype v))).symm

/-- A compression of a composition is the sum of the products of the
compressions through the two intermediate orthogonal summands.
The row and column subspaces `X` and `Y` are arbitrary. -/
theorem orthogonal_compression_comp (M X Y : Submodule 𝕜 H)
    (A B : H →ₗ[𝕜] H) :
    (LinearMap.adjoint X.subtype).comp ((A.comp B).comp Y.subtype) =
      ((LinearMap.adjoint X.subtype).comp (A.comp M.subtype)).comp
        ((LinearMap.adjoint M.subtype).comp (B.comp Y.subtype)) +
      ((LinearMap.adjoint X.subtype).comp (A.comp Mᗮ.subtype)).comp
        ((LinearMap.adjoint Mᗮ.subtype).comp (B.comp Y.subtype)) := by
  apply LinearMap.ext
  intro y
  change LinearMap.adjoint X.subtype (A (B (Y.subtype y))) = _
  calc
    LinearMap.adjoint X.subtype (A (B (Y.subtype y))) =
        LinearMap.adjoint X.subtype (A
          (M.subtype (LinearMap.adjoint M.subtype (B (Y.subtype y))) +
            Mᗮ.subtype (LinearMap.adjoint Mᗮ.subtype (B (Y.subtype y))))) := by
      rw [subtype_adjoint_decompose]
    _ = _ := by simp only [LinearMap.comp_apply, LinearMap.add_apply, map_add]

/-- Taking the adjoint of the operator transposes and adjoints its fixed
orthogonal subspace compressions. No relation between `X` and `Y` is needed. -/
theorem orthogonal_compression_adjoint (X Y : Submodule 𝕜 H)
    (A : H →ₗ[𝕜] H) :
    (LinearMap.adjoint X.subtype).comp ((LinearMap.adjoint A).comp Y.subtype) =
      LinearMap.adjoint
        ((LinearMap.adjoint Y.subtype).comp (A.comp X.subtype)) := by
  simp only [LinearMap.adjoint_comp, LinearMap.adjoint_adjoint, LinearMap.comp_assoc]

end NumStability
