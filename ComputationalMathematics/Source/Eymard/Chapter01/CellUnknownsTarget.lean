/-
SPDX-License-Identifier: MIT
-/
/-!
# Cell Unknowns Target

The Section 2.2 notation supplies one value per control volume and natural
time level. This type specifies no numerical accuracy or reconstruction.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/


set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- The Section 2.2 notation supplies one value per control volume and natural
time level. This type specifies no numerical accuracy or reconstruction. -/
abbrev CellUnknowns (Cell State : Type) : Type :=
  Nat → Cell → State

/-- The cell-unknown family is exactly the time- and cell-indexed data type.
Mesh realization, the meaning of approximation and scheme solvability are
separate from this data convention. -/
def cellUnknownsTarget : Prop :=
  ∀ (Cell State : Type), CellUnknowns Cell State = (Nat → Cell → State)

end NumStability.Eymard.Chapter01
