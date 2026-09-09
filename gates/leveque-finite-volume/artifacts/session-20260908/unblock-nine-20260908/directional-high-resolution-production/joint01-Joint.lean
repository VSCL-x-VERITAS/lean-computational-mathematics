import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FinitePhysicalReferenceError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RefiningLineMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethod
import ComputationalMathematics.Analysis.Normed.Group.SequentialError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineMethodEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCellProjection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianGeometry
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FiniteCartesianReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.CFLUnitShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.HighResolutionAdvectionLine
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.HighResolutionCoordinateSweep

namespace DIMJointPrimaryWitness

open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine
open NumStability.FiniteCartesian NumStability.SequentialError
open scoped BigOperators

abbrev Direction := Fin 1
abbrev State := Fin 1 → ℝ
def position (j : ℤ) : Direction → ℤ := fun _ => j
noncomputable def active : Finset (Direction → ℤ) := (Finset.Ico (0 : ℤ) 4).image position
abbrev Cell := ↥active

theorem position_injective : Function.Injective position := by
  intro i j h
  exact congrFun h 0

theorem active_nonempty : active.Nonempty := by
  exact ⟨position 0, Finset.mem_image.mpr ⟨0, by simp, rfl⟩⟩

theorem cell_index_bounds (cell : Cell) : 0 ≤ cell.val 0 ∧ cell.val 0 < 4 := by
  obtain ⟨j, hj, he⟩ := Finset.mem_image.mp cell.property
  rw [← he]
  exact Finset.mem_Ico.mp hj

theorem cell_position (cell : Cell) : position (cell.val 0) = cell.val := by
  funext d
  have hd : d = 0 := Subsingleton.elim _ _
  subst d
  rfl

def cellAt (j : ℤ) (hj : 0 ≤ j ∧ j < 4) : Cell :=
  ⟨position j, Finset.mem_image.mpr ⟨j, Finset.mem_Ico.mpr hj, rfl⟩⟩

noncomputable def axes : Direction → OneDimensionalFiniteVolumeGrid :=
  fun _ => (NumStability.HighResolutionAdvectionLine.family 1).grid 0

theorem identity_hyperbolic : ∀ _ : Direction, IsHyperbolicFluxOn (id : State → State) univ := by
  intro d state hs
  exact (NumStability.HighResolutionAdvectionLine.family 1).hyperbolic 0 (by norm_num [NumStability.HighResolutionAdvectionLine.family]) state hs

noncomputable def physical : PhysicalData Direction Cell (Direction → ℤ)
    (Direction → ℝ) (Direction → ℝ) 1 :=
  data axes active active_nonempty (fun _ => univ) (fun _ => id) identity_hyperbolic

noncomputable def coord : LineCoordinates (m := 1) Direction Cell (Direction → ℤ) Unit where
  cellLine := fun _ _ => ()
  cellIndex := fun _ cell => cell.val 0
  faceLine := fun _ _ => ()
  faceIndex := fun _ face => face 0
  lookup := fun _ _ j => if hj : 0 ≤ j ∧ j < 4 then some (cellAt j hj) else none
  lookup_cell := by
    intro d cell
    rw [dif_pos (cell_index_bounds cell)]
    congr 1
    exact Subtype.ext (cell_position cell)
  lookup_sound := by
    intro d line j cell he
    split at he
    next hj =>
      have hc := Option.some.inj he
      subst cell
      exact ⟨Subsingleton.elim _ _, rfl⟩
    next hj => contradiction
  ghost := fun _ _ _ => 0

theorem physical_volume (cell : Cell) : physical.cellVolume cell =
    ((NumStability.HighResolutionAdvectionLine.family 1).grid 0).cellVolume (cell.val 0) := by
  rw [physical, data_cellVolume]
  simp [CartesianGrid.cellVolume, axes]

theorem physical_area (d : Direction) (face : Direction → ℤ) :
    (physical.faceMeasure d face univ).toReal = 1 := by
  change (faceMeasure axes d face univ).toReal = 1
  rw [faceMeasure_area]
  have hd : d = 0 := Subsingleton.elim _ _
  subst d
  simp [CartesianGrid.faceArea]

noncomputable def families : Direction → Unit → LineFamily 1 :=
  fun _ _ => NumStability.HighResolutionAdvectionLine.family 1

