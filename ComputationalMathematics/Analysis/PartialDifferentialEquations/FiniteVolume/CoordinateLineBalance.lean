/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference

/-!
# Conservative coordinate lines with supplied cell volumes

Cells have indices `D → ℤ`. A shared face is indexed by its direction and
right cell; its supplied numerical normal flux includes the face-area factor.
The actual update reads one coordinate line and conserves volume-weighted
mass, with the two exterior face terms retained on each finite line.

Volumes are supplied positive data in the balance theorems. This algebra
does not derive a physical chart, measure, normal, area, or constitutive flux
from the indices, and does not assert accuracy or constant-state preservation.
-/

open scoped BigOperators

namespace NumStability.CoordinateLineBalance

variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]

/-- The rule reads the actual coordinate line through the indexed shared face.
Its `E`-valued output is the supplied oriented, area-integrated normal flux. -/
def normalFaceFlux
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (rightCell : D → ℤ) : E :=
  rule d rightCell dt (fun j => state (Function.update rightCell d j))

/-- The right face of a cell is the left face of its coordinate successor. -/
def netOutwardFlux (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  normalFaceFlux rule d dt state (Function.update cell d (cell d + 1)) -
    normalFaceFlux rule d dt state cell

/-- One conservative coordinate-direction update with the supplied physical volume. -/
noncomputable def advance (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) : E :=
  finiteVolumeCellAverageUpdate dt (volume cell) (state cell)
    (netOutwardFlux rule d dt state cell)

/-- The cell-total formula is a direct instance of the existing generic theorem. -/
theorem advance_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (hvolume cell).ne'

/-- No values outside this coordinate line can affect its updated states. -/
theorem advance_line_local (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state other : (D → ℤ) → E) (base : D → ℤ)
    (hline : ∀ j, state (Function.update base d j) = other (Function.update base d j)) :
    ∀ j, advance volume rule d dt state (Function.update base d j) =
      advance volume rule d dt other (Function.update base d j) := by
  intro j
  simp only [advance, finiteVolumeCellAverageUpdate, netOutwardFlux,
    normalFaceFlux, Function.update_self, Function.update_idem]
  rw [hline j, funext hline]

/-- Every interior shared-face value cancels, with arbitrary nonuniform volumes. -/
theorem finite_line_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      (∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k))) -
      dt • (normalFaceFlux rule d dt state (Function.update base d (start + count)) -
        normalFaceFlux rule d dt state (Function.update base d start)) := by
  let mass : ℕ → E := fun k =>
    volume (Function.update base d (start + k)) • state (Function.update base d (start + k))
  let faces : ℕ → E := fun k =>
    normalFaceFlux rule d dt state (Function.update base d (start + k))
  calc
    _ = ∑ k ∈ Finset.range count, conservativeFluxDifferenceUpdate dt mass faces k := by
      apply Finset.sum_congr rfl
      intro k hk
      rw [advance_mass_balance volume hvolume]
      simp [conservativeFluxDifferenceUpdate, mass, faces, netOutwardFlux,
        Function.update_idem, add_assoc]
    _ = _ := by
      simpa [mass, faces] using sum_conservativeFluxDifferenceUpdate dt mass faces count

/-- Equal exterior face fluxes preserve the total physical mass on the finite line. -/
theorem finite_line_mass_preserved (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E)
    (base : D → ℤ) (start : ℤ) (count : ℕ)
    (hboundary : normalFaceFlux rule d dt state (Function.update base d (start + count)) =
      normalFaceFlux rule d dt state (Function.update base d start)) :
    (∑ k ∈ Finset.range count,
      volume (Function.update base d (start + k)) •
        advance volume rule d dt state (Function.update base d (start + k))) =
      ∑ k ∈ Finset.range count,
        volume (Function.update base d (start + k)) • state (Function.update base d (start + k)) := by
  rw [finite_line_mass_balance volume hvolume, hboundary, sub_self, smul_zero, sub_zero]

/-- In two adjacent cells the same intermediate normal flux occurs with opposite signs. -/
theorem adjacent_cells_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • advance volume rule d dt state cell +
      volume (Function.update cell d (cell d + 1)) •
        advance volume rule d dt state (Function.update cell d (cell d + 1)) =
      volume cell • state cell +
        volume (Function.update cell d (cell d + 1)) • state (Function.update cell d (cell d + 1)) -
      dt • (normalFaceFlux rule d dt state (Function.update cell d (cell d + 2)) -
        normalFaceFlux rule d dt state cell) := by
  rw [advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]
  simp only [netOutwardFlux, Function.update_self, Function.update_idem]
  have hindex : cell d + 1 + 1 = cell d + 2 := by omega
  rw [hindex]
  module

end NumStability.CoordinateLineBalance
