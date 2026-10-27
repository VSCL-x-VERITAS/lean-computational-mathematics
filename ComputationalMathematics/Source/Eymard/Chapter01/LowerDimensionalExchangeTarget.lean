/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.LowerDimensionalExchange

/-!
# Lower Dimensional Exchange Target

Section 2.2's numerical zero-exchange requirement on the full source mesh
domain. This characterizes a requirement; it does not assert it for arbitrary
supplied exchanges. The mesh uses the existing open-closure-cover predicate.
No finite, neighbour, disjointness, or boundary-regularity restriction is added.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 2.2's numerical zero-exchange requirement on the full source mesh
domain. This characterizes a requirement; it does not assert it for arbitrary
supplied exchanges. The mesh uses the existing open-closure-cover predicate.
No finite, neighbour, disjointness, or boundary-regularity restriction is added. -/
def lowerDimensionalExchangeTarget : Prop :=
  ∀ (d : ℕ), (d = 1 ∨ d = 2 ∨ d = 3) →
    ∀ (Ω : Set (EuclideanSpace ℝ (Fin d)))
      (regions : Set (Set (EuclideanSpace ℝ (Fin d)))),
      NumStability.FiniteVolume.IsOpenClosureCover Ω regions →
        ∀ (exchange : ℕ → ↥regions → ↥regions → ℝ),
          NumStability.FiniteVolume.IsZeroOnLowerDimensionalInterfaces regions exchange ↔
            ∀ (n : ℕ) (K L : ↥regions),
              dimH (closure K.val ∩ closure L.val) < ((d - 1 : ℕ) : ENNReal) →
                exchange n K L = 0

end NumStability.Eymard.Chapter01