theorem quality : ∀ d line, (families d line).HasControlledHighResolution :=
  fun _ _ => NumStability.HighResolutionAdvectionLine.family_quality 1

noncomputable def method : LineRealization physical coord families where
  level := fun _ _ => 0
  duration := fun _ => NumStability.HighResolutionAdvectionLine.h 0
  duration_eq := fun _ _ => rfl
  area := fun _ _ => 1
  area_pos := by intros; norm_num
  left_line := fun _ _ => rfl
  right_line := fun _ _ => rfl
  left_index := fun _ _ => rfl
  right_index := by
    intro d cell
    have hd : d = 0 := Subsingleton.elim _ _
    subst d
    simp [coord, physical, data]
  active_cell := by
    intro d cell
    exact Finset.mem_Ico.mpr (cell_index_bounds cell)
  volume_eq := by
    intro d cell
    simpa [families, coord] using physical_volume cell
  physical_flux := by
    intro d face state
    have hf : IsFiniteMeasure (physical.faceMeasure d face) :=
      ⟨lt_top_iff_ne_top.mpr (ENNReal.toReal_pos_iff.mp (by rw [physical_area]; norm_num)).2.ne⟩
    refine ⟨integrable_const state, ?_⟩
    change (∫ _, state ∂physical.faceMeasure d face) = (1 : ℝ) • state
    rw [integral_const]
    simp only [measureReal_def, physical_area]
  states_eq := fun _ _ => rfl

theorem cartesian : NumStability.FiniteCartesian.CartesianIdentification
    physical axes Subtype.val (fun _ face => face) (fun _ => id) where
  left_position := fun _ _ => rfl
  right_position := fun _ _ => rfl
  cell_measure := fun _ => rfl
  face_measurable := data_face_measurable axes active active_nonempty _ _ identity_hyperbolic
  face_measure := data_face_measure axes active active_nonempty _ _ identity_hyperbolic
  normal_flux := data_normal_flux axes active active_nonempty _ _ identity_hyperbolic

def initial (cell : Cell) : State := if cell.val 0 = 0 then 1 else 0
def reference : (Direction → ℝ) → ℝ → State := fun _ _ => 0

theorem initial_nonconstant :
    initial (cellAt 0 (by omega)) ≠ initial (cellAt 1 (by omega)) := by
  simp [initial, cellAt, position]

theorem mean_zero (cell : Cell) (t : ℝ) : physical.cellMean reference cell t = 0 := by
  simp [PhysicalData.cellMean, cellVolumeAverage, reference]

theorem flux_zero (d : Direction) (face : Direction → ℤ) (t : ℝ) :
    physical.faceFlux d reference face t = 0 := by
  simp [PhysicalData.faceFlux, physical, data, reference]

theorem reference_valid (d : Direction) (s t : ℝ) : physical.ReferenceOn d reference s t := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro cell τ hτ
    exact integrableOn_zero
  · intro cell τ hτ
    exact ⟨integrable_zero _ _ _, integrable_zero _ _ _⟩
  · intro x hx τ hτ
    exact mem_univ _
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

theorem extracted_zero (d : Direction) (line : Unit) : coord.extract d line (fun _ : Cell => (0 : State)) = 0 := by
  funext j
  simp only [LineCoordinates.extract, coord]
  split <;> rfl

theorem rule_zero (d : Direction) (face : Direction → ℤ) :
    method.rule d (method.duration d) (fun c => physical.cellMean reference c 0) face = 0 := by
  simp only [mean_zero, LineRealization.rule, method, families, NumStability.HighResolutionAdvectionLine.family,
    extracted_zero, Pi.zero_apply, smul_zero]

noncomputable def amplification (_ : ℕ) : ℝ :=
  1 + (NumStability.HighResolutionAdvectionLine.family 1).stabilityRate (NumStability.HighResolutionAdvectionLine.family_quality 1) *
    NumStability.HighResolutionAdvectionLine.h 0

theorem amplification_nonneg (n : ℕ) : 0 ≤ amplification n := by
  unfold amplification
  exact add_nonneg (by norm_num) (mul_nonneg
    ((NumStability.HighResolutionAdvectionLine.family 1).stabilityRate_spec
      (NumStability.HighResolutionAdvectionLine.family_quality 1)).1 (NumStability.HighResolutionAdvectionLine.h_pos 0).le)

