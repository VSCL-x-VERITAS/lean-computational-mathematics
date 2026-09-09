import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Topology.Instances.ENNReal.Lemmas
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

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

end CapacityCoordinate

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

namespace CartesianDirectionalAffineReference
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.FiniteCartesian
open scoped BigOperators
abbrev Direction := Fin 2
abbrev Point := Direction → ℝ
abbrev State := Fin 1 → ℝ

def profile (x t : ℝ) : State := CFLUnitShift.smoothProfile (x - t)
def reference (d : Direction) (x : Point) (t : ℝ) : State := profile (x d) t

theorem reference_smooth (d : Direction) :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry (reference d)) := by
  exact contDiff_pi.mpr (fun _ => ((contDiff_apply ℝ ℝ d).comp contDiff_fst).sub contDiff_snd)

theorem reference_nonconstant (d : Direction) :
    reference d (fun _ => 0) 0 ≠ reference d (fun _ => 1) 0 := by
  intro h
  apply CFLUnitShift.smoothProfile_nonconstant
  simpa only [reference, profile, sub_zero] using h

theorem profile_rectangle : IsRectangleConservationLawSolution profile id :=
  CFLUnitShift.translated_is_conserved _ CFLUnitShift.smoothProfile_integrable

theorem identity_hyperbolic : IsHyperbolicFluxOn (id : State → State) Set.univ := by
  intro state _
  have h := hyperbolicConservationLaw_isHyperbolicFluxAt
    (StationaryRiemannField.transportLaw (m := 1)) state
  have heq : (StationaryRiemannField.transportLaw (m := 1)).physicalFlux = id :=
    funext StationaryRiemannField.physicalFlux
  simpa only [heq] using h

theorem interval_mean {a b : ℝ} (hab : a < b) (t : ℝ) :
    oneDimensionalCellAverage (fun x => profile x t) a b = fun _ => (a + b) / 2 - t := by
  have hf : (fun x => profile x t) = fun x => (x - t) • (1 : State) := by
    funext x i
    simp [profile, CFLUnitShift.smoothProfile]
  rw [hf, oneDimensionalCellAverage, intervalIntegral.integral_smul_const]
  rw [intervalIntegral.integral_sub (f := fun x : ℝ => x) (g := fun _ => t)
    (continuous_id.intervalIntegrable a b) (continuous_const.intervalIntegrable a b),
    integral_id, intervalIntegral.integral_const]
  ext i
  simp only [Pi.smul_apply, smul_eq_mul, Pi.one_apply, mul_one]
  field_simp [ne_of_gt (sub_pos.mpr hab)]
  nlinarith

variable (axes : Direction → OneDimensionalFiniteVolumeGrid)
variable (active : Finset (Direction → ℤ)) (hne : active.Nonempty)
variable (hflux : ∀ _ : Direction, IsHyperbolicFluxOn (id : State → State) Set.univ)

noncomputable def physical := FiniteCartesian.data axes active hne (fun _ => Set.univ) (fun _ => id) hflux

theorem identification : CartesianIdentification (physical axes active hne hflux) axes Subtype.val
    (fun _ face => face) (fun _ => id) where
  left_position := fun _ _ => rfl
  right_position := fun _ _ => rfl
  cell_measure := fun _ => rfl
  face_measurable := data_face_measurable axes active hne _ _ hflux
  face_measure := data_face_measure axes active hne _ _ hflux
  normal_flux := data_normal_flux axes active hne _ _ hflux

theorem box_integrable (d : Direction) (position : Direction → ℤ) (t : ℝ) :
    IntegrableOn (fun x => reference d x t) (CartesianGrid.cellBox axes position) volume := by
  have hc : Continuous (fun x : Point => reference d x t) := by
    exact continuous_pi fun _ => (continuous_apply d).sub continuous_const
  apply (hc.integrableOn_Icc (a := fun e => (axes e).cellLeft (position e))
    (b := fun e => (axes e).cellRight (position e))).mono_set
  intro x hx
  exact ⟨fun e => (hx e (mem_univ e)).1, fun e => (hx e (mem_univ e)).2.le⟩

