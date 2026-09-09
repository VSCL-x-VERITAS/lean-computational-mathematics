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

#check CapacityZeroFlux.faceFlux_zero
#print axioms CapacityZeroFlux.faceFlux_zero
#check CapacityZeroFlux.cellMean_eq
#print axioms CapacityZeroFlux.cellMean_eq
#check CapacityZeroFlux.method
#print axioms CapacityZeroFlux.method
#check CapacityZeroFlux.lineAdvance_eq
#print axioms CapacityZeroFlux.lineAdvance_eq
#check CapacityZeroFlux.advance_eq
#print axioms CapacityZeroFlux.advance_eq
#check CapacityZeroFlux.advance_withGhost_eq
#print axioms CapacityZeroFlux.advance_withGhost_eq
#check CapacityZeroFlux.admitted
#print axioms CapacityZeroFlux.admitted
#check CapacityZeroFlux.admitted_withGhost
#print axioms CapacityZeroFlux.admitted_withGhost
#check CapacityZeroFlux.stable
#print axioms CapacityZeroFlux.stable
#check CapacityZeroFlux.stable_withGhost
#print axioms CapacityZeroFlux.stable_withGhost
#check CapacityZeroFlux.positive_available
#print axioms CapacityZeroFlux.positive_available
#check CapacityZeroFlux.exact_reference
#print axioms CapacityZeroFlux.exact_reference
#check CapacityZeroFlux.norm_error_zero
#print axioms CapacityZeroFlux.norm_error_zero
#check CapacityZeroFlux.onceEdgeVariation
#print axioms CapacityZeroFlux.onceEdgeVariation
#check CapacityZeroFlux.variation_eq
#print axioms CapacityZeroFlux.variation_eq


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

def method (data : PhysicalData D Cell Face Point FacePoint m)
    (coord : LineCoordinates (m := m) D Cell Face Line)
    (incidence : PhysicalCapacityBridge.Incidence data coord) (ε : State) :
    CapacityCoordinate.Method data coord where
  incidence := incidence
  numericalFlux := fun _ _ _ _ j => (-(j : ℝ)) • ε
  admitted := fun _ _ _ _ => True

variable (data : PhysicalData D Cell Face Point FacePoint m)
variable (coord : LineCoordinates (m := m) D Cell Face Line)
variable (incidence : PhysicalCapacityBridge.Incidence data coord) (ε : Fin m → ℝ)

theorem lineAdvance_eq (d : D) (line : Line) (dt : ℝ) (values : ℤ → State) (j : ℤ) :
    PhysicalCapacityBridge.lineAdvance data coord (method data coord incidence ε).numericalFlux
      d line dt values j = values j + (dt / PhysicalCapacityBridge.capacity data coord d line j) • ε := by
  have hc : -((j + 1 : ℤ) : ℝ) - -(j : ℝ) = -1 := by push_cast; ring
  change finiteVolumeCellAverageUpdate dt (PhysicalCapacityBridge.capacity data coord d line j)
    (values j) ((-((j + 1 : ℤ) : ℝ)) • ε - (-(j : ℝ)) • ε) = _
  rw [← sub_smul, hc]
  simp [finiteVolumeCellAverageUpdate]

theorem admitted_withGhost (ghost : D → Line → ℤ → State) (d : D) (dt : ℝ)
    (current : Cell → State) : ((method data coord incidence ε).withGhost ghost).Admitted d dt current := by
  intro cell
  trivial

theorem stable (d : D) (dt : ℝ) : (method data coord incidence ε).StableAt d dt 1 := by
  intro cell values other _ _ E _ herr
  simp only [lineAdvance_eq, add_sub_add_right_eq_sub, one_mul]
  exact herr (coord.cellIndex d cell)

