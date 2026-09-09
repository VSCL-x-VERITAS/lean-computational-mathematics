import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianGridGeometry
import Mathlib.MeasureTheory.Integral.Pi
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.PhysicalIntervalSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PhysicalCoordinateGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting

open MeasureTheory
open scoped BigOperators
namespace NumStability.FiniteDirectionalRepair

/-- Finite active physical cells with shared face IDs. Exterior faces require
incidence with their active cell only; no fictitious exterior physical cell
or unspecified boundary condition is introduced. -/
structure PhysicalData (D Cell Face Point FacePoint : Type*)
    [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] (m : ℕ) where
  cells : FiniteVolumeCellPartition Cell Point
  measure : Measure Point
  positive : ∀ cell, measure (cells.cellRegion cell) ≠ 0
  finite : ∀ cell, measure (cells.cellRegion cell) ≠ ⊤
  leftFace : D → Cell → Face
  rightFace : D → Cell → Face
  faceMeasure : D → Face → Measure FacePoint
  facePoint : D → Face → FacePoint → Point
  left_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (leftFace d cell),
    facePoint d (leftFace d cell) point ∈ closure (cells.cellRegion cell)
  right_incidence : ∀ d cell, ∀ᵐ point ∂faceMeasure d (rightFace d cell),
    facePoint d (rightFace d cell) point ∈ closure (cells.cellRegion cell)
  admissibleStates : D → Set (Fin m → ℝ)
  normalFlux : D → Face → FacePoint → (Fin m → ℝ) → Fin m → ℝ
  hyperbolic : ∀ d face point, IsHyperbolicFluxOn (normalFlux d face point) (admissibleStates d)

variable {D Cell Face Point FacePoint : Type*}
variable [MeasurableSpace Point] [TopologicalSpace Point] [MeasurableSpace FacePoint] {m : ℕ}
local notation "State" => Fin m → ℝ

noncomputable def PhysicalData.cellVolume (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : ℝ := (data.measure (data.cells.cellRegion cell)).toReal

theorem PhysicalData.cellVolume_pos (data : PhysicalData D Cell Face Point FacePoint m)
    (cell : Cell) : 0 < data.cellVolume cell := ENNReal.toReal_pos (data.positive cell) (data.finite cell)

noncomputable def PhysicalData.cellMean (data : PhysicalData D Cell Face Point FacePoint m)
    (q : Point → ℝ → State) (cell : Cell) (t : ℝ) : State :=
  cellVolumeAverage data.measure (data.cells.cellRegion cell) (fun x => q x t)

noncomputable def PhysicalData.faceFlux (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (face : Face) (t : ℝ) : State :=
  ∫ point, data.normalFlux d face point (q (data.facePoint d face point) t) ∂data.faceMeasure d face

/-- Every subinterval has an actual physical integral balance. All regularity
and trace premises are restricted to active cells and their incident faces. -/
def PhysicalData.ReferenceOn (data : PhysicalData D Cell Face Point FacePoint m)
    (d : D) (q : Point → ℝ → State) (s t : ℝ) : Prop :=
  (∀ cell, ∀ τ ∈ Set.uIcc s t, IntegrableOn (fun x => q x τ) (data.cells.cellRegion cell) data.measure) ∧
  (∀ cell, ∀ τ ∈ Set.uIcc s t,
    Integrable (fun point => data.normalFlux d (data.leftFace d cell) point
      (q (data.facePoint d (data.leftFace d cell) point) τ)) (data.faceMeasure d (data.leftFace d cell)) ∧
    Integrable (fun point => data.normalFlux d (data.rightFace d cell) point
      (q (data.facePoint d (data.rightFace d cell) point) τ)) (data.faceMeasure d (data.rightFace d cell))) ∧
  (∀ x ∈ data.cells.domain, ∀ τ ∈ Set.uIcc s t, q x τ ∈ data.admissibleStates d) ∧
  ∀ u ∈ Set.uIcc s t, ∀ v ∈ Set.uIcc s t,
    (∀ cell, IntervalIntegrable (data.faceFlux d q (data.leftFace d cell)) volume u v ∧
      IntervalIntegrable (data.faceFlux d q (data.rightFace d cell)) volume u v) ∧
    ∀ cell, data.cellVolume cell • (data.cellMean q cell v - data.cellMean q cell u) =
      ∫ τ in u..v, data.faceFlux d q (data.leftFace d cell) τ - data.faceFlux d q (data.rightFace d cell) τ

/-- Boundary/ghost inputs may be closed over in `rule`; the current numerical
array contains only actual active cell values. Shared face IDs ensure the
same numerical flux is reused by both incident cells. -/
noncomputable def advance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) : State :=
  finiteVolumeCellAverageUpdate dt (data.cellVolume cell) (current cell)
    (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell))

