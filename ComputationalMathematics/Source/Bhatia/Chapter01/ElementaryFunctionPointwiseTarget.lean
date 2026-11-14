/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# The definition of an elementary bilinear functional

Prospective transparent definition contract for Bhatia, Matrix Analysis (1997),
I.4, printed page 12, under the finite-dimensional complex Hilbert-space
conventions of I.1, printed page 1. The inner product is conjugate-linear in its
first argument. The final Prop records a definitional characterization on the
source bilinear domain.
-/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The raw source bilinear domain, with both complete complex linearity laws
in their printed order: the second argument first, then the first argument.
The helper retains the finite-dimensional complex Hilbert-space source scope. -/
def sourceBilinearFunction (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (F : H → H → ℂ) : Prop :=
  (∀ (a b : ℂ) (u v₁ v₂ : H),
    F u (a • v₁ + b • v₂) = a * F u v₁ + b * F u v₂) ∧
  (∀ (a b : ℂ) (u₁ u₂ v : H),
    F (a • u₁ + b • u₂) v = a * F u₁ v + b * F u₂ v)

/-- An elementary functional is a source-bilinear raw function admitting one
fixed representing pair. Both witnesses precede both pointwise variables;
zero vectors and zero-dimensional spaces are included. -/
def sourceElementaryFunction (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (F : H → H → ℂ) : Prop :=
  sourceBilinearFunction H F ∧
    ∃ x : H, ∃ y : H, ∀ u : H, ∀ v : H,
      F u v = inner ℂ x u * inner ℂ y v

/-- The elementary definition, characterized on the supplied source bilinear
domain. This is a definitional characterization; realization of a prescribed
fixed-pair formula and the neighboring nonclosure claim belong to separate rows. -/
def elementaryFunctionPointwiseCharacterization : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (F : H → H → ℂ),
    sourceBilinearFunction H F →
      (sourceElementaryFunction H F ↔
        ∃ x : H, ∃ y : H, ∀ u : H, ∀ v : H,
          F u v = inner ℂ x u * inner ℂ y v)

end NumStability.Bhatia.Chapter01.Targets