theorem face_integrable (d : Direction) (face : Direction → ℤ) (t : ℝ) :
    Integrable (fun x => reference d x t) (FiniteCartesian.faceMeasure axes d face) := by
  have hp : 0 < (FiniteCartesian.faceMeasure axes d face Set.univ).toReal := by
    rw [FiniteCartesian.faceMeasure_area]
    exact Finset.prod_pos (fun e _ => (axes e).cellVolume_pos (face e))
  haveI : IsFiniteMeasure (FiniteCartesian.faceMeasure axes d face) :=
    ⟨(ENNReal.toReal_pos_iff.mp hp).2⟩
  have hn : ∀ᵐ x ∂FiniteCartesian.faceMeasure axes d face,
      x d = (axes d).cellLeft (face d) := by
    rw [FiniteCartesian.faceMeasure, ae_map_iff
      (FiniteCartesian.facePoint_measurable axes d face).aemeasurable
      (measurableSet_eq_fun (measurable_pi_apply d) measurable_const)]
    exact Filter.Eventually.of_forall (CartesianGrid.facePoint_normal axes d face)
  apply (integrable_const (profile ((axes d).cellLeft (face d)) t)).congr
  filter_upwards [hn] with x hx
  simp only [reference, hx]

theorem cell_mean (d : Direction) (cell : ↥active) (t : ℝ) :
    (physical axes active hne hflux).cellMean (reference d) cell t =
      fun _ => ((axes d).cellLeft (cell.val d) + (axes d).cellRight (cell.val d)) / 2 - t := by
  unfold reference
  rw [(identification axes active hne hflux).cellMean_lift profile d cell t (profile_rectangle.1 _ _ t)]
  exact interval_mean ((axes d).cell_nonempty (cell.val d)) t

theorem face_flux (d : Direction) (face : Direction → ℤ) (t : ℝ) :
    (physical axes active hne hflux).faceFlux d (reference d) face t =
      CartesianGrid.faceArea axes d face • profile ((axes d).cellLeft (face d)) t :=
  (identification axes active hne hflux).faceFlux_lift profile d face t

theorem face_time_integrable (d : Direction) (face : Direction → ℤ) (s t : ℝ) :
    IntervalIntegrable ((physical axes active hne hflux).faceFlux d (reference d) face) volume s t := by
  have he : (physical axes active hne hflux).faceFlux d (reference d) face =
      fun τ => CartesianGrid.faceArea axes d face • profile ((axes d).cellLeft (face d)) τ :=
    funext (face_flux axes active hne hflux d face)
  rw [he]
  exact (profile_rectangle.2.1 ((axes d).cellLeft (face d)) s t).smul
    (CartesianGrid.faceArea axes d face)

theorem reference_valid (d : Direction) (s t : ℝ) :
    (physical axes active hne hflux).ReferenceOn d (reference d) s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ _
    exact box_integrable axes d cell.val τ
  · intro cell τ _
    exact ⟨face_integrable axes d cell.val τ,
      face_integrable axes d (Function.update cell.val d (cell.val d + 1)) τ⟩
  · intro x hx τ hτ
    exact Set.mem_univ _
  · intro u hu v hv
    refine ⟨?_, ?_⟩
    · intro cell
      exact ⟨face_time_integrable axes active hne hflux d cell.val u v,
        face_time_integrable axes active hne hflux d
          (Function.update cell.val d (cell.val d + 1)) u v⟩
    · intro cell
      exact (identification axes active hne hflux).rectangle_balance_lift profile d profile_rectangle cell u v

/-- An actual Ico ghost box has the same measured mean; it need not be an
active cell. No boundary condition or finite lookup is asserted here. -/
theorem ghost_box_mean (d : Direction) (position : Direction → ℤ) :
    cellVolumeAverage volume (CartesianGrid.cellBox axes position)
      (fun x => reference d x 0) =
      fun _ => ((axes d).cellLeft (position d) + (axes d).cellRight (position d)) / 2 := by
  unfold reference
  rw [CartesianGrid.cellVolumeAverage_projection axes d position (fun x => profile x 0)
    (profile_rectangle.1 _ _ 0)]
  simpa only [sub_zero] using interval_mean ((axes d).cell_nonempty (position d)) 0

theorem unit_transport_reference (d : Direction) (s t : ℝ) :
    (physical axes active hne (fun _ => identity_hyperbolic)).ReferenceOn d
      (reference d) s t :=
  reference_valid axes active hne (fun _ => identity_hyperbolic) d s t

end CartesianDirectionalAffineReference

