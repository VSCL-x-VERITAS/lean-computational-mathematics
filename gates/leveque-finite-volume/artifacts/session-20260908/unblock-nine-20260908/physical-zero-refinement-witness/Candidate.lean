import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Data.Finset.Lattice.Fold
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Data.Finset.Lattice.Fold
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Data.Finset.Lattice.Fold
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod

/-! Artifact-only foundation: ordered lines with actual measured capacities.
No regularity, quality, source-acceptance, or integrated-hyperbolicity claim. -/

namespace PhysicalCapacityBridge
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

structure Incidence (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) : Prop where
  left_line : ∀ d cell, coord.faceLine d (data.leftFace d cell) = coord.cellLine d cell
  right_line : ∀ d cell, coord.faceLine d (data.rightFace d cell) = coord.cellLine d cell
  left_index : ∀ d cell, coord.faceIndex d (data.leftFace d cell) = coord.cellIndex d cell
  right_index : ∀ d cell, coord.faceIndex d (data.rightFace d cell) = coord.cellIndex d cell + 1

noncomputable def capacity (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) (j : ℤ) : ℝ :=
  match coord.lookup d line j with
  | some cell => data.cellVolume cell
  | none => 1

theorem capacity_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) (j : ℤ) :
    0 < capacity data coord d line j := by
  unfold capacity
  split
  next cell _ => exact data.cellVolume_pos cell
  next => norm_num

theorem capacity_cell (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (cell : Cell) :
    capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) = data.cellVolume cell := by
  simp [capacity, coord.lookup_cell]

/-- These are the supplied already-integrated numerical face fluxes. -/
def faceRule (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) (face : Face) : State :=
  numericalFlux d (coord.faceLine d face) dt
    (coord.extract d (coord.faceLine d face) current) (coord.faceIndex d face)

noncomputable def lineAdvance (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (line : Line) (dt : ℝ) (values : ℤ → State) (j : ℤ) : State :=
  finiteVolumeCellAverageUpdate dt (capacity data coord d line j) (values j)
    (numericalFlux d line dt values (j + 1) - numericalFlux d line dt values j)

/-- This equality is unconditional in the positive physical capacities and
supplied numerical flux: no common-area factorization is assumed. -/
theorem advance_eq (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (incidence : Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    advance data (faceRule coord numericalFlux) d dt current cell =
      lineAdvance data coord numericalFlux d (coord.cellLine d cell) dt
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) := by
  simp only [advance, faceRule, lineAdvance, incidence.left_line, incidence.right_line,
    incidence.left_index, incidence.right_index, capacity_cell, coord.extract_cell]

/-- The projected line entry uses exactly the same measured physical mean. -/
theorem projection_cell (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (q : Point → ℝ → State)
    (d : D) (t : ℝ) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t)
      (coord.cellIndex d cell) =
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t) := by
  rw [coord.extract_cell]
  rfl

theorem advance_line_local (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) (incidence : Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current other : Cell → State) (cell : Cell)
    (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data (faceRule coord numericalFlux) d dt current cell =
      advance data (faceRule coord numericalFlux) d dt other cell := by
  rw [advance_eq data coord incidence, advance_eq data coord incidence,
    coord.extract_local d (coord.cellLine d cell) current other h]

theorem weighted_mass_balance [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (dt : ℝ) (current : Cell → State) :
    (∑ cell, data.cellVolume cell • advance data (faceRule coord numericalFlux) d dt current cell) =
      (∑ cell, data.cellVolume cell • current cell) - dt •
        ∑ cell, (faceRule coord numericalFlux d dt current (data.rightFace d cell) -
          faceRule coord numericalFlux d dt current (data.leftFace d cell)) :=
  finite_mass_balance data (faceRule coord numericalFlux) d dt current

#print axioms capacity_pos
#print axioms capacity_cell
#print axioms advance_eq
#print axioms projection_cell
#print axioms advance_line_local
#print axioms weighted_mass_balance
end PhysicalCapacityBridge


namespace CapacityNetReferenceError
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The signed difference of the two actual numerical-minus-physical face errors.
Physical means are time averages of the same reference on the selected slab. -/
noncomputable def netFluxDefect (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  (rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
    (rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)

/-- Extracted physical weighted error balance, before any triangle estimate.
The reference retains all its cell/face integrability, state, and subinterval premises. -/
theorem advance_error_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
        (t - s) • netFluxDefect data rule d current q s t cell := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
  unfold netFluxDefect
  module

/-- Only the norm of the NET face error is bounded. Separate face errors may
be large and cancel; no separate per-face asymptotic order is imposed. -/
theorem advance_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data rule d current q s t cell‖ ≤ netDefectBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * netDefectBound := by
  have hb := advance_error_balance data rule d current q href hst cell
  simpa only [add_zero] using
    (norm_le_of_weighted_error_balance (rightError := (0 : State)) (rightBound := 0)
      (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
      (by simpa only [sub_zero] using hb) hold hnet (by simp))

/-- The exact same measured projection, capacity and supplied line flux are
used in the physical balance and extracted active-cell line operator. -/
theorem capacity_line_error_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) •
      (PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t) (coord.cellIndex d cell)) =
      data.cellVolume cell •
        (coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) -
          cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x s)) +
        (t - s) • netFluxDefect data (PhysicalCapacityBridge.faceRule coord numericalFlux)
          d current q s t cell := by
  rw [PhysicalCapacityBridge.capacity_cell,
    ← PhysicalCapacityBridge.advance_eq data coord incidence,
    coord.extract_cell, coord.extract_cell]
  exact advance_error_balance data (PhysicalCapacityBridge.faceRule coord numericalFlux)
    d current q href hst cell

theorem capacity_line_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data (PhysicalCapacityBridge.faceRule coord numericalFlux)
      d current q s t cell‖ ≤ netDefectBound) :
    ‖PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)‖ ≤
      oldBound + (t - s) /
        PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) *
          netDefectBound := by
  rw [PhysicalCapacityBridge.capacity_cell, ← PhysicalCapacityBridge.advance_eq data coord incidence]
  exact advance_error_le_net data (PhysicalCapacityBridge.faceRule coord numericalFlux)
    d current q href hst cell oldBound netDefectBound hold hnet

/-- A scalar cell with zero exact density and zero physical faces can have
arbitrarily large common numerical bias. Its net defect is 2 and actual error is 1. -/
theorem scalar_nonzero_net_example (bias : ℝ) :
    IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume 0 2 ∧
    IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume 0 1 ∧
    (∀ a b s t : ℝ, (∫ _x in a..b, (0 : ℝ)) - (∫ _x in a..b, (0 : ℝ)) =
      ∫ _τ in s..t, ((0 : ℝ) - 0)) ∧
    ((bias + 2 - 0) - (bias - 0) = 2) ∧
    (finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) = 1) ∧
    (‖finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) - 0‖ =
      (0 : ℝ) + 1 / 2 * 2) ∧
    (0 < ‖finiteVolumeCellAverageUpdate (1 : ℝ) 2 0 (bias - (bias + 2)) - 0‖) := by
  have hnet : bias - (bias + 2) = -2 := by ring
  refine ⟨by simp, by simp, by intros; simp, by ring, ?_, ?_, ?_⟩ <;>
    norm_num [hnet, finiteVolumeCellAverageUpdate]
  rfl

#check netFluxDefect
#print axioms netFluxDefect
#check advance_error_balance
#print axioms advance_error_balance
#check advance_error_le_net
#print axioms advance_error_le_net
#check capacity_line_error_balance
#print axioms capacity_line_error_balance
#check capacity_line_error_le_net
#print axioms capacity_line_error_le_net
#check scalar_nonzero_net_example
#print axioms scalar_nonzero_net_example
end CapacityNetReferenceError


namespace CapacityCoordinate
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A supplied capacity line method. The numerical outputs are integrated fluxes.
Admission is indexed by the actual supplied time step; no common area or
hyperbolicity of an averaged flux is asserted. -/
structure Method (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line) where
  incidence : PhysicalCapacityBridge.Incidence data coord
  numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State
  admitted : D → Line → ℝ → (ℤ → State) → Prop

variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}

noncomputable def Method.rule (method : Method data coord) :=
  PhysicalCapacityBridge.faceRule coord method.numericalFlux

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
      ‖PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt values (coord.cellIndex d cell) -
        PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt other (coord.cellIndex d cell)‖ ≤ A * E

theorem Method.advance_eq (method : Method data coord) (d : D) (dt : ℝ)
    (current : Cell → State) (cell : Cell) :
    advance data method.rule d dt current cell =
      PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt (coord.extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  PhysicalCapacityBridge.advance_eq data coord method.incidence method.numericalFlux d dt current cell

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

theorem Method.projection_cell (_method : Method data coord) (d : D)
    (q : Point → ℝ → State) (t : ℝ) (cell : Cell) :
    coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t) (coord.cellIndex d cell) =
      cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t) :=
  PhysicalCapacityBridge.projection_cell data coord q d t cell

/-- A cell observes only its own coordinate line, with supplied ghosts fixed. -/
theorem Method.coordinate_local (method : Method data coord) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data method.rule d dt current cell = advance data method.rule d dt other cell :=
  PhysicalCapacityBridge.advance_line_local data coord method.incidence method.numericalFlux
    d dt current other cell h

noncomputable def step (method : ℕ → Method data coord) (direction : ℕ → D)
    (duration : ℕ → ℝ) (n : ℕ) : (Cell → State) → Cell → State :=
  advance data (method n).rule (direction n) (duration n)

noncomputable def run (method : ℕ → Method data coord) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) : ℕ → Cell → State :=
  execution (step method direction duration) initial

theorem run_succ (method : ℕ → Method data coord) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (n : ℕ) :
    run method direction duration initial (n + 1) =
      advance data (method n).rule (direction n) (duration n)
        (run method direction duration initial n) := rfl

theorem run_ordered (method : ℕ → Method data coord) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (n : ℕ) :
    run method direction duration initial n =
      orderedOperatorSweep ((List.range n).map (step method direction duration)) initial := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [run_succ, List.range_succ, List.map_append, orderedOperatorSweep]
    simp only [List.map_cons, List.map_nil, List.foldl_append, List.foldl_cons, List.foldl_nil]
    change step method direction duration n (run method direction duration initial n) =
      step method direction duration n
        (orderedOperatorSweep ((List.range n).map (step method direction duration)) initial)
    rw [ih]

