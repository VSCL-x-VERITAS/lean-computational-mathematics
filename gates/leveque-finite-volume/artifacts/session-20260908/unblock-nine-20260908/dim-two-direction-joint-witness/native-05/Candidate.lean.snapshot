import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateHighResolutionMethods
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import Mathlib.Data.Fintype.BigOperators

set_option maxRecDepth 4096
set_option maxHeartbeats 800000

/- Artifact-only full two-direction application to current canonical definitions.
The separate pending C-infinity correction requires a fresh replay. -/
namespace DIMTwoDirectionJointWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine NumStability.FiniteCartesian
open scoped BigOperators

abbrev Direction := Fin 2
abbrev State := Fin 1 → ℝ
abbrev Position := Direction → ℤ
noncomputable def active : Finset Position := Fintype.piFinset (fun _ => Finset.Ico 0 4)
abbrev Cell := ↥active

theorem mem_active (p : Position) : p ∈ active ↔ ∀ d, 0 ≤ p d ∧ p d < 4 := by
  simp [active, Fintype.mem_piFinset]

theorem active_nonempty : active.Nonempty := ⟨0, (mem_active _).2 (by intro d; norm_num)⟩

theorem cell_index_bounds (cell : Cell) (d : Direction) : 0 ≤ cell.val d ∧ cell.val d < 4 :=
  (mem_active _).1 cell.property d

def position (i j : ℤ) : Position := ![i,j]
def cellAt (i j : ℤ) (hi : 0 ≤ i ∧ i < 4) (hj : 0 ≤ j ∧ j < 4) : Cell :=
  ⟨position i j, (mem_active _).2 (by intro d; fin_cases d <;> simpa [position])⟩

noncomputable def axes : Direction → OneDimensionalFiniteVolumeGrid :=
  fun _ => (HighResolutionAdvectionLine.family 1).grid 0

theorem identity_hyperbolic : ∀ _ : Direction, IsHyperbolicFluxOn (id : State → State) univ := by
  intro d state hs
  exact (HighResolutionAdvectionLine.family 1).hyperbolic 0 (by norm_num [HighResolutionAdvectionLine.family]) state hs

noncomputable def physical : PhysicalData Direction Cell Position
    (Direction → ℝ) (Direction → ℝ) 1 :=
  data axes active active_nonempty (fun _ => univ) (fun _ => id) identity_hyperbolic

noncomputable def coord : LineCoordinates (m := 1) Direction Cell Position Position where
  cellLine := fun d cell => Function.update cell.val d 0
  cellIndex := fun d cell => cell.val d
  faceLine := fun d face => Function.update face d 0
  faceIndex := fun d face => face d
  lookup := fun d line j =>
    if h : line d = 0 ∧ Function.update line d j ∈ active then
      some ⟨Function.update line d j, h.2⟩ else none
  lookup_cell := by
    intro d cell
    have h : (Function.update cell.val d 0) d = 0 ∧
        Function.update (Function.update cell.val d 0) d (cell.val d) ∈ active := by
      simp [cell.property]
    rw [dif_pos h]
    congr 1
    apply Subtype.ext
    simp
  lookup_sound := by
    intro d line j cell he
    split at he
    next h =>
      have hc := Option.some.inj he
      subst cell
      constructor
      · simp only [Function.update_idem]
        rw [← h.1, Function.update_eq_self]
      · simp
    next => contradiction
  ghost := fun _ _ _ => 0

theorem axis_volume (d : Direction) (j : ℤ) : (axes d).cellVolume j = (1 : ℝ) / 2 := by
  change (CFLUnitShift.grid (HighResolutionAdvectionLine.h 0) (HighResolutionAdvectionLine.h_pos 0)).cellVolume j = _
  rw [CFLUnitShift.grid_volume, HighResolutionAdvectionLine.h_eq]
  norm_num

theorem physical_volume (cell : Cell) : physical.cellVolume cell = (1 : ℝ) / 4 := by
  rw [physical, data_cellVolume]
  simp [CartesianGrid.cellVolume, axis_volume]
  norm_num

theorem physical_area (d : Direction) (face : Position) :
    (physical.faceMeasure d face univ).toReal = (1 : ℝ) / 2 := by
  change (faceMeasure axes d face univ).toReal = _
  rw [faceMeasure_area]
  fin_cases d <;> norm_num [CartesianGrid.faceArea, Fin.prod_univ_two, axis_volume]

noncomputable def families : Direction → Position → LineFamily 1 :=
  fun _ _ => HighResolutionAdvectionLine.family 1