#check CartesianDirectionalAffineReference.reference_smooth
#print axioms CartesianDirectionalAffineReference.reference_smooth
#check CartesianDirectionalAffineReference.reference_nonconstant
#print axioms CartesianDirectionalAffineReference.reference_nonconstant
#check CartesianDirectionalAffineReference.profile_rectangle
#print axioms CartesianDirectionalAffineReference.profile_rectangle
#check CartesianDirectionalAffineReference.interval_mean
#print axioms CartesianDirectionalAffineReference.interval_mean
#check CartesianDirectionalAffineReference.identification
#print axioms CartesianDirectionalAffineReference.identification
#check CartesianDirectionalAffineReference.box_integrable
#print axioms CartesianDirectionalAffineReference.box_integrable
#check CartesianDirectionalAffineReference.face_integrable
#print axioms CartesianDirectionalAffineReference.face_integrable
#check CartesianDirectionalAffineReference.cell_mean
#print axioms CartesianDirectionalAffineReference.cell_mean
#check CartesianDirectionalAffineReference.face_flux
#print axioms CartesianDirectionalAffineReference.face_flux
#check CartesianDirectionalAffineReference.reference_valid
#print axioms CartesianDirectionalAffineReference.reference_valid
#check CartesianDirectionalAffineReference.face_time_integrable
#print axioms CartesianDirectionalAffineReference.face_time_integrable
#check CartesianDirectionalAffineReference.ghost_box_mean
#print axioms CartesianDirectionalAffineReference.ghost_box_mean
#check CartesianDirectionalAffineReference.identity_hyperbolic
#print axioms CartesianDirectionalAffineReference.identity_hyperbolic
#check CartesianDirectionalAffineReference.unit_transport_reference
#print axioms CartesianDirectionalAffineReference.unit_transport_reference

namespace RefiningCartesianWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian

def reference (d : Direction) : Point → ℝ → State :=
  CartesianDirectionalAffineReference.reference d

theorem reference_smooth (d : Direction) :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry (reference d)) :=
  CartesianDirectionalAffineReference.reference_smooth d

theorem reference_valid (n : ℕ) (d : Direction) (s t : ℝ) :
    (physical n).ReferenceOn d (reference d) s t :=
  CartesianDirectionalAffineReference.reference_valid
    (axes n) (active n) (active_nonempty n) identity_hyperbolic d s t

theorem reference_mean (n : ℕ) (d : Direction) (cell : Cell n) (t : ℝ) :
    (physical n).cellMean (reference d) cell t =
      fun _ => ((axes n d).cellLeft (cell.val d) + (axes n d).cellRight (cell.val d))/2-t :=
  CartesianDirectionalAffineReference.cell_mean
    (axes n) (active n) (active_nonempty n) identity_hyperbolic d cell t

theorem reference_boundary_integrable (n : ℕ) (d e : Direction) (line : Position) (j : ℤ) :
    IntegrableOn (fun x => reference d x 0) (boundaryRegion n e line j) volume :=
  CartesianDirectionalAffineReference.box_integrable (axes n) d _ 0

theorem reference_nonconstant_on_target (d : Direction) :
    ∃ x ∈ target, ∃ y ∈ target, reference d x 0 ≠ reference d y 0 := by
  refine ⟨fun _ => 1/4, ?_, fun _ => 3/4, ?_, ?_⟩
  · norm_num [target]
  · norm_num [target]
  · intro he
    have he0 := congrFun he (0 : Fin 1)
    norm_num [reference, CartesianDirectionalAffineReference.reference,
      CartesianDirectionalAffineReference.profile, CFLUnitShift.smoothProfile] at he0

theorem extract_reference_on_neighbor (n : ℕ) (d : Direction) (cell : Cell n) (j : ℤ)
    (hj : cell.val d - 1 ≤ j ∧ j ≤ cell.val d + 1) :
    (coord n (referenceGhost n (reference d))).extract d
      (Function.update cell.val d 0) (fun c => (physical n).cellMean (reference d) c 0) j =
      fun _ => ((axes n d).cellLeft j + (axes n d).cellRight j)/2 := by
  simp only [LineCoordinates.extract]
  split
  next found he =>
    have hi : found.val d = j :=
      ((coord n (referenceGhost n (reference d))).lookup_sound d
        (Function.update cell.val d 0) j found he).2
    rw [reference_mean]
    simp only [hi, sub_zero]
  next =>
    change referenceGhost n (reference d) d (Function.update cell.val d 0) j = _
    rw [referenceGhost_on_neighbor n (reference d) cell d j hj]
    rw [show reference d = CartesianDirectionalAffineReference.reference d from rfl]
    rw [CartesianDirectionalAffineReference.ghost_box_mean]
    simp only [Function.update_self]