/-- Actual ordered capacity execution, compared with physical measured cell
means. Stability, net physical-flux defect, and stage-reference mismatch remain
independent hypotheses. This theorem does not define a high-resolution class. -/
theorem run_physical_error (method : ℕ → Method data coord) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (physical : ℕ → Point → ℝ → State)
    (steps : ℕ) (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (netError : ℕ → Cell → ℝ)
    (hdt : ∀ n < steps, 0 < duration n)
    (href : ∀ n < steps, data.ReferenceOn (direction n) (physical n) 0 (duration n))
    (hinitial : ∀ cell, ‖initial cell - data.cellMean (physical 0) cell 0‖ ≤ initialError)
    (hactual : ∀ n < steps, (method n).Admitted (direction n) (duration n)
      (run method direction duration initial n))
    (hrefadmit : ∀ n < steps, (method n).Admitted (direction n) (duration n)
      (fun cell => data.cellMean (physical n) cell 0))
    (hstable : ∀ n < steps, (method n).StableAt (direction n) (duration n) (amplification n))
    (hnet : ∀ n < steps, ∀ cell,
      ‖CapacityNetReferenceError.netFluxDefect data (method n).rule (direction n)
        (fun c => data.cellMean (physical n) c 0) (physical n) 0 (duration n) cell‖ ≤ netError n cell)
    (hlocal : ∀ n < steps, ∀ cell,
      duration n / data.cellVolume cell * netError n cell ≤ localDefect n)
    (hsplit : ∀ n < steps, ∀ cell,
      ‖data.cellMean (physical n) cell (duration n) -
        data.cellMean (physical (n + 1)) cell 0‖ ≤ splittingDefect n) :
    ∀ n ≤ steps, ∀ cell,
      ‖run method direction duration initial n cell - data.cellMean (physical n) cell 0‖ ≤
        errorBudget amplification localDefect splittingDefect initialError n := by
  apply execution_error_le_upto (step method direction duration)
    (fun n => (method n).Admitted (direction n) (duration n)) initial
    (fun n cell => data.cellMean (physical n) cell 0)
    (fun n cell => data.cellMean (physical n) cell (duration n))
    amplification localDefect splittingDefect initialError steps hinitial hactual hrefadmit
  · intro n hn current other hc ho E herr
    have hE : 0 ≤ E := (norm_nonneg _).trans (herr (Classical.choice data.cells.cells_nonempty))
    exact (method n).coordinate_stability (direction n) (duration n) (amplification n)
      (hstable n hn) current other hc ho hE herr
  · intro n hn cell
    have he := CapacityNetReferenceError.advance_error_le_net data (method n).rule (direction n)
      (fun c => data.cellMean (physical n) c 0) (physical n) (href n hn) (hdt n hn) cell
      0 (netError n cell) (by simp) (hnet n hn cell)
    apply le_trans ?_ (hlocal n hn cell)
    simpa [step] using he
  · exact hsplit

end CapacityCoordinate

namespace CapacityPhysicalMesh
open NumStability
variable {Cell Point : Type*} [Fintype Cell] [MeasurableSpace Point] [PseudoMetricSpace Point]

/-- Maximum of actual physical cell diameters. This uses no cell measure,
capacity, logical index spacing, or dummy ghost. Unbounded cells must be
excluded explicitly before using the diameter as a distance bound. -/
noncomputable def mesh (cells : FiniteVolumeCellPartition Cell Point) : ℝ :=
  Finset.univ.sup' (by
    obtain ⟨cell⟩ := cells.cells_nonempty
    exact ⟨cell, Finset.mem_univ cell⟩) (fun cell => Metric.diam (cells.cellRegion cell))

theorem diameter_le_mesh (cells : FiniteVolumeCellPartition Cell Point) (cell : Cell) :
    Metric.diam (cells.cellRegion cell) ≤ mesh cells := by
  unfold mesh
  exact Finset.le_sup' (fun c => Metric.diam (cells.cellRegion c)) (Finset.mem_univ cell)

theorem mesh_nonneg (cells : FiniteVolumeCellPartition Cell Point) : 0 ≤ mesh cells :=
  Metric.diam_nonneg.trans (diameter_le_mesh cells (Classical.choice cells.cells_nonempty))

theorem mesh_le_iff (cells : FiniteVolumeCellPartition Cell Point) (h : ℝ) :
    mesh cells ≤ h ↔ ∀ cell, Metric.diam (cells.cellRegion cell) ≤ h := by
  simp only [mesh, Finset.sup'_le_iff, Finset.mem_univ, forall_const]

theorem mesh_attained (cells : FiniteVolumeCellPartition Cell Point) :
    ∃ cell, mesh cells = Metric.diam (cells.cellRegion cell) := by
  obtain ⟨cell, _, he⟩ := Finset.exists_mem_eq_sup'
    (s := (Finset.univ : Finset Cell))
    (by exact ⟨Classical.choice cells.cells_nonempty, Finset.mem_univ _⟩)
    (fun cell => Metric.diam (cells.cellRegion cell))
  exact ⟨cell, he⟩

theorem dist_le_mesh (cells : FiniteVolumeCellPartition Cell Point) (cell : Cell)
    (hb : Bornology.IsBounded (cells.cellRegion cell)) {x y : Point}
    (hx : x ∈ cells.cellRegion cell) (hy : y ∈ cells.cellRegion cell) : dist x y ≤ mesh cells :=
  (Metric.dist_le_diam_of_mem hb hx hy).trans (diameter_le_mesh cells cell)

theorem mesh_pos_of_separated (cells : FiniteVolumeCellPartition Cell Point) (cell : Cell)
    (hb : Bornology.IsBounded (cells.cellRegion cell)) {x y : Point}
    (hx : x ∈ cells.cellRegion cell) (hy : y ∈ cells.cellRegion cell) (hxy : 0 < dist x y) :
    0 < mesh cells := hxy.trans_le (dist_le_mesh cells cell hb hx hy)

end CapacityPhysicalMesh

#check CapacityCoordinate.Method
#print axioms CapacityCoordinate.Method
#check CapacityCoordinate.Method.rule
#print axioms CapacityCoordinate.Method.rule
#check CapacityCoordinate.Method.Admitted
#print axioms CapacityCoordinate.Method.Admitted
#check CapacityCoordinate.Method.StableAt
#print axioms CapacityCoordinate.Method.StableAt
#check CapacityCoordinate.Method.advance_eq
#print axioms CapacityCoordinate.Method.advance_eq
#check CapacityCoordinate.Method.coordinate_stability
#print axioms CapacityCoordinate.Method.coordinate_stability
#check CapacityCoordinate.Method.projection_cell
#print axioms CapacityCoordinate.Method.projection_cell
#check CapacityCoordinate.Method.coordinate_local
#print axioms CapacityCoordinate.Method.coordinate_local
#check CapacityCoordinate.step
#print axioms CapacityCoordinate.step
#check CapacityCoordinate.run
#print axioms CapacityCoordinate.run
#check CapacityCoordinate.run_succ
#print axioms CapacityCoordinate.run_succ
#check CapacityCoordinate.run_ordered
#print axioms CapacityCoordinate.run_ordered
#check CapacityCoordinate.run_physical_error
#print axioms CapacityCoordinate.run_physical_error
#check CapacityPhysicalMesh.mesh
#print axioms CapacityPhysicalMesh.mesh
#check CapacityPhysicalMesh.diameter_le_mesh
#print axioms CapacityPhysicalMesh.diameter_le_mesh
#check CapacityPhysicalMesh.mesh_nonneg
#print axioms CapacityPhysicalMesh.mesh_nonneg
#check CapacityPhysicalMesh.mesh_le_iff
#print axioms CapacityPhysicalMesh.mesh_le_iff
#check CapacityPhysicalMesh.mesh_attained
#print axioms CapacityPhysicalMesh.mesh_attained
#check CapacityPhysicalMesh.dist_le_mesh
#print axioms CapacityPhysicalMesh.dist_le_mesh
#check CapacityPhysicalMesh.mesh_pos_of_separated
#print axioms CapacityPhysicalMesh.mesh_pos_of_separated


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

namespace CapacityGhost
open NumStability NumStability.FiniteCoordinate
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}

theorem capacity_withGhost (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (newGhost : D → Line → ℤ → Fin m → ℝ) (d : D) (line : Line) (j : ℤ) :
    PhysicalCapacityBridge.capacity data (coord.withGhost newGhost) d line j =
      PhysicalCapacityBridge.capacity data coord d line j := rfl

end CapacityGhost

namespace CapacityCoordinate.Method
open NumStability NumStability.FiniteCoordinate
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}
local notation "State" => Fin m → ℝ

/-- The new coordinate type is nominally different. Reconstruct its incidence
proofs and retain the identical numerical-flux and admission functions. -/
def withGhost (method : CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) : CapacityCoordinate.Method data (coord.withGhost newGhost) where
  incidence := ⟨method.incidence.left_line, method.incidence.right_line,
    method.incidence.left_index, method.incidence.right_index⟩
  numericalFlux := method.numericalFlux
  admitted := method.admitted

theorem withGhost_flux_admission (method : CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) :
    (method.withGhost newGhost).numericalFlux = method.numericalFlux ∧
      (method.withGhost newGhost).admitted = method.admitted := ⟨rfl, rfl⟩

