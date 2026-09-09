/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalMethodSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateCoordinateSweep

/-!
# A physical interval realization of a directional numerical method

Real unit intervals, their actual common endpoints and unit point-face measure
realize the full directional-method premises simultaneously. Identity physical
flux transports a nonconstant step. The numerical left-state update is also
nonconstant. The reference errors concern its inputs only.
-/

open MeasureTheory

namespace NumStability.PhysicalIntervalSweep

open DirectionalFiniteVolume

local notation "Cell" => Fin 1 → ℤ
local notation "State" => Fin 1 → ℝ

def cells : FiniteVolumeCellPartition Cell ℝ where
  domain := Set.univ
  cellRegion := fun cell => Set.Ioc ((cell 0 : ℝ) - 1) (cell 0)
  cells_nonempty := inferInstance
  measurable_cell := fun _ => measurableSet_Ioc
  disjoint_cells := by
    intro a b hab
    apply Set.disjoint_left.mpr
    intro x hx hy
    apply hab
    have h := (Int.ceil_eq_iff.mpr hx).symm.trans (Int.ceil_eq_iff.mpr hy)
    funext i
    fin_cases i
    exact h
  covers_domain := by
    intro x
    constructor
    · intro _
      exact ⟨fun _ => ⌈x⌉, Int.ceil_eq_iff.mp rfl⟩
    · intro _; trivial

def axis : OneDimensionalFiniteVolumeGrid where
  cellLeft := fun j => (j : ℝ) - 1
  cellRight := fun j => j
  cell_nonempty := fun _ => by linarith
  adjacent := fun j => by simp

theorem cell_measure (cell : Cell) : volume (cells.cellRegion cell) = 1 := by
  simp [cells, Real.volume_Ioc]

noncomputable def data : PhysicalData (Fin 1) ℝ Unit 1 where
  cells := cells
  measure := volume
  positive := by intro cell; rw [cell_measure]; norm_num
  finite := by intro cell; rw [cell_measure]; norm_num
  faceMeasure := fun _ _ => Measure.dirac ()
  facePoint := fun _ cell _ => (cell 0 : ℝ) - 1
  incidence := by
    intro d cell point
    fin_cases d
    simp only [cells, Function.update_self, Int.cast_sub, Int.cast_one]
    rw [closure_Ioc (by linarith), closure_Ioc (by linarith)]
    constructor <;> constructor <;> linarith
  admissibleStates := fun _ => Set.univ
  normalFlux := fun _ _ _ state => state
  hyperbolic := by
    intro d cell point state _
    have h := hyperbolicConservationLaw_isHyperbolicFluxAt
      (StationaryRiemannField.transportLaw (m := 1)) state
    have heq : (StationaryRiemannField.transportLaw (m := 1)).physicalFlux = id :=
      funext StationaryRiemannField.physicalFlux
    simpa only [heq] using h

@[simp] theorem data_volume (cell : Cell) : data.cellVolume cell = 1 := by
  simp [PhysicalData.cellVolume, data, cell_measure]

@[simp] theorem data_mean (q : ℝ → ℝ → State) (cell : Cell) (t : ℝ) :
    data.cellMean q cell t = finiteVolumeCellAverageOn axis (fun x => q x t) (cell 0) := by
  exact cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ (by dsimp; linarith)

@[simp] theorem data_flux (q : ℝ → ℝ → State) (d : Fin 1) (cell : Cell) (t : ℝ) :
    data.faceFlux d q cell t = q ((cell 0 : ℝ) - 1) t := by
  simp [PhysicalData.faceFlux, data]

theorem reference_on (q : ℝ → ℝ → State)
    (hq : IsRectangleConservationLawSolution q id) (d : Fin 1) (s t : ℝ) :
    data.ReferenceOn d q s t := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro cell τ _
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le (by linarith)).mp
      (hq.1 τ ((cell 0 : ℝ) - 1) (cell 0))
  · intro cell τ _
    exact integrable_const _
  · intros; trivial
  · intros; trivial
  · fin_cases d
    have h := cartesian_reference (fun _ : Fin 1 => axis) 0 id q hq s t
    simpa only [IsDirectionalReference, data_volume, data_mean, data_flux,
      CartesianGrid.cellVolume, CartesianGrid.faceArea, Fin.prod_univ_one,
      Finset.univ_unique, Fin.default_eq_zero, Finset.erase_singleton,
      Finset.prod_empty, one_smul, axis, OneDimensionalFiniteVolumeGrid.cellVolume,
      sub_sub_cancel, id_eq] using h