theorem reference_update_exact (n : ℕ) (d : Direction) (cell : Cell n) :
    advance (physical n) (capacityMethod n (referenceGhost n (reference d))).rule d (h n)
      (fun c => (physical n).cellMean (reference d) c 0) cell =
        (physical n).cellMean (reference d) cell (h n) := by
  rw [physical_update_eq_shift]
  change (coord n (referenceGhost n (reference d))).extract d (Function.update cell.val d 0)
    (fun c => (physical n).cellMean (reference d) c 0) (cell.val d - 1) = _
  rw [extract_reference_on_neighbor n d cell _ (by constructor <;> omega), reference_mean]
  ext k
  simp only [axis_left, axis_right, Int.cast_sub, Int.cast_one]
  ring

/-- One fixed, genuinely smooth and spatially nonconstant physical reference
works at every refinement level, using actual measured initial/ghost means
and the same admitted integrated-flux capacity update. This is a directional
reference/consumer, not an instance of the evolving generic quality class. -/
theorem nonconstant_reference_execution (d : Direction) :
    ContDiff ℝ ((⊤ : ℕ∞) : WithTop ℕ∞) (Function.uncurry (reference d)) ∧
    (∃ x ∈ target, ∃ y ∈ target, reference d x 0 ≠ reference d y 0) ∧
    ∀ n, (physical n).ReferenceOn d (reference d) 0 1 ∧
      0 < h n ∧ h n ≤ 1 ∧
      (capacityMethod n (referenceGhost n (reference d))).Admitted d (h n)
        (fun c => (physical n).cellMean (reference d) c 0) ∧
      ∀ cell, advance (physical n) (capacityMethod n (referenceGhost n (reference d))).rule
        d (h n) (fun c => (physical n).cellMean (reference d) c 0) cell =
          (physical n).cellMean (reference d) cell (h n) := by
  refine ⟨reference_smooth d, reference_nonconstant_on_target d, ?_⟩
  intro n
  exact ⟨reference_valid n d 0 1, h_pos n,
    (HighResolutionAdvectionLine.h_le_half n).trans (by norm_num),
    actual_admission n _ _ _, reference_update_exact n d⟩

end RefiningCartesianWitness

set_option pp.deepTerms true
set_option pp.maxSteps 1000000