/-- The physical update retains the original physical capacities and supplied
flux formula, and uses precisely the newly extracted boundary data. -/
theorem advance_withGhost_eq (method : CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    advance data (method.withGhost newGhost).rule d dt current cell =
      PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt ((coord.withGhost newGhost).extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  (method.withGhost newGhost).advance_eq d dt current cell

theorem projection_withGhost (method : CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) (d : D) (q : Point → ℝ → State) (t : ℝ) (cell : Cell) :
    (coord.withGhost newGhost).extract d (coord.cellLine d cell)
      (fun c => data.cellMean q c t) (coord.cellIndex d cell) =
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t) :=
  (method.withGhost newGhost).projection_cell d q t cell

/-- Cross-boundary-data stability uses both actual cell error and actual
missing-lookup ghost error. Both arrays must be admitted at the same dt. -/
theorem coordinate_stability_withGhost (method : CapacityCoordinate.Method data coord)
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

end CapacityCoordinate.Method

#check NumStability.FiniteCoordinate.LineCoordinates.withGhost
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost
#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_maps
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_maps
#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_self
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_self
#check NumStability.FiniteCoordinate.LineCoordinates.withGhost_withGhost
#print axioms NumStability.FiniteCoordinate.LineCoordinates.withGhost_withGhost
#check NumStability.FiniteCoordinate.LineCoordinates.extract_withGhost_error_le_max
#print axioms NumStability.FiniteCoordinate.LineCoordinates.extract_withGhost_error_le_max
#check CapacityGhost.capacity_withGhost
#print axioms CapacityGhost.capacity_withGhost
#check CapacityCoordinate.Method.withGhost
#print axioms CapacityCoordinate.Method.withGhost
#check CapacityCoordinate.Method.withGhost_flux_admission
#print axioms CapacityCoordinate.Method.withGhost_flux_admission
#check CapacityCoordinate.Method.advance_withGhost_eq
#print axioms CapacityCoordinate.Method.advance_withGhost_eq
#check CapacityCoordinate.Method.projection_withGhost
#print axioms CapacityCoordinate.Method.projection_withGhost
#check CapacityCoordinate.Method.coordinate_stability_withGhost
#print axioms CapacityCoordinate.Method.coordinate_stability_withGhost


namespace PhysicalRefinementQuality
open MeasureTheory Filter NumStability NumStability.FiniteCoordinate
open scoped BigOperators Topology
variable {D FacePoint : Type*} [Fintype D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ

/-- A refining family of actual physical meshes and supplied conservative
methods. Single-grid execution does not require this structure. The fixed
physical flux and state domain are shared by every level; normals are supplied
geometric data, and no hyperbolicity of an integrated flux is inferred. -/
structure Family (D FacePoint : Type*) [Fintype D] [MeasurableSpace FacePoint] (m : ℕ) where
  Cell : ℕ → Type
  Face : ℕ → Type
  Line : ℕ → Type
  finiteCell : ∀ n, Fintype (Cell n)
  data : ∀ n, PhysicalData D (Cell n) (Face n) (D → ℝ) FacePoint m
  coordinates : ∀ n, LineCoordinates (m := m) D (Cell n) (Face n) (Line n)
  method : ∀ n, CapacityCoordinate.Method (data n) (coordinates n)
  measure : Measure (D → ℝ)
  measure_eq : ∀ n, (data n).measure = measure
  states : D → Set (Fin m → ℝ)
  states_nonempty : ∀ d, (states d).Nonempty
  states_eq : ∀ n d, (data n).admissibleStates d = states d
  physicalFlux : (D → ℝ) → (Fin m → ℝ) → D → Fin m → ℝ
  normal : ∀ n, D → Face n → FacePoint → D → ℝ
  normal_flux_eq : ∀ n d face point state,
    (data n).normalFlux d face point state =
      ∑ k, normal n d face point k • physicalFlux ((data n).facePoint d face point) state k
  region : Set (D → ℝ)
  target : Set (D → ℝ)
  target_interior_nonempty : (interior target).Nonempty
  target_inside : target ⊆ region
  active_inside : ∀ n cell, (data n).cells.cellRegion cell ⊆ region
  target_covered : ∀ n x, x ∈ target → ∃ cell, x ∈ (data n).cells.cellRegion cell
  bounded_cells : ∀ n cell, Bornology.IsBounded ((data n).cells.cellRegion cell)
  mesh : ℕ → ℝ
  mesh_actual : ∀ n, mesh n = (by
    letI := finiteCell n
    exact CapacityPhysicalMesh.mesh (data n).cells)
  mesh_pos : ∀ n, 0 < mesh n
  mesh_tendsto : Tendsto mesh atTop (𝓝 0)
  horizon : ℝ
  horizon_pos : 0 < horizon
  boundaryRegion : ∀ n, D → Line n → ℤ → Set (D → ℝ)
  boundary_measurable : ∀ n d line j, MeasurableSet (boundaryRegion n d line j)
  boundary_positive : ∀ n d line j, measure (boundaryRegion n d line j) ≠ 0
  boundary_finite : ∀ n d line j, measure (boundaryRegion n d line j) ≠ ⊤
  boundary_inside : ∀ n d line j, boundaryRegion n d line j ⊆ region

variable (family : Family D FacePoint m)

namespace Family

/-- Exact reference boundary data are measured averages of the supplied
boundary regions. They are inputs, not fictitious active physical cells. -/
noncomputable def referenceGhost (n : ℕ) (q : Point → ℝ → State) :
    D → family.Line n → ℤ → State :=
  fun d line j => cellVolumeAverage family.measure (family.boundaryRegion n d line j)
    (fun x => q x 0)

noncomputable def projected (n : ℕ) (q : Point → ℝ → State) (t : ℝ) : family.Cell n → State :=
  fun cell => (family.data n).cellMean q cell t

/-- Genuine smoothness includes incident boundary points. The reference is
fixed before the refinement level and obeys the same measured physical law
at every level. Boundary integrability is stated separately and explicitly. -/
def SmoothReference (d : D) (q : Point → ℝ → State) : Prop :=
  ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry q)
    (closure family.region ×ˢ Set.Icc 0 family.horizon) ∧
  (∀ n, (family.data n).ReferenceOn d q 0 family.horizon) ∧
  (∀ n line j, IntegrableOn (fun x => q x 0)
    (family.boundaryRegion n d line j) family.measure)

/-- One physical reference, one constant and one threshold. The certificate
is chosen before any later mesh level, time step or coordinate execution. -/
structure AccuracyCertificate (d : D) (q : Point → ℝ → State) (p : ℝ) where
  constant : ℝ
  constant_nonneg : 0 ≤ constant
  threshold : ℕ
  projection_available : ∀ n, threshold ≤ n → ∃ dt : ℝ,
    0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
        (family.projected n q 0)
  bound : ∀ n, threshold ≤ n → ∀ dt : ℝ, 0 < dt → dt ≤ family.horizon →
    ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0) → ∀ cell,
    ‖advance (family.data n) ((family.method n).withGhost (family.referenceGhost n q)).rule
        d dt (family.projected n q 0) cell - family.projected n q dt cell‖ ≤
      constant * dt * family.mesh n ^ p

/-- Quantitative variation along actual coordinate adjacency. Each internal
edge is counted once as a left edge; a right exterior edge is added only when
the next physical lookup is absent. Both boundary sides are retained. -/
noncomputable def variation (n : ℕ) (d : D) (line : family.Line n)
    (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State) : ℝ := by
  classical
  letI := family.finiteCell n
  let coord := (family.coordinates n).withGhost ghost
  exact ∑ cell, if coord.cellLine d cell = line then
    ‖current cell - coord.extract d line current (coord.cellIndex d cell - 1)‖ +
      (if coord.lookup d line (coord.cellIndex d cell + 1) = none then
        ‖coord.extract d line current (coord.cellIndex d cell + 1) - current cell‖ else 0) else 0

/-- Core quality contains higher smooth order, quantitative oscillation
control and a nonempty time-step domain for every admissible physical input.
It imposes no pairwise perturbation stability and no fixed CFL coefficient. -/
structure HasHighResolution : Prop where
  input_available : ∀ n d (ghost : D → family.Line n → ℤ → State)
    (current : family.Cell n → State),
    (∀ cell, current cell ∈ family.states d) →
    (∀ line j, (family.coordinates n).lookup d line j = none → ghost d line j ∈ family.states d) →
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost ghost).Admitted d dt current
  order : ∀ d, ∃ p : ℝ, 1 < p ∧ ∀ q : Point → ℝ → State,
    family.SmoothReference d q → Nonempty (family.AccuracyCertificate d q p)
  oscillation : ∀ d, ∃ K : ℝ, 0 ≤ K ∧ ∃ noise : ℕ → ℝ,
    (∀ n, 0 ≤ noise n) ∧ Tendsto noise atTop (𝓝 0) ∧
    ∀ n (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State)
      (dt : ℝ), 0 < dt → dt ≤ family.horizon →
      ((family.method n).withGhost ghost).Admitted d dt current → ∀ line,
      family.variation n d line ghost
          (advance (family.data n) ((family.method n).withGhost ghost).rule d dt current) ≤
        (1 + K * dt) * family.variation n d line ghost current + dt * noise n

/-- Every two-state physical array, with admissible supplied boundary inputs,
has an actual positive admitted step. The side predicate may describe a jump. -/
theorem HasHighResolution.two_state_available (quality : family.HasHighResolution)
    (n : ℕ) (d : D) (ghost : D → family.Line n → ℤ → State)
    (left right : State) (hl : left ∈ family.states d) (hr : right ∈ family.states d)
    (side : family.Cell n → Prop) [DecidablePred side]
    (hg : ∀ line j, (family.coordinates n).lookup d line j = none → ghost d line j ∈ family.states d) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method n).withGhost ghost).Admitted d dt (fun cell => if side cell then left else right) := by
  apply quality.input_available n d ghost _ _ hg
  intro cell
  split <;> assumption

/-- The certificate's own fixed threshold admits an exact physical projection.
No selected execution can defeat this assertion by choosing a later threshold. -/
theorem AccuracyCertificate.available_at_threshold {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      ((family.method certificate.threshold).withGhost
        (family.referenceGhost certificate.threshold q)).Admitted d dt
          (family.projected certificate.threshold q 0) :=
  certificate.projection_available certificate.threshold le_rfl

/-- Optional stability transfers the same fixed certificate to actual cell
and boundary inputs. Both inputs use the same admitted time step; existence
of a different admissible step does not satisfy these premises. -/
theorem AccuracyCertificate.perturbed_at {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) (n : ℕ) (hn : certificate.threshold ≤ n)
    (dt : ℝ) (hdt : 0 < dt) (hT : dt ≤ family.horizon)
    (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State)
    (hactual : ((family.method n).withGhost ghost).Admitted d dt current)
    (hprojected : ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0))
    (A E G : ℝ) (hstable : (family.method n).StableAt d dt A)
    (hcell : ∀ cell, ‖current cell - family.projected n q 0 cell‖ ≤ E)
    (hghost : ∀ cell j,
      (family.coordinates n).lookup d ((family.coordinates n).cellLine d cell) j = none →
      ‖ghost d ((family.coordinates n).cellLine d cell) j -
        family.referenceGhost n q d ((family.coordinates n).cellLine d cell) j‖ ≤ G)
    (cell : family.Cell n) :
    ‖advance (family.data n) ((family.method n).withGhost ghost).rule d dt current cell -
      family.projected n q dt cell‖ ≤
        A * max E G + certificate.constant * dt * family.mesh n ^ p := by
  have hs := (family.method n).coordinate_stability_withGhost ghost (family.referenceGhost n q)
    d dt A hstable current (family.projected n q 0) hactual hprojected E G hcell hghost cell
  have ha := certificate.bound n hn dt hdt hT hprojected cell
  exact (norm_sub_le_norm_sub_add_norm_sub _ _ _).trans (add_le_add hs ha)

