/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalLineCapacity

/-!
# Supplied capacity methods and conditional stability

Numerical flux and admission depend on the actual supplied time step.
Construction and execution require no pairwise stability property. The separate
StableAt estimate compares two admitted inputs at the same step. Boundary replacement
preserves flux and admission functions, with actual-cell and ghost errors kept explicit.
-/

namespace NumStability.CapacityCoordinate
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A supplied capacity line method. The numerical outputs are integrated fluxes.
Admission is indexed by the actual supplied time step; no common area or
hyperbolicity of an averaged flux is asserted. -/
structure Method (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) where
  incidence : NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord
  numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State
  admitted : D → Line → ℝ → (ℤ → State) → Prop

variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}

noncomputable def Method.rule (method : Method data coord) :=
  NumStability.FiniteCoordinate.PhysicalLine.faceRule coord method.numericalFlux

def Method.Admitted (method : Method data coord) (d : D) (dt : ℝ) (current : Cell → State) : Prop :=
  ∀ cell, method.admitted d (coord.cellLine d cell) dt
    (coord.extract d (coord.cellLine d cell) current)

/-- A separate conditional stability estimate for the same supplied time step.
Only actual cell positions are observed; fixed numerical ghosts are included in
the extracted array, without declaring them physical cells. -/
def Method.StableAt (method : Method data coord) (d : D) (dt A : ℝ) : Prop :=
  ∀ cell values other,
    method.admitted d (coord.cellLine d cell) dt values →
    method.admitted d (coord.cellLine d cell) dt other →
    ∀ E : ℝ, 0 ≤ E → (∀ j, ‖values j - other j‖ ≤ E) →
      ‖NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt values (coord.cellIndex d cell) -
        NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt other (coord.cellIndex d cell)‖ ≤ A * E

theorem Method.advance_eq (method : Method data coord) (d : D) (dt : ℝ)
    (current : Cell → State) (cell : Cell) :
    advance data method.rule d dt current cell =
      NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt (coord.extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  NumStability.FiniteCoordinate.PhysicalLine.advance_eq data coord method.incidence method.numericalFlux d dt current cell

theorem Method.coordinate_stability (method : Method data coord) (d : D) (dt A : ℝ)
    (hstable : method.StableAt d dt A) (current other : Cell → State)
    (hc : method.Admitted d dt current) (ho : method.Admitted d dt other)
    {E : ℝ} (hE : 0 ≤ E) (herr : ∀ cell, ‖current cell - other cell‖ ≤ E) :
    ∀ cell, ‖advance data method.rule d dt current cell -
      advance data method.rule d dt other cell‖ ≤ A * E := by
  intro cell
  rw [method.advance_eq, method.advance_eq]
  exact hstable cell _ _ (hc cell) (ho cell) E hE
    (coord.extract_error_le d (coord.cellLine d cell) current other hE herr)

/-- A cell observes only its own coordinate line, with supplied ghosts fixed. -/
theorem Method.coordinate_local (method : Method data coord) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data method.rule d dt current cell = advance data method.rule d dt other cell :=
  NumStability.FiniteCoordinate.PhysicalLine.advance_line_local data coord method.incidence method.numericalFlux
    d dt current other cell h

end NumStability.CapacityCoordinate

namespace NumStability.CapacityCoordinate.Method
open NumStability NumStability.FiniteCoordinate
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}
local notation "State" => Fin m → ℝ

/-- The new coordinate type is nominally different. Reconstruct its incidence
proofs and retain the identical numerical-flux and admission functions. -/
def withGhost (method : NumStability.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) : NumStability.CapacityCoordinate.Method data (coord.withGhost newGhost) where
  incidence := ⟨method.incidence.left_line, method.incidence.right_line,
    method.incidence.left_index, method.incidence.right_index⟩
  numericalFlux := method.numericalFlux
  admitted := method.admitted

theorem withGhost_flux_admission (method : NumStability.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) :
    (method.withGhost newGhost).numericalFlux = method.numericalFlux ∧
      (method.withGhost newGhost).admitted = method.admitted := ⟨rfl, rfl⟩

/-- The physical update retains the original physical capacities and supplied
flux formula, and uses precisely the newly extracted boundary data. -/
theorem advance_withGhost_eq (method : NumStability.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    advance data (method.withGhost newGhost).rule d dt current cell =
      NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt ((coord.withGhost newGhost).extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  (method.withGhost newGhost).advance_eq d dt current cell

/-- Cross-boundary-data stability uses both actual cell error and actual
missing-lookup ghost error. Both arrays must be admitted at the same dt. -/
theorem coordinate_stability_withGhost (method : NumStability.CapacityCoordinate.Method data coord)
    (first second : D → Line → ℤ → State) (d : D) (dt A : ℝ)
    (hstable : method.StableAt d dt A) (current other : Cell → State)
    (hc : (method.withGhost first).Admitted d dt current)
    (ho : (method.withGhost second).Admitted d dt other) (E G : ℝ)
    (hcell : ∀ cell, ‖current cell - other cell‖ ≤ E)
    (hghost : ∀ cell j, coord.lookup d (coord.cellLine d cell) j = none →
      ‖first d (coord.cellLine d cell) j - second d (coord.cellLine d cell) j‖ ≤ G) :
    ∀ cell, ‖advance data (method.withGhost first).rule d dt current cell -
      advance data (method.withGhost second).rule d dt other cell‖ ≤ A * max E G := by
  intro cell
  rw [method.advance_withGhost_eq, method.advance_withGhost_eq]
  have hE : 0 ≤ E := (norm_nonneg _).trans (hcell (Classical.choice data.cells.cells_nonempty))
  exact hstable cell _ _ (hc cell) (ho cell) (max E G) (hE.trans (le_max_left _ _))
    (coord.extract_withGhost_error_le_max first second d (coord.cellLine d cell)
      current other E G hcell (hghost cell))

end NumStability.CapacityCoordinate.Method