theorem quality : ∀ d line, (families d line).HasControlledHighResolution :=
  fun _ _ => HighResolutionAdvectionLine.family_quality 1

noncomputable def method : LineRealization physical coord families where
  level := fun _ _ => 0
  duration := fun _ => HighResolutionAdvectionLine.h 0
  duration_eq := fun _ _ => rfl
  area := fun _ _ => 1 / 2
  area_pos := by intros; norm_num
  left_line := fun _ _ => rfl
  right_line := by intro d cell; simp [coord, physical, data]
  left_index := fun _ _ => rfl
  right_index := by intro d cell; simp [coord, physical, data]
  active_cell := by intro d cell; exact Finset.mem_Ico.mpr (cell_index_bounds cell d)
  volume_eq := by
    intro d cell
    rw [physical_volume]
    change (1 : ℝ) / 4 = 1 / 2 * (axes d).cellVolume (cell.val d)
    rw [axis_volume]
    norm_num
  physical_flux := by
    intro d face state
    have hf : IsFiniteMeasure (physical.faceMeasure d face) :=
      ⟨lt_top_iff_ne_top.mpr (ENNReal.toReal_pos_iff.mp (by rw [physical_area]; norm_num)).2.ne⟩
    refine ⟨integrable_const state, ?_⟩
    change (∫ _, state ∂physical.faceMeasure d face) = ((1 : ℝ) / 2) • state
    rw [integral_const]
    simp only [measureReal_def, physical_area]
  states_eq := fun _ _ => rfl

theorem cartesian : CartesianIdentification
    physical axes Subtype.val (fun _ face => face) (fun _ => id) where
  left_position := fun _ _ => rfl
  right_position := fun _ _ => rfl
  cell_measure := fun _ => rfl
  face_measurable := data_face_measurable axes active active_nonempty _ _ identity_hyperbolic
  face_measure := data_face_measure axes active active_nonempty _ _ identity_hyperbolic
  normal_flux := data_normal_flux axes active active_nonempty _ _ identity_hyperbolic

def initial (cell : Cell) : State := if cell.val = 0 then 1 else 0
def reference : (Direction → ℝ) → ℝ → State := fun _ _ => 0

theorem initial_nonconstant :
    initial (cellAt 0 0 (by omega) (by omega)) ≠ initial (cellAt 1 0 (by omega) (by omega)) := by
  norm_num [initial, cellAt, position, funext_iff, Fin.forall_fin_two]

theorem mean_zero (cell : Cell) (t : ℝ) : physical.cellMean reference cell t = 0 := by
  simp [PhysicalData.cellMean, cellVolumeAverage, reference]

theorem flux_zero (d : Direction) (face : Position) (t : ℝ) :
    physical.faceFlux d reference face t = 0 := by
  simp [PhysicalData.faceFlux, physical, data, reference]

theorem reference_valid (d : Direction) (s t : ℝ) : physical.ReferenceOn d reference s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ hτ; exact integrableOn_zero
  · intro cell τ hτ; exact ⟨integrable_zero _ _ _, integrable_zero _ _ _⟩
  · intro x hx τ hτ; exact mem_univ _
  · intro u hu v hv
    refine ⟨?_, ?_⟩
    · intro cell
      constructor <;>
        (convert (intervalIntegrable_const : IntervalIntegrable (fun _ : ℝ => (0 : State)) volume u v) using 1
         funext τ
         exact flux_zero _ _ τ)
    · intro cell
      simp only [mean_zero, flux_zero, sub_self, smul_zero, intervalIntegral.integral_zero]

theorem initial_error (cell : Cell) : ‖initial cell - physical.cellMean reference cell 0‖ ≤ 1 := by
  rw [mean_zero]
  simp only [initial]
  split <;> simp

theorem admitted (d : Direction) (current : Cell → State) : method.Admitted d current :=
  fun _ => True.intro

theorem extracted_zero (d : Direction) (line : Position) :
    coord.extract d line (fun _ : Cell => (0 : State)) = 0 := by
  funext j
  simp only [LineCoordinates.extract, coord]
  split <;> rfl

theorem rule_zero (d : Direction) (face : Position) :
    method.rule d (method.duration d) (fun c => physical.cellMean reference c 0) face = 0 := by
  simp only [mean_zero, LineRealization.rule, method, families, HighResolutionAdvectionLine.family,
    extracted_zero, Pi.zero_apply, smul_zero]

noncomputable def amplification (_ : ℕ) : ℝ :=
  1 + (HighResolutionAdvectionLine.family 1).stabilityRate (HighResolutionAdvectionLine.family_quality 1) *
    HighResolutionAdvectionLine.h 0