end Family
end PhysicalRefinementQuality


#check PhysicalRefinementQuality.Family
#print axioms PhysicalRefinementQuality.Family
#check PhysicalRefinementQuality.Family.referenceGhost
#print axioms PhysicalRefinementQuality.Family.referenceGhost
#check PhysicalRefinementQuality.Family.projected
#print axioms PhysicalRefinementQuality.Family.projected
#check PhysicalRefinementQuality.Family.SmoothReference
#print axioms PhysicalRefinementQuality.Family.SmoothReference
#check PhysicalRefinementQuality.Family.AccuracyCertificate
#print axioms PhysicalRefinementQuality.Family.AccuracyCertificate
#check PhysicalRefinementQuality.Family.variation
#print axioms PhysicalRefinementQuality.Family.variation
#check PhysicalRefinementQuality.Family.HasHighResolution
#print axioms PhysicalRefinementQuality.Family.HasHighResolution
#check PhysicalRefinementQuality.Family.HasHighResolution.two_state_available
#print axioms PhysicalRefinementQuality.Family.HasHighResolution.two_state_available
#check PhysicalRefinementQuality.Family.AccuracyCertificate.available_at_threshold
#print axioms PhysicalRefinementQuality.Family.AccuracyCertificate.available_at_threshold
#check PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at
#print axioms PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at


namespace CapacityZeroFlux
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

theorem faceFlux_zero (data : PhysicalData D Cell Face Point FacePoint m) (d : D)
    (hzero : ∀ face point state, data.normalFlux d face point state = 0)
    (q : Point → ℝ → State) (face : Face) (t : ℝ) : data.faceFlux d q face t = 0 := by
  simp [PhysicalData.faceFlux, hzero]

/-- Zero actual physical face fluxes force every measured cell mean to remain
constant on the reference slab. No differentiability recovery is used. -/
theorem cellMean_eq (data : PhysicalData D Cell Face Point FacePoint m) (d : D)
    (q : Point → ℝ → State) {s t : ℝ} (href : data.ReferenceOn d q s t)
    (hzero : ∀ face τ, data.faceFlux d q face τ = 0)
    {u v : ℝ} (hu : u ∈ Set.uIcc s t) (hv : v ∈ Set.uIcc s t) (cell : Cell) :
    data.cellMean q cell v = data.cellMean q cell u := by
  have hb := (href.2.2.2 u hu v hv).2 cell
  have hz : data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) = 0 := by
    simpa only [hzero, sub_self, intervalIntegral.integral_zero] using hb
  have he := congrArg (fun value : State => (data.cellVolume cell)⁻¹ • value) hz
  have hdiff : data.cellMean q cell v - data.cellMean q cell u = 0 := by
    simpa only [smul_smul, inv_mul_cancel₀ (data.cellVolume_pos cell).ne', one_smul, smul_zero] using he
  exact sub_eq_zero.mp hdiff

def method (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord) : CapacityCoordinate.Method data coord where
  incidence := incidence
  numericalFlux := fun _ _ _ _ _ => 0
  admitted := fun _ _ _ _ => True

variable (data : PhysicalData D Cell Face Point FacePoint m)
variable (coord : LineCoordinates (m := m) D Cell Face Line)
variable (incidence : PhysicalCapacityBridge.Incidence data coord)

theorem lineAdvance_eq (d : D) (line : Line) (dt : ℝ) (values : ℤ → State) :
    PhysicalCapacityBridge.lineAdvance data coord (method data coord incidence).numericalFlux d line dt values =
      values := by
  funext j
  simp [PhysicalCapacityBridge.lineAdvance, method, finiteVolumeCellAverageUpdate]

theorem advance_eq (d : D) (dt : ℝ) (current : Cell → State) :
    advance data (method data coord incidence).rule d dt current = current := by
  funext cell
  simp [advance, method, CapacityCoordinate.Method.rule, PhysicalCapacityBridge.faceRule,
    finiteVolumeCellAverageUpdate]

theorem advance_withGhost_eq (ghost : D → Line → ℤ → State) (d : D) (dt : ℝ)
    (current : Cell → State) :
    advance data ((method data coord incidence).withGhost ghost).rule d dt current = current := by
  funext cell
  simp [advance, method, CapacityCoordinate.Method.withGhost, CapacityCoordinate.Method.rule,
    PhysicalCapacityBridge.faceRule, finiteVolumeCellAverageUpdate]

theorem admitted (d : D) (dt : ℝ) (current : Cell → State) :
    (method data coord incidence).Admitted d dt current := by intro cell; trivial

theorem admitted_withGhost (ghost : D → Line → ℤ → State) (d : D) (dt : ℝ)
    (current : Cell → State) : ((method data coord incidence).withGhost ghost).Admitted d dt current := by
  intro cell
  trivial

theorem stable (d : D) (dt : ℝ) : (method data coord incidence).StableAt d dt 1 := by
  intro cell values other _ _ E _ herr
  simpa only [lineAdvance_eq, one_mul] using herr (coord.cellIndex d cell)

theorem stable_withGhost (ghost : D → Line → ℤ → State) (d : D) (dt : ℝ) :
    ((method data coord incidence).withGhost ghost).StableAt d dt 1 := by
  intro cell values other _ _ E _ herr
  simpa [PhysicalCapacityBridge.lineAdvance, method, CapacityCoordinate.Method.withGhost,
    finiteVolumeCellAverageUpdate] using herr (coord.cellIndex d cell)

theorem positive_available (ghost : D → Line → ℤ → State) (d : D) (current : Cell → State)
    (horizon : ℝ) (hH : 0 < horizon) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ horizon ∧
      ((method data coord incidence).withGhost ghost).Admitted d dt current :=
  ⟨horizon, hH, le_rfl, admitted_withGhost data coord incidence ghost d horizon current⟩

/-- Every physical reference of the zero-flux law is reproduced at the level
of its actual measured cell averages, with arbitrary supplied ghosts. -/
theorem exact_reference (ghost : D → Line → ℤ → State) (d : D) (q : Point → ℝ → State)
    {horizon dt : ℝ} (href : data.ReferenceOn d q 0 horizon)
    (hzero : ∀ face τ, data.faceFlux d q face τ = 0) (hdt : 0 < dt) (hT : dt ≤ horizon) :
    advance data ((method data coord incidence).withGhost ghost).rule d dt
      (fun cell => data.cellMean q cell 0) = fun cell => data.cellMean q cell dt := by
  rw [advance_withGhost_eq]
  funext cell
  exact (cellMean_eq data d q href hzero Set.left_mem_uIcc (Set.mem_uIcc_of_le hdt.le hT) cell).symm

theorem norm_error_zero (ghost : D → Line → ℤ → State) (d : D) (q : Point → ℝ → State)
    {horizon dt : ℝ} (href : data.ReferenceOn d q 0 horizon)
    (hzero : ∀ face τ, data.faceFlux d q face τ = 0) (hdt : 0 < dt) (hT : dt ≤ horizon)
    (cell : Cell) :
    ‖advance data ((method data coord incidence).withGhost ghost).rule d dt
      (fun c => data.cellMean q c 0) cell - data.cellMean q cell dt‖ = 0 := by
  rw [exact_reference data coord incidence ghost d q href hzero hdt hT]
  simp

end CapacityZeroFlux

namespace CapacityZeroFlux
open NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*} {m : ℕ}
local notation "State" => Fin m → ℝ

/-- The same once-per-left-edge sum as the physical-quality interface, with
an extra right edge only at missing next lookup. No ghost is an active cell. -/
noncomputable def onceEdgeVariation [Fintype Cell]
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line)
    (ghost : D → Line → ℤ → State) (current : Cell → State) : ℝ := by
  classical
  let actual := coord.withGhost ghost
  exact ∑ cell, if actual.cellLine d cell = line then
    ‖current cell - actual.extract d line current (actual.cellIndex d cell - 1)‖ +
      (if actual.lookup d line (actual.cellIndex d cell + 1) = none then
        ‖actual.extract d line current (actual.cellIndex d cell + 1) - current cell‖ else 0) else 0

variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint]

theorem variation_eq [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord)
    (ghost : D → Line → ℤ → State) (d : D) (line : Line) (dt : ℝ) (current : Cell → State) :
    onceEdgeVariation coord d line ghost
      (advance data ((method data coord incidence).withGhost ghost).rule d dt current) =
      onceEdgeVariation coord d line ghost current := by
  rw [advance_withGhost_eq]

end CapacityZeroFlux


