import Mathlib.Analysis.InnerProductSpace.Orthogonal
import Mathlib.LinearAlgebra.Projection

/-!
# Vershynin, Chapter 4, orthogonal projection convention

Source-correspondence contract for the footnote definition of a projection and
an orthogonal projection.
-/

open scoped InnerProductSpace

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Chapter 4 footnote: a projection
is idempotent, and it is orthogonal when its image and kernel are orthogonal
subspaces.

The statement uses Mathlib's canonical predicates and exposes their pointwise
content. It applies to real inner-product spaces, and therefore includes the
finite-dimensional Euclidean matrix setting of the source. -/
theorem hdp_04_orthogonal_projection_definition
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (P : Module.End ℝ E) :
    (IsIdempotentElem P ∧ LinearMap.range P ⟂ LinearMap.ker P) ↔
      (P * P = P ∧
        ∀ u ∈ LinearMap.range P, ∀ v ∈ LinearMap.ker P, ⟪u, v⟫_ℝ = 0) := by
  rw [IsIdempotentElem, Submodule.isOrtho_iff_inner_eq]

end NumStability.HDP.Contract