theorem face_error_zero (d : Direction) (face : Position) :
    ‖method.rule d (method.duration d) (fun cell => physical.cellMean reference cell 0) face -
      oneDimensionalCellAverage (physical.faceFlux d reference face) 0 (method.duration d)‖ ≤ 0 := by
  simp only [rule_zero, flux_zero, oneDimensionalCellAverage, intervalIntegral.integral_zero,
    smul_zero, sub_self, norm_zero, le_refl]

def direction (n : ℕ) : Direction := if n = 0 then 0 else 1

theorem schedule : ∀ d : Direction, ∃ n < 2, direction n = d := by
  intro d
  fin_cases d
  · exact ⟨0, by omega, rfl⟩
  · exact ⟨1, by omega, rfl⟩

noncomputable def full_application :=
  NumStability.leveque01_coordinateHighResolutionMethods_sourceContract
    (data := physical) (coord := coord) (family := families)
    (by norm_num : 0 < 1) (by simp : 0 < Fintype.card Direction)
    (fun _ => method) direction quality initial (fun _ => reference) 2
    amplification (fun _ => 0) (fun _ => 0) 1 (fun _ _ => 0) (fun _ _ => 0)
    (fun _ _ => reference_valid _ 0 _) initial_error
    (fun _ _ => admitted _ _) (fun _ _ => admitted _ _)
    (fun _ _ _ => le_rfl)
    (fun _ _ cell => face_error_zero _ _) (fun _ _ cell => face_error_zero _ _)
    (by intros; simp) (by intros; simp only [mean_zero, sub_self, norm_zero, le_refl]) schedule

theorem active_count : active.card = 16 := by
  simp [active, Fintype.card_piFinset]

theorem advance_shift (d : Direction) (current : Cell → State) (cell : Cell) :
    advance physical method.rule d (method.duration d) current cell =
      coord.extract d (Function.update cell.val d 0) current (cell.val d - 1) := by
  rw [method.advance_eq]
  exact HighResolutionAdvectionLine.family_advance 1 0 _ _

theorem extract_at (d : Direction) (line : Position) (j : ℤ) (cell : Cell)
    (hline : line d = 0) (heq : Function.update line d j = cell.val)
    (current : Cell → State) : coord.extract d line current j = current cell := by
  have hci : coord.cellIndex d cell = j := by
    change cell.val d = j
    rw [← heq]
    simp
  have hcl : coord.cellLine d cell = line := by
    change Function.update cell.val d 0 = line
    rw [← heq, Function.update_idem, ← hline, Function.update_eq_self]
  rw [← hcl, ← hci]
  exact coord.extract_cell d current cell

theorem extract_outside (d : Direction) (line : Position) (j : ℤ)
    (hj : j < 0) (current : Cell → State) : coord.extract d line current j = 0 := by
  have hnot : ¬(line d = 0 ∧ Function.update line d j ∈ active) := by
    intro h
    have hz := (mem_active _).1 h.2 d
    simp only [Function.update_self] at hz
    omega
  simp [LineCoordinates.extract, coord, hnot]

theorem advance_x_predecessor (current : Cell → State) :
    advance physical method.rule 0 (method.duration 0) current (cellAt 1 0 (by omega) (by omega)) =
      current (cellAt 0 0 (by omega) (by omega)) := by
  rw [advance_shift]
  apply extract_at
  · simp
  · funext d
    fin_cases d <;> norm_num [cellAt, position, Function.update_apply]

theorem advance_x_origin (current : Cell → State) :
    advance physical method.rule 0 (method.duration 0) current (cellAt 0 0 (by omega) (by omega)) = 0 := by
  rw [advance_shift]
  apply extract_outside
  norm_num [cellAt, position]

theorem advance_y_predecessor (current : Cell → State) :
    advance physical method.rule 1 (method.duration 1) current (cellAt 1 1 (by omega) (by omega)) =
      current (cellAt 1 0 (by omega) (by omega)) := by
  rw [advance_shift]
  apply extract_at
  · simp
  · funext d
    fin_cases d <;> norm_num [cellAt, position, Function.update_apply]

theorem advance_y_bottom (current : Cell → State) :
    advance physical method.rule 1 (method.duration 1) current (cellAt 1 0 (by omega) (by omega)) = 0 := by
  rw [advance_shift]
  apply extract_outside
  norm_num [cellAt, position]

theorem initial_origin : initial (cellAt 0 0 (by omega) (by omega)) = 1 := by
  norm_num [initial, cellAt, position, funext_iff, Fin.forall_fin_two]

