import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteLineCoordinates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalHighResolutionSweep
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Data.Finset.Lattice.Fold
set_option maxRecDepth 4096
set_option maxHeartbeats 1600000

/- Artifact-only comparison. Historical nominal structures and proof producers are
retained under root-qualified scratch namespaces; shared canonical names are imported.
The locally renamed scratch source theorem is the latest admitted proposal, not
the old rejected production target. No source acceptance is inferred. -/


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
    (incidence : _root_.PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell) :
    _root_.PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) •
      (_root_.PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
        (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        coord.extract d (coord.cellLine d cell) (fun c => data.cellMean q c t) (coord.cellIndex d cell)) =
      data.cellVolume cell •
        (coord.extract d (coord.cellLine d cell) current (coord.cellIndex d cell) -
          cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x s)) +
        (t - s) • netFluxDefect data (_root_.PhysicalCapacityBridge.faceRule coord numericalFlux)
          d current q s t cell := by
  rw [_root_.PhysicalCapacityBridge.capacity_cell,
    ← _root_.PhysicalCapacityBridge.advance_eq data coord incidence,
    coord.extract_cell, coord.extract_cell]
  exact advance_error_balance data (_root_.PhysicalCapacityBridge.faceRule coord numericalFlux)
    d current q href hst cell

theorem capacity_line_error_le_net (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : _root_.PhysicalCapacityBridge.Incidence data coord)
    (numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State)
    (d : D) (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound netDefectBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hnet : ‖netFluxDefect data (_root_.PhysicalCapacityBridge.faceRule coord numericalFlux)
      d current q s t cell‖ ≤ netDefectBound) :
    ‖_root_.PhysicalCapacityBridge.lineAdvance data coord numericalFlux d (coord.cellLine d cell) (t - s)
      (coord.extract d (coord.cellLine d cell) current) (coord.cellIndex d cell) -
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)‖ ≤
      oldBound + (t - s) /
        _root_.PhysicalCapacityBridge.capacity data coord d (coord.cellLine d cell) (coord.cellIndex d cell) *
          netDefectBound := by
  rw [_root_.PhysicalCapacityBridge.capacity_cell, ← _root_.PhysicalCapacityBridge.advance_eq data coord incidence]
  exact advance_error_le_net data (_root_.PhysicalCapacityBridge.faceRule coord numericalFlux)
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
  incidence : _root_.PhysicalCapacityBridge.Incidence data coord
  numericalFlux : D → Line → ℝ → (ℤ → State) → ℤ → State
  admitted : D → Line → ℝ → (ℤ → State) → Prop

variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}

noncomputable def Method.rule (method : Method data coord) :=
  _root_.PhysicalCapacityBridge.faceRule coord method.numericalFlux

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
      ‖_root_.PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt values (coord.cellIndex d cell) -
        _root_.PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
          (coord.cellLine d cell) dt other (coord.cellIndex d cell)‖ ≤ A * E

theorem Method.advance_eq (method : Method data coord) (d : D) (dt : ℝ)
    (current : Cell → State) (cell : Cell) :
    advance data method.rule d dt current cell =
      _root_.PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt (coord.extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  _root_.PhysicalCapacityBridge.advance_eq data coord method.incidence method.numericalFlux d dt current cell

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
  _root_.PhysicalCapacityBridge.projection_cell data coord q d t cell

/-- A cell observes only its own coordinate line, with supplied ghosts fixed. -/
theorem Method.coordinate_local (method : Method data coord) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (h : ∀ c, coord.cellLine d c = coord.cellLine d cell → current c = other c) :
    advance data method.rule d dt current cell = advance data method.rule d dt other cell :=
  _root_.PhysicalCapacityBridge.advance_line_local data coord method.incidence method.numericalFlux
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
      ‖_root_.CapacityNetReferenceError.netFluxDefect data (method n).rule (direction n)
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
    have he := _root_.CapacityNetReferenceError.advance_error_le_net data (method n).rule (direction n)
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




/- Exact shared ghost namespace excluded; use canonical FiniteLineCoordinates. -/


namespace CapacityGhost
open NumStability NumStability.FiniteCoordinate
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}

theorem capacity_withGhost (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (newGhost : D → Line → ℤ → Fin m → ℝ) (d : D) (line : Line) (j : ℤ) :
    _root_.PhysicalCapacityBridge.capacity data (coord.withGhost newGhost) d line j =
      _root_.PhysicalCapacityBridge.capacity data coord d line j := rfl

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
def withGhost (method : _root_.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) : _root_.CapacityCoordinate.Method data (coord.withGhost newGhost) where
  incidence := ⟨method.incidence.left_line, method.incidence.right_line,
    method.incidence.left_index, method.incidence.right_index⟩
  numericalFlux := method.numericalFlux
  admitted := method.admitted

theorem withGhost_flux_admission (method : _root_.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) :
    (method.withGhost newGhost).numericalFlux = method.numericalFlux ∧
      (method.withGhost newGhost).admitted = method.admitted := ⟨rfl, rfl⟩

/-- The physical update retains the original physical capacities and supplied
flux formula, and uses precisely the newly extracted boundary data. -/
theorem advance_withGhost_eq (method : _root_.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    advance data (method.withGhost newGhost).rule d dt current cell =
      _root_.PhysicalCapacityBridge.lineAdvance data coord method.numericalFlux d
        (coord.cellLine d cell) dt ((coord.withGhost newGhost).extract d (coord.cellLine d cell) current)
          (coord.cellIndex d cell) :=
  (method.withGhost newGhost).advance_eq d dt current cell

theorem projection_withGhost (method : _root_.CapacityCoordinate.Method data coord)
    (newGhost : D → Line → ℤ → State) (d : D) (q : Point → ℝ → State) (t : ℝ) (cell : Cell) :
    (coord.withGhost newGhost).extract d (coord.cellLine d cell)
      (fun c => data.cellMean q c t) (coord.cellIndex d cell) =
        cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t) :=
  (method.withGhost newGhost).projection_cell d q t cell

/-- Cross-boundary-data stability uses both actual cell error and actual
missing-lookup ghost error. Both arrays must be admitted at the same dt. -/
theorem coordinate_stability_withGhost (method : _root_.CapacityCoordinate.Method data coord)
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
  method : ∀ n, _root_.CapacityCoordinate.Method (data n) (coordinates n)
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
    exact _root_.CapacityPhysicalMesh.mesh (data n).cells)
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



