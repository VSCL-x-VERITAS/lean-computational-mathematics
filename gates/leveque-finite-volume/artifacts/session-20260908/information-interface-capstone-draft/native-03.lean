import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
# Prospective information-only interface workflow

Scratch assembly. Execution has no field or accuracy obligation. Physical
comparison uses an independent rectangle-conserved reference and explicit
finite-step trace errors. The quantitative interpretation remains unselected.
-/

open MeasureTheory

namespace NumStability.InformationInterfaceDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- Ordered input and information are tied to this actual selected result.
There is no full-field, initial-trace, conservation or accuracy assertion. -/
def PureInterfaceContract (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) : Prop :=
  let problem := adjacentCellRiemannProblem law old j
  let result := method.solve problem (hdomain j)
  let information := method.extract result
  problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    method.selectedResult old hdomain j = result ∧
    method.interfaceFlux old hdomain j = method.numericalFlux information

theorem pure_interface_execution (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    PureInterfaceContract method old hdomain j :=
  method.interface_execution old hdomain j

/-- Spatial normalization is the existing volume average on the actual cell. -/
theorem normalized_spatial_average (grid : OneDimensionalFiniteVolumeGrid)
    (field : ℝ → Fin m → ℝ) (i : ℤ) :
    finiteVolumeCellAverageOn grid field i =
      cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) field :=
  (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage field (grid.cell_nonempty i)).symm

/-- Temporal normalization uses the same volume-average operator on the step. -/
theorem normalized_physical_face_flux (grid : OneDimensionalFiniteVolumeGrid)
    (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    {s t : ℝ} (hst : s < t) (j : ℤ) :
    timeAveragedPhysicalFaceFlux grid q flux s t j =
      cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft j) τ)) :=
  (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hst).symm

/-- Exact normalized initialization and actual solve/extract/update. Later
comparison permits old numerical data different from the reference averages. -/
theorem normalized_interface_execution (grid : OneDimensionalFiniteVolumeGrid)
    (initialState : ℝ → Fin m → ℝ)
    (hintegrable : ∀ i, IntervalIntegrable initialState volume
      (grid.cellLeft i) (grid.cellRight i))
    (method : RiemannInformationFluxMethod law Result Information)
    (hdomain : ∀ j, method.domain
      (adjacentCellRiemannProblem law (finiteVolumeCellAverageOn grid initialState) j))
    (dt : ℝ) :
    let old := finiteVolumeCellAverageOn grid initialState
    let numericalFlux := method.interfaceFlux old hdomain
    ∀ i, IsOneDimensionalCellAverage initialState (grid.cellLeft i) (grid.cellRight i) (old i) ∧
      old i = cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) initialState ∧
      grid.cellRight (i - 1) = grid.cellLeft i ∧
      PureInterfaceContract method old hdomain i ∧
      PureInterfaceContract method old hdomain (i + 1) ∧
      riemannFiniteVolumeUpdate grid dt old numericalFlux i =
        old i - (dt / grid.cellVolume i) • (numericalFlux (i + 1) - numericalFlux i) := by
  dsimp only
  intro i
  exact ⟨finiteVolumeCellAverageOn_spec grid initialState hintegrable i,
    normalized_spatial_average grid initialState i, grid.adjacent i,
    pure_interface_execution method _ hdomain i,
    pure_interface_execution method _ hdomain (i + 1), rfl⟩

theorem constant_interface_consistency (method : RiemannInformationFluxMethod law Result Information)
    (state : Fin m → ℝ) (j : ℤ) :
    method.interfaceFlux (fun _ => state) (fun _ => method.constants_in_domain state) j =
      law.physicalFlux state :=
  method.interfaceFlux_constant state _ j

