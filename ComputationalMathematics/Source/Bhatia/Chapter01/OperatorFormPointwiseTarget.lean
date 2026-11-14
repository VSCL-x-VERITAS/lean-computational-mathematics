/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# The prescribed sesquilinear function of a linear operator

Transparent pointwise statement contract for Bhatia, Matrix Analysis (1997),
I.4, printed page 12. The inner product is conjugate-linear in its first argument.
-/

set_option autoImplicit false

universe u v

namespace NumStability.Bhatia.Chapter01.Targets

/-- Every complex-linear operator gives the prescribed function on K × H,
with the complete second-variable linear law followed by the complete
first-variable conjugate-linear law, in source order. -/
def operatorSesquilinearFunctionPointwise : Prop :=
  ∀ (H : Type u) (K : Type v)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      [NormedAddCommGroup K] [InnerProductSpace ℂ K] [FiniteDimensional ℂ K]
      (A : H →ₗ[ℂ] K),
    let F : K → H → ℂ := fun u v => inner ℂ u (A v)
    (∀ (a b : ℂ) (u : K) (v₁ v₂ : H),
      F u (a • v₁ + b • v₂) = a * F u v₁ + b * F u v₂) ∧
    (∀ (a b : ℂ) (u₁ u₂ : K) (v : H),
      F (a • u₁ + b • u₂) v = star a * F u₁ v + star b * F u₂ v)

end NumStability.Bhatia.Chapter01.Targets