namespace CapacityBoundarySweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError _root_.CapacityCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

noncomputable def step (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (n : ℕ) : (Cell → State) → Cell → State :=
  advance data (method n).rule (direction n) (duration n)

noncomputable def run (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) : ℕ → Cell → State :=
  execution (step method direction duration) initial

theorem run_succ (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (n : ℕ) :
    run method direction duration initial (n + 1) =
      advance data (method n).rule (direction n) (duration n)
        (run method direction duration initial n) := rfl

theorem run_ordered (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
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
theorem run_physical_error (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
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
      ‖_root_.CapacityNetReferenceError.netFluxDefect data (method n).rule (direction n)
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
    have he := _root_.CapacityNetReferenceError.advance_error_le_net data (method n).rule (direction n)
      (fun c => data.cellMean (physical n) c 0) (physical n) (href n hn) (hdt n hn) cell
      0 (netError n cell) (by simp) (hnet n hn cell)
    apply le_trans ?_ (hlocal n hn cell)
    simpa [step] using he
  · exact hsplit

end CapacityBoundarySweep

namespace CapacityBoundarySweep
open MeasureTheory NumStability NumStability.FiniteCoordinate _root_.CapacityCoordinate
open scoped BigOperators
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

theorem run_zero (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) :
    run method direction duration initial 0 = initial := rfl

/-- Every stage applies its own capacity line operator to the actual preceding array. -/
theorem run_line_step (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) (cell : Cell) :
    run method direction duration initial (k + 1) cell =
      _root_.PhysicalCapacityBridge.lineAdvance data (coord k) (method k).numericalFlux (direction k)
        ((coord k).cellLine (direction k) cell) (duration k)
        ((coord k).extract (direction k) ((coord k).cellLine (direction k) cell)
          (run method direction duration initial k)) ((coord k).cellIndex (direction k) cell) := by
  rw [run_succ]
  exact (method k).advance_eq (direction k) (duration k) _ cell

/-- Conservation retains actual exterior transfer. No admission, quality,
stability or step-size hypothesis is needed for this identity. -/
theorem run_mass_balance [Fintype Cell] (method : ∀ k, Method data (coord k))
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) :
    (∑ cell, data.cellVolume cell • run method direction duration initial (k + 1) cell) =
      (∑ cell, data.cellVolume cell • run method direction duration initial k cell) -
        duration k • ∑ cell,
          ((method k).rule (direction k) (duration k) (run method direction duration initial k)
              (data.rightFace (direction k) cell) -
            (method k).rule (direction k) (duration k) (run method direction duration initial k)
              (data.leftFace (direction k) cell)) := by
  rw [run_succ]
  exact finite_mass_balance data (method k).rule (direction k) (duration k) _

/-- Stage-locality concerns the current stage's coordinate line and its fixed
supplied ghosts. It makes no claim about the entire composed initial stencil. -/
theorem step_coordinate_local (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (k : ℕ) (current other : Cell → State) (cell : Cell)
    (h : ∀ c, (coord k).cellLine (direction k) c = (coord k).cellLine (direction k) cell →
      current c = other c) :
    step method direction duration k current cell = step method direction duration k other cell :=
  (method k).coordinate_local (direction k) (duration k) current other cell h

theorem run_stage_local (method : ∀ k, Method data (coord k)) (direction : ℕ → D)
    (duration : ℕ → ℝ) (initial otherInitial : Cell → State) (k : ℕ) (cell : Cell)
    (h : ∀ c, (coord k).cellLine (direction k) c = (coord k).cellLine (direction k) cell →
      run method direction duration initial k c = run method direction duration otherInitial k c) :
    run method direction duration initial (k + 1) cell =
      run method direction duration otherInitial (k + 1) cell := by
  rw [run_succ, run_succ]
  exact (method k).coordinate_local (direction k) (duration k) _ _ cell h

/-- Direct application to arbitrary stage-dependent ghost functions. The
original physical capacities and line maps remain fixed by withGhost. -/
theorem run_withGhost_line_step (base : LineCoordinates (m := m) D Cell Face Line)
    (method : ℕ → Method data base) (ghost : ℕ → D → Line → ℤ → State)
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → State) (k : ℕ) (cell : Cell) :
    run (fun n => (method n).withGhost (ghost n)) direction duration initial (k + 1) cell =
      _root_.PhysicalCapacityBridge.lineAdvance data base (method k).numericalFlux (direction k)
        (base.cellLine (direction k) cell) (duration k)
        ((base.withGhost (ghost k)).extract (direction k) (base.cellLine (direction k) cell)
          (run (fun n => (method n).withGhost (ghost n)) direction duration initial k))
        (base.cellIndex (direction k) cell) := by
  rw [run_succ]
  exact (method k).advance_withGhost_eq (ghost k) (direction k) (duration k) _ cell

/-- The previous fixed-coordinate API is exactly the constant-family special case. -/
theorem run_constant_coord (base : LineCoordinates (m := m) D Cell Face Line)
    (method : ℕ → Method data base) (direction : ℕ → D) (duration : ℕ → ℝ)
    (initial : Cell → State) :
    run (coord := fun _ => base) method direction duration initial =
      _root_.CapacityCoordinate.run method direction duration initial := rfl

end CapacityBoundarySweep


namespace PhysicalHighResolutionSweep
open MeasureTheory NumStability NumStability.FiniteCoordinate NumStability.SequentialError
open scoped BigOperators
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "Point" => D → ℝ
local notation "State" => Fin m → ℝ
variable (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)

def coordinates (level : ℕ) (ghost : ℕ → D → family.Line level → ℤ → State) (k : ℕ) :=
  (family.coordinates level).withGhost (ghost k)

def method (level : ℕ) (ghost : ℕ → D → family.Line level → ℤ → State) (k : ℕ) :
    _root_.CapacityCoordinate.Method (family.data level) (coordinates family level ghost k) :=
  (family.method level).withGhost (ghost k)

noncomputable def execution (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State) :=
  _root_.CapacityBoundarySweep.run (method family level ghost) direction duration initial

/-- The supplied high-resolution family is executed on its actual selected
physical mesh. Quality, unconditional operator construction and conditional
analysis are separate fields. No stability assumption restricts construction. -/
structure Specification (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State)
    (steps : ℕ) : Prop where
  quality : family.HasHighResolution
  schedule : ∀ d : D, ∃ k < steps, direction k = d
  ordered : ∀ k ≤ steps, execution family level direction duration ghost initial k =
    orderedOperatorSweep ((List.range k).map
      (_root_.CapacityBoundarySweep.step (method family level ghost) direction duration)) initial
  constituent : ∀ k < steps, ∀ cell,
    execution family level direction duration ghost initial (k + 1) cell =
      _root_.PhysicalCapacityBridge.lineAdvance (family.data level) (family.coordinates level)
        (family.method level).numericalFlux (direction k)
        ((family.coordinates level).cellLine (direction k) cell) (duration k)
        (((family.coordinates level).withGhost (ghost k)).extract (direction k)
          ((family.coordinates level).cellLine (direction k) cell)
          (execution family level direction duration ghost initial k))
        ((family.coordinates level).cellIndex (direction k) cell)
  conservative : ∀ k < steps, (by
    letI := family.finiteCell level
    exact (∑ cell, (family.data level).cellVolume cell •
      execution family level direction duration ghost initial (k + 1) cell) =
      (∑ cell, (family.data level).cellVolume cell •
        execution family level direction duration ghost initial k cell) - duration k •
      ∑ cell,
        ((method family level ghost k).rule (direction k) (duration k)
          (execution family level direction duration ghost initial k)
          ((family.data level).rightFace (direction k) cell) -
        (method family level ghost k).rule (direction k) (duration k)
          (execution family level direction duration ghost initial k)
          ((family.data level).leftFace (direction k) cell)))
  line_local : ∀ k < steps, ∀ cell current other,
    (∀ c, (family.coordinates level).cellLine (direction k) c =
      (family.coordinates level).cellLine (direction k) cell → current c = other c) →
    advance (family.data level) (method family level ghost k).rule (direction k) (duration k)
      current cell =
    advance (family.data level) (method family level ghost k).rule (direction k) (duration k)
      other cell
  accuracy : ∀ d (q : Point → ℝ → State) (p : ℝ)
    (certificate : family.AccuracyCertificate d q p),
    ∀ n, certificate.threshold ≤ n → ∀ dt : ℝ, 0 < dt → dt ≤ family.horizon →
    ∀ boundary : D → family.Line n → ℤ → State, ∀ current : family.Cell n → State,
    ((family.method n).withGhost boundary).Admitted d dt current →
    ((family.method n).withGhost (family.referenceGhost n q)).Admitted d dt
      (family.projected n q 0) →
    ∀ A E G : ℝ, (family.method n).StableAt d dt A →
    (∀ cell, ‖current cell - family.projected n q 0 cell‖ ≤ E) →
    (∀ cell j,
      (family.coordinates n).lookup d ((family.coordinates n).cellLine d cell) j = none →
      ‖boundary d ((family.coordinates n).cellLine d cell) j -
        family.referenceGhost n q d ((family.coordinates n).cellLine d cell) j‖ ≤ G) →
    ∀ cell,
    ‖advance (family.data n) ((family.method n).withGhost boundary).rule d dt current cell -
      family.projected n q dt cell‖ ≤
        A * max E G + certificate.constant * dt * family.mesh n ^ p
  physical_error : ∀ (physical : ℕ → Point → ℝ → State)
    (amplification localDefect splittingDefect : ℕ → ℝ) (initialError : ℝ)
    (netError : ℕ → family.Cell level → ℝ),
    (∀ k < steps, 0 < duration k) →
    (∀ k < steps, (family.data level).ReferenceOn (direction k) (physical k) 0 (duration k)) →
    (∀ cell, ‖initial cell - (family.data level).cellMean (physical 0) cell 0‖ ≤ initialError) →
    (∀ k < steps, (method family level ghost k).Admitted (direction k) (duration k)
      (execution family level direction duration ghost initial k)) →
    (∀ k < steps, (method family level ghost k).Admitted (direction k) (duration k)
      (fun cell => (family.data level).cellMean (physical k) cell 0)) →
    (∀ k < steps, (method family level ghost k).StableAt (direction k) (duration k) (amplification k)) →
    (∀ k < steps, ∀ cell,
      ‖_root_.CapacityNetReferenceError.netFluxDefect (family.data level) (method family level ghost k).rule
        (direction k) (fun c => (family.data level).cellMean (physical k) c 0)
        (physical k) 0 (duration k) cell‖ ≤ netError k cell) →
    (∀ k < steps, ∀ cell,
      duration k / (family.data level).cellVolume cell * netError k cell ≤ localDefect k) →
    (∀ k < steps, ∀ cell,
      ‖(family.data level).cellMean (physical k) cell (duration k) -
        (family.data level).cellMean (physical (k + 1)) cell 0‖ ≤ splittingDefect k) →
    ∀ k ≤ steps, ∀ cell,
      ‖execution family level direction duration ghost initial k cell -
        (family.data level).cellMean (physical k) cell 0‖ ≤
          errorBudget amplification localDefect splittingDefect initialError k
  cartesian : ∀ (axes : D → OneDimensionalFiniteVolumeGrid)
    (cellPosition : family.Cell level → D → ℤ)
    (facePosition : D → family.Face level → D → ℤ) (flux : D → State → State),
    FiniteCartesian.CartesianIdentification (family.data level) axes cellPosition facePosition flux →
    (∀ cell, (family.data level).cellVolume cell = CartesianGrid.cellVolume axes (cellPosition cell)) ∧
    (∀ (q : Point → ℝ → State) cell t, (family.data level).cellMean q cell t =
      cellVolumeAverage volume (CartesianGrid.cellBox axes (cellPosition cell)) (fun x => q x t)) ∧
    (∀ (q : ℝ → ℝ → State) d face t,
      (family.data level).faceFlux d (fun x τ => q (x d) τ) face t =
        CartesianGrid.faceArea axes d (facePosition d face) •
          flux d (q ((axes d).cellLeft (facePosition d face d)) t)) ∧
    (∀ (q : ℝ → ℝ → State) d, IsRectangleConservationLawSolution q (flux d) → ∀ cell s t,
      (family.data level).cellVolume cell •
        ((family.data level).cellMean (fun x τ => q (x d) τ) cell t -
          (family.data level).cellMean (fun x τ => q (x d) τ) cell s) =
        ∫ τ in s..t,
          (family.data level).faceFlux d (fun x σ => q (x d) σ)
            ((family.data level).leftFace d cell) τ -
          (family.data level).faceFlux d (fun x σ => q (x d) σ)
            ((family.data level).rightFace d cell) τ)

/-- Supplied high-resolution methods admit coordinate execution without
additional stability or common-area hypotheses. Error analysis is retained as
an explicit conditional component of the same construction. -/
theorem specification (quality : family.HasHighResolution)
    (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → State) (initial : family.Cell level → State)
    (steps : ℕ) (hschedule : ∀ d : D, ∃ k < steps, direction k = d) :
    Specification family level direction duration ghost initial steps := by
  refine {
    quality := quality
    schedule := hschedule
    ordered := ?_
    constituent := ?_
    conservative := ?_
    line_local := ?_
    accuracy := ?_
    physical_error := ?_
    cartesian := ?_ }
  · intro k _
    exact _root_.CapacityBoundarySweep.run_ordered (method family level ghost) direction duration initial k
  · intro k _ cell
    change advance (family.data level) ((family.method level).withGhost (ghost k)).rule
      (direction k) (duration k) (execution family level direction duration ghost initial k) cell = _
    exact (family.method level).advance_withGhost_eq (ghost k) (direction k) (duration k) _ cell
  · intro k _
    letI := family.finiteCell level
    exact finite_mass_balance (family.data level) (method family level ghost k).rule (direction k)
      (duration k) (execution family level direction duration ghost initial k)
  · intro k _ cell current other h
    exact (method family level ghost k).coordinate_local (direction k) (duration k) current other cell h
  · intro d q p certificate n hn dt hdt hT boundary current hactual hprojected A E G hstable hcell hghost cell
    exact _root_.PhysicalRefinementQuality.Family.AccuracyCertificate.perturbed_at family certificate
      n hn dt hdt hT boundary current hactual hprojected
      A E G hstable hcell hghost cell
  · intro physical amplification localDefect splittingDefect initialError netError
      hdt href hinitial hactual hrefadmit hstable hnet hlocal hsplit
    exact _root_.CapacityBoundarySweep.run_physical_error (method family level ghost) direction duration initial
      physical steps amplification localDefect splittingDefect initialError netError
      hdt href hinitial hactual hrefadmit hstable hnet hlocal hsplit
  · intro axes cellPosition facePosition flux cart
    exact ⟨cart.cellVolume_eq, cart.cellMean_eq, cart.faceFlux_lift,
      fun q d hq cell s t => cart.rectangle_balance_lift q d hq cell s t⟩

end PhysicalHighResolutionSweep




namespace PhysicalHighResolutionSweep
open NumStability NumStability.FiniteCoordinate
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}

/-- A particular numerical run uses positive substeps in the quality horizon
and the actual intermediate arrays belong to each method's admitted domain.
This is separate from the total algebraic coordinate-sweep construction. -/
def ValidSubsteps (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)
    (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ) : Prop :=
  ∀ k < steps, 0 < duration k ∧ duration k ≤ family.horizon ∧
    (method family level ghost k).Admitted (direction k) (duration k)
      (execution family level direction duration ghost initial k)

/-- The total construction specializes to an actual admitted coordinate run.
Stability is still confined to the conditional error analysis. -/
theorem admitted_specification (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)
    (quality : family.HasHighResolution) (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)
    (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : ValidSubsteps family level direction duration ghost initial steps) :
    Specification family level direction duration ghost initial steps ∧
      ValidSubsteps family level direction duration ghost initial steps :=
  ⟨specification family quality level direction duration ghost initial steps hschedule, hvalid⟩

end PhysicalHighResolutionSweep



namespace NumStability
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}

/-- Chapter 1 coordinate splitting under the recorded physical logical-grid
interpretation and the separately adopted high-resolution convention: order
greater than one on smooth references and quantitative oscillation control.
The supplied methods execute positive, admitted coordinate substeps on the
selected measured mesh, with explicit stage-dependent boundary inputs.
Stability and physical reference-error hypotheses belong to the conditional
analysis, rather than to the coordinate construction or core quality. -/
theorem comparison_draft_leveque01_coordinateHighResolutionMethods_sourceContract
    (hm : 0 < m) (hD : 0 < Fintype.card D)
    (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)
    (quality : family.HasHighResolution) (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
    (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
    (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)
    (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : _root_.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps) :
    0 < m ∧ 0 < Fintype.card D ∧
      _root_.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps ∧
      _root_.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps :=
  ⟨hm, hD, _root_.PhysicalHighResolutionSweep.admitted_specification family quality level direction duration ghost
    initial steps hschedule hvalid⟩

end NumStability


namespace PhysicalDIMTransport
open MeasureTheory NumStability NumStability.FiniteCoordinate
open scoped BigOperators Topology

section Method
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : LineCoordinates (m := m) D Cell Face Line}

def incidenceToCanonical (h : _root_.PhysicalCapacityBridge.Incidence data coord) :
    NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord :=
  ⟨h.left_line, h.right_line, h.left_index, h.right_index⟩

def incidenceToDraft (h : NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord) :
    _root_.PhysicalCapacityBridge.Incidence data coord :=
  ⟨h.left_line, h.right_line, h.left_index, h.right_index⟩

theorem incidence_draft_roundtrip (h : _root_.PhysicalCapacityBridge.Incidence data coord) :
    incidenceToDraft (incidenceToCanonical h) = h := Subsingleton.elim _ _

theorem incidence_canonical_roundtrip
    (h : NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord) :
    incidenceToCanonical (incidenceToDraft h) = h := Subsingleton.elim _ _

def methodToCanonical (method : _root_.CapacityCoordinate.Method data coord) :
    NumStability.CapacityCoordinate.Method data coord where
  incidence := incidenceToCanonical method.incidence
  numericalFlux := method.numericalFlux
  admitted := method.admitted

def methodToDraft (method : NumStability.CapacityCoordinate.Method data coord) :
    _root_.CapacityCoordinate.Method data coord where
  incidence := incidenceToDraft method.incidence
  numericalFlux := method.numericalFlux
  admitted := method.admitted

theorem method_draft_roundtrip (method : _root_.CapacityCoordinate.Method data coord) :
    methodToDraft (methodToCanonical method) = method := by cases method; rfl

theorem method_canonical_roundtrip (method : NumStability.CapacityCoordinate.Method data coord) :
    methodToCanonical (methodToDraft method) = method := by cases method; rfl

theorem capacity_eq (d : D) (line : Line) (j : ℤ) :
    NumStability.FiniteCoordinate.PhysicalLine.capacity data coord d line j =
      _root_.PhysicalCapacityBridge.capacity data coord d line j := rfl

theorem faceRule_eq (flux : D → Line → ℝ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ) :
    NumStability.FiniteCoordinate.PhysicalLine.faceRule coord flux =
      _root_.PhysicalCapacityBridge.faceRule coord flux := rfl

theorem lineAdvance_eq (flux : D → Line → ℝ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ) :
    NumStability.FiniteCoordinate.PhysicalLine.lineAdvance data coord flux =
      _root_.PhysicalCapacityBridge.lineAdvance data coord flux := rfl

theorem method_fields (method : _root_.CapacityCoordinate.Method data coord) :
    (methodToCanonical method).numericalFlux = method.numericalFlux ∧
      (methodToCanonical method).admitted = method.admitted := ⟨rfl, rfl⟩

theorem method_rule (method : _root_.CapacityCoordinate.Method data coord) :
    (methodToCanonical method).rule = method.rule := rfl

theorem method_admitted (method : _root_.CapacityCoordinate.Method data coord)
    (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) :
    (methodToCanonical method).Admitted d dt current ↔ method.Admitted d dt current := Iff.rfl

theorem method_stable (method : _root_.CapacityCoordinate.Method data coord)
    (d : D) (dt A : ℝ) :
    (methodToCanonical method).StableAt d dt A ↔ method.StableAt d dt A := Iff.rfl

theorem method_withGhost (method : _root_.CapacityCoordinate.Method data coord)
    (ghost : D → Line → ℤ → Fin m → ℝ) :
    methodToCanonical (method.withGhost ghost) = (methodToCanonical method).withGhost ghost := rfl

theorem method_withGhost_admitted (method : _root_.CapacityCoordinate.Method data coord)
    (ghost : D → Line → ℤ → Fin m → ℝ) (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) :
    ((methodToCanonical method).withGhost ghost).Admitted d dt current ↔
      (method.withGhost ghost).Admitted d dt current := Iff.rfl

theorem method_withGhost_advance (method : _root_.CapacityCoordinate.Method data coord)
    (ghost : D → Line → ℤ → Fin m → ℝ) (d : D) (dt : ℝ) (current : Cell → Fin m → ℝ) :
    advance data ((methodToCanonical method).withGhost ghost).rule d dt current =
      advance data (method.withGhost ghost).rule d dt current := rfl

theorem netFluxDefect_eq (rule : D → ℝ → (Cell → Fin m → ℝ) → Face → Fin m → ℝ)
    (d : D) (current : Cell → Fin m → ℝ) (q : Point → ℝ → Fin m → ℝ) (s t : ℝ) (cell : Cell) :
    NumStability.FiniteCoordinate.netFluxDefect data rule d current q s t cell =
      _root_.CapacityNetReferenceError.netFluxDefect data rule d current q s t cell := rfl

end Method

section Mesh
variable {Cell Point : Type*} [Fintype Cell] [MeasurableSpace Point] [PseudoMetricSpace Point]
theorem mesh_eq (cells : FiniteVolumeCellPartition Cell Point) :
    NumStability.FiniteVolumeCellPartition.mesh cells = _root_.CapacityPhysicalMesh.mesh cells := rfl
end Mesh

section Family
variable {D FacePoint : Type*} [Fintype D] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ
local notation "Point" => D → ℝ

def familyToCanonical (family : _root_.PhysicalRefinementQuality.Family D FacePoint m) :
    NumStability.PhysicalRefinementQuality.Family D FacePoint m where
  Cell := family.Cell
  Face := family.Face
  Line := family.Line
  finiteCell := family.finiteCell
  data := family.data
  coordinates := family.coordinates
  method := fun n => methodToCanonical (family.method n)
  measure := family.measure
  measure_eq := family.measure_eq
  states := family.states
  states_nonempty := family.states_nonempty
  states_eq := family.states_eq
  physicalFlux := family.physicalFlux
  normal := family.normal
  normal_flux_eq := family.normal_flux_eq
  region := family.region
  target := family.target
  target_interior_nonempty := family.target_interior_nonempty
  target_inside := family.target_inside
  active_inside := family.active_inside
  target_covered := family.target_covered
  bounded_cells := family.bounded_cells
  mesh := family.mesh
  mesh_actual := family.mesh_actual
  mesh_pos := family.mesh_pos
  mesh_tendsto := family.mesh_tendsto
  horizon := family.horizon
  horizon_pos := family.horizon_pos
  boundaryRegion := family.boundaryRegion
  boundary_measurable := family.boundary_measurable
  boundary_positive := family.boundary_positive
  boundary_finite := family.boundary_finite
  boundary_inside := family.boundary_inside

def familyToDraft (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) :
    _root_.PhysicalRefinementQuality.Family D FacePoint m where
  Cell := family.Cell
  Face := family.Face
  Line := family.Line
  finiteCell := family.finiteCell
  data := family.data
  coordinates := family.coordinates
  method := fun n => methodToDraft (family.method n)
  measure := family.measure
  measure_eq := family.measure_eq
  states := family.states
  states_nonempty := family.states_nonempty
  states_eq := family.states_eq
  physicalFlux := family.physicalFlux
  normal := family.normal
  normal_flux_eq := family.normal_flux_eq
  region := family.region
  target := family.target
  target_interior_nonempty := family.target_interior_nonempty
  target_inside := family.target_inside
  active_inside := family.active_inside
  target_covered := family.target_covered
  bounded_cells := family.bounded_cells
  mesh := family.mesh
  mesh_actual := family.mesh_actual
  mesh_pos := family.mesh_pos
  mesh_tendsto := family.mesh_tendsto
  horizon := family.horizon
  horizon_pos := family.horizon_pos
  boundaryRegion := family.boundaryRegion
  boundary_measurable := family.boundary_measurable
  boundary_positive := family.boundary_positive
  boundary_finite := family.boundary_finite
  boundary_inside := family.boundary_inside

theorem family_draft_roundtrip (family : _root_.PhysicalRefinementQuality.Family D FacePoint m) :
    familyToDraft (familyToCanonical family) = family := by cases family; rfl

theorem family_canonical_roundtrip (family : NumStability.PhysicalRefinementQuality.Family D FacePoint m) :
    familyToCanonical (familyToDraft family) = family := by cases family; rfl

variable (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)

theorem family_indices :
    (familyToCanonical family).Cell = family.Cell ∧
    (familyToCanonical family).Face = family.Face ∧
    (familyToCanonical family).Line = family.Line := ⟨rfl, rfl, rfl⟩

theorem family_geometry :
    (familyToCanonical family).data = family.data ∧
    (familyToCanonical family).coordinates = family.coordinates ∧
    (familyToCanonical family).measure = family.measure ∧
    (familyToCanonical family).mesh = family.mesh ∧
    (familyToCanonical family).boundaryRegion = family.boundaryRegion := ⟨rfl, rfl, rfl, rfl, rfl⟩

theorem family_finiteCell (n : ℕ) : (familyToCanonical family).finiteCell n = family.finiteCell n := rfl

theorem family_projected (n : ℕ) (q : Point → ℝ → State) (t : ℝ) :
    (familyToCanonical family).projected n q t = family.projected n q t := rfl

theorem family_referenceGhost (n : ℕ) (q : Point → ℝ → State) :
    (familyToCanonical family).referenceGhost n q = family.referenceGhost n q := rfl

theorem family_smoothReference (d : D) (q : Point → ℝ → State) :
    (familyToCanonical family).SmoothReference d q ↔ family.SmoothReference d q := Iff.rfl

theorem family_variation (n : ℕ) (d : D) (line : family.Line n)
    (ghost : D → family.Line n → ℤ → State) (current : family.Cell n → State) :
    (familyToCanonical family).variation n d line ghost current =
      family.variation n d line ghost current := rfl

def certificateToCanonical {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    (familyToCanonical family).AccuracyCertificate d q p where
  constant := certificate.constant
  constant_nonneg := certificate.constant_nonneg
  threshold := certificate.threshold
  projection_available := certificate.projection_available
  bound := certificate.bound

def certificateToDraft {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : (familyToCanonical family).AccuracyCertificate d q p) :
    family.AccuracyCertificate d q p where
  constant := certificate.constant
  constant_nonneg := certificate.constant_nonneg
  threshold := certificate.threshold
  projection_available := certificate.projection_available
  bound := certificate.bound

theorem certificate_draft_roundtrip {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    certificateToDraft family (certificateToCanonical family certificate) = certificate := by
  cases certificate
  rfl

theorem certificate_canonical_roundtrip {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : (familyToCanonical family).AccuracyCertificate d q p) :
    certificateToCanonical family (certificateToDraft family certificate) = certificate := by
  cases certificate
  rfl

def certificateEquiv (d : D) (q : Point → ℝ → State) (p : ℝ) :
    family.AccuracyCertificate d q p ≃ (familyToCanonical family).AccuracyCertificate d q p where
  toFun := certificateToCanonical family
  invFun := certificateToDraft family
  left_inv := certificate_draft_roundtrip family
  right_inv := certificate_canonical_roundtrip family

theorem certificate_numeric_witnesses {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    (certificateToCanonical family certificate).constant = certificate.constant ∧
      (certificateToCanonical family certificate).threshold = certificate.threshold := ⟨rfl, rfl⟩

theorem certificate_all_levels {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    ∀ n, certificate.threshold ≤ n → ∀ dt : ℝ, 0 < dt → dt ≤ family.horizon →
    (((familyToCanonical family).method n).withGhost
      ((familyToCanonical family).referenceGhost n q)).Admitted d dt
        ((familyToCanonical family).projected n q 0) → ∀ cell,
    ‖advance ((familyToCanonical family).data n)
        (((familyToCanonical family).method n).withGhost
          ((familyToCanonical family).referenceGhost n q)).rule d dt
          ((familyToCanonical family).projected n q 0) cell -
      (familyToCanonical family).projected n q dt cell‖ ≤
        certificate.constant * dt * family.mesh n ^ p :=
  (certificateToCanonical family certificate).bound

theorem certificate_available_at_same_threshold {d : D} {q : Point → ℝ → State} {p : ℝ}
    (certificate : family.AccuracyCertificate d q p) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ family.horizon ∧
      (((familyToCanonical family).method certificate.threshold).withGhost
        ((familyToCanonical family).referenceGhost certificate.threshold q)).Admitted d dt
          ((familyToCanonical family).projected certificate.threshold q 0) :=
  (certificateToCanonical family certificate).projection_available certificate.threshold le_rfl

def qualityToCanonical (quality : family.HasHighResolution) :
    (familyToCanonical family).HasHighResolution where
  input_available := quality.input_available
  order := by
    intro d
    obtain ⟨p, hp, hcert⟩ := quality.order d
    refine ⟨p, hp, ?_⟩
    intro q hq
    obtain ⟨certificate⟩ := hcert q hq
    exact ⟨certificateToCanonical family certificate⟩
  oscillation := quality.oscillation

def qualityToDraft (quality : (familyToCanonical family).HasHighResolution) :
    family.HasHighResolution where
  input_available := quality.input_available
  order := by
    intro d
    obtain ⟨p, hp, hcert⟩ := quality.order d
    refine ⟨p, hp, ?_⟩
    intro q hq
    obtain ⟨certificate⟩ := hcert q hq
    exact ⟨certificateToDraft family certificate⟩
  oscillation := quality.oscillation

theorem quality_iff : family.HasHighResolution ↔ (familyToCanonical family).HasHighResolution :=
  ⟨qualityToCanonical family, qualityToDraft family⟩

theorem quality_draft_roundtrip (quality : family.HasHighResolution) :
    qualityToDraft family (qualityToCanonical family quality) = quality := Subsingleton.elim _ _

theorem quality_canonical_roundtrip (quality : (familyToCanonical family).HasHighResolution) :
    qualityToCanonical family (qualityToDraft family quality) = quality := Subsingleton.elim _ _

end Family

section Sweep
variable {D Cell Face Point FacePoint Line : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
variable {data : PhysicalData D Cell Face Point FacePoint m}
variable {coord : ℕ → LineCoordinates (m := m) D Cell Face Line}

theorem sweep_step (method : ∀ k, _root_.CapacityCoordinate.Method data (coord k))
    (direction : ℕ → D) (duration : ℕ → ℝ) (k : ℕ) :
    NumStability.CapacityCoordinate.Sweep.step (fun k => methodToCanonical (method k))
      direction duration k = _root_.CapacityBoundarySweep.step method direction duration k := rfl

theorem sweep_run (method : ∀ k, _root_.CapacityCoordinate.Method data (coord k))
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → Fin m → ℝ) (k : ℕ) :
    NumStability.CapacityCoordinate.Sweep.run (fun k => methodToCanonical (method k))
      direction duration initial k =
      _root_.CapacityBoundarySweep.run method direction duration initial k := rfl

theorem fixed_coordinate_run (fixed : LineCoordinates (m := m) D Cell Face Line)
    (method : ℕ → _root_.CapacityCoordinate.Method data fixed)
    (direction : ℕ → D) (duration : ℕ → ℝ) (initial : Cell → Fin m → ℝ) (k : ℕ) :
    NumStability.CapacityCoordinate.Sweep.run (fun k => methodToCanonical (method k))
      direction duration initial k = _root_.CapacityCoordinate.run method direction duration initial k := rfl
end Sweep

section Specification
variable {D FacePoint : Type*} [Fintype D] [DecidableEq D] [MeasurableSpace FacePoint] {m : ℕ}
variable (family : _root_.PhysicalRefinementQuality.Family D FacePoint m)
variable (level : ℕ) (direction : ℕ → D) (duration : ℕ → ℝ)
variable (ghost : ℕ → D → family.Line level → ℤ → Fin m → ℝ)
variable (initial : family.Cell level → Fin m → ℝ) (steps : ℕ)

theorem family_execution (k : ℕ) :
    NumStability.PhysicalHighResolutionSweep.execution (familyToCanonical family)
      level direction duration ghost initial k =
      _root_.PhysicalHighResolutionSweep.execution family level direction duration ghost initial k := rfl

theorem validSubsteps_iff :
    _root_.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps ↔
    NumStability.PhysicalHighResolutionSweep.ValidSubsteps (familyToCanonical family)
      level direction duration ghost initial steps := Iff.rfl

/-- Both complete specification producers are reused. Individual data,
method, admission, certificate and execution observations are compared above;
this avoids duplicating the large theorem's proof-field construction. -/
def specificationToCanonical
    (spec : _root_.PhysicalHighResolutionSweep.Specification family
      level direction duration ghost initial steps) :
    NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
      level direction duration ghost initial steps :=
  NumStability.PhysicalHighResolutionSweep.specification (familyToCanonical family)
    (qualityToCanonical family spec.quality) level direction duration ghost initial steps spec.schedule

def specificationToDraft
    (spec : NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
      level direction duration ghost initial steps) :
    _root_.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps :=
  _root_.PhysicalHighResolutionSweep.specification family (qualityToDraft family spec.quality)
    level direction duration ghost initial steps spec.schedule

theorem specification_iff :
    _root_.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps ↔
    NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
      level direction duration ghost initial steps :=
  ⟨specificationToCanonical family level direction duration ghost initial steps,
    specificationToDraft family level direction duration ghost initial steps⟩

theorem specification_draft_roundtrip
    (spec : _root_.PhysicalHighResolutionSweep.Specification family
      level direction duration ghost initial steps) :
    specificationToDraft family level direction duration ghost initial steps
      (specificationToCanonical family level direction duration ghost initial steps spec) = spec :=
  Subsingleton.elim _ _

theorem specification_canonical_roundtrip
    (spec : NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
      level direction duration ghost initial steps) :
    specificationToCanonical family level direction duration ghost initial steps
      (specificationToDraft family level direction duration ghost initial steps spec) = spec :=
  Subsingleton.elim _ _

theorem admitted_source_conclusion_iff :
    (0 < m ∧ 0 < Fintype.card D ∧
      _root_.PhysicalHighResolutionSweep.Specification family level direction duration ghost initial steps ∧
      _root_.PhysicalHighResolutionSweep.ValidSubsteps family level direction duration ghost initial steps) ↔
    (0 < m ∧ 0 < Fintype.card D ∧
      NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
        level direction duration ghost initial steps ∧
      NumStability.PhysicalHighResolutionSweep.ValidSubsteps (familyToCanonical family)
        level direction duration ghost initial steps) := by
  constructor
  · rintro ⟨hm, hD, spec, hvalid⟩
    exact ⟨hm, hD, specificationToCanonical family level direction duration ghost initial steps spec,
      (validSubsteps_iff family level direction duration ghost initial steps).mp hvalid⟩
  · rintro ⟨hm, hD, spec, hvalid⟩
    exact ⟨hm, hD, specificationToDraft family level direction duration ghost initial steps spec,
      (validSubsteps_iff family level direction duration ghost initial steps).mpr hvalid⟩

/-- Actual canonical source theorem application retains every source premise.
It compares only the final admitted scratch proposal, not the earlier rejected target. -/
theorem canonical_source_application (hm : 0 < m) (hD : 0 < Fintype.card D)
    (quality : family.HasHighResolution) (hschedule : ∀ d : D, ∃ k < steps, direction k = d)
    (hvalid : _root_.PhysicalHighResolutionSweep.ValidSubsteps family
      level direction duration ghost initial steps) :
    0 < m ∧ 0 < Fintype.card D ∧
      NumStability.PhysicalHighResolutionSweep.Specification (familyToCanonical family)
        level direction duration ghost initial steps ∧
      NumStability.PhysicalHighResolutionSweep.ValidSubsteps (familyToCanonical family)
        level direction duration ghost initial steps :=
  NumStability.leveque01_coordinateHighResolutionMethods_sourceContract hm hD
    (familyToCanonical family) (qualityToCanonical family quality) level direction duration ghost initial
    steps hschedule ((validSubsteps_iff family level direction duration ghost initial steps).mp hvalid)

end Specification
end PhysicalDIMTransport

#check PhysicalDIMTransport.incidenceToCanonical
#print axioms PhysicalDIMTransport.incidenceToCanonical
#check PhysicalDIMTransport.incidenceToDraft
#print axioms PhysicalDIMTransport.incidenceToDraft
#check PhysicalDIMTransport.incidence_draft_roundtrip
#print axioms PhysicalDIMTransport.incidence_draft_roundtrip
#check PhysicalDIMTransport.incidence_canonical_roundtrip
#print axioms PhysicalDIMTransport.incidence_canonical_roundtrip
#check PhysicalDIMTransport.methodToCanonical
#print axioms PhysicalDIMTransport.methodToCanonical
#check PhysicalDIMTransport.methodToDraft
#print axioms PhysicalDIMTransport.methodToDraft
#check PhysicalDIMTransport.method_draft_roundtrip
#print axioms PhysicalDIMTransport.method_draft_roundtrip
#check PhysicalDIMTransport.method_canonical_roundtrip
#print axioms PhysicalDIMTransport.method_canonical_roundtrip
#check PhysicalDIMTransport.capacity_eq
#print axioms PhysicalDIMTransport.capacity_eq
#check PhysicalDIMTransport.faceRule_eq
#print axioms PhysicalDIMTransport.faceRule_eq
#check PhysicalDIMTransport.lineAdvance_eq
#print axioms PhysicalDIMTransport.lineAdvance_eq
#check PhysicalDIMTransport.method_fields
#print axioms PhysicalDIMTransport.method_fields
#check PhysicalDIMTransport.method_rule
#print axioms PhysicalDIMTransport.method_rule
#check PhysicalDIMTransport.method_admitted
#print axioms PhysicalDIMTransport.method_admitted
#check PhysicalDIMTransport.method_stable
#print axioms PhysicalDIMTransport.method_stable
#check PhysicalDIMTransport.method_withGhost
#print axioms PhysicalDIMTransport.method_withGhost
#check PhysicalDIMTransport.method_withGhost_admitted
#print axioms PhysicalDIMTransport.method_withGhost_admitted
#check PhysicalDIMTransport.method_withGhost_advance
#print axioms PhysicalDIMTransport.method_withGhost_advance
#check PhysicalDIMTransport.netFluxDefect_eq
#print axioms PhysicalDIMTransport.netFluxDefect_eq
#check PhysicalDIMTransport.mesh_eq
#print axioms PhysicalDIMTransport.mesh_eq
#check PhysicalDIMTransport.familyToCanonical
#print axioms PhysicalDIMTransport.familyToCanonical
#check PhysicalDIMTransport.familyToDraft
#print axioms PhysicalDIMTransport.familyToDraft
#check PhysicalDIMTransport.family_draft_roundtrip
#print axioms PhysicalDIMTransport.family_draft_roundtrip
#check PhysicalDIMTransport.family_canonical_roundtrip
#print axioms PhysicalDIMTransport.family_canonical_roundtrip
#check PhysicalDIMTransport.family_indices
#print axioms PhysicalDIMTransport.family_indices
#check PhysicalDIMTransport.family_geometry
#print axioms PhysicalDIMTransport.family_geometry
#check PhysicalDIMTransport.family_finiteCell
#print axioms PhysicalDIMTransport.family_finiteCell
#check PhysicalDIMTransport.family_projected
#print axioms PhysicalDIMTransport.family_projected
#check PhysicalDIMTransport.family_referenceGhost
#print axioms PhysicalDIMTransport.family_referenceGhost
#check PhysicalDIMTransport.family_smoothReference
#print axioms PhysicalDIMTransport.family_smoothReference
#check PhysicalDIMTransport.family_variation
#print axioms PhysicalDIMTransport.family_variation
#check PhysicalDIMTransport.certificateToCanonical
#print axioms PhysicalDIMTransport.certificateToCanonical
#check PhysicalDIMTransport.certificateToDraft
#print axioms PhysicalDIMTransport.certificateToDraft
#check PhysicalDIMTransport.certificate_draft_roundtrip
#print axioms PhysicalDIMTransport.certificate_draft_roundtrip
#check PhysicalDIMTransport.certificate_canonical_roundtrip
#print axioms PhysicalDIMTransport.certificate_canonical_roundtrip
#check PhysicalDIMTransport.certificateEquiv
#print axioms PhysicalDIMTransport.certificateEquiv
#check PhysicalDIMTransport.certificate_numeric_witnesses
#print axioms PhysicalDIMTransport.certificate_numeric_witnesses
#check PhysicalDIMTransport.certificate_all_levels
#print axioms PhysicalDIMTransport.certificate_all_levels
#check PhysicalDIMTransport.certificate_available_at_same_threshold
#print axioms PhysicalDIMTransport.certificate_available_at_same_threshold
#check PhysicalDIMTransport.qualityToCanonical
#print axioms PhysicalDIMTransport.qualityToCanonical
#check PhysicalDIMTransport.qualityToDraft
#print axioms PhysicalDIMTransport.qualityToDraft
#check PhysicalDIMTransport.quality_iff
#print axioms PhysicalDIMTransport.quality_iff
#check PhysicalDIMTransport.quality_draft_roundtrip
#print axioms PhysicalDIMTransport.quality_draft_roundtrip
#check PhysicalDIMTransport.quality_canonical_roundtrip
#print axioms PhysicalDIMTransport.quality_canonical_roundtrip
#check PhysicalDIMTransport.sweep_step
#print axioms PhysicalDIMTransport.sweep_step
#check PhysicalDIMTransport.sweep_run
#print axioms PhysicalDIMTransport.sweep_run
#check PhysicalDIMTransport.fixed_coordinate_run
#print axioms PhysicalDIMTransport.fixed_coordinate_run
#check PhysicalDIMTransport.family_execution
#print axioms PhysicalDIMTransport.family_execution
#check PhysicalDIMTransport.validSubsteps_iff
#print axioms PhysicalDIMTransport.validSubsteps_iff
#check PhysicalDIMTransport.specificationToCanonical
#print axioms PhysicalDIMTransport.specificationToCanonical
#check PhysicalDIMTransport.specificationToDraft
#print axioms PhysicalDIMTransport.specificationToDraft
#check PhysicalDIMTransport.specification_iff
#print axioms PhysicalDIMTransport.specification_iff
#check PhysicalDIMTransport.specification_draft_roundtrip
#print axioms PhysicalDIMTransport.specification_draft_roundtrip
#check PhysicalDIMTransport.specification_canonical_roundtrip
#print axioms PhysicalDIMTransport.specification_canonical_roundtrip
#check PhysicalDIMTransport.admitted_source_conclusion_iff
#print axioms PhysicalDIMTransport.admitted_source_conclusion_iff
#check PhysicalDIMTransport.canonical_source_application
#print axioms PhysicalDIMTransport.canonical_source_application