noncomputable def reference : ℝ → ℝ → State := StationaryRiemannField.reference 0 1

theorem reference_conserved : IsRectangleConservationLawSolution reference id := by
  have heq : (StationaryRiemannField.transportLaw (m := 1)).physicalFlux = id :=
    funext StationaryRiemannField.physicalFlux
  simpa only [heq] using StationaryRiemannField.reference_rectangle (0 : State) 1

def rule (d : Fin 1) (cell : Cell) (_dt : ℝ) (line : ℤ → State) : State :=
  line (cell d - 1)

theorem constant_consistent (d : Fin 1) (cell : Cell) (dt : ℝ) (value : State)
    (_hdt : 0 < dt) (_hstate : value ∈ data.admissibleStates d) (_hadmit : True) :
    Integrable (fun point => data.normalFlux d cell point value) (data.faceMeasure d cell) ∧
    rule d cell dt (fun _ => value) =
      ∫ point, data.normalFlux d cell point value ∂data.faceMeasure d cell := by
  exact ⟨integrable_const _, by simp [rule, data]⟩

def initial (cell : Cell) : State := if cell 0 ≤ 0 then 0 else 1

noncomputable def oldError (before : List (Fin 1 × ℝ)) (d : Fin 1) (dt : ℝ) (cell : Cell) : ℝ :=
  ‖CoordinateLineBalance.sweep data.cellVolume rule before initial cell -
    data.cellMean reference cell 0‖

noncomputable def faceError (before : List (Fin 1 × ℝ)) (d : Fin 1) (dt : ℝ) (cell : Cell) : ℝ :=
  ‖CoordinateLineBalance.normalFaceFlux rule d dt
      (CoordinateLineBalance.sweep data.cellVolume rule before initial) cell -
    faceAverage (data.faceFlux d reference) 0 dt cell‖

/-- Application of the entire generic conjunction to one simultaneous
physical geometry, actual conserved field and nonconstant numerical method.
The displayed tolerances are input residual norms, not output certificates. -/
theorem simultaneous_contract := directional_splitting_contract
  data (by decide) rule (fun _ _ _ _ => True) constant_consistent
  [(0, 1)] (by simp) (by intro d; fin_cases d; exact ⟨1, by simp⟩)
  (by intro stage h; simp only [List.mem_singleton] at h; subst stage; norm_num)
  initial (fun _ _ _ => reference) oldError faceError
  (fun _ d dt _ _ => reference_on reference reference_conserved d 0 dt)
  (by intros; trivial) (by intros; trivial)
  (by intros; exact le_rfl) (by intros; exact le_rfl)

theorem unit_update (state : Cell → State) (cell : Cell) :
    CoordinateLineBalance.advance data.cellVolume rule 0 1 state cell =
      state (Function.update cell 0 (cell 0 - 1)) := by
  simp [CoordinateLineBalance.advance, data_volume, finiteVolumeCellAverageUpdate,
    CoordinateLineBalance.netOutwardFlux, CoordinateLineBalance.normalFaceFlux, rule]

theorem nonconstant_execution :
    initial (fun _ => 1) = 1 ∧
    CoordinateLineBalance.sweep data.cellVolume rule [(0, 1)] initial (fun _ => 1) = 0 ∧
    CoordinateLineBalance.sweep data.cellVolume rule [(0, 1)] initial (fun _ => 2) = 1 ∧
    reference (-1) 0 = 0 ∧ reference 1 0 = 1 := by
  simp [CoordinateLineBalance.sweep, orderedOperatorSweep, unit_update, initial,
    reference, StationaryRiemannField.reference, travelingWave, riemannData]

end NumStability.PhysicalIntervalSweep