end DIMJointPrimaryWitness

namespace DIMJointPrimaryWitness
open NumStability MeasureTheory Set
open NumStability.FiniteCoordinate NumStability.DirectionalLine
open NumStability.FiniteCartesian NumStability.SequentialError
open scoped BigOperators

theorem face_error_zero (d : Direction) (face : Direction → ℤ) :
    ‖method.rule d (method.duration d) (fun cell => physical.cellMean reference cell 0) face -
      oneDimensionalCellAverage (physical.faceFlux d reference face) 0 (method.duration d)‖ ≤ 0 := by
  simp only [rule_zero, flux_zero, oneDimensionalCellAverage, intervalIntegral.integral_zero,
    smul_zero, sub_self, norm_zero, le_refl]

/-- This is an actual application of the entire corrected source contract,
with every hypothesis discharged. Its inferred type preserves every clause
of that contract, including the uniform all-refinement smooth accuracy clause.
The reference is zero and the actual initial array is nonconstant. -/
noncomputable def full_application :=
  NumStability.HighResolutionCoordinateSweep.coordinate_highResolution_specification
    (data := physical) (coord := coord) (family := families)
    (by norm_num : 0 < 1) (by simp : 0 < Fintype.card Direction)
    (fun _ => method) (fun _ => (0 : Direction)) quality initial (fun _ => reference) 1
    amplification (fun _ => 0) (fun _ => 0) 1 (fun _ _ => 0) (fun _ _ => 0)
    (fun _ _ => reference_valid 0 0 _) initial_error
    (fun _ _ => admitted _ _) (fun _ _ => admitted _ _)
    (fun _ _ _ => le_rfl)
    (fun _ _ cell => face_error_zero _ _) (fun _ _ cell => face_error_zero _ _)
    (by intros; simp) (by intros; simp only [mean_zero, sub_self, norm_zero, le_refl])
    (fun d => ⟨0, by omega, Subsingleton.elim _ _⟩)

theorem actual_geometry :
    CartesianIdentification physical axes Subtype.val (fun _ face => face) (fun _ => id) := cartesian

theorem active_count : active.card = 4 := by
  rw [active, Finset.card_image_of_injective _ position_injective]
  norm_num
  decide

theorem step_duration : method.duration 0 = (1 : ℝ) / 2 := by
  change NumStability.HighResolutionAdvectionLine.h 0 = _
  rw [NumStability.HighResolutionAdvectionLine.h_eq]
  norm_num

theorem actual_shift (current : Cell → State) (cell : Cell) :
    coordinateExecution (fun _ => method) (fun _ => (0 : Direction)) current 1 cell =
      coord.extract 0 () current (cell.val 0 - 1) := by
  rw [coordinateExecution_succ]
  rw [method.advance_eq]
  exact NumStability.HighResolutionAdvectionLine.family_advance 1 0 _ _

theorem initial_moves :
    coordinateExecution (fun _ => method) (fun _ => (0 : Direction)) initial 1
      (cellAt 0 (by omega)) = 0 ∧
    coordinateExecution (fun _ => method) (fun _ => (0 : Direction)) initial 1
      (cellAt 1 (by omega)) = 1 := by
  constructor
  · calc
      _ = coord.extract 0 () initial ((cellAt 0 (by omega)).val 0 - 1) :=
        actual_shift initial (cellAt 0 (by omega))
      _ = 0 := by norm_num [coord, LineCoordinates.extract, cellAt, position]
  · calc
      _ = coord.extract 0 () initial ((cellAt 1 (by omega)).val 0 - 1) :=
        actual_shift initial (cellAt 1 (by omega))
      _ = 1 := by norm_num [coord, LineCoordinates.extract, cellAt, position, initial]

/-- The full primary result and its actual Cartesian premise are witnessed
together with the same four cells and nonconstant moving initial array. -/
noncomputable def joint_applicability :=
  And.intro full_application (And.intro cartesian (And.intro active_count
    (And.intro initial_nonconstant initial_moves)))

end DIMJointPrimaryWitness

