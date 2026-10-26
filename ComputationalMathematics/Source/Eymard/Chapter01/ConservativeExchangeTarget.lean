/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.LocalConservativity

/-!
# Conservative Exchange Target

Section 2.2's numerical-exchange conservativity uses every ordered cell
pair. Ordered directions provide a thin view of the supplied exchange values
for the canonical outward-flux predicate; no mesh is constructed by this view.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 2.2's numerical-exchange conservativity uses every ordered cell
pair. Ordered directions provide a thin view of the supplied exchange values
for the canonical outward-flux predicate; no mesh is constructed by this view. -/
def conservativeExchangeTarget : Prop :=
  ∀ (Cell Value : Type) [AddCommGroup Value]
    (exchange : Nat → Cell → Cell → Value),
    NumStability.FiniteVolume.IsLocallyConservative
        (fun pair : Cell × Cell => pair) Prod.swap
        (fun (n : Nat) (direction : Cell × Cell) (_face : Cell × Cell) =>
          exchange n direction.1 direction.2) ↔
      ∀ n K L, exchange n K L = -exchange n L K

end NumStability.Eymard.Chapter01
