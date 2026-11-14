/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Mirman's triangle norm bound

The statement of Bhatia, Matrix Analysis (1997), Problem I.6.17(iii),
printed page 25 / PDF page 37. The three vertices are arbitrary complex
numbers, including coincident or collinear triples.

The conclusion uses the pointwise form of the operator norm bound for the
canonical continuous realization of a finite-dimensional linear operator.
The radius is nonnegative, so this formulation also covers the zero space.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Containment of the numerical range in a prescribed triangle implies
the operator norm bound by the largest modulus of its vertices. -/
def mirmanTriangleNormBound : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (z : Fin 3 → ℂ) (A : H →ₗ[ℂ] H),
    let W : Set ℂ :=
      {w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)}
    let R : ℝ := max ‖z 0‖ (max ‖z 1‖ ‖z 2‖)
    (W ⊆ convexHull ℝ (Set.range z)) →
      ∀ x : H, ‖A x‖ ≤ R * ‖x‖

end NumStability.Bhatia.Chapter01.Targets
