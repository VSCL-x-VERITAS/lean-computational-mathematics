/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5.
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.WedgeDefinitions
import Mathlib.LinearAlgebra.Span.Defs

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The named subspace is the algebraic span of every normalized wedge. -/
def exteriorSpace (H : Type u) [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (hk : 0 < k) :
    Submodule ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  Submodule.span ℂ (Set.range (normalizedWedge k hk :
    (Fin k → H) → PiTensorProduct ℂ (fun _ : Fin k => H)))

/-- I.5.exterior-space: definition as a subspace, with all tuples as generators.
It asserts no dimension, basis, range-of-projector or decomposability result.
-/
def exteriorSpaceDefinition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (hk : 0 < k),
    exteriorSpace H k hk =
      Submodule.span ℂ (Set.range (normalizedWedge k hk :
        (Fin k → H) → PiTensorProduct ℂ (fun _ : Fin k => H)))

end

end NumStability.Bhatia.Chapter01.Targets