namespace PhysicalRefinementQuality.Family
open MeasureTheory Filter NumStability NumStability.FiniteCoordinate
open scoped BigOperators Topology
variable {D FacePoint : Type*} [Fintype D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ

/-- The zero-flux method is a complete core-quality instance on every actual
refinement geometry. The physical reference class remains the entire genuine
smooth class of the shared law; its measured means are constant by conservation. -/
theorem zero_flux_quality (family : Family D FacePoint m)
    (hnum : ∀ n d line dt values j, (family.method n).numericalFlux d line dt values j = 0)
    (hadmit : ∀ n d line dt values, (family.method n).admitted d line dt values)
    (hphysical : ∀ n d face point state, (family.data n).normalFlux d face point state = 0) :
    family.HasHighResolution := by
  have admitted : ∀ n d ghost dt current,
      ((family.method n).withGhost ghost).Admitted d dt current := by
    intro n d ghost dt current cell
    exact hadmit n d _ dt _
  have identity : ∀ n d ghost dt current,
      advance (family.data n) ((family.method n).withGhost ghost).rule d dt current = current := by
    intro n d ghost dt current
    funext cell
    simp [advance, CapacityCoordinate.Method.withGhost, CapacityCoordinate.Method.rule,
      PhysicalCapacityBridge.faceRule, hnum, finiteVolumeCellAverageUpdate]
  refine ⟨?_, ?_, ?_⟩
  · intro n d ghost current _ _
    exact ⟨family.horizon, family.horizon_pos, le_rfl,
      admitted n d ghost family.horizon current⟩
  · intro d
    refine ⟨2, by norm_num, ?_⟩
    intro q hq
    refine ⟨{
      constant := 0
      constant_nonneg := le_rfl
      threshold := 0
      projection_available := ?_
      bound := ?_ }⟩
    · intro n _
      exact ⟨family.horizon, family.horizon_pos, le_rfl,
        admitted n d (family.referenceGhost n q) family.horizon (family.projected n q 0)⟩
    · intro n _ dt hdt hT _ cell
      rw [identity]
      have hface : ∀ face τ, (family.data n).faceFlux d q face τ = 0 :=
        fun face τ => CapacityZeroFlux.faceFlux_zero (family.data n) d (hphysical n d) q face τ
      have hmean := CapacityZeroFlux.cellMean_eq (family.data n) d q (hq.2.1 n) hface
        Set.left_mem_uIcc (Set.mem_uIcc_of_le hdt.le hT) cell
      change ‖(family.data n).cellMean q cell 0 - (family.data n).cellMean q cell dt‖ ≤ _
      rw [hmean]
      simp
  · intro d
    refine ⟨0, le_rfl, fun _ => 0, fun _ => le_rfl, tendsto_const_nhds, ?_⟩
    intro n ghost current dt _ _ _ line
    rw [identity]
    simp

/-- The zero-flux family's perturbation stability is proved separately from
core quality. No stability requirement has been inserted into that definition. -/
theorem zero_flux_stable (family : Family D FacePoint m)
    (hnum : ∀ n d line dt values j, (family.method n).numericalFlux d line dt values j = 0)
    (n : ℕ) (d : D) (dt : ℝ) : (family.method n).StableAt d dt 1 := by
  intro cell values other _ _ E _ herr
  simpa [PhysicalCapacityBridge.lineAdvance, hnum, finiteVolumeCellAverageUpdate] using
    herr ((family.coordinates n).cellIndex d cell)

end PhysicalRefinementQuality.Family

#check PhysicalRefinementQuality.Family.zero_flux_quality
#print axioms PhysicalRefinementQuality.Family.zero_flux_quality
#check PhysicalRefinementQuality.Family.zero_flux_stable
#print axioms PhysicalRefinementQuality.Family.zero_flux_stable


-- New checks occur in the frozen authored fragment.


namespace CapacitySmallBias
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

/-- A constant flux has its actual zero derivative and a complete real
standard eigenbasis; no strict separation of wave speeds is needed. -/
theorem constantFlux_hyperbolic (constant : State) (states : Set State) :
    IsHyperbolicFluxOn (fun _ : State => constant) states := by
  intro state _
  refine ⟨0, hasFDerivAt_const constant state, fun _ => 0, Pi.basisFun ℝ (Fin m), ?_⟩
  intro p
  simp [Matrix.col]
  rfl

end CapacitySmallBias

namespace RefiningCartesianWitness
open NumStability MeasureTheory Set Filter
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators Topology

abbrev Direction := Fin 2
abbrev State := Fin 1 → ℝ
abbrev Position := Direction → ℤ
abbrev Point := Direction → ℝ

noncomputable def h (n : ℕ) : ℝ := HighResolutionAdvectionLine.h n
theorem h_pos (n : ℕ) : 0 < h n := HighResolutionAdvectionLine.h_pos n
theorem h_tendsto : Tendsto h atTop (𝓝 0) := HighResolutionAdvectionLine.h_tendsto_zero

noncomputable def active (n : ℕ) : Finset Position :=
  Fintype.piFinset (fun _ => Finset.Ico (0 : ℤ) (n + 4))
abbrev Cell (n : ℕ) := ↥(active n)

theorem mem_active (n : ℕ) (p : Position) :
    p ∈ active n ↔ ∀ d, 0 ≤ p d ∧ p d < n + 4 := by
  simp [active, Fintype.mem_piFinset]

theorem active_nonempty (n : ℕ) : (active n).Nonempty :=
  ⟨0, (mem_active n _).2 (by intro d; constructor; simp; change (0 : ℤ) < n + 4; omega)⟩

theorem cell_index_bounds (n : ℕ) (cell : Cell n) (d : Direction) :
    0 ≤ cell.val d ∧ cell.val d < n + 4 := (mem_active n _).1 cell.property d

theorem active_card (n : ℕ) : (active n).card = (n + 4)^2 := by
  simp [active]
  omega

noncomputable def axes (n : ℕ) : Direction → OneDimensionalFiniteVolumeGrid :=
  fun _ => (HighResolutionAdvectionLine.family 1).grid n

theorem axis_left (n : ℕ) (d : Direction) (j : ℤ) :
    (axes n d).cellLeft j = ((j : ℝ) - 1) * h n := rfl
theorem axis_right (n : ℕ) (d : Direction) (j : ℤ) :
    (axes n d).cellRight j = (j : ℝ) * h n := rfl
theorem axis_volume (n : ℕ) (d : Direction) (j : ℤ) :
    (axes n d).cellVolume j = h n :=
  CFLUnitShift.grid_volume (h n) (h_pos n) j

theorem identity_hyperbolic : ∀ _ : Direction, IsHyperbolicFluxOn (id : State → State) univ := by
  intro d state hs
  exact (HighResolutionAdvectionLine.family 1).hyperbolic 0
    (by norm_num [HighResolutionAdvectionLine.family]) state hs

noncomputable def physical (n : ℕ) : PhysicalData Direction (Cell n) Position Point Point 1 :=
  data (axes n) (active n) (active_nonempty n) (fun _ => univ) (fun _ => id)
    identity_hyperbolic

theorem physical_volume (n : ℕ) (cell : Cell n) :
    (physical n).cellVolume cell = h n ^ 2 := by
  rw [physical, data_cellVolume]
  simp [CartesianGrid.cellVolume, axis_volume, pow_two]

theorem physical_area (n : ℕ) (d : Direction) (face : Position) :
    ((physical n).faceMeasure d face univ).toReal = h n := by
  change (faceMeasure (axes n) d face univ).toReal = _
  rw [faceMeasure_area]
  fin_cases d <;> simp [CartesianGrid.faceArea, axis_volume]

def target : Set Point := Set.pi univ (fun _ => Ioo (0 : ℝ) 1)
def region : Set Point := Set.pi univ (fun _ => Icc (-2 : ℝ) 2)

theorem target_nonempty : target.Nonempty := by
  refine ⟨fun _ => 1/2, ?_⟩
  norm_num [target]

theorem target_open : IsOpen target := isOpen_set_pi finite_univ (fun _ _ => isOpen_Ioo)

theorem target_inside : target ⊆ interior region := by
  apply target_open.subset_interior_iff.mpr
  intro x hx
  simp only [target, mem_univ_pi, mem_Ioo] at hx
  simp only [region, mem_univ_pi, mem_Icc]
  intro d
  constructor <;> linarith [(hx d).1, (hx d).2]

theorem active_inside (n : ℕ) (cell : Cell n) :
    (physical n).cells.cellRegion cell ⊆ region := by
  intro x hx
  change x ∈ CartesianGrid.cellBox (axes n) cell.val at hx
  simp only [CartesianGrid.cellBox, mem_univ_pi, mem_Ico] at hx
  simp only [region, mem_univ_pi, mem_Icc]
  intro d
  have hb := cell_index_bounds n cell d
  have hh := HighResolutionAdvectionLine.input_geometry n (cell.val d)
    (by simp only [Finset.mem_Ico, Nat.cast_add, Nat.cast_ofNat]; omega)
  exact ⟨hh.1.trans (hx d).1, (hx d).2.le.trans hh.2⟩

theorem axis_coverage (n : ℕ) (x : ℝ) (hx : x ∈ Icc (0 : ℝ) 1) :
    ∃ j ∈ Finset.Ico (0 : ℤ) (n + 4),
      x ∈ Ico ((axes n 0).cellLeft j) ((axes n 0).cellRight j) := by
  let k : ℤ := ⌊x * ((n : ℝ) + 2)⌋
  have hk0 : 0 ≤ k := Int.floor_nonneg.mpr (mul_nonneg hx.1 (by positivity))
  have hkle := Int.floor_le (x * ((n : ℝ) + 2))
  have hklt := Int.lt_floor_add_one (x * ((n : ℝ) + 2))
  have hkmax : k ≤ (n : ℤ) + 2 := by
    have hkr : (k : ℝ) ≤ (n : ℝ) + 2 := by
      dsimp [k]
      nlinarith [mul_le_mul_of_nonneg_right hx.2 (show 0 ≤ (n : ℝ) + 2 by positivity)]
    exact_mod_cast hkr
  refine ⟨k + 1, ?_, ?_⟩
  · simp only [Finset.mem_Ico]; omega
  · rw [axis_left, axis_right]
    simp only [Int.cast_add, Int.cast_one, add_sub_cancel_right]
    have hl := mul_le_mul_of_nonneg_right hkle (h_pos n).le
    have hr := mul_lt_mul_of_pos_right hklt (h_pos n)
    have he : h n * ((n : ℝ) + 2) = 1 := HighResolutionAdvectionLine.h_mul n
    have heq : (x * ((n : ℝ) + 2)) * h n = x := by
      calc
        _ = x * (h n * ((n : ℝ) + 2)) := by ring
        _ = x := by rw [he, mul_one]
    dsimp [k] at *
    constructor <;> nlinarith

theorem target_covered (n : ℕ) (x : Point) (hx : x ∈ target) :
    ∃ cell : Cell n, x ∈ (physical n).cells.cellRegion cell := by
  simp only [target, mem_univ_pi, mem_Ioo] at hx
  have cov (d : Direction) := axis_coverage n (x d) ⟨(hx d).1.le, (hx d).2.le⟩
  choose pos hpos hmem using cov
  have ha : pos ∈ active n := (mem_active n _).2 (by
    intro d; exact Finset.mem_Ico.mp (hpos d))
  refine ⟨⟨pos, ha⟩, ?_⟩
  change x ∈ CartesianGrid.cellBox (axes n) pos
  simpa only [CartesianGrid.cellBox, mem_univ_pi] using hmem

theorem box_bounded (n : ℕ) (pos : Position) :
    Bornology.IsBounded (CartesianGrid.cellBox (axes n) pos) := by
  have hb : Bornology.IsBounded (Set.pi univ
      (fun d => Icc ((axes n d).cellLeft (pos d)) ((axes n d).cellRight (pos d)))) :=
    (isCompact_univ_pi (fun _ => isCompact_Icc)).isBounded
  apply hb.subset
  intro x hx d hd
  exact ⟨(hx d hd).1, (hx d hd).2.le⟩

theorem box_diameter_le (n : ℕ) (pos : Position) :
    Metric.diam (CartesianGrid.cellBox (axes n) pos) ≤ h n := by
  apply ENNReal.toReal_le_of_le_ofReal (h_pos n).le
  apply Metric.ediam_pi_le_of_le
  intro d
  rw [Real.ediam_Ico]
  have he : (axes n d).cellRight (pos d) - (axes n d).cellLeft (pos d) = h n := by
    rw [axis_left, axis_right]; ring
  rw [he]

noncomputable def actualMesh (n : ℕ) : ℝ := CapacityPhysicalMesh.mesh (physical n).cells

theorem actualMesh_le (n : ℕ) : actualMesh n ≤ h n := by
  apply (CapacityPhysicalMesh.mesh_le_iff _ _).2
  intro cell
  exact box_diameter_le n cell.val

theorem actualMesh_nonneg (n : ℕ) : 0 ≤ actualMesh n := CapacityPhysicalMesh.mesh_nonneg _

theorem actualMesh_positive (n : ℕ) : 0 < actualMesh n := by
  let cell : Cell n := ⟨0, (mem_active n _).2 (by intro d; constructor; simp; change (0 : ℤ) < n + 4; omega)⟩
  let x : Point := fun _ => -h n
  let y : Point := fun _ => -h n / 2
  have hx : x ∈ (physical n).cells.cellRegion cell := by
    change x ∈ CartesianGrid.cellBox (axes n) 0
    simp only [CartesianGrid.cellBox, mem_univ_pi, mem_Ico, axis_left, axis_right]
    intro d
    dsimp [x]
    have hh := h_pos n
    constructor
    · norm_num
    · norm_num; linarith
  have hy : y ∈ (physical n).cells.cellRegion cell := by
    change y ∈ CartesianGrid.cellBox (axes n) 0
    simp only [CartesianGrid.cellBox, mem_univ_pi, mem_Ico, axis_left, axis_right]
    intro d
    dsimp [y]
    have hh := h_pos n
    constructor <;> norm_num <;> linarith
  apply CapacityPhysicalMesh.mesh_pos_of_separated _ cell (box_bounded n 0) hx hy
  apply dist_pos.mpr
  intro he
  have he0 := congrFun he (0 : Direction)
  dsimp [x, y] at he0
  linarith [h_pos n]

theorem actualMesh_tendsto : Tendsto actualMesh atTop (𝓝 0) :=
  squeeze_zero actualMesh_nonneg actualMesh_le h_tendsto

end RefiningCartesianWitness

namespace RefiningCartesianWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators

/-- Geometry is independent of the selected state law. The hyperbolicity
premise is the existing canonical pointwise directional-flux condition. -/
noncomputable def physicalWith (n : ℕ) (flux : Direction → State → State)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) univ) :
    PhysicalData Direction (Cell n) Position Point Point 1 :=
  data (axes n) (active n) (active_nonempty n) (fun _ => univ) flux hflux