/-- Uniform actual physical capacity makes the increment the same in every
active cell. Supplied ghosts do not affect this input-independent flux. -/
theorem advance_withGhost_uniform (V : ℝ) (hV : ∀ cell, data.cellVolume cell = V)
    (ghost : D → Line → ℤ → State) (d : D) (dt : ℝ) (current : Cell → State) :
    advance data ((method data coord incidence ε).withGhost ghost).rule d dt current =
      fun cell => current cell + (dt / V) • ε := by
  funext cell
  rw [(method data coord incidence ε).advance_withGhost_eq, lineAdvance_eq,
    PhysicalCapacityBridge.capacity_cell, hV]
  simp only [LineCoordinates.extract, LineCoordinates.withGhost, coord.lookup_cell]

theorem positive_available (ghost : D → Line → ℤ → State) (d : D) (current : Cell → State)
    (horizon : ℝ) (hH : 0 < horizon) :
    ∃ dt : ℝ, 0 < dt ∧ dt ≤ horizon ∧
      ((method data coord incidence ε).withGhost ghost).Admitted d dt current :=
  ⟨horizon, hH, le_rfl, admitted_withGhost data coord incidence ε ghost d horizon current⟩

/-- For the zero physical-flux law, this is the actual nonzero local error,
for every reference admitted by the physical all-subinterval balance. -/
theorem reference_norm_error (V : ℝ) (hV : ∀ cell, data.cellVolume cell = V)
    (ghost : D → Line → ℤ → State) (d : D) (q : Point → ℝ → State)
    {horizon dt : ℝ} (href : data.ReferenceOn d q 0 horizon)
    (hzero : ∀ face τ, data.faceFlux d q face τ = 0) (hdt : 0 < dt) (hT : dt ≤ horizon)
    (cell : Cell) :
    ‖advance data ((method data coord incidence ε).withGhost ghost).rule d dt
      (fun c => data.cellMean q c 0) cell - data.cellMean q cell dt‖ = dt / V * ‖ε‖ := by
  have hv : 0 < V := by rw [← hV cell]; exact data.cellVolume_pos cell
  rw [advance_withGhost_uniform data coord incidence ε V hV]
  rw [CapacityZeroFlux.cellMean_eq data d q href hzero Set.left_mem_uIcc
    (Set.mem_uIcc_of_le hdt.le hT) cell]
  simp [norm_smul, Real.norm_eq_abs, abs_of_pos hdt, abs_of_pos hv]

theorem cartesian_scaling (h dt : ℝ) (hh : 0 < h) (hdt : 0 < dt) :
    (dt / h ^ 2) • (h ^ 5 • (1 : Fin 1 → ℝ)) = (dt * h ^ 3) • (1 : Fin 1 → ℝ) ∧
    ‖(dt / h ^ 2) • (h ^ 5 • (1 : Fin 1 → ℝ))‖ = dt * h ^ 3 ∧
    0 < dt * h ^ 3 := by
  have he : dt / h ^ 2 * h ^ 5 = dt * h ^ 3 := by field_simp
  have hp : 0 < dt * h ^ 3 := mul_pos hdt (pow_pos hh 3)
  refine ⟨?_, ?_, hp⟩
  · rw [smul_smul, he]
  · rw [smul_smul, he, norm_smul]
    simp [Real.norm_eq_abs, abs_of_pos hdt, abs_of_pos hh]

end CapacitySmallBias

namespace CapacitySmallBias
open NumStability NumStability.FiniteCoordinate
open scoped BigOperators
variable {D Cell Face Line : Type*} {m : ℕ}
local notation "State" => Fin m → ℝ

/-- Actual boundary-edge count on a selected line. Holes produce additional
boundary edges; no universal two-edge assertion is built into this count. -/
noncomputable def boundaryCount [Fintype Cell]
    (coord : LineCoordinates (m := m) D Cell Face Line) (d : D) (line : Line) : ℕ := by
  classical
  exact ∑ cell, if coord.cellLine d cell = line then
    (if coord.lookup d line (coord.cellIndex d cell - 1) = none then 1 else 0) +
      (if coord.lookup d line (coord.cellIndex d cell + 1) = none then 1 else 0) else 0

