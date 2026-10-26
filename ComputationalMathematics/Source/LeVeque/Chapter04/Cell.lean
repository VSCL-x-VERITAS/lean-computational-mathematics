/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# LeVeque Chapter 4: one-dimensional finite-volume cells

The cell on printed page 64 is the open interval between its two interfaces.
The integer `j` denotes the interface at `x_(j+1/2)`, so cell `i` has
interfaces `i - 1` and `i`.
-/

namespace NumStability

/-- LeVeque's cell `C_i = (x_(i-1/2), x_(i+1/2))`. -/
abbrev leveque04_cell (interface : ℤ → ℝ) (i : ℤ) : Set ℝ :=
  Set.Ioo (interface (i - 1)) (interface i)

/-- The width of LeVeque's cell, without assuming a uniform grid. -/
def leveque04_cellWidth (interface : ℤ → ℝ) (i : ℤ) : ℝ :=
  interface i - interface (i - 1)

/-- On an ordered cell, the source's cell and width notation resolve to an
open interval and its positive endpoint difference. -/
theorem leveque04_cell_geometry (interface : ℤ → ℝ) (i : ℤ)
    (hcell : interface (i - 1) < interface i) :
    leveque04_cell interface i = Set.Ioo (interface (i - 1)) (interface i) ∧
      leveque04_cellWidth interface i = interface i - interface (i - 1) ∧
        0 < leveque04_cellWidth interface i := by
  exact ⟨rfl, rfl, sub_pos.mpr hcell⟩

end NumStability
