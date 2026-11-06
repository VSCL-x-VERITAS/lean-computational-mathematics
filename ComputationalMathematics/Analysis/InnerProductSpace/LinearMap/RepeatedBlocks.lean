/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.ProdL2

/-!
# Positivity of repeated operator blocks

The operator with all four blocks equal to `A` is positive precisely when `A`
is positive. The block operator acts on the genuine Hilbert L2 product, and
positivity includes both symmetry and nonnegativity of the quadratic form.
No completeness, finite dimension or nonzero-space hypothesis is needed.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E : Type*} [RCLike 𝕜]
  [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]

/-- Repeating an operator in all four blocks preserves and reflects positivity.
The coordinate realization is fixed by `WithLp.linearEquiv`. -/
theorem repeated_block_isPositive_iff (A : E →ₗ[𝕜] E) :
    let L := WithLp.linearEquiv 2 𝕜 (E × E)
    let B := L.symm.toLinearMap.comp
      (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
    B.IsPositive ↔ A.IsPositive := by
  let L := WithLp.linearEquiv 2 𝕜 (E × E)
  let B := L.symm.toLinearMap.comp
    (((A.coprod A).prod (A.coprod A)).comp L.toLinearMap)
  change B.IsPositive ↔ A.IsPositive
  have hleft (p q : WithLp 2 (E × E)) :
      inner 𝕜 (B p) q =
        inner 𝕜 (A ((WithLp.ofLp p).1 + (WithLp.ofLp p).2))
          ((WithLp.ofLp q).1 + (WithLp.ofLp q).2) := by
    simp [B, L, WithLp.prod_inner_apply, inner_add_right]
  have hright (p q : WithLp 2 (E × E)) :
      inner 𝕜 p (B q) =
        inner 𝕜 ((WithLp.ofLp p).1 + (WithLp.ofLp p).2)
          (A ((WithLp.ofLp q).1 + (WithLp.ofLp q).2)) := by
    simp [B, L, WithLp.prod_inner_apply, inner_add_left]
  constructor
  · intro hB
    constructor
    · intro x y
      have h := hB.1 (WithLp.toLp 2 (x, 0)) (WithLp.toLp 2 (y, 0))
      simpa only [hleft, hright, WithLp.ofLp_toLp, add_zero] using h
    · intro x
      have h := hB.2 (WithLp.toLp 2 (x, 0))
      simpa only [hleft, WithLp.ofLp_toLp, add_zero] using h
  · intro hA
    constructor
    · intro p q
      rw [hleft, hright]
      exact hA.1 _ _
    · intro p
      rw [hleft]
      exact hA.2 _

end NumStability