noncomputable def sweep (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (stages : List (D × ℝ)) (current : Cell → State) : Cell → State :=
  orderedOperatorSweep (stages.map fun stage => advance data rule stage.1 stage.2) current

theorem advance_mass_balance (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) (cell : Cell) :
    data.cellVolume cell • advance data rule d dt current cell =
      data.cellVolume cell • current cell - dt •
        (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) :=
  cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _ (data.cellVolume_pos cell).ne'

/-- The finite active-cell balance retains all exterior boundary transfers. -/
theorem finite_mass_balance [Fintype Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (current : Cell → State) :
    (∑ cell, data.cellVolume cell • advance data rule d dt current cell) =
      (∑ cell, data.cellVolume cell • current cell) - dt •
        ∑ cell, (rule d dt current (data.rightFace d cell) - rule d dt current (data.leftFace d cell)) := by
  simp_rw [advance_mass_balance]
  rw [Finset.sum_sub_distrib, Finset.smul_sum]

theorem sweep_cons (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (current : Cell → State) :
    sweep data rule ((d, dt) :: stages) current =
      sweep data rule stages (advance data rule d dt current) := rfl

theorem sweep_split (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (before after : List (D × ℝ)) (d : D) (dt : ℝ) (current : Cell → State) :
    sweep data rule (before ++ (d, dt) :: after) current =
      sweep data rule after (advance data rule d dt (sweep data rule before current)) := by
  simp [sweep, orderedOperatorSweep, List.foldl_append]

def LineLocal [DecidableEq Cell]
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State) : Prop :=
  ∀ d dt current other face,
    (∀ cell ∈ stencil d face, current cell = other cell) →
      rule d dt current face = rule d dt other face

theorem advance_local [DecidableEq Cell] (data : PhysicalData D Cell Face Point FacePoint m)
    (stencil : D → Face → Finset Cell)
    (rule : D → ℝ → (Cell → State) → Face → State)
    (hlocal : LineLocal stencil rule) (d : D) (dt : ℝ)
    (current other : Cell → State) (cell : Cell)
    (hagree : ∀ j ∈ insert cell (stencil d (data.leftFace d cell) ∪ stencil d (data.rightFace d cell)),
      current j = other j) : advance data rule d dt current cell = advance data rule d dt other cell := by
  have hc := hagree cell (by simp)
  have hl := hlocal d dt current other (data.leftFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  have hr := hlocal d dt current other (data.rightFace d cell)
    (fun j hj => hagree j (by simp [hj]))
  simp only [advance, hc, hl, hr]

/-- An auxiliary local estimate uses independent physical averages and flux
histories; it is not the high-resolution class or a stand-in for that class. -/
theorem advance_error_le (data : PhysicalData D Cell Face Point FacePoint m)
    (rule : D → ℝ → (Cell → State) → Face → State) (d : D)
    (current : Cell → State) (q : Point → ℝ → State) {s t : ℝ}
    (href : data.ReferenceOn d q s t) (hst : s < t) (cell : Cell)
    (oldBound leftBound rightBound : ℝ)
    (hold : ‖current cell - data.cellMean q cell s‖ ≤ oldBound)
    (hleft : ‖rule d (t - s) current (data.leftFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t‖ ≤ leftBound)
    (hright : ‖rule d (t - s) current (data.rightFace d cell) -
      oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t‖ ≤ rightBound) :
    ‖advance data rule d (t - s) current cell - data.cellMean q cell t‖ ≤
      oldBound + (t - s) / data.cellVolume cell * (leftBound + rightBound) := by
  have href' := href.2.2.2 s Set.left_mem_uIcc t Set.right_mem_uIcc
  have hb := href'.2 cell
  rw [intervalIntegral.integral_sub (href'.1 cell).1 (href'.1 cell).2] at hb
  rw [smul_sub] at hb
  rw [← cellWidth_smul_oneDimensionalCellAverage _ hst,
    ← cellWidth_smul_oneDimensionalCellAverage _ hst] at hb
  have he : data.cellVolume cell • (advance data rule d (t - s) current cell - data.cellMean q cell t) =
      data.cellVolume cell • (current cell - data.cellMean q cell s) +
      (t - s) • ((rule d (t - s) current (data.leftFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.leftFace d cell)) s t) -
        (rule d (t - s) current (data.rightFace d cell) -
        oneDimensionalCellAverage (data.faceFlux d q (data.rightFace d cell)) s t)) := by
    rw [smul_sub, advance_mass_balance, eq_add_of_sub_eq hb]
    module
  exact norm_le_of_weighted_error_balance (data.cellVolume_pos cell) (sub_nonneg.mpr hst.le)
    he hold hleft hright

end NumStability.FiniteDirectionalRepair

#check NumStability.FiniteDirectionalRepair.PhysicalData
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData
#check NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#print axioms NumStability.FiniteDirectionalRepair.PhysicalData.ReferenceOn
#check NumStability.FiniteDirectionalRepair.advance_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.advance_mass_balance
#check NumStability.FiniteDirectionalRepair.finite_mass_balance
#print axioms NumStability.FiniteDirectionalRepair.finite_mass_balance
#check NumStability.FiniteDirectionalRepair.sweep_cons
#print axioms NumStability.FiniteDirectionalRepair.sweep_cons
#check NumStability.FiniteDirectionalRepair.sweep_split
#print axioms NumStability.FiniteDirectionalRepair.sweep_split
#check NumStability.FiniteDirectionalRepair.LineLocal
#print axioms NumStability.FiniteDirectionalRepair.LineLocal
#check NumStability.FiniteDirectionalRepair.advance_local
#print axioms NumStability.FiniteDirectionalRepair.advance_local
#check NumStability.FiniteDirectionalRepair.advance_error_le
#print axioms NumStability.FiniteDirectionalRepair.advance_error_le

namespace NumStability.FiniteCartesianDraft

open MeasureTheory
open FiniteDirectionalRepair
open scoped BigOperators

variable {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}

theorem axis_right_eq_next_left (axis : OneDimensionalFiniteVolumeGrid) (j : ℤ) :
    axis.cellRight j = axis.cellLeft (j + 1) := by
  simpa using axis.adjacent (j + 1)

theorem axis_left_strictMono (axis : OneDimensionalFiniteVolumeGrid) :
    StrictMono axis.cellLeft := by
  apply strictMono_int_of_lt_succ
  intro j
  rw [← axis_right_eq_next_left]
  exact axis.cell_nonempty j

theorem axis_index_unique (axis : OneDimensionalFiniteVolumeGrid) {a b : ℤ} {x : ℝ}
    (ha : x ∈ Set.Ico (axis.cellLeft a) (axis.cellRight a))
    (hb : x ∈ Set.Ico (axis.cellLeft b) (axis.cellRight b)) : a = b := by
  have cannot {j k : ℤ} (hj : x ∈ Set.Ico (axis.cellLeft j) (axis.cellRight j))
      (hk : x ∈ Set.Ico (axis.cellLeft k) (axis.cellRight k)) (hjk : j < k) : False := by
    have hle : j + 1 ≤ k := by omega
    have h := (axis_left_strictMono axis).monotone hle
    rw [← axis_right_eq_next_left] at h
    exact (not_lt_of_ge (h.trans hk.1)) hj.2
  rcases lt_trichotomy a b with h | h | h
  · exact False.elim (cannot ha hb h)
  · exact h
  · exact False.elim (cannot hb ha h)

omit [Fintype D] [DecidableEq D] in
theorem cellBox_disjoint (axes : D → OneDimensionalFiniteVolumeGrid)
    {a b : D → ℤ} (hab : a ≠ b) :
    Disjoint (CartesianGrid.cellBox axes a) (CartesianGrid.cellBox axes b) := by
  apply Set.disjoint_left.mpr
  intro x hx hy
  apply hab
  funext d
  exact axis_index_unique (axes d) (hx d (Set.mem_univ d)) (hy d (Set.mem_univ d))

omit [DecidableEq D] in
theorem cellBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid) (cell : D → ℤ) :
    MeasurableSet (CartesianGrid.cellBox axes cell) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

omit [DecidableEq D] in
theorem tangentialFaceBox_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : MeasurableSet (CartesianGrid.tangentialFaceBox axes d face) :=
  MeasurableSet.univ_pi fun _ => measurableSet_Ico

def cells (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty) :
    FiniteVolumeCellPartition ↥active (D → ℝ) where
  domain := ⋃ cell : ↥active, CartesianGrid.cellBox axes cell.val
  cellRegion := fun cell => CartesianGrid.cellBox axes cell.val
  cells_nonempty := by
    obtain ⟨cell, hcell⟩ := hne
    exact ⟨⟨cell, hcell⟩⟩
  measurable_cell := fun cell => cellBox_measurable axes cell.val
  disjoint_cells := by
    intro a b hab
    exact cellBox_disjoint axes (fun h => hab (Subtype.ext h))
  covers_domain := by intro point; simp

omit [Fintype D] in
theorem facePoint_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measurable (CartesianGrid.facePoint axes d face) := by
  apply measurable_pi_lambda
  intro e
  by_cases he : e = d
  · subst e
    simpa only [CartesianGrid.facePoint_normal] using
      (measurable_const : Measurable (fun _ : {e : D // e ≠ d} → ℝ => (axes d).cellLeft (face d)))
  · simpa only [CartesianGrid.facePoint_transverse axes d face _ e he] using
      (measurable_pi_apply (⟨e, he⟩ : {e : D // e ≠ d}))

noncomputable def faceMeasure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) : Measure (D → ℝ) :=
  Measure.map (CartesianGrid.facePoint axes d face)
    (volume.restrict (CartesianGrid.tangentialFaceBox axes d face))

omit [Fintype D] in
theorem left_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d cell) :
    CartesianGrid.facePoint axes d cell point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal]
    exact ⟨le_rfl, (axes d).cell_nonempty (cell d) |>.le⟩
  · rw [CartesianGrid.facePoint_transverse axes d cell point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

omit [Fintype D] in
theorem right_face_in_closure (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) (point : {e : D // e ≠ d} → ℝ)
    (hp : point ∈ CartesianGrid.tangentialFaceBox axes d
      (Function.update cell d (cell d + 1))) :
    CartesianGrid.facePoint axes d (Function.update cell d (cell d + 1)) point ∈
      closure (CartesianGrid.cellBox axes cell) := by
  rw [CartesianGrid.tangentialFaceBox_update] at hp
  apply mem_closure_pi.mpr
  intro e _
  rw [closure_Ico ((axes e).cell_nonempty (cell e)).ne]
  by_cases he : e = d
  · subst e
    rw [CartesianGrid.facePoint_normal, ← CartesianGrid.shared_face_position]
    exact ⟨(axes d).cell_nonempty (cell d) |>.le, le_rfl⟩
  · rw [CartesianGrid.facePoint_transverse axes d _ point e he]
    exact ⟨(hp ⟨e, he⟩ (by trivial)).1, (hp ⟨e, he⟩ (by trivial)).2.le⟩

theorem left_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d cell, point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d cell).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d cell)] with point hp
  exact left_face_in_closure axes d cell point hp

theorem right_face_ae_incidence (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (cell : D → ℤ) :
    ∀ᵐ point ∂faceMeasure axes d (Function.update cell d (cell d + 1)),
      point ∈ closure (CartesianGrid.cellBox axes cell) := by
  apply (ae_map_iff (facePoint_measurable axes d _).aemeasurable
    isClosed_closure.measurableSet).2
  filter_upwards [ae_restrict_mem (tangentialFaceBox_measurable axes d _)] with point hp
  exact right_face_in_closure axes d cell point hp

noncomputable def data (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) :
    PhysicalData D ↥active (D → ℤ) (D → ℝ) (D → ℝ) m where
  cells := cells axes active hne
  measure := volume
  positive := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).1.ne'
  finite := by
    intro cell
    have h := CartesianGrid.cellVolume_pos axes cell.val
    rw [← CartesianGrid.cellBox_volume] at h
    exact (ENNReal.toReal_pos_iff.mp h).2.ne
  leftFace := fun _ cell => cell.val
  rightFace := fun d cell => Function.update cell.val d (cell.val d + 1)
  faceMeasure := faceMeasure axes
  facePoint := fun _ _ point => point
  left_incidence := fun d cell => left_face_ae_incidence axes d cell.val
  right_incidence := fun d cell => right_face_ae_incidence axes d cell.val
  admissibleStates := states
  normalFlux := fun d _ _ => flux d
  hyperbolic := fun d _ _ => hflux d

theorem data_cell_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).measure.restrict
      ((data axes active hne states flux hflux).cells.cellRegion cell) =
      volume.restrict (CartesianGrid.cellBox axes cell.val) := rfl

theorem data_cellVolume (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (cell : ↥active) :
    (data axes active hne states flux hflux).cellVolume cell =
      CartesianGrid.cellVolume axes cell.val := CartesianGrid.cellBox_volume axes cell.val

theorem data_face_measure (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    Measure.map ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) =
      Measure.map (CartesianGrid.facePoint axes d face)
        (volume.restrict (CartesianGrid.tangentialFaceBox axes d face)) := by
  exact Measure.map_id

theorem data_shared_face (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d))
    (d : D) (left right : ↥active)
    (hadjacent : right.val = Function.update left.val d (left.val d + 1)) :
    (data axes active hne states flux hflux).rightFace d left =
      (data axes active hne states flux hflux).leftFace d right := hadjacent.symm

theorem data_left_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).leftFace d cell = cell.val := rfl

theorem data_right_position (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (cell : ↥active) :
    (data axes active hne states flux hflux).rightFace d cell =
      Function.update cell.val d (cell.val d + 1) := rfl

theorem data_face_measurable (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    AEMeasurable ((data axes active hne states flux hflux).facePoint d face)
      ((data axes active hne states flux hflux).faceMeasure d face) := measurable_id.aemeasurable

theorem data_normal_flux (axes : D → OneDimensionalFiniteVolumeGrid)
    (active : Finset (D → ℤ)) (hne : active.Nonempty)
    (states : D → Set (Fin m → ℝ)) (flux : D → (Fin m → ℝ) → Fin m → ℝ)
    (hflux : ∀ d, IsHyperbolicFluxOn (flux d) (states d)) (d : D) (face : D → ℤ) :
    ∀ᵐ point ∂(data axes active hne states flux hflux).faceMeasure d face,
      ∀ value, (data axes active hne states flux hflux).normalFlux d face point value = flux d value := by
  exact Filter.Eventually.of_forall fun _ _ => rfl

theorem faceMeasure_area (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (face : D → ℤ) :
    (faceMeasure axes d face Set.univ).toReal = CartesianGrid.faceArea axes d face := by
  rw [faceMeasure, Measure.map_apply_of_aemeasurable
    (facePoint_measurable axes d face).aemeasurable MeasurableSet.univ]
  simpa using CartesianGrid.tangentialFaceBox_volume axes d face

end NumStability.FiniteCartesianDraft

namespace NumStability.FiniteCartesianDraft.Example

open MeasureTheory

def axes : Fin 2 → OneDimensionalFiniteVolumeGrid := fun _ => PhysicalIntervalSweep.axis
def lower : Fin 2 → ℤ := fun _ => 0
def upper : Fin 2 → ℤ := Function.update lower 0 1
def active : Finset (Fin 2 → ℤ) := {lower, upper}

theorem lower_ne_upper : lower ≠ upper := by
  intro h
  have he := congrFun h 0
  norm_num [lower, upper] at he

theorem active_card : active.card = 2 := by simp [active, lower_ne_upper]
theorem active_nonempty : active.Nonempty := by exact ⟨lower, by simp [active]⟩

def lowerCell : ↥active := ⟨lower, by simp [active]⟩
def upperCell : ↥active := ⟨upper, by simp [active]⟩

theorem identity_hyperbolic :
    ∀ _ : Fin 2, IsHyperbolicFluxOn (fun state : Fin 1 → ℝ => state) Set.univ := by
  intro _
  exact PhysicalIntervalSweep.data.hyperbolic 0 (fun _ => 0) ()

noncomputable def physical :
    FiniteDirectionalRepair.PhysicalData (Fin 2) ↥active (Fin 2 → ℤ) (Fin 2 → ℝ) (Fin 2 → ℝ) 1 :=
  data axes active active_nonempty (fun _ => Set.univ) (fun _ state => state) identity_hyperbolic

theorem distinct_active_cells : lowerCell ≠ upperCell := by
  intro h
  exact lower_ne_upper (congrArg Subtype.val h)

theorem shared_internal_face : physical.rightFace 0 lowerCell = physical.leftFace 0 upperCell := rfl

theorem physical_cellVolume (cell : ↥active) : physical.cellVolume cell = 1 := by
  rw [physical, data_cellVolume]
  simp [CartesianGrid.cellVolume, axes, PhysicalIntervalSweep.axis,
    OneDimensionalFiniteVolumeGrid.cellVolume]

theorem physical_faceArea (d : Fin 2) (face : Fin 2 → ℤ) :
    (physical.faceMeasure d face Set.univ).toReal = 1 := by
  change (faceMeasure axes d face Set.univ).toReal = 1
  rw [faceMeasure_area]
  simp [CartesianGrid.faceArea, axes, PhysicalIntervalSweep.axis,
    OneDimensionalFiniteVolumeGrid.cellVolume]

theorem concrete_geometry :
    active.card = 2 ∧ lowerCell ≠ upperCell ∧
    physical.rightFace 0 lowerCell = physical.leftFace 0 upperCell ∧
    (∀ cell, physical.cellVolume cell = 1) ∧
    (∀ d face, (physical.faceMeasure d face Set.univ).toReal = 1) :=
  ⟨active_card, distinct_active_cells, shared_internal_face, physical_cellVolume, physical_faceArea⟩

end NumStability.FiniteCartesianDraft.Example

set_option pp.maxSteps 1000000
set_option pp.deepTerms true
#check NumStability.FiniteCartesianDraft.axis_right_eq_next_left
#print axioms NumStability.FiniteCartesianDraft.axis_right_eq_next_left
#check NumStability.FiniteCartesianDraft.axis_left_strictMono
#print axioms NumStability.FiniteCartesianDraft.axis_left_strictMono
#check NumStability.FiniteCartesianDraft.axis_index_unique
#print axioms NumStability.FiniteCartesianDraft.axis_index_unique
#check NumStability.FiniteCartesianDraft.cellBox_disjoint
#print axioms NumStability.FiniteCartesianDraft.cellBox_disjoint
#check NumStability.FiniteCartesianDraft.cellBox_measurable
#print axioms NumStability.FiniteCartesianDraft.cellBox_measurable
#check NumStability.FiniteCartesianDraft.tangentialFaceBox_measurable
#print axioms NumStability.FiniteCartesianDraft.tangentialFaceBox_measurable
#check NumStability.FiniteCartesianDraft.cells
#print axioms NumStability.FiniteCartesianDraft.cells
#check NumStability.FiniteCartesianDraft.facePoint_measurable
#print axioms NumStability.FiniteCartesianDraft.facePoint_measurable
#check NumStability.FiniteCartesianDraft.faceMeasure
#print axioms NumStability.FiniteCartesianDraft.faceMeasure
#check NumStability.FiniteCartesianDraft.left_face_in_closure
#print axioms NumStability.FiniteCartesianDraft.left_face_in_closure
#check NumStability.FiniteCartesianDraft.right_face_in_closure
#print axioms NumStability.FiniteCartesianDraft.right_face_in_closure
#check NumStability.FiniteCartesianDraft.left_face_ae_incidence
#print axioms NumStability.FiniteCartesianDraft.left_face_ae_incidence
#check NumStability.FiniteCartesianDraft.right_face_ae_incidence
#print axioms NumStability.FiniteCartesianDraft.right_face_ae_incidence
#check NumStability.FiniteCartesianDraft.data
#print axioms NumStability.FiniteCartesianDraft.data
#check NumStability.FiniteCartesianDraft.data_cell_measure
#print axioms NumStability.FiniteCartesianDraft.data_cell_measure
#check NumStability.FiniteCartesianDraft.data_cellVolume
#print axioms NumStability.FiniteCartesianDraft.data_cellVolume
#check NumStability.FiniteCartesianDraft.data_face_measure
#print axioms NumStability.FiniteCartesianDraft.data_face_measure
#check NumStability.FiniteCartesianDraft.data_shared_face
#print axioms NumStability.FiniteCartesianDraft.data_shared_face
#check NumStability.FiniteCartesianDraft.data_left_position
#print axioms NumStability.FiniteCartesianDraft.data_left_position
#check NumStability.FiniteCartesianDraft.data_right_position
#print axioms NumStability.FiniteCartesianDraft.data_right_position
#check NumStability.FiniteCartesianDraft.data_face_measurable
#print axioms NumStability.FiniteCartesianDraft.data_face_measurable
#check NumStability.FiniteCartesianDraft.data_normal_flux
#print axioms NumStability.FiniteCartesianDraft.data_normal_flux
#check NumStability.FiniteCartesianDraft.faceMeasure_area
#print axioms NumStability.FiniteCartesianDraft.faceMeasure_area
#check NumStability.FiniteCartesianDraft.Example.axes
#print axioms NumStability.FiniteCartesianDraft.Example.axes
#check NumStability.FiniteCartesianDraft.Example.lower
#print axioms NumStability.FiniteCartesianDraft.Example.lower
#check NumStability.FiniteCartesianDraft.Example.upper
#print axioms NumStability.FiniteCartesianDraft.Example.upper
#check NumStability.FiniteCartesianDraft.Example.active
#print axioms NumStability.FiniteCartesianDraft.Example.active
#check NumStability.FiniteCartesianDraft.Example.lower_ne_upper
#print axioms NumStability.FiniteCartesianDraft.Example.lower_ne_upper
#check NumStability.FiniteCartesianDraft.Example.active_card
#print axioms NumStability.FiniteCartesianDraft.Example.active_card
#check NumStability.FiniteCartesianDraft.Example.active_nonempty
#print axioms NumStability.FiniteCartesianDraft.Example.active_nonempty
#check NumStability.FiniteCartesianDraft.Example.lowerCell
#print axioms NumStability.FiniteCartesianDraft.Example.lowerCell
#check NumStability.FiniteCartesianDraft.Example.upperCell
#print axioms NumStability.FiniteCartesianDraft.Example.upperCell
#check NumStability.FiniteCartesianDraft.Example.identity_hyperbolic
#print axioms NumStability.FiniteCartesianDraft.Example.identity_hyperbolic
#check NumStability.FiniteCartesianDraft.Example.physical
#print axioms NumStability.FiniteCartesianDraft.Example.physical
#check NumStability.FiniteCartesianDraft.Example.distinct_active_cells
#print axioms NumStability.FiniteCartesianDraft.Example.distinct_active_cells
#check NumStability.FiniteCartesianDraft.Example.shared_internal_face
#print axioms NumStability.FiniteCartesianDraft.Example.shared_internal_face
#check NumStability.FiniteCartesianDraft.Example.physical_cellVolume
#print axioms NumStability.FiniteCartesianDraft.Example.physical_cellVolume
#check NumStability.FiniteCartesianDraft.Example.physical_faceArea
#print axioms NumStability.FiniteCartesianDraft.Example.physical_faceArea
#check NumStability.FiniteCartesianDraft.Example.concrete_geometry
#print axioms NumStability.FiniteCartesianDraft.Example.concrete_geometry
