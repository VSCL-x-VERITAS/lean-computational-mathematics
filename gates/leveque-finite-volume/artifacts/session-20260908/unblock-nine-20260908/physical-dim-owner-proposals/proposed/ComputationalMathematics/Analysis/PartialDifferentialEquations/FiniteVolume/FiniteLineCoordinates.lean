/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Group.Constructions

/-!
# Finite coordinate lookup and supplied boundary data

Canonical finite-cell and face indices, sound lookup, line extraction and its norm bounds.
Ghost replacement changes supplied values only. It introduces no physical cell, mesh,
measure, numerical method, or high-resolution premise.
-/

namespace NumStability.FiniteCoordinate
variable {D Cell Face Line : Type*} {m : ℕ}
local notation "State" => Fin m → ℝ

/-- Actual line coordinates of finite cells, with explicit supplied ghost
values where the finite physical array has no cell. A lookup can neither
broadcast an unrelated cell nor read a different coordinate line. -/
structure LineCoordinates (D Cell Face Line : Type*) where
  cellLine : D → Cell → Line
  cellIndex : D → Cell → ℤ
  faceLine : D → Face → Line
  faceIndex : D → Face → ℤ
  lookup : D → Line → ℤ → Option Cell
  lookup_cell : ∀ d cell, lookup d (cellLine d cell) (cellIndex d cell) = some cell
  lookup_sound : ∀ d line j cell, lookup d line j = some cell →
    cellLine d cell = line ∧ cellIndex d cell = j
  ghost : D → Line → ℤ → (Fin m → ℝ)

def LineCoordinates.extract (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current : Cell → State) (j : ℤ) : State :=
  match coord.lookup d line j with
  | some cell => current cell
  | none => coord.ghost d line j

theorem LineCoordinates.extract_cell (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (current : Cell → State) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) = current cell := by
  simp [LineCoordinates.extract, coord.lookup_cell]

theorem LineCoordinates.extract_local (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current other : Cell → State)
    (h : ∀ cell, coord.cellLine d cell = line → current cell = other cell) :
    coord.extract d line current = coord.extract d line other := by
  funext j
  simp only [LineCoordinates.extract]
  split
  next cell he => exact h cell (coord.lookup_sound d line j cell he).1
  next => rfl

theorem LineCoordinates.extract_error_le (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (current other : Cell → State) {E : ℝ} (hE : 0 ≤ E)
    (herr : ∀ cell, ‖current cell - other cell‖ ≤ E) (j : ℤ) :
    ‖coord.extract d line current j - coord.extract d line other j‖ ≤ E := by
  simp only [LineCoordinates.extract]
  split
  next cell _he => exact herr cell
  next => simpa using hE

end NumStability.FiniteCoordinate

namespace NumStability.FiniteCoordinate.LineCoordinates
variable {D Cell Face Line : Type*} {m : ℕ}
local notation "State" => Fin m → ℝ

/-- Replace only supplied numerical ghost values. No physical region, measure,
face, incidence, or coordinate lookup is changed. -/
def withGhost (coord : LineCoordinates (m := m) D Cell Face Line)
    (newGhost : D → Line → ℤ → State) : LineCoordinates (m := m) D Cell Face Line :=
  { coord with ghost := newGhost }

theorem withGhost_maps (coord : LineCoordinates (m := m) D Cell Face Line)
    (newGhost : D → Line → ℤ → State) :
    (coord.withGhost newGhost).cellLine = coord.cellLine ∧
    (coord.withGhost newGhost).cellIndex = coord.cellIndex ∧
    (coord.withGhost newGhost).faceLine = coord.faceLine ∧
    (coord.withGhost newGhost).faceIndex = coord.faceIndex ∧
    (coord.withGhost newGhost).lookup = coord.lookup ∧
    (coord.withGhost newGhost).ghost = newGhost := ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem withGhost_self (coord : LineCoordinates (m := m) D Cell Face Line) :
    coord.withGhost coord.ghost = coord := rfl

theorem withGhost_withGhost (coord : LineCoordinates (m := m) D Cell Face Line)
    (first second : D → Line → ℤ → State) :
    (coord.withGhost first).withGhost second = coord.withGhost second := rfl

/-- Only missing lookup positions need a ghost error bound. Actual cells and
ghosts may have different error bounds; both enter through their maximum. -/
theorem extract_withGhost_error_le_max (coord : LineCoordinates (m := m) D Cell Face Line)
    (first second : D → Line → ℤ → State) (d : D) (line : Line)
    (current other : Cell → State) (E G : ℝ)
    (hcell : ∀ cell, ‖current cell - other cell‖ ≤ E)
    (hghost : ∀ j, coord.lookup d line j = none → ‖first d line j - second d line j‖ ≤ G)
    (j : ℤ) :
    ‖(coord.withGhost first).extract d line current j -
      (coord.withGhost second).extract d line other j‖ ≤ max E G := by
  simp only [LineCoordinates.extract, withGhost]
  split
  next cell _ => exact (hcell cell).trans (le_max_left _ _)
  next h => exact (hghost j h).trans (le_max_right _ _)

end NumStability.FiniteCoordinate.LineCoordinates