theorem variation_add_le [Fintype Cell] (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (ghost : D → Line → ℤ → State) (current : Cell → State) (shift : State) :
    CapacityZeroFlux.onceEdgeVariation coord d line ghost (fun cell => current cell + shift) ≤
      CapacityZeroFlux.onceEdgeVariation coord d line ghost current +
        (boundaryCount coord d line : ℝ) * ‖shift‖ := by
  classical
  unfold CapacityZeroFlux.onceEdgeVariation boundaryCount
  simp only [Nat.cast_sum, Finset.sum_mul, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro cell _
  by_cases hl : coord.cellLine d cell = line
  · have hleft : ‖current cell + shift - ghost d line (coord.cellIndex d cell - 1)‖ ≤
        ‖current cell - ghost d line (coord.cellIndex d cell - 1)‖ + ‖shift‖ := by
      simpa [add_comm] using norm_sub_le_norm_sub_add_norm_sub
        (current cell + shift) (current cell) (ghost d line (coord.cellIndex d cell - 1))
    have hright : ‖ghost d line (coord.cellIndex d cell + 1) - (current cell + shift)‖ ≤
        ‖ghost d line (coord.cellIndex d cell + 1) - current cell‖ + ‖shift‖ := by
      simpa using norm_sub_le_norm_sub_add_norm_sub
        (ghost d line (coord.cellIndex d cell + 1)) (current cell) (current cell + shift)
    cases hp : coord.lookup d line (coord.cellIndex d cell - 1) <;>
      cases hn : coord.lookup d line (coord.cellIndex d cell + 1) <;>
        simp [LineCoordinates.withGhost, LineCoordinates.extract, hl, hp, hn] <;> linarith
  · simp [LineCoordinates.withGhost, hl]

theorem variation_add_le_two [Fintype Cell] (coord : LineCoordinates (m := m) D Cell Face Line)
    (d : D) (line : Line) (ghost : D → Line → ℤ → State) (current : Cell → State) (shift : State)
    (hcount : boundaryCount coord d line ≤ 2) :
    CapacityZeroFlux.onceEdgeVariation coord d line ghost (fun cell => current cell + shift) ≤
      CapacityZeroFlux.onceEdgeVariation coord d line ghost current + 2 * ‖shift‖ := by
  apply (variation_add_le coord d line ghost current shift).trans
  have hc : (boundaryCount coord d line : ℝ) ≤ 2 := by exact_mod_cast hcount
  exact add_le_add le_rfl (mul_le_mul_of_nonneg_right hc (norm_nonneg shift))

end CapacitySmallBias

#check CapacitySmallBias.constantFlux_hyperbolic
#print axioms CapacitySmallBias.constantFlux_hyperbolic
#check CapacitySmallBias.method
#print axioms CapacitySmallBias.method
#check CapacitySmallBias.lineAdvance_eq
#print axioms CapacitySmallBias.lineAdvance_eq
#check CapacitySmallBias.admitted_withGhost
#print axioms CapacitySmallBias.admitted_withGhost
#check CapacitySmallBias.stable
#print axioms CapacitySmallBias.stable
#check CapacitySmallBias.advance_withGhost_uniform
#print axioms CapacitySmallBias.advance_withGhost_uniform
#check CapacitySmallBias.positive_available
#print axioms CapacitySmallBias.positive_available
#check CapacitySmallBias.reference_norm_error
#print axioms CapacitySmallBias.reference_norm_error
#check CapacitySmallBias.cartesian_scaling
#print axioms CapacitySmallBias.cartesian_scaling
#check CapacitySmallBias.boundaryCount
#print axioms CapacitySmallBias.boundaryCount
#check CapacitySmallBias.variation_add_le
#print axioms CapacitySmallBias.variation_add_le
#check CapacitySmallBias.variation_add_le_two
#print axioms CapacitySmallBias.variation_add_le_two