theorem physicalWith_cells (n : ℕ) (flux : Direction → State → State)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) univ) :
    (physicalWith n flux hflux).cells = (physical n).cells := rfl

theorem physicalWith_measure (n : ℕ) (flux : Direction → State → State)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) univ) :
    (physicalWith n flux hflux).measure = volume := rfl

def tensorFlux (flux : Direction → State → State) : Point → State → Direction → State :=
  fun _ q d => flux d q

def normal (d : Direction) : Direction → ℝ := fun k => if k = d then 1 else 0

theorem physical_normal_flux (n : ℕ) (flux : Direction → State → State)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) univ)
    (d : Direction) (face : Position) (point : Point) (state : State) :
    (physicalWith n flux hflux).normalFlux d face point state =
      ∑ k, normal d k • tensorFlux flux ((physicalWith n flux hflux).facePoint d face point) state k := by
  simp [physicalWith, data, normal, tensorFlux]

/-- Only finite active and one-cell neighboring indices are physical inputs.
The clamp provides genuine bounded filler cells at never-read totalized slots. -/
def boundaryIndex (n : ℕ) (j : ℤ) : ℤ := min (max j (-1)) (n + 4)
def boundaryPosition (n : ℕ) (pos : Position) : Position := fun d => boundaryIndex n (pos d)
def boundaryRegion (n : ℕ) (d : Direction) (line : Position) (j : ℤ) : Set Point :=
  CartesianGrid.cellBox (axes n) (boundaryPosition n (Function.update line d j))

theorem boundaryIndex_bounds (n : ℕ) (j : ℤ) :
    -1 ≤ boundaryIndex n j ∧ boundaryIndex n j ≤ n + 4 := by
  simp only [boundaryIndex]
  constructor
  · exact le_min (le_max_right _ _) (by omega)
  · exact min_le_right _ _

theorem boundaryIndex_eq (n : ℕ) (j : ℤ) (hj : -1 ≤ j ∧ j ≤ n + 4) :
    boundaryIndex n j = j := by
  rw [boundaryIndex, max_eq_left hj.1, min_eq_left hj.2]

theorem boundaryPosition_eq (n : ℕ) (pos : Position)
    (hp : ∀ d, -1 ≤ pos d ∧ pos d ≤ n + 4) : boundaryPosition n pos = pos := by
  funext d
  exact boundaryIndex_eq n (pos d) (hp d)

theorem extended_box_inside (n : ℕ) (pos : Position)
    (hp : ∀ d, -1 ≤ pos d ∧ pos d ≤ n + 4) :
    CartesianGrid.cellBox (axes n) pos ⊆ region := by
  intro x hx
  simp only [CartesianGrid.cellBox, mem_univ_pi, mem_Ico] at hx
  simp only [region, mem_univ_pi, mem_Icc]
  intro d
  have hpl : (-1 : ℝ) ≤ (pos d : ℝ) := by exact_mod_cast (hp d).1
  have hpr : (pos d : ℝ) ≤ (n : ℝ) + 4 := by exact_mod_cast (hp d).2
  have hh := h_pos n
  have hb : h n ≤ 1/2 := HighResolutionAdvectionLine.h_le_half n
  have he : h n * ((n : ℝ)+2) = 1 := HighResolutionAdvectionLine.h_mul n
  have hl := mul_le_mul_of_nonneg_right hpl hh.le
  have hr := mul_le_mul_of_nonneg_right hpr hh.le
  have hx' := hx d
  rw [axis_left, axis_right] at hx'
  constructor <;> nlinarith

theorem boundary_inside (n : ℕ) (d : Direction) (line : Position) (j : ℤ) :
    boundaryRegion n d line j ⊆ region :=
  extended_box_inside n _ (fun _ => boundaryIndex_bounds n _)

theorem boundary_measurable (n : ℕ) (d : Direction) (line : Position) (j : ℤ) :
    MeasurableSet (boundaryRegion n d line j) := cellBox_measurable _ _

theorem boundary_volume (n : ℕ) (d : Direction) (line : Position) (j : ℤ) :
    (volume (boundaryRegion n d line j)).toReal = h n ^ 2 := by
  rw [boundaryRegion, CartesianGrid.cellBox_volume]
  simp [CartesianGrid.cellVolume, axis_volume, pow_two]

theorem boundary_positive_finite (n : ℕ) (d : Direction) (line : Position) (j : ℤ) :
    0 < volume (boundaryRegion n d line j) ∧ volume (boundaryRegion n d line j) < ⊤ := by
  apply ENNReal.toReal_pos_iff.mp
  rw [boundary_volume]
  exact pow_pos (h_pos n) 2

/-- Every actually read neighboring index retains its actual Cartesian box;
the off-domain totalization is absent from this equality. -/
theorem boundary_on_neighbor (n : ℕ) (cell : Cell n) (d : Direction) (j : ℤ)
    (hj : cell.val d - 1 ≤ j ∧ j ≤ cell.val d + 1) :
    boundaryRegion n d (Function.update cell.val d 0) j =
      CartesianGrid.cellBox (axes n) (Function.update cell.val d j) := by
  unfold boundaryRegion
  rw [Function.update_idem]
  congr 1
  apply boundaryPosition_eq
  intro k
  by_cases he : k = d
  · subst k
    simp only [Function.update_self]
    have hb := cell_index_bounds n cell d
    constructor <;> omega
  · rw [Function.update_of_ne he]
    have hb := cell_index_bounds n cell k
    constructor <;> omega

end RefiningCartesianWitness

namespace RefiningCartesianWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators

noncomputable def coord (n : ℕ) (ghost : Direction → Position → ℤ → State) :
    LineCoordinates (m := 1) Direction (Cell n) Position Position where
  cellLine := fun d cell => Function.update cell.val d 0
  cellIndex := fun d cell => cell.val d
  faceLine := fun d face => Function.update face d 0
  faceIndex := fun d face => face d
  lookup := fun d line j =>
    if hs : line d = 0 ∧ Function.update line d j ∈ active n then
      some ⟨Function.update line d j, hs.2⟩ else none
  lookup_cell := by
    intro d cell
    have hs : (Function.update cell.val d 0) d = 0 ∧
        Function.update (Function.update cell.val d 0) d (cell.val d) ∈ active n := by
      simp [cell.property]
    rw [dif_pos hs]
    congr 1
    apply Subtype.ext
    simp
  lookup_sound := by
    intro d line j cell he
    split at he
    next hs =>
      have hc := Option.some.inj he
      subst cell
      constructor
      · simp only [Function.update_idem]
        rw [← hs.1, Function.update_eq_self]
      · simp
    next => contradiction
  ghost := ghost

theorem incidence (n : ℕ) (ghost : Direction → Position → ℤ → State) :
    PhysicalCapacityBridge.Incidence (physical n) (coord n ghost) where
  left_line := fun _ _ => rfl
  right_line := by intro d cell; simp [coord, physical, data]
  left_index := fun _ _ => rfl
  right_index := by intro d cell; simp [coord, physical, data]

