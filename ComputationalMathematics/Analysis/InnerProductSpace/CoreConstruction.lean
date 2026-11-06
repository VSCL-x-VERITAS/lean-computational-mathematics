/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Defs

/-!
# Compatibility of the inner-product core construction

A positive-definite inner-product core supplies the normed and inner-product
structures without a prior distance or topology. The construction preserves
the original algebra and inner product, and induces their usual square-root
norm.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [g : AddCommGroup H] [m : Module 𝕜 H]

/-- Constructing the normed and inner-product structures from a core keeps
the supplied inner product. -/
theorem innerProductSpaceCore_inner_eq (cd : InnerProductSpace.Core 𝕜 H) (x y : H) :
    letI : NormedAddCommGroup H := cd.toNormedAddCommGroup
    letI : InnerProductSpace 𝕜 H := InnerProductSpace.ofCore (@instCoreOfCore 𝕜 H _ _ _ cd)
    inner 𝕜 x y = cd.inner x y := rfl

/-- The core construction preserves both the additive group and scalar
module structures. -/
theorem innerProductSpaceCore_algebra_eq (cd : InnerProductSpace.Core 𝕜 H) :
    letI : NormedAddCommGroup H := cd.toNormedAddCommGroup
    letI : NormedSpace 𝕜 H :=
      @InnerProductSpace.Core.toNormedSpace 𝕜 H _ _ _ (@instCoreOfCore 𝕜 H _ _ _ cd)
    (inferInstance : NormedAddCommGroup H).toAddCommGroup = g ∧
      (inferInstance : NormedSpace 𝕜 H).toModule = m := ⟨rfl, rfl⟩

/-- The norm induced by a positive-definite inner-product core is the
square root of the real part of the original self inner product. -/
theorem innerProductSpaceCore_norm_eq (cd : InnerProductSpace.Core 𝕜 H) (x : H) :
    letI : NormedAddCommGroup H := cd.toNormedAddCommGroup
    ‖x‖ = Real.sqrt (RCLike.re (cd.inner x x)) := rfl

end NumStability