/-- The existing field method embeds with its original result and computation.
Extra field obligations do not become obligations of the information core. -/
theorem field_adapter_contract (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let adapted := RiemannInformationFluxMethod.ofField method
    let problem := adjacentCellRiemannProblem law old j
    let result := adapted.solve problem (hdomain j)
    adapted.domain problem = method.domain problem ∧
      result = method.solve problem (hdomain j) ∧
      adapted.extract result = method.extract result ∧
      adapted.numericalFlux (adapted.extract result) = method.numericalFlux (method.extract result) ∧
      adapted.interfaceFlux old hdomain j = method.interfaceFlux old hdomain j :=
  ⟨rfl, rfl, rfl, rfl, RiemannInformationFluxMethod.ofField_interfaceFlux method old hdomain j⟩

/-- Physical comparison is separate from execution. Only the two used result
traces require integrability and error bounds on this finite step. The mass
rate holds almost everywhere for each fixed spatial interval. -/
theorem finite_step_reference_comparison (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannInformationFluxMethod law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t oldBound aLeft bLeft aRight bRight : ℝ} (hst : s < t) (i : ℤ)
    (localTrace : (j : ℤ) → Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hold : ‖old i - cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
      (fun x => q x s)‖ ≤ oldBound)
    (hl : IntervalIntegrable (localTrace i (method.selectedResult old hdomain i)) volume s t)
    (hr : IntervalIntegrable (localTrace (i + 1) (method.selectedResult old hdomain (i + 1))) volume s t)
    (hnl : ∀ τ ∈ Set.uIoc s t, ‖method.interfaceFlux old hdomain i -
      localTrace i (method.selectedResult old hdomain i) τ‖ ≤ aLeft)
    (hel : ∀ τ ∈ Set.uIoc s t, ‖localTrace i (method.selectedResult old hdomain i) τ -
      law.physicalFlux (q (grid.cellLeft i) τ)‖ ≤ bLeft)
    (hnr : ∀ τ ∈ Set.uIoc s t, ‖method.interfaceFlux old hdomain (i + 1) -
      localTrace (i + 1) (method.selectedResult old hdomain (i + 1)) τ‖ ≤ aRight)
    (her : ∀ τ ∈ Set.uIoc s t, ‖localTrace (i + 1) (method.selectedResult old hdomain (i + 1)) τ -
      law.physicalFlux (q (grid.cellLeft (i + 1)) τ)‖ ≤ bRight) :
    PureInterfaceContract method old hdomain i ∧ PureInterfaceContract method old hdomain (i + 1) ∧
    (∀ a b : ℝ, ∀ᵐ τ, HasDerivAt (fun r => ∫ x in a..b, q x r)
      (law.physicalFlux (q a τ) - law.physicalFlux (q b τ)) τ) ∧
    (‖method.interfaceFlux old hdomain i - cellVolumeAverage volume (Set.Ioc s t)
      (fun τ => law.physicalFlux (q (grid.cellLeft i) τ))‖ ≤ aLeft + bLeft) ∧
    (‖method.interfaceFlux old hdomain (i + 1) - cellVolumeAverage volume (Set.Ioc s t)
      (fun τ => law.physicalFlux (q (grid.cellLeft (i + 1)) τ))‖ ≤ aRight + bRight) ∧
    (‖riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
      cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i)) (fun x => q x t)‖ ≤
      oldBound + (t - s) / grid.cellVolume i * ((aLeft + bLeft) + (aRight + bRight))) := by
  refine ⟨pure_interface_execution method old hdomain i,
    pure_interface_execution method old hdomain (i + 1), hq.hasDerivAt_mass_ae, ?_, ?_, ?_⟩
  · rw [← normalized_physical_face_flux grid q law.physicalFlux hst i]
    exact method.interface_error_le grid old hdomain hst i (localTrace i) hl (hq.2.1 _ _ _) hnl hel
  · rw [← normalized_physical_face_flux grid q law.physicalFlux hst (i + 1)]
    exact method.interface_error_le grid old hdomain hst (i + 1) (localTrace (i + 1)) hr
      (hq.2.1 _ _ _) hnr her
  · rw [← normalized_spatial_average grid (fun x => q x t) i]
    rw [← normalized_spatial_average grid (fun x => q x s) i] at hold
    exact method.update_error_le grid old hdomain hq hst i localTrace hold hl hr hnl hel hnr her

namespace Witness