theorem first_stage_moves :
    coordinateExecution (fun _ => method) direction initial 1 (cellAt 0 0 (by omega) (by omega)) = 0 ∧
    coordinateExecution (fun _ => method) direction initial 1 (cellAt 1 0 (by omega) (by omega)) = 1 := by
  constructor
  · rw [coordinateExecution_succ]
    exact advance_x_origin initial
  · rw [coordinateExecution_succ]
    exact (advance_x_predecessor initial).trans initial_origin

theorem second_stage_moves :
    coordinateExecution (fun _ => method) direction initial 2 (cellAt 1 0 (by omega) (by omega)) = 0 ∧
    coordinateExecution (fun _ => method) direction initial 2 (cellAt 1 1 (by omega) (by omega)) = 1 := by
  constructor
  · rw [show (2 : ℕ) = 1 + 1 from rfl, coordinateExecution_succ]
    exact advance_y_bottom _
  · rw [show (2 : ℕ) = 1 + 1 from rfl, coordinateExecution_succ]
    exact (advance_y_predecessor _).trans first_stage_moves.2

theorem step_duration (d : Direction) : method.duration d = (1 : ℝ) / 2 := by
  change HighResolutionAdvectionLine.h 0 = _
  rw [HighResolutionAdvectionLine.h_eq]
  norm_num

theorem physical_flux_identity (d : Direction) (face : Position) (point : Direction → ℝ) (state : State) :
    physical.normalFlux d face point state = state := rfl

theorem numerical_flux_value : method.rule 0 (method.duration 0) initial (position 1 0) =
    ((1 : ℝ) / 2) • (1 : State) := by
  change ((1 : ℝ) / 2) • coord.extract 0 (Function.update (position 1 0) 0 0)
    initial (position 1 0 0 - 1) = _
  have he : coord.extract 0 (Function.update (position 1 0) 0 0)
      initial (position 1 0 0 - 1) = initial (cellAt 0 0 (by omega) (by omega)) := by
    apply extract_at
    · simp
    · funext d
      fin_cases d <;> norm_num [cellAt, position, Function.update_apply]
  rw [he, initial_origin]

theorem numerical_flux_nonzero : method.rule 0 (method.duration 0) initial (position 1 0) ≠ 0 := by
  rw [numerical_flux_value]
  intro heq
  have he := congrFun heq 0
  norm_num at he

noncomputable def joint_applicability :=
  And.intro full_application (And.intro cartesian (And.intro active_count
    (And.intro initial_nonconstant (And.intro initial_origin
      (And.intro first_stage_moves (And.intro second_stage_moves numerical_flux_nonzero))))))

end DIMTwoDirectionJointWitness

set_option pp.deepTerms true
set_option pp.maxSteps 1000000

