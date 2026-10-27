/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.LocalConservativity

/-!
# Local Conservativity Target

The introductory term "local conservativity", using outward orientation.
The two maps give the distinct cells incident to an interface. This is a
definition of the property, with concrete flux realizations treated separately.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- The introductory term "local conservativity", using outward orientation.
The two maps give the distinct cells incident to an interface. This is a
definition of the property, with concrete flux realizations treated separately. -/
def localConservativityTarget : Prop :=
  ∀ (Cell Face Time Value : Type) [AddCommGroup Value]
    (left right : Face → Cell)
    (_distinct : ∀ face, left face ≠ right face)
    (flux : Time → Cell → Face → Value),
    NumStability.FiniteVolume.IsLocallyConservative left right flux ↔
      ∀ time face, flux time (left face) face = -flux time (right face) face

end NumStability.Eymard.Chapter01