def unitGrid : OneDimensionalFiniteVolumeGrid where
  cellLeft := fun i => (i : ℝ)
  cellRight := fun i => (i : ℝ) + 1
  cell_nonempty := by intro i; linarith
  adjacent := by intro i; push_cast; ring

noncomputable def initialState : ℝ → Fin 1 → ℝ := riemannData 0 0 1

theorem initialState_integrable (i : ℤ) :
    IntervalIntegrable initialState volume (unitGrid.cellLeft i) (unitGrid.cellRight i) :=
  riemannData_intervalIntegrable 0 0 1 _ _

theorem normalized_pair :
    finiteVolumeCellAverageOn unitGrid initialState (-1) = 0 ∧
      finiteVolumeCellAverageOn unitGrid initialState 0 = 1 := by
  have hl : cellVolumeAverage volume (Set.Ioc (-1 : ℝ) 0) initialState = 0 := by
    rw [cellVolumeAverage_congr volume measurableSet_Ioc (other := fun _ => (0 : Fin 1 → ℝ))]
    · exact cellVolumeAverage_const volume (Set.Ioc (-1 : ℝ) 0)
        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_zero_iff.mpr (by norm_num))
        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top) 0
    · intro x hx
      by_cases h : x < 0
      · simp [initialState, riemannData, h]
      · have hx0 : x = 0 := le_antisymm hx.2 (le_of_not_gt h)
        simp [hx0, initialState]
  have hr : cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1) initialState = 1 := by
    rw [cellVolumeAverage_congr volume measurableSet_Ioc (other := fun _ => (1 : Fin 1 → ℝ))]
    · exact cellVolumeAverage_const volume (Set.Ioc (0 : ℝ) 1)
        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_zero_iff.mpr (by norm_num))
        (by rw [Real.volume_Ioc]; exact ENNReal.ofReal_ne_top) 1
    · intro x hx
      simp [initialState, riemannData, hx.1, not_lt.mpr hx.1.le]
  constructor
  · rw [normalized_spatial_average]
    simpa [unitGrid] using hl
  · rw [normalized_spatial_average]
    simpa [unitGrid] using hr

/-- Literal normalized Fin 1 applicability. Its returned information is the
actual pair (0,1), with flux zero. A separate positive-step reference average
identity is supplied for this particular unit-speed example. -/
theorem information_only_applicability (dt : ℝ) (hdt : 0 < dt) :
    let law := StationaryRiemannField.transportLaw (m := 1)
    let method := LeftStateInformationFlux.method law
    let old := finiteVolumeCellAverageOn unitGrid initialState
    (∀ i, IsOneDimensionalCellAverage initialState (unitGrid.cellLeft i) (unitGrid.cellRight i) (old i) ∧
      old i = cellVolumeAverage volume (Set.Ioc (unitGrid.cellLeft i) (unitGrid.cellRight i)) initialState ∧
      unitGrid.cellRight (i - 1) = unitGrid.cellLeft i ∧
      PureInterfaceContract method old (fun _ => trivial) i ∧
      PureInterfaceContract method old (fun _ => trivial) (i + 1) ∧
      riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) i =
        old i - (dt / unitGrid.cellVolume i) •
          (method.interfaceFlux old (fun _ => trivial) (i + 1) - method.interfaceFlux old (fun _ => trivial) i)) ∧
    method.extract (method.selectedResult old (fun _ => trivial) 0) = (0, 1) ∧
    method.interfaceFlux old (fun _ => trivial) 0 = 0 ∧
    method.interfaceFlux old (fun _ => trivial) 0 =
      cellVolumeAverage volume (Set.Ioc 0 dt)
        (fun τ => law.physicalFlux (StationaryRiemannField.reference 0 1 0 τ)) := by
  dsimp only
  refine ⟨normalized_interface_execution unitGrid initialState initialState_integrable _ _ dt, ?_, ?_, ?_⟩
  · rw [LeftStateInformationFlux.selected_pair]
    simpa using congrArg₂ Prod.mk normalized_pair.1 normalized_pair.2
  · rw [LeftStateInformationFlux.selected_flux]
    simpa using congrArg StationaryRiemannField.transportLaw.physicalFlux normalized_pair.1
  · have h := LeftStateInformationFlux.selected_flux_eq_reference_average
      (adjacentCellRiemannProblem (StationaryRiemannField.transportLaw (m := 1))
        (finiteVolumeCellAverageOn unitGrid initialState) 0) hdt
    rw [cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hdt]
    simpa only [adjacentCellRiemannProblem, sub_zero, zero_sub, normalized_pair.1, normalized_pair.2,
      RiemannInformationFluxMethod.interfaceFlux, RiemannInformationFluxMethod.selectedResult] using h