#check RefiningCartesianWitness.Direction
#print axioms RefiningCartesianWitness.Direction
#check RefiningCartesianWitness.State
#print axioms RefiningCartesianWitness.State
#check RefiningCartesianWitness.Position
#print axioms RefiningCartesianWitness.Position
#check RefiningCartesianWitness.Point
#print axioms RefiningCartesianWitness.Point
#check RefiningCartesianWitness.h
#print axioms RefiningCartesianWitness.h
#check RefiningCartesianWitness.h_pos
#print axioms RefiningCartesianWitness.h_pos
#check RefiningCartesianWitness.h_tendsto
#print axioms RefiningCartesianWitness.h_tendsto
#check RefiningCartesianWitness.active
#print axioms RefiningCartesianWitness.active
#check RefiningCartesianWitness.Cell
#print axioms RefiningCartesianWitness.Cell
#check RefiningCartesianWitness.mem_active
#print axioms RefiningCartesianWitness.mem_active
#check RefiningCartesianWitness.active_nonempty
#print axioms RefiningCartesianWitness.active_nonempty
#check RefiningCartesianWitness.cell_index_bounds
#print axioms RefiningCartesianWitness.cell_index_bounds
#check RefiningCartesianWitness.active_card
#print axioms RefiningCartesianWitness.active_card
#check RefiningCartesianWitness.axes
#print axioms RefiningCartesianWitness.axes
#check RefiningCartesianWitness.axis_left
#print axioms RefiningCartesianWitness.axis_left
#check RefiningCartesianWitness.axis_right
#print axioms RefiningCartesianWitness.axis_right
#check RefiningCartesianWitness.axis_volume
#print axioms RefiningCartesianWitness.axis_volume
#check RefiningCartesianWitness.identity_hyperbolic
#print axioms RefiningCartesianWitness.identity_hyperbolic
#check RefiningCartesianWitness.physical
#print axioms RefiningCartesianWitness.physical
#check RefiningCartesianWitness.physical_volume
#print axioms RefiningCartesianWitness.physical_volume
#check RefiningCartesianWitness.physical_area
#print axioms RefiningCartesianWitness.physical_area
#check RefiningCartesianWitness.target
#print axioms RefiningCartesianWitness.target
#check RefiningCartesianWitness.region
#print axioms RefiningCartesianWitness.region
#check RefiningCartesianWitness.target_nonempty
#print axioms RefiningCartesianWitness.target_nonempty
#check RefiningCartesianWitness.target_open
#print axioms RefiningCartesianWitness.target_open
#check RefiningCartesianWitness.target_inside
#print axioms RefiningCartesianWitness.target_inside
#check RefiningCartesianWitness.active_inside
#print axioms RefiningCartesianWitness.active_inside
#check RefiningCartesianWitness.axis_coverage
#print axioms RefiningCartesianWitness.axis_coverage
#check RefiningCartesianWitness.target_covered
#print axioms RefiningCartesianWitness.target_covered
#check RefiningCartesianWitness.box_bounded
#print axioms RefiningCartesianWitness.box_bounded
#check RefiningCartesianWitness.box_diameter_le
#print axioms RefiningCartesianWitness.box_diameter_le
#check RefiningCartesianWitness.actualMesh
#print axioms RefiningCartesianWitness.actualMesh
#check RefiningCartesianWitness.actualMesh_le
#print axioms RefiningCartesianWitness.actualMesh_le
#check RefiningCartesianWitness.actualMesh_nonneg
#print axioms RefiningCartesianWitness.actualMesh_nonneg
#check RefiningCartesianWitness.actualMesh_positive
#print axioms RefiningCartesianWitness.actualMesh_positive
#check RefiningCartesianWitness.actualMesh_tendsto
#print axioms RefiningCartesianWitness.actualMesh_tendsto
#check RefiningCartesianWitness.physicalWith
#print axioms RefiningCartesianWitness.physicalWith
#check RefiningCartesianWitness.physicalWith_cells
#print axioms RefiningCartesianWitness.physicalWith_cells
#check RefiningCartesianWitness.physicalWith_measure
#print axioms RefiningCartesianWitness.physicalWith_measure
#check RefiningCartesianWitness.tensorFlux
#print axioms RefiningCartesianWitness.tensorFlux
#check RefiningCartesianWitness.normal
#print axioms RefiningCartesianWitness.normal
#check RefiningCartesianWitness.physical_normal_flux
#print axioms RefiningCartesianWitness.physical_normal_flux
#check RefiningCartesianWitness.boundaryIndex
#print axioms RefiningCartesianWitness.boundaryIndex
#check RefiningCartesianWitness.boundaryPosition
#print axioms RefiningCartesianWitness.boundaryPosition
#check RefiningCartesianWitness.boundaryRegion
#print axioms RefiningCartesianWitness.boundaryRegion
#check RefiningCartesianWitness.boundaryIndex_bounds
#print axioms RefiningCartesianWitness.boundaryIndex_bounds
#check RefiningCartesianWitness.boundaryIndex_eq
#print axioms RefiningCartesianWitness.boundaryIndex_eq
#check RefiningCartesianWitness.boundaryPosition_eq
#print axioms RefiningCartesianWitness.boundaryPosition_eq
#check RefiningCartesianWitness.extended_box_inside
#print axioms RefiningCartesianWitness.extended_box_inside
#check RefiningCartesianWitness.boundary_inside
#print axioms RefiningCartesianWitness.boundary_inside
#check RefiningCartesianWitness.boundary_measurable
#print axioms RefiningCartesianWitness.boundary_measurable
#check RefiningCartesianWitness.boundary_volume
#print axioms RefiningCartesianWitness.boundary_volume
#check RefiningCartesianWitness.boundary_positive_finite
#print axioms RefiningCartesianWitness.boundary_positive_finite
#check RefiningCartesianWitness.boundary_on_neighbor
#print axioms RefiningCartesianWitness.boundary_on_neighbor
#check RefiningCartesianWitness.coord
#print axioms RefiningCartesianWitness.coord
#check RefiningCartesianWitness.incidence
#print axioms RefiningCartesianWitness.incidence
#check RefiningCartesianWitness.integratedNumericalFlux
#print axioms RefiningCartesianWitness.integratedNumericalFlux
#check RefiningCartesianWitness.capacityMethod
#print axioms RefiningCartesianWitness.capacityMethod
#check RefiningCartesianWitness.actual_admission
#print axioms RefiningCartesianWitness.actual_admission
#check RefiningCartesianWitness.actual_step_available
#print axioms RefiningCartesianWitness.actual_step_available
#check RefiningCartesianWitness.capacity_at_cell
#print axioms RefiningCartesianWitness.capacity_at_cell
#check RefiningCartesianWitness.line_update_eq_shift
#print axioms RefiningCartesianWitness.line_update_eq_shift
#check RefiningCartesianWitness.physical_update_eq_shift
#print axioms RefiningCartesianWitness.physical_update_eq_shift
#check RefiningCartesianWitness.actual_projection
#print axioms RefiningCartesianWitness.actual_projection
#check RefiningCartesianWitness.referenceGhost
#print axioms RefiningCartesianWitness.referenceGhost
#check RefiningCartesianWitness.referenceGhost_on_neighbor
#print axioms RefiningCartesianWitness.referenceGhost_on_neighbor
#check RefiningCartesianWitness.weighted_mass_balance
#print axioms RefiningCartesianWitness.weighted_mass_balance
#check RefiningCartesianWitness.cellEquiv
#print axioms RefiningCartesianWitness.cellEquiv
#check RefiningCartesianWitness.position
#print axioms RefiningCartesianWitness.position
#check RefiningCartesianWitness.cellAt
#print axioms RefiningCartesianWitness.cellAt
#check RefiningCartesianWitness.extract_at
#print axioms RefiningCartesianWitness.extract_at
#check RefiningCartesianWitness.extract_below
#print axioms RefiningCartesianWitness.extract_below
#check RefiningCartesianWitness.initial
#print axioms RefiningCartesianWitness.initial
#check RefiningCartesianWitness.initial_nonconstant
#print axioms RefiningCartesianWitness.initial_nonconstant
#check RefiningCartesianWitness.initial_origin
#print axioms RefiningCartesianWitness.initial_origin
#check RefiningCartesianWitness.stage
#print axioms RefiningCartesianWitness.stage
#check RefiningCartesianWitness.stage_x_predecessor
#print axioms RefiningCartesianWitness.stage_x_predecessor
#check RefiningCartesianWitness.stage_y_predecessor
#print axioms RefiningCartesianWitness.stage_y_predecessor
#check RefiningCartesianWitness.stage_x_origin
#print axioms RefiningCartesianWitness.stage_x_origin
#check RefiningCartesianWitness.stage_y_bottom
#print axioms RefiningCartesianWitness.stage_y_bottom
#check RefiningCartesianWitness.actual_two_direction_motion
#print axioms RefiningCartesianWitness.actual_two_direction_motion
#check RefiningCartesianWitness.actual_intermediate_admission
#print axioms RefiningCartesianWitness.actual_intermediate_admission
#check RefiningCartesianWitness.reference
#print axioms RefiningCartesianWitness.reference
#check RefiningCartesianWitness.reference_smooth
#print axioms RefiningCartesianWitness.reference_smooth
#check RefiningCartesianWitness.reference_valid
#print axioms RefiningCartesianWitness.reference_valid
#check RefiningCartesianWitness.reference_mean
#print axioms RefiningCartesianWitness.reference_mean
#check RefiningCartesianWitness.reference_boundary_integrable
#print axioms RefiningCartesianWitness.reference_boundary_integrable
#check RefiningCartesianWitness.reference_nonconstant_on_target
#print axioms RefiningCartesianWitness.reference_nonconstant_on_target
#check RefiningCartesianWitness.extract_reference_on_neighbor
#print axioms RefiningCartesianWitness.extract_reference_on_neighbor
#check RefiningCartesianWitness.reference_update_exact
#print axioms RefiningCartesianWitness.reference_update_exact
#check RefiningCartesianWitness.nonconstant_reference_execution
#print axioms RefiningCartesianWitness.nonconstant_reference_execution