/-- This is the actual shared-face integrated upwind flux. Its h factor is
the measured transverse face area, not a surrogate for the physical mesh. -/
noncomputable def integratedNumericalFlux (n : ℕ) :
    Direction → Position → ℝ → (ℤ → State) → ℤ → State :=
  fun _ _ _ values j => h n • values (j - 1)

noncomputable def capacityMethod (n : ℕ) (ghost : Direction → Position → ℤ → State) :
    CapacityCoordinate.Method (physical n) (coord n ghost) where
  incidence := incidence n ghost
  numericalFlux := integratedNumericalFlux n
  admitted := fun _ _ dt _ => dt = h n

theorem actual_admission (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (current : Cell n → State) :
    (capacityMethod n ghost).Admitted d (h n) current := fun _ => rfl

theorem actual_step_available (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (current : Cell n → State) :
    ∃ dt, 0 < dt ∧ dt ≤ 1 ∧ (capacityMethod n ghost).Admitted d dt current :=
  ⟨h n, h_pos n, (HighResolutionAdvectionLine.h_le_half n).trans (by norm_num),
    actual_admission n ghost d current⟩

theorem capacity_at_cell (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (cell : Cell n) :
    PhysicalCapacityBridge.capacity (physical n) (coord n ghost) d
      ((coord n ghost).cellLine d cell) ((coord n ghost).cellIndex d cell) = h n ^ 2 := by
  rw [PhysicalCapacityBridge.capacity_cell, physical_volume]

theorem line_update_eq_shift (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (cell : Cell n) (values : ℤ → State) :
    PhysicalCapacityBridge.lineAdvance (physical n) (coord n ghost)
      (integratedNumericalFlux n) d ((coord n ghost).cellLine d cell) (h n) values
        ((coord n ghost).cellIndex d cell) = values ((coord n ghost).cellIndex d cell - 1) := by
  unfold PhysicalCapacityBridge.lineAdvance
  rw [capacity_at_cell]
  ext k
  simp only [integratedNumericalFlux, finiteVolumeCellAverageUpdate, Pi.sub_apply,
    Pi.smul_apply, smul_eq_mul, add_sub_cancel_right]
  have hh : h n ≠ 0 := ne_of_gt (h_pos n)
  field_simp
  ring

theorem physical_update_eq_shift (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (current : Cell n → State) (cell : Cell n) :
    advance (physical n) (capacityMethod n ghost).rule d (h n) current cell =
      (coord n ghost).extract d ((coord n ghost).cellLine d cell) current
        ((coord n ghost).cellIndex d cell - 1) := by
  rw [(capacityMethod n ghost).advance_eq]
  exact line_update_eq_shift n ghost d cell _

theorem actual_projection (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (q : Point → ℝ → State) (d : Direction) (t : ℝ) (cell : Cell n) :
    (coord n ghost).extract d ((coord n ghost).cellLine d cell)
      (fun c => (physical n).cellMean q c t) ((coord n ghost).cellIndex d cell) =
        cellVolumeAverage volume (CartesianGrid.cellBox (axes n) cell.val) (fun x => q x t) :=
  PhysicalCapacityBridge.projection_cell (physical n) (coord n ghost) q d t cell

noncomputable def referenceGhost (n : ℕ) (q : Point → ℝ → State) :
    Direction → Position → ℤ → State := fun d line j =>
  cellVolumeAverage volume (boundaryRegion n d line j) (fun x => q x 0)

theorem referenceGhost_on_neighbor (n : ℕ) (q : Point → ℝ → State)
    (cell : Cell n) (d : Direction) (j : ℤ)
    (hj : cell.val d - 1 ≤ j ∧ j ≤ cell.val d + 1) :
    referenceGhost n q d (Function.update cell.val d 0) j =
      cellVolumeAverage volume (CartesianGrid.cellBox (axes n) (Function.update cell.val d j))
        (fun x => q x 0) := by
  simp only [referenceGhost, boundary_on_neighbor n cell d j hj]

theorem weighted_mass_balance (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (dt : ℝ) (current : Cell n → State) :
    (∑ cell, (physical n).cellVolume cell •
      advance (physical n) (capacityMethod n ghost).rule d dt current cell) =
    (∑ cell, (physical n).cellVolume cell • current cell) - dt •
      ∑ cell, ((capacityMethod n ghost).rule d dt current ((physical n).rightFace d cell) -
        (capacityMethod n ghost).rule d dt current ((physical n).leftFace d cell)) :=
  finite_mass_balance (physical n) (capacityMethod n ghost).rule d dt current

end RefiningCartesianWitness

namespace RefiningCartesianWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian

/-- The finite subtype is exactly the growing finite square, with its actual
logical coordinates retained by the equivalence. -/
noncomputable def cellEquiv (n : ℕ) : Cell n ≃ (Direction → Fin (n + 4)) where
  toFun := fun cell d => ⟨(cell.val d).toNat, by
    have hb := cell_index_bounds n cell d
    omega⟩
  invFun := fun p => ⟨fun d => ((p d).val : ℤ), (mem_active n _).2 (by
    intro d
    constructor
    · exact Int.natCast_nonneg _
    · exact_mod_cast (p d).isLt)⟩
  left_inv := by
    intro cell
    apply Subtype.ext
    funext d
    exact Int.toNat_of_nonneg (cell_index_bounds n cell d).1
  right_inv := by
    intro p
    funext d
    apply Fin.ext
    exact Int.toNat_natCast _

def position (i j : ℤ) : Position := ![i,j]
def cellAt (n : ℕ) (i j : ℤ) (hi : 0 ≤ i ∧ i < n+4)
    (hj : 0 ≤ j ∧ j < n+4) : Cell n :=
  ⟨position i j, (mem_active n _).2 (by intro d; fin_cases d <;> simpa [position])⟩

theorem extract_at (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (line : Position) (j : ℤ) (cell : Cell n)
    (hline : line d = 0) (heq : Function.update line d j = cell.val)
    (current : Cell n → State) : (coord n ghost).extract d line current j = current cell := by
  have hci : (coord n ghost).cellIndex d cell = j := by
    change cell.val d = j
    rw [← heq]
    simp
  have hcl : (coord n ghost).cellLine d cell = line := by
    change Function.update cell.val d 0 = line
    rw [← heq, Function.update_idem, ← hline, Function.update_eq_self]
  rw [← hcl, ← hci]
  exact (coord n ghost).extract_cell d current cell

theorem extract_below (n : ℕ) (ghost : Direction → Position → ℤ → State)
    (d : Direction) (line : Position) (j : ℤ) (hj : j < 0)
    (current : Cell n → State) : (coord n ghost).extract d line current j = ghost d line j := by
  have hnot : ¬(line d = 0 ∧ Function.update line d j ∈ active n) := by
    intro hs
    have hz := (mem_active n _).1 hs.2 d
    simp only [Function.update_self] at hz
    omega
  simp [LineCoordinates.extract, coord, hnot]

def initial (n : ℕ) (cell : Cell n) : State := if cell.val = 0 then 1 else 0

theorem initial_nonconstant (n : ℕ) :
    initial n (cellAt n 0 0 (by omega) (by omega)) ≠
      initial n (cellAt n 1 0 (by omega) (by omega)) := by
  norm_num [initial, cellAt, position, funext_iff, Fin.forall_fin_two]

theorem initial_origin (n : ℕ) : initial n (cellAt n 0 0 (by omega) (by omega)) = 1 := by
  norm_num [initial, cellAt, position, funext_iff, Fin.forall_fin_two]

noncomputable def stage (n : ℕ) (d : Direction) (current : Cell n → State) : Cell n → State :=
  advance (physical n) (capacityMethod n (fun _ _ _ => 0)).rule d (h n) current

theorem stage_x_predecessor (n : ℕ) (current : Cell n → State) :
    stage n 0 current (cellAt n 1 0 (by omega) (by omega)) =
      current (cellAt n 0 0 (by omega) (by omega)) := by
  rw [stage, physical_update_eq_shift]
  apply extract_at
  · simp [coord]
  · funext d
    fin_cases d <;> norm_num [coord, cellAt, position, Function.update_apply]

theorem stage_y_predecessor (n : ℕ) (current : Cell n → State) :
    stage n 1 current (cellAt n 1 1 (by omega) (by omega)) =
      current (cellAt n 1 0 (by omega) (by omega)) := by
  rw [stage, physical_update_eq_shift]
  apply extract_at
  · simp [coord]
  · funext d
    fin_cases d <;> norm_num [coord, cellAt, position, Function.update_apply]

theorem stage_x_origin (n : ℕ) (current : Cell n → State) :
    stage n 0 current (cellAt n 0 0 (by omega) (by omega)) = 0 := by
  rw [stage, physical_update_eq_shift]
  apply extract_below
  norm_num [coord, cellAt, position]

theorem stage_y_bottom (n : ℕ) (current : Cell n → State) :
    stage n 1 current (cellAt n 1 0 (by omega) (by omega)) = 0 := by
  rw [stage, physical_update_eq_shift]
  apply extract_below
  norm_num [coord, cellAt, position]

theorem actual_two_direction_motion (n : ℕ) :
    stage n 0 (initial n) (cellAt n 0 0 (by omega) (by omega)) = 0 ∧
    stage n 0 (initial n) (cellAt n 1 0 (by omega) (by omega)) = 1 ∧
    stage n 1 (stage n 0 (initial n)) (cellAt n 1 0 (by omega) (by omega)) = 0 ∧
    stage n 1 (stage n 0 (initial n)) (cellAt n 1 1 (by omega) (by omega)) = 1 := by
  refine ⟨stage_x_origin n _, ?_, stage_y_bottom n _, ?_⟩
  · rw [stage_x_predecessor, initial_origin]
  · rw [stage_y_predecessor, stage_x_predecessor, initial_origin]

theorem actual_intermediate_admission (n : ℕ) :
    (capacityMethod n (fun _ _ _ => 0)).Admitted 0 (h n) (initial n) ∧
    (capacityMethod n (fun _ _ _ => 0)).Admitted 1 (h n) (stage n 0 (initial n)) :=
  ⟨actual_admission n _ _ _, actual_admission n _ _ _⟩

end RefiningCartesianWitness

namespace ZeroPhysicalRefinementWitness
open NumStability MeasureTheory Set Filter
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators Topology
open RefiningCartesianWitness (Direction State Point Position Cell)

def zeroFlux : Direction → State → State := fun _ _ => 0

theorem zero_hyperbolic : ∀ d, IsHyperbolicFluxOn (zeroFlux d) univ :=
  fun _ => CapacitySmallBias.constantFlux_hyperbolic 0 univ

noncomputable def data (n : ℕ) := RefiningCartesianWitness.physicalWith n zeroFlux zero_hyperbolic
noncomputable def coordinates (n : ℕ) := RefiningCartesianWitness.coord n (fun _ _ _ => 0)

noncomputable def method (n : ℕ) : CapacityCoordinate.Method (data n) (coordinates n) where
  incidence := {
    left_line := fun _ _ => rfl
    right_line := by
      intro d cell
      simp [coordinates, RefiningCartesianWitness.coord, data,
        RefiningCartesianWitness.physicalWith, FiniteCartesian.data]
    left_index := fun _ _ => rfl
    right_index := by
      intro d cell
      simp [coordinates, RefiningCartesianWitness.coord, data,
        RefiningCartesianWitness.physicalWith, FiniteCartesian.data] }
  numericalFlux := fun _ _ _ _ _ => 0
  admitted := fun _ _ _ _ => True

/-- A complete inhabitant of the frozen physical-family interface. The
measured grid and physical diameters are the already verified growing boxes;
the zero tensor flux is fixed across all refinement levels. -/
noncomputable def family : PhysicalRefinementQuality.Family Direction Point 1 where
  Cell := Cell
  Face := fun _ => Position
  Line := fun _ => Position
  finiteCell := fun _ => inferInstance
  data := data
  coordinates := coordinates
  method := method
  measure := volume
  measure_eq := fun _ => rfl
  states := fun _ => univ
  states_nonempty := fun _ => ⟨0, mem_univ _⟩
  states_eq := fun _ _ => rfl
  physicalFlux := fun _ _ _ => 0
  normal := fun _ d _ _ => RefiningCartesianWitness.normal d
  normal_flux_eq := by
    intro n d face point state
    simp [data, RefiningCartesianWitness.physicalWith, FiniteCartesian.data, zeroFlux]
  region := RefiningCartesianWitness.region
  target := RefiningCartesianWitness.target
  target_interior_nonempty := by
    rw [RefiningCartesianWitness.target_open.interior_eq]
    exact RefiningCartesianWitness.target_nonempty
  target_inside := RefiningCartesianWitness.target_inside.trans interior_subset
  active_inside := RefiningCartesianWitness.active_inside
  target_covered := RefiningCartesianWitness.target_covered
  bounded_cells := fun n cell => RefiningCartesianWitness.box_bounded n cell.val
  mesh := RefiningCartesianWitness.actualMesh
  mesh_actual := fun _ => rfl
  mesh_pos := RefiningCartesianWitness.actualMesh_positive
  mesh_tendsto := RefiningCartesianWitness.actualMesh_tendsto
  horizon := 1
  horizon_pos := by norm_num
  boundaryRegion := RefiningCartesianWitness.boundaryRegion
  boundary_measurable := RefiningCartesianWitness.boundary_measurable
  boundary_positive := fun n d line j =>
    ne_of_gt (RefiningCartesianWitness.boundary_positive_finite n d line j).1
  boundary_finite := fun n d line j =>
    ne_of_lt (RefiningCartesianWitness.boundary_positive_finite n d line j).2
  boundary_inside := RefiningCartesianWitness.boundary_inside

theorem family_quality : family.HasHighResolution :=
  family.zero_flux_quality (by intros; rfl) (by intros; trivial) (by intros; rfl)

theorem family_stable (n : ℕ) (d : Direction) (dt : ℝ) :
    (family.method n).StableAt d dt 1 :=
  family.zero_flux_stable (by intros; rfl) n d dt

def stationary (x : Point) (_t : ℝ) : State := fun _ => x 0 + x 1

theorem stationary_smooth :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry stationary) := by
  exact contDiff_pi.mpr (fun _ => ((contDiff_apply ℝ ℝ 0).comp contDiff_fst).add
    ((contDiff_apply ℝ ℝ 1).comp contDiff_fst))

theorem stationary_nonconstant :
    ∃ x ∈ family.target, ∃ y ∈ family.target, stationary x 0 ≠ stationary y 0 := by
  refine ⟨fun _ => 1/4, ?_, fun _ => 3/4, ?_, ?_⟩
  · norm_num [family, RefiningCartesianWitness.target]
  · norm_num [family, RefiningCartesianWitness.target]
  · intro he
    have he0 := congrFun he (0 : Fin 1)
    norm_num [stationary] at he0

theorem stationary_box_integrable (n : ℕ) (pos : Position) (t : ℝ) :
    IntegrableOn (fun x => stationary x t)
      (CartesianGrid.cellBox (RefiningCartesianWitness.axes n) pos) volume := by
  have hc : Continuous (fun x => stationary x t) :=
    continuous_pi (fun _ => (continuous_apply 0).add (continuous_apply 1))
  apply (hc.integrableOn_Icc
    (a := fun d => (RefiningCartesianWitness.axes n d).cellLeft (pos d))
    (b := fun d => (RefiningCartesianWitness.axes n d).cellRight (pos d))).mono_set
  intro x hx
  exact ⟨fun e => (hx e (mem_univ e)).1, fun e => (hx e (mem_univ e)).2.le⟩

theorem faceFlux_zero (n : ℕ) (d : Direction) (q : Point → ℝ → State) (face : Position) (t : ℝ) :
    (data n).faceFlux d q face t = 0 := by
  simp [PhysicalData.faceFlux, data, RefiningCartesianWitness.physicalWith,
    FiniteCartesian.data, zeroFlux]

theorem stationary_reference (n : ℕ) (d : Direction) (s t : ℝ) :
    (data n).ReferenceOn d stationary s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ _
    exact stationary_box_integrable n cell.val τ
  · intro cell τ _
    exact ⟨integrable_zero _ _ _, integrable_zero _ _ _⟩
  · intro x hx τ hτ
    exact mem_univ _
  · intro u hu v hv
    refine ⟨?_, ?_⟩
    · intro cell
      simp only [show (data n).faceFlux d stationary = fun _ _ => 0 from funext (fun f => funext (faceFlux_zero n d stationary f))]
      exact ⟨intervalIntegrable_const, intervalIntegrable_const⟩
    · intro cell
      simp only [faceFlux_zero, sub_self, intervalIntegral.integral_zero]
      have hmean : (data n).cellMean stationary cell v = (data n).cellMean stationary cell u := rfl
      rw [hmean, sub_self, smul_zero]

theorem stationary_in_reference_class (d : Direction) : family.SmoothReference d stationary := by
  refine ⟨stationary_smooth.contDiffOn, ?_, ?_⟩
  · intro n
    exact stationary_reference n d 0 1
  · intro n line j
    exact stationary_box_integrable n _ 0

theorem stationary_certificates (d : Direction) :
    ∃ p : ℝ, 1 < p ∧ Nonempty (family.AccuracyCertificate d stationary p) := by
  obtain ⟨p, hp, certificates⟩ := family_quality.order d
  exact ⟨p, hp, certificates stationary (stationary_in_reference_class d)⟩

/-- The same fixed nonconstant reference belongs to the genuine class used
by the full quality theorem; its class is not an arbitrary eligibility tag. -/
theorem nonconstant_full_quality :
    family.HasHighResolution ∧
    (∃ x ∈ family.target, ∃ y ∈ family.target, stationary x 0 ≠ stationary y 0) ∧
    (∀ d, family.SmoothReference d stationary) ∧
    (∀ n, 0 < family.mesh n) ∧ Tendsto family.mesh atTop (𝓝 0) :=
  ⟨family_quality, stationary_nonconstant, stationary_in_reference_class,
    family.mesh_pos, family.mesh_tendsto⟩

end ZeroPhysicalRefinementWitness

set_option pp.deepTerms true
set_option pp.maxSteps 1000000
#check ZeroPhysicalRefinementWitness.zeroFlux
#print axioms ZeroPhysicalRefinementWitness.zeroFlux
#check ZeroPhysicalRefinementWitness.zero_hyperbolic
#print axioms ZeroPhysicalRefinementWitness.zero_hyperbolic
#check ZeroPhysicalRefinementWitness.data
#print axioms ZeroPhysicalRefinementWitness.data
#check ZeroPhysicalRefinementWitness.coordinates
#print axioms ZeroPhysicalRefinementWitness.coordinates
#check ZeroPhysicalRefinementWitness.method
#print axioms ZeroPhysicalRefinementWitness.method
#check ZeroPhysicalRefinementWitness.family
#print axioms ZeroPhysicalRefinementWitness.family
#check ZeroPhysicalRefinementWitness.family_quality
#print axioms ZeroPhysicalRefinementWitness.family_quality
#check ZeroPhysicalRefinementWitness.family_stable
#print axioms ZeroPhysicalRefinementWitness.family_stable
#check ZeroPhysicalRefinementWitness.stationary
#print axioms ZeroPhysicalRefinementWitness.stationary
#check ZeroPhysicalRefinementWitness.stationary_smooth
#print axioms ZeroPhysicalRefinementWitness.stationary_smooth
#check ZeroPhysicalRefinementWitness.stationary_nonconstant
#print axioms ZeroPhysicalRefinementWitness.stationary_nonconstant
#check ZeroPhysicalRefinementWitness.stationary_box_integrable
#print axioms ZeroPhysicalRefinementWitness.stationary_box_integrable
#check ZeroPhysicalRefinementWitness.faceFlux_zero
#print axioms ZeroPhysicalRefinementWitness.faceFlux_zero
#check ZeroPhysicalRefinementWitness.stationary_reference
#print axioms ZeroPhysicalRefinementWitness.stationary_reference
#check ZeroPhysicalRefinementWitness.stationary_in_reference_class
#print axioms ZeroPhysicalRefinementWitness.stationary_in_reference_class
#check ZeroPhysicalRefinementWitness.stationary_certificates
#print axioms ZeroPhysicalRefinementWitness.stationary_certificates
#check ZeroPhysicalRefinementWitness.nonconstant_full_quality
#print axioms ZeroPhysicalRefinementWitness.nonconstant_full_quality
#check CapacitySmallBias.constantFlux_hyperbolic
#print axioms CapacitySmallBias.constantFlux_hyperbolic