end Witness
end NumStability.InformationInterfaceDraft

#check NumStability.InformationInterfaceDraft.PureInterfaceContract
#print axioms NumStability.InformationInterfaceDraft.PureInterfaceContract
#check NumStability.InformationInterfaceDraft.pure_interface_execution
#print axioms NumStability.InformationInterfaceDraft.pure_interface_execution
#check NumStability.InformationInterfaceDraft.normalized_spatial_average
#print axioms NumStability.InformationInterfaceDraft.normalized_spatial_average
#check NumStability.InformationInterfaceDraft.normalized_physical_face_flux
#print axioms NumStability.InformationInterfaceDraft.normalized_physical_face_flux
#check NumStability.InformationInterfaceDraft.normalized_interface_execution
#print axioms NumStability.InformationInterfaceDraft.normalized_interface_execution
#check NumStability.InformationInterfaceDraft.constant_interface_consistency
#print axioms NumStability.InformationInterfaceDraft.constant_interface_consistency
#check NumStability.InformationInterfaceDraft.field_adapter_contract
#print axioms NumStability.InformationInterfaceDraft.field_adapter_contract
#check NumStability.InformationInterfaceDraft.finite_step_reference_comparison
#print axioms NumStability.InformationInterfaceDraft.finite_step_reference_comparison
#check NumStability.InformationInterfaceDraft.Witness.unitGrid
#print axioms NumStability.InformationInterfaceDraft.Witness.unitGrid
#check NumStability.InformationInterfaceDraft.Witness.initialState
#print axioms NumStability.InformationInterfaceDraft.Witness.initialState
#check NumStability.InformationInterfaceDraft.Witness.initialState_integrable
#print axioms NumStability.InformationInterfaceDraft.Witness.initialState_integrable
#check NumStability.InformationInterfaceDraft.Witness.normalized_pair
#print axioms NumStability.InformationInterfaceDraft.Witness.normalized_pair
#check NumStability.InformationInterfaceDraft.Witness.information_only_applicability
#print axioms NumStability.InformationInterfaceDraft.Witness.information_only_applicability
#check NumStability.RiemannInformationFluxMethod.interface_execution
#print axioms NumStability.RiemannInformationFluxMethod.interface_execution
#check NumStability.RiemannInformationFluxMethod.interfaceFlux_constant
#print axioms NumStability.RiemannInformationFluxMethod.interfaceFlux_constant
#check NumStability.RiemannInformationFluxMethod.ofField_interfaceFlux
#print axioms NumStability.RiemannInformationFluxMethod.ofField_interfaceFlux
#check NumStability.RiemannInformationFluxMethod.interface_error_le
#print axioms NumStability.RiemannInformationFluxMethod.interface_error_le
#check NumStability.RiemannInformationFluxMethod.update_error_le
#print axioms NumStability.RiemannInformationFluxMethod.update_error_le
#check NumStability.cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
#print axioms NumStability.cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage
#check NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
#print axioms NumStability.IsRectangleConservationLawSolution.hasDerivAt_mass_ae
#check NumStability.LeftStateInformationFlux.concrete_information_only
#print axioms NumStability.LeftStateInformationFlux.concrete_information_only
#check NumStability.LeftStateInformationFlux.selected_flux_eq_reference_average
#print axioms NumStability.LeftStateInformationFlux.selected_flux_eq_reference_average
#check Real.volume_Ioc
#print axioms Real.volume_Ioc