#check DIMTwoDirectionJointWitness.Direction
#print axioms DIMTwoDirectionJointWitness.Direction
#check DIMTwoDirectionJointWitness.State
#print axioms DIMTwoDirectionJointWitness.State
#check DIMTwoDirectionJointWitness.Position
#print axioms DIMTwoDirectionJointWitness.Position
#check DIMTwoDirectionJointWitness.Cell
#print axioms DIMTwoDirectionJointWitness.Cell
#check DIMTwoDirectionJointWitness.active
#print axioms DIMTwoDirectionJointWitness.active
#check DIMTwoDirectionJointWitness.position
#print axioms DIMTwoDirectionJointWitness.position
#check DIMTwoDirectionJointWitness.cellAt
#print axioms DIMTwoDirectionJointWitness.cellAt
#check DIMTwoDirectionJointWitness.axes
#print axioms DIMTwoDirectionJointWitness.axes
#check DIMTwoDirectionJointWitness.physical
#print axioms DIMTwoDirectionJointWitness.physical
#check DIMTwoDirectionJointWitness.coord
#print axioms DIMTwoDirectionJointWitness.coord
#check DIMTwoDirectionJointWitness.families
#print axioms DIMTwoDirectionJointWitness.families
#check DIMTwoDirectionJointWitness.method
#print axioms DIMTwoDirectionJointWitness.method
#check DIMTwoDirectionJointWitness.initial
#print axioms DIMTwoDirectionJointWitness.initial
#check DIMTwoDirectionJointWitness.reference
#print axioms DIMTwoDirectionJointWitness.reference
#check DIMTwoDirectionJointWitness.amplification
#print axioms DIMTwoDirectionJointWitness.amplification
#check DIMTwoDirectionJointWitness.direction
#print axioms DIMTwoDirectionJointWitness.direction
#check DIMTwoDirectionJointWitness.full_application
#print axioms DIMTwoDirectionJointWitness.full_application
#check DIMTwoDirectionJointWitness.joint_applicability
#print axioms DIMTwoDirectionJointWitness.joint_applicability
#check DIMTwoDirectionJointWitness.mem_active
#print axioms DIMTwoDirectionJointWitness.mem_active
#check DIMTwoDirectionJointWitness.active_nonempty
#print axioms DIMTwoDirectionJointWitness.active_nonempty
#check DIMTwoDirectionJointWitness.cell_index_bounds
#print axioms DIMTwoDirectionJointWitness.cell_index_bounds
#check DIMTwoDirectionJointWitness.identity_hyperbolic
#print axioms DIMTwoDirectionJointWitness.identity_hyperbolic
#check DIMTwoDirectionJointWitness.axis_volume
#print axioms DIMTwoDirectionJointWitness.axis_volume
#check DIMTwoDirectionJointWitness.physical_volume
#print axioms DIMTwoDirectionJointWitness.physical_volume
#check DIMTwoDirectionJointWitness.physical_area
#print axioms DIMTwoDirectionJointWitness.physical_area
#check DIMTwoDirectionJointWitness.quality
#print axioms DIMTwoDirectionJointWitness.quality
#check DIMTwoDirectionJointWitness.cartesian
#print axioms DIMTwoDirectionJointWitness.cartesian
#check DIMTwoDirectionJointWitness.initial_nonconstant
#print axioms DIMTwoDirectionJointWitness.initial_nonconstant
#check DIMTwoDirectionJointWitness.mean_zero
#print axioms DIMTwoDirectionJointWitness.mean_zero
#check DIMTwoDirectionJointWitness.flux_zero
#print axioms DIMTwoDirectionJointWitness.flux_zero
#check DIMTwoDirectionJointWitness.reference_valid
#print axioms DIMTwoDirectionJointWitness.reference_valid
#check DIMTwoDirectionJointWitness.initial_error
#print axioms DIMTwoDirectionJointWitness.initial_error
#check DIMTwoDirectionJointWitness.admitted
#print axioms DIMTwoDirectionJointWitness.admitted
#check DIMTwoDirectionJointWitness.extracted_zero
#print axioms DIMTwoDirectionJointWitness.extracted_zero
#check DIMTwoDirectionJointWitness.rule_zero
#print axioms DIMTwoDirectionJointWitness.rule_zero
#check DIMTwoDirectionJointWitness.face_error_zero
#print axioms DIMTwoDirectionJointWitness.face_error_zero
#check DIMTwoDirectionJointWitness.schedule
#print axioms DIMTwoDirectionJointWitness.schedule
#check DIMTwoDirectionJointWitness.active_count
#print axioms DIMTwoDirectionJointWitness.active_count
#check DIMTwoDirectionJointWitness.advance_shift
#print axioms DIMTwoDirectionJointWitness.advance_shift
#check DIMTwoDirectionJointWitness.extract_at
#print axioms DIMTwoDirectionJointWitness.extract_at
#check DIMTwoDirectionJointWitness.extract_outside
#print axioms DIMTwoDirectionJointWitness.extract_outside
#check DIMTwoDirectionJointWitness.advance_x_predecessor
#print axioms DIMTwoDirectionJointWitness.advance_x_predecessor
#check DIMTwoDirectionJointWitness.advance_x_origin
#print axioms DIMTwoDirectionJointWitness.advance_x_origin
#check DIMTwoDirectionJointWitness.advance_y_predecessor
#print axioms DIMTwoDirectionJointWitness.advance_y_predecessor
#check DIMTwoDirectionJointWitness.advance_y_bottom
#print axioms DIMTwoDirectionJointWitness.advance_y_bottom
#check DIMTwoDirectionJointWitness.initial_origin
#print axioms DIMTwoDirectionJointWitness.initial_origin
#check DIMTwoDirectionJointWitness.first_stage_moves
#print axioms DIMTwoDirectionJointWitness.first_stage_moves
#check DIMTwoDirectionJointWitness.second_stage_moves
#print axioms DIMTwoDirectionJointWitness.second_stage_moves
#check DIMTwoDirectionJointWitness.step_duration
#print axioms DIMTwoDirectionJointWitness.step_duration
#check DIMTwoDirectionJointWitness.physical_flux_identity
#print axioms DIMTwoDirectionJointWitness.physical_flux_identity
#check DIMTwoDirectionJointWitness.numerical_flux_value
#print axioms DIMTwoDirectionJointWitness.numerical_flux_value
#check DIMTwoDirectionJointWitness.numerical_flux_nonzero
#print axioms DIMTwoDirectionJointWitness.numerical_flux_nonzero
