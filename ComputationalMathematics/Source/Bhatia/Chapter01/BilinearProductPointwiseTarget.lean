/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# The prescribed product of two inner functionals

Transparent pointwise statement contract for Bhatia, Matrix Analysis (1997),
I.4, printed page 12. The inner product is conjugate-linear in its first argument.
-/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed function satisfies both complete bilinear identities,
in source order: the second argument first, then the first argument. -/
def fixedInnerProductBilinearFunctionPointwise : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (x y : H),
    let F : H → H → ℂ := fun u v => inner ℂ x u * inner ℂ y v
    (∀ (a b : ℂ) (u v₁ v₂ : H),
      F u (a • v₁ + b • v₂) = a * F u v₁ + b * F u v₂) ∧
    (∀ (a b : ℂ) (u₁ u₂ v : H),
      F (a • u₁ + b • u₂) v = a * F u₁ v + b * F u₂ v)

end NumStability.Bhatia.Chapter01.Targets
