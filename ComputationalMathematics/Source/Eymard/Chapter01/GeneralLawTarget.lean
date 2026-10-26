/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.CoordinateBalance

/-!
# General Law Target

The physical spatial dimensions specified in Section 2.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

open scoped BigOperators

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume.CoordinateBalance

/-- The physical spatial dimensions specified in Section 2. -/
def IsSourceDimension (d : ℕ) : Prop := d = 1 ∨ d = 2 ∨ d = 3

/-- Equation (2.1) defines a pointwise modelling predicate. This correspondence
characterizes that predicate using genuine derivative witnesses; it asserts no
existence of fields or solutions. Only its indicated scalar partials must exist.
The operative region does not require the law away from its points.
This target describes one scalar equation/component; adjacent Example 2.1
applies the same form componentwise to a system in one spatial dimension. -/
def generalLawTarget : Prop :=
  ∀ d, IsSourceDimension d → ∀ (R : Set (Point d × ℝ))
    (q : Point d → ℝ → ℝ) (F : Point d → ℝ → Point d) (f : Point d → ℝ → ℝ),
    LocalLawOn R q F f ↔ ∀ x t, (x, t) ∈ R →
      ∃ qt : ℝ, ∃ di : Fin d → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
        (∀ i, HasDerivAt (fun s => F (replace x i s) t i) (di i) (x i)) ∧
        qt + (∑ i, di i) = f x t

end NumStability.Eymard.Chapter01