#check DIMJointPrimaryWitness.Direction
#print axioms DIMJointPrimaryWitness.Direction
#check DIMJointPrimaryWitness.State
#print axioms DIMJointPrimaryWitness.State
#check DIMJointPrimaryWitness.position
#print axioms DIMJointPrimaryWitness.position
#check DIMJointPrimaryWitness.active
#print axioms DIMJointPrimaryWitness.active
#check DIMJointPrimaryWitness.Cell
#print axioms DIMJointPrimaryWitness.Cell
#check DIMJointPrimaryWitness.position_injective
#print axioms DIMJointPrimaryWitness.position_injective
#check DIMJointPrimaryWitness.active_nonempty
#print axioms DIMJointPrimaryWitness.active_nonempty
#check DIMJointPrimaryWitness.cell_index_bounds
#print axioms DIMJointPrimaryWitness.cell_index_bounds
#check DIMJointPrimaryWitness.cell_position
#print axioms DIMJointPrimaryWitness.cell_position
#check DIMJointPrimaryWitness.cellAt
#print axioms DIMJointPrimaryWitness.cellAt
#check DIMJointPrimaryWitness.axes
#print axioms DIMJointPrimaryWitness.axes
#check DIMJointPrimaryWitness.identity_hyperbolic
#print axioms DIMJointPrimaryWitness.identity_hyperbolic
#check DIMJointPrimaryWitness.physical
#print axioms DIMJointPrimaryWitness.physical
#check DIMJointPrimaryWitness.coord
#print axioms DIMJointPrimaryWitness.coord
#check DIMJointPrimaryWitness.physical_volume
#print axioms DIMJointPrimaryWitness.physical_volume
#check DIMJointPrimaryWitness.physical_area
#print axioms DIMJointPrimaryWitness.physical_area
#check DIMJointPrimaryWitness.families
#print axioms DIMJointPrimaryWitness.families
#check DIMJointPrimaryWitness.quality
#print axioms DIMJointPrimaryWitness.quality
#check DIMJointPrimaryWitness.method
#print axioms DIMJointPrimaryWitness.method
#check DIMJointPrimaryWitness.cartesian
#print axioms DIMJointPrimaryWitness.cartesian
#check DIMJointPrimaryWitness.initial
#print axioms DIMJointPrimaryWitness.initial
#check DIMJointPrimaryWitness.reference
#print axioms DIMJointPrimaryWitness.reference
#check DIMJointPrimaryWitness.initial_nonconstant
#print axioms DIMJointPrimaryWitness.initial_nonconstant
#check DIMJointPrimaryWitness.mean_zero
#print axioms DIMJointPrimaryWitness.mean_zero
#check DIMJointPrimaryWitness.flux_zero
#print axioms DIMJointPrimaryWitness.flux_zero
#check DIMJointPrimaryWitness.reference_valid
#print axioms DIMJointPrimaryWitness.reference_valid
#check DIMJointPrimaryWitness.initial_error
#print axioms DIMJointPrimaryWitness.initial_error
#check DIMJointPrimaryWitness.admitted
#print axioms DIMJointPrimaryWitness.admitted
#check DIMJointPrimaryWitness.extracted_zero
#print axioms DIMJointPrimaryWitness.extracted_zero
#check DIMJointPrimaryWitness.rule_zero
#print axioms DIMJointPrimaryWitness.rule_zero
#check DIMJointPrimaryWitness.amplification
#print axioms DIMJointPrimaryWitness.amplification
#check DIMJointPrimaryWitness.amplification_nonneg
#print axioms DIMJointPrimaryWitness.amplification_nonneg
#check DIMJointPrimaryWitness.face_error_zero
#print axioms DIMJointPrimaryWitness.face_error_zero
#check DIMJointPrimaryWitness.full_application
#print axioms DIMJointPrimaryWitness.full_application
#check DIMJointPrimaryWitness.actual_geometry
#print axioms DIMJointPrimaryWitness.actual_geometry
#check DIMJointPrimaryWitness.active_count
#print axioms DIMJointPrimaryWitness.active_count
#check DIMJointPrimaryWitness.step_duration
#print axioms DIMJointPrimaryWitness.step_duration
#check DIMJointPrimaryWitness.actual_shift
#print axioms DIMJointPrimaryWitness.actual_shift
#check DIMJointPrimaryWitness.initial_moves
#print axioms DIMJointPrimaryWitness.initial_moves
#check DIMJointPrimaryWitness.joint_applicability
#print axioms DIMJointPrimaryWitness.joint_applicability
