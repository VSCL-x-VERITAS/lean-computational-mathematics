import ComputationalMathematics.Source.LeVeque.Chapter01.FiniteVolumeUpdateError
import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInformationInterfaceFlux
import ComputationalMathematics.Source.LeVeque.Chapter01.CoordinateSplittingBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateCoordinateSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TemporalDerivative

/-!
An unselected conditional-error capstone, assembled only from canonical owners.
The accuracy convention remains an unanswered source-scope choice.
-/

open MeasureTheory

namespace NumStability.FVUpdateCapstoneDraft

/-- The reference averages, weighted update error and conditional error bound
are linked to the same grid, independently supplied exact field, old numerical
array, two times, and full-array numerical flux rule. -/
theorem finiteVolumeUpdate_capstone {m : ℕ} (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → (Fin m → ℝ)) → ℤ → (Fin m → ℝ))
    {s t : ℝ} (hst : s < t) (old : ℤ → (Fin m → ℝ)) :
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
      grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
            (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound →
        ‖rule s t old (i + 1) -
          timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  intro i
  refine ⟨finiteVolumeCellAverageOn_spec grid _ (fun _ => hq.1 _ _ _) i,
    timeAveragedPhysicalFaceFlux_isCellAverage grid hq hst i,
    riemannFiniteVolumeUpdate_weighted_error grid hq rule hst old i, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact riemannFiniteVolumeUpdate_error_le grid hq rule hst old i hold hleft hright

end NumStability.FVUpdateCapstoneDraft


/- Verification witness only; the checked standalone file prepends the candidate
and imports Mathlib.Analysis.SpecialFunctions.Integrals.Basic. -/
namespace NumStability.FVUpdateCapstoneDraft.Witness

noncomputable def grid : OneDimensionalFiniteVolumeGrid where
  cellLeft i := i
  cellRight i := (i : ℝ) + 1
  cell_nonempty i := by linarith
  adjacent i := by push_cast; ring

noncomputable def q (x t : ℝ) : Fin 1 → ℝ := (x - t) • (1 : Fin 1 → ℝ)

theorem q_conserved : IsRectangleConservationLawSolution q id := by
  have hp : ∀ a b, IntervalIntegrable (fun x : ℝ => x • (1 : Fin 1 → ℝ)) volume a b :=
    fun a b => (continuous_id.smul continuous_const).intervalIntegrable a b
  have hq : travelingWave (fun x : ℝ => x • (1 : Fin 1 → ℝ)) 1 = q := by
    funext x t
    simp [q, travelingWave]
  have hf : (fun state : Fin 1 → ℝ => (1 : ℝ) • state) = id := by
    funext state
    simp
  rw [← hq, ← hf]
  exact travelingWave_isRectangleConservationLawSolution _ hp 1

noncomputable def old : ℤ → (Fin 1 → ℝ) := fun _ => 0

noncomputable def rule (s t : ℝ) (data : ℤ → (Fin 1 → ℝ)) (j : ℤ) : Fin 1 → ℝ :=
  data (j + 2) + (t - s) • (1 : Fin 1 → ℝ)

theorem exact_initial_average :
    finiteVolumeCellAverageOn grid (fun x => q x 0) 0 = (1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  simp [finiteVolumeCellAverageOn, oneDimensionalCellAverage, grid, q,
    intervalIntegral.integral_smul_const, integral_id]

theorem physical_reference :
    timeAveragedPhysicalFaceFlux grid q id 0 1 0 = (-1 / 2 : ℝ) • (1 : Fin 1 → ℝ) := by
  simp [timeAveragedPhysicalFaceFlux, oneDimensionalCellAverage, grid, q,
    intervalIntegral.integral_smul_const, intervalIntegral.integral_neg, integral_id]
  module

/-- Numerical input differs from the exact cell average; the physical reference
is time dependent and differs from the initial point flux; the numerical flux
is nonzero. All components of the error-balance theorem have an actual instance. -/
theorem roles_are_distinct :
    old 0 ≠ finiteVolumeCellAverageOn grid (fun x => q x 0) 0 ∧
      timeAveragedPhysicalFaceFlux grid q id 0 1 0 ≠ id (q (grid.cellLeft 0) 0) ∧
      rule 0 1 old 0 ≠ 0 := by
  rw [exact_initial_average, physical_reference]
  constructor
  · intro h
    have hh := congrFun h 0
    norm_num [old] at hh
  constructor
  · intro h
    have hh := congrFun h 0
    norm_num [q, grid] at hh
  · intro h
    exact (one_ne_zero : (1 : ℝ) ≠ 0) (by simpa [rule, old] using congrFun h 0)

theorem actual_error_identity :
    grid.cellVolume 0 • (riemannFiniteVolumeUpdate grid (1 - 0) old (rule 0 1 old) 0 -
        finiteVolumeCellAverageOn grid (fun x => q x 1) 0) =
      grid.cellVolume 0 • (old 0 - finiteVolumeCellAverageOn grid (fun x => q x 0) 0) +
        (1 - 0 : ℝ) • ((rule 0 1 old 0 - timeAveragedPhysicalFaceFlux grid q id 0 1 0) -
          (rule 0 1 old 1 - timeAveragedPhysicalFaceFlux grid q id 0 1 1)) :=
  riemannFiniteVolumeUpdate_weighted_error grid q_conserved rule (by norm_num) old 0

end NumStability.FVUpdateCapstoneDraft.Witness

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

namespace NumStability.InformationInterfaceDraft.Witness

/-- A literal application of the complete conditional capstone. For this
unit-speed step and this cell only, 0 < dt < 1 makes both face errors vanish.
It is not a generic accuracy or time-step requirement. -/
theorem finite_step_comparison_applicability {dt : ℝ} (hdt : 0 < dt) (hdt1 : dt < 1) :
    let method := LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))
    let old := finiteVolumeCellAverageOn unitGrid initialState
    riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) 0 =
      cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1)
        (fun x => StationaryRiemannField.reference 0 1 x dt) := by
  dsimp only
  let law := StationaryRiemannField.transportLaw (m := 1)
  let method := LeftStateInformationFlux.method law
  let old := finiteVolumeCellAverageOn unitGrid initialState
  let localTrace : (j : ℤ) → LeftStateInformationFlux.OrderedResult
      (adjacentCellRiemannProblem law old j) → ℝ → Fin 1 → ℝ :=
    fun _ => LeftStateInformationFlux.localTrace
  have hq := StationaryRiemannField.reference_rectangle (0 : Fin 1 → ℝ) 1
  have hinit : (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x 0) = initialState := by
    funext x
    simp [StationaryRiemannField.reference, travelingWave, initialState]
  have hold : ‖old 0 - cellVolumeAverage volume
      (Set.Ioc (unitGrid.cellLeft 0) (unitGrid.cellRight 0))
      (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x 0)‖ ≤ 0 := by
    rw [hinit, ← normalized_spatial_average]
    simp [old]
  have hn (j : ℤ) (τ : ℝ) : ‖method.interfaceFlux old (fun _ => trivial) j -
      localTrace j (method.selectedResult old (fun _ => trivial) j) τ‖ ≤ 0 := by
    change ‖law.physicalFlux (old (j - 1)) - law.physicalFlux (old (j - 1))‖ ≤ 0
    simp
  have hel : ∀ τ ∈ Set.uIoc 0 dt,
      ‖localTrace 0 (method.selectedResult old (fun _ => trivial) 0) τ -
        law.physicalFlux (StationaryRiemannField.reference 0 1 (unitGrid.cellLeft 0) τ)‖ ≤ 0 := by
    intro τ hτ
    rw [Set.uIoc_of_le hdt.le] at hτ
    have href : StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 0 τ = 0 := by
      simp [StationaryRiemannField.reference, travelingWave, riemannData, neg_lt_zero.mpr hτ.1]
    simp [localTrace, method, RiemannInformationFluxMethod.selectedResult,
      LeftStateInformationFlux.method, LeftStateInformationFlux.localTrace,
      adjacentCellRiemannProblem, unitGrid, show old (-1) = 0 from normalized_pair.1, href]
  have her : ∀ τ ∈ Set.uIoc 0 dt,
      ‖localTrace (0 + 1) (method.selectedResult old (fun _ => trivial) (0 + 1)) τ -
        law.physicalFlux (StationaryRiemannField.reference 0 1 (unitGrid.cellLeft (0 + 1)) τ)‖ ≤ 0 := by
    intro τ hτ
    rw [Set.uIoc_of_le hdt.le] at hτ
    have hpositive : 0 < 1 - τ := by linarith [hτ.2]
    have href : StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 1 τ = 1 := by
      simp [StationaryRiemannField.reference, travelingWave, riemannData, hpositive, not_lt.mpr hpositive.le]
    simp [localTrace, method, RiemannInformationFluxMethod.selectedResult,
      LeftStateInformationFlux.method, LeftStateInformationFlux.localTrace,
      adjacentCellRiemannProblem, unitGrid, show old (0) = 1 from normalized_pair.2, href]
  have hb := finite_step_reference_comparison unitGrid method old (fun _ => trivial) hq hdt 0 localTrace hold
    (LeftStateInformationFlux.localTrace_integrable _ 0 dt)
    (LeftStateInformationFlux.localTrace_integrable _ 0 dt)
    (fun τ _ => hn 0 τ) hel (fun τ _ => hn (0 + 1) τ) her
  have hbound : ‖riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) 0 -
      cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1)
        (fun x => StationaryRiemannField.reference 0 1 x dt)‖ ≤ 0 := by
    simpa [unitGrid] using hb.2.2.2.2.2
  exact sub_eq_zero.mp (norm_eq_zero.mp (le_antisymm hbound (norm_nonneg _)))

end NumStability.InformationInterfaceDraft.Witness

namespace NumStability.NumericsSourceChecks
open MeasureTheory CoordinateLineBalance
open scoped BigOperators

theorem wholeType_leveque01_finiteVolumeUpdateError_sourceContract {m : ℕ} (hm : 0 < m)
    (grid : OneDimensionalFiniteVolumeGrid)
    {q : ℝ → ℝ → Fin m → ℝ} {flux : (Fin m → ℝ) → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (rule : ℝ → ℝ → (ℤ → Fin m → ℝ) → ℤ → Fin m → ℝ)
    {s t : ℝ} (hst : s < t) (old : ℤ → Fin m → ℝ) :
    0 < m ∧ ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => flux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q flux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q flux s t i =
        cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i =
        old i - ((t - s) / grid.cellVolume i) • (rule s t old (i + 1) - rule s t old i) ∧
      grid.cellVolume i • (riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) • ((rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i) -
            (rule s t old (i + 1) - timeAveragedPhysicalFaceFlux grid q flux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖rule s t old i - timeAveragedPhysicalFaceFlux grid q flux s t i‖ ≤ leftBound →
        ‖rule s t old (i + 1) -
          timeAveragedPhysicalFaceFlux grid q flux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (rule s t old) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  exact leveque01_finiteVolumeUpdateError_sourceContract hm grid hq rule hst old

theorem wholeType_leveque01_riemannInformationInterfaceFlux_sourceContract
    {m : ℕ} (hm : 0 < m) (grid : OneDimensionalFiniteVolumeGrid)
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}
    (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ}
    (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t : ℝ} (hst : s < t) :
    0 < m ∧
    (∀ a b : ℝ, ∀ᵐ τ, HasDerivAt (fun r => ∫ x in a..b, q x r)
      (law.physicalFlux (q a τ) - law.physicalFlux (q b τ)) τ) ∧
    (∀ state j, method.interfaceFlux (fun _ => state)
      (fun _ => method.constants_in_domain state) j = law.physicalFlux state) ∧
    (∀ j,
      let problem := adjacentCellRiemannProblem law old j
      let result := method.solve problem (hdomain j)
      grid.cellRight (j - 1) = grid.cellLeft j ∧
      problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
      method.selectedResult old hdomain j = result ∧
      method.interfaceFlux old hdomain j = method.numericalFlux (method.extract result)) ∧
    ∀ i,
      IsOneDimensionalCellAverage (fun x => q x s) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x s) i) ∧
      IsOneDimensionalCellAverage (fun x => q x t) (grid.cellLeft i) (grid.cellRight i)
        (finiteVolumeCellAverageOn grid (fun x => q x t) i) ∧
      finiteVolumeCellAverageOn grid (fun x => q x s) i =
        cellVolumeAverage volume (Set.Ioc (grid.cellLeft i) (grid.cellRight i))
          (fun x => q x s) ∧
      IsOneDimensionalCellAverage (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) s t
        (timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) ∧
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i =
        cellVolumeAverage volume (Set.Ioc s t)
          (fun τ => law.physicalFlux (q (grid.cellLeft i) τ)) ∧
      riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i =
        old i - ((t - s) / grid.cellVolume i) •
          (method.interfaceFlux old hdomain (i + 1) - method.interfaceFlux old hdomain i) ∧
      grid.cellVolume i •
          (riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
            finiteVolumeCellAverageOn grid (fun x => q x t) i) =
        grid.cellVolume i • (old i - finiteVolumeCellAverageOn grid (fun x => q x s) i) +
          (t - s) •
            ((method.interfaceFlux old hdomain i - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i) -
              (method.interfaceFlux old hdomain (i + 1) - timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1))) ∧
      ∀ oldBound leftBound rightBound : ℝ,
        ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound →
        ‖method.interfaceFlux old hdomain i -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t i‖ ≤ leftBound →
        ‖method.interfaceFlux old hdomain (i + 1) -
          timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t (i + 1)‖ ≤ rightBound →
        ‖riemannFiniteVolumeUpdate grid (t - s) old (method.interfaceFlux old hdomain) i -
          finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
          oldBound + (t - s) / grid.cellVolume i * (leftBound + rightBound) := by
  exact leveque01_riemannInformationInterfaceFlux_sourceContract hm grid method old hdomain hq hst

theorem wholeType_leveque01_coordinateSplittingBalance_sourceContract
    {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]
    (cellVolume : (D → ℤ) → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hduration : ∀ stage ∈ stages, 0 < stage.2) (state : (D → ℤ) → E) :
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ stage ∈ stages, 0 < stage.2) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := sweep cellVolume rule before state
      sweep cellVolume rule stages state =
        sweep cellVolume rule after (advance cellVolume rule d dt current) ∧
      (∀ cell, cellVolume cell • advance cellVolume rule d dt current cell =
        cellVolume cell • current cell - dt • netOutwardFlux rule d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          advance cellVolume rule d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, cellVolume (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
          dt • (normalFaceFlux rule d dt current (Function.update base d (start + count)) -
            normalFaceFlux rule d dt current (Function.update base d start))) ∧
      ∀ other base,
        (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, advance cellVolume rule d dt current (Function.update base d j) =
          advance cellVolume rule d dt other (Function.update base d j) := by
  exact leveque01_coordinateSplittingBalance_sourceContract cellVolume hvolume rule stages hnonempty hcover hduration state

theorem wholeType_leveque01_coordinateSplittingBalance_information
    {D : Type*} [DecidableEq D] {m : ℕ}
    {laws : D → OneDimensionalHyperbolicConservationLaw (Fin m)}
    {Result : (d : D) → HyperbolicRiemannProblem (laws d) → Type*}
    {Information : D → Type*}
    (methods : (d : D) → ℝ → RiemannInformationFluxMethod (laws d) (Result d) (Information d))
    (cellVolume : (D → ℤ) → ℝ) (area : D → (D → ℤ) → ℝ)
    (fallback : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (stages : List (D × ℝ)) (state : (D → ℤ) → Fin m → ℝ)
    (hadmitted : RiemannInformationCoordinate.SweepAdmitted methods cellVolume area fallback stages state) :
    (∀ other, sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) stages state =
      sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area other) stages state) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after → ∀ cell,
      let current := sweep cellVolume (RiemannInformationCoordinate.guardedRule methods area fallback) before state
      ∃ admitted : RiemannInformationCoordinate.FaceAdmitted methods d dt current cell,
        let problem := adjacentCellRiemannProblem (laws d)
          (fun j => current (Function.update cell d j)) (cell d)
        let result := (methods d dt).solve problem admitted
        problem.leftState = current (Function.update cell d (cell d - 1)) ∧
        problem.rightState = current cell ∧
        normalFaceFlux (RiemannInformationCoordinate.guardedRule methods area fallback) d dt current cell =
          area d cell • (methods d dt).numericalFlux ((methods d dt).extract result) := by
  exact leveque01_coordinateSplittingBalance_information methods cellVolume area fallback stages state hadmitted

theorem wholeType_leveque01_coordinateSplittingBalance_cartesian
    {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → Fin m → ℝ) → Fin m → ℝ)
    (d : D) (dt : ℝ) (state : (D → ℤ) → Fin m → ℝ) (base : D → ℤ) :
    (∀ cell, 0 < CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.cellBox axes cell)).toReal = CartesianGrid.cellVolume axes cell) ∧
    (∀ cell, (volume (CartesianGrid.tangentialFaceBox axes d cell)).toReal = CartesianGrid.faceArea axes d cell) ∧
    (∀ cell : D → ℤ, (axes d).cellRight (cell d) =
      (axes d).cellLeft ((Function.update cell d (cell d + 1)) d)) ∧
    (fun j => advance (CartesianGrid.cellVolume axes)
      (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt state (Function.update base d j)) =
      riemannFiniteVolumeUpdate (axes d) dt (fun j => state (Function.update base d j))
        (fun j => rule d (Function.update base d j) dt (fun k => state (Function.update base d k))) := by
  exact leveque01_coordinateSplittingBalance_cartesian axes rule d dt state base

theorem cartesian_primary_instantiation
    {D : Type*} [Fintype D] [DecidableEq D] {m : ℕ}
    (axes : D → OneDimensionalFiniteVolumeGrid)
    (rule : D → (D → ℤ) → ℝ → (ℤ → (Fin m → ℝ)) → (Fin m → ℝ))
    (stages : List (D × ℝ)) (hnonempty : stages ≠ [])
    (hcover : ∀ d, ∃ dt, (d, dt) ∈ stages)
    (hduration : ∀ stage ∈ stages, 0 < stage.2) (state : (D → ℤ) → (Fin m → ℝ)) :
    stages ≠ [] ∧ (∀ d, ∃ dt, (d, dt) ∈ stages) ∧
    (∀ stage ∈ stages, 0 < stage.2) ∧
    ∀ before d dt after, stages = before ++ (d, dt) :: after →
      let current := sweep (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) before state
      sweep (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) stages state =
        sweep (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) after (advance (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current) ∧
      (∀ cell, (CartesianGrid.cellVolume axes) cell • advance (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current cell =
        (CartesianGrid.cellVolume axes) cell • current cell - dt • netOutwardFlux (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current cell) ∧
      (∀ base start count,
        (∑ k ∈ Finset.range count, (CartesianGrid.cellVolume axes) (Function.update base d (start + k)) •
          advance (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current (Function.update base d (start + k))) =
        (∑ k ∈ Finset.range count, (CartesianGrid.cellVolume axes) (Function.update base d (start + k)) •
          current (Function.update base d (start + k))) -
          dt • (normalFaceFlux (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current (Function.update base d (start + count)) -
            normalFaceFlux (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current (Function.update base d start))) ∧
      ∀ other base,
        (∀ j, current (Function.update base d j) = other (Function.update base d j)) →
        ∀ j, advance (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt current (Function.update base d j) =
          advance (CartesianGrid.cellVolume axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule) d dt other (Function.update base d j) := by
  exact leveque01_coordinateSplittingBalance_sourceContract (CartesianGrid.cellVolume axes)
    (CartesianGrid.cellVolume_pos axes) (CartesianCoordinateUpdate.areaWeightedRule axes rule)
    stages hnonempty hcover hduration state

open FVUpdateCapstoneDraft.Witness in
theorem independent_reference_weighted_error :
    old 0 ≠ finiteVolumeCellAverageOn grid (fun x => q x 0) 0 ∧
    timeAveragedPhysicalFaceFlux grid q id 0 1 0 ≠ id (q (grid.cellLeft 0) 0) ∧
    rule 0 1 old 0 ≠ 0 ∧
    grid.cellVolume 0 • (riemannFiniteVolumeUpdate grid (1 - 0) old (rule 0 1 old) 0 -
      finiteVolumeCellAverageOn grid (fun x => q x 1) 0) =
      grid.cellVolume 0 • (old 0 - finiteVolumeCellAverageOn grid (fun x => q x 0) 0) +
        (1 - 0 : ℝ) • ((rule 0 1 old 0 - timeAveragedPhysicalFaceFlux grid q id 0 1 0) -
          (rule 0 1 old 1 - timeAveragedPhysicalFaceFlux grid q id 0 1 1)) := by
  have h := (leveque01_finiteVolumeUpdateError_sourceContract (by decide) grid q_conserved rule
    (show (0 : ℝ) < 1 by norm_num) old).2 0
  exact ⟨roles_are_distinct.1, roles_are_distinct.2.1, roles_are_distinct.2.2,
    h.2.2.2.2.2.2.1⟩

open InformationInterfaceDraft InformationInterfaceDraft.Witness in
theorem information_capstone_finite_step_comparison {dt : ℝ} (hdt : 0 < dt) (hdt1 : dt < 1) :
    let method := LeftStateInformationFlux.method (StationaryRiemannField.transportLaw (m := 1))
    let old := finiteVolumeCellAverageOn unitGrid initialState
    riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) 0 =
      cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1)
        (fun x => StationaryRiemannField.reference 0 1 x dt) := by
  dsimp only
  let law := StationaryRiemannField.transportLaw (m := 1)
  let method := LeftStateInformationFlux.method law
  let old := finiteVolumeCellAverageOn unitGrid initialState
  let localTrace : (j : ℤ) → LeftStateInformationFlux.OrderedResult
      (adjacentCellRiemannProblem law old j) → ℝ → Fin 1 → ℝ :=
    fun _ => LeftStateInformationFlux.localTrace
  have hq := StationaryRiemannField.reference_rectangle (0 : Fin 1 → ℝ) 1
  have hinit : (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x 0) = initialState := by
    funext x
    simp [StationaryRiemannField.reference, travelingWave, initialState]
  have hold : ‖old 0 - cellVolumeAverage volume
      (Set.Ioc (unitGrid.cellLeft 0) (unitGrid.cellRight 0))
      (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x 0)‖ ≤ 0 := by
    rw [hinit, ← normalized_spatial_average]
    simp [old]
  have hn (j : ℤ) (τ : ℝ) : ‖method.interfaceFlux old (fun _ => trivial) j -
      localTrace j (method.selectedResult old (fun _ => trivial) j) τ‖ ≤ 0 := by
    change ‖law.physicalFlux (old (j - 1)) - law.physicalFlux (old (j - 1))‖ ≤ 0
    simp
  have hel : ∀ τ ∈ Set.uIoc 0 dt,
      ‖localTrace 0 (method.selectedResult old (fun _ => trivial) 0) τ -
        law.physicalFlux (StationaryRiemannField.reference 0 1 (unitGrid.cellLeft 0) τ)‖ ≤ 0 := by
    intro τ hτ
    rw [Set.uIoc_of_le hdt.le] at hτ
    have href : StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 0 τ = 0 := by
      simp [StationaryRiemannField.reference, travelingWave, riemannData, neg_lt_zero.mpr hτ.1]
    simp [localTrace, method, RiemannInformationFluxMethod.selectedResult,
      LeftStateInformationFlux.method, LeftStateInformationFlux.localTrace,
      adjacentCellRiemannProblem, unitGrid, show old (-1) = 0 from normalized_pair.1, href]
  have her : ∀ τ ∈ Set.uIoc 0 dt,
      ‖localTrace (0 + 1) (method.selectedResult old (fun _ => trivial) (0 + 1)) τ -
        law.physicalFlux (StationaryRiemannField.reference 0 1 (unitGrid.cellLeft (0 + 1)) τ)‖ ≤ 0 := by
    intro τ hτ
    rw [Set.uIoc_of_le hdt.le] at hτ
    have hpositive : 0 < 1 - τ := by linarith [hτ.2]
    have href : StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 1 τ = 1 := by
      simp [StationaryRiemannField.reference, travelingWave, riemannData, hpositive, not_lt.mpr hpositive.le]
    simp [localTrace, method, RiemannInformationFluxMethod.selectedResult,
      LeftStateInformationFlux.method, LeftStateInformationFlux.localTrace,
      adjacentCellRiemannProblem, unitGrid, show old (0) = 1 from normalized_pair.2, href]
  have hleft := method.interface_error_le unitGrid old (fun _ => trivial) hdt 0
    (localTrace 0) (LeftStateInformationFlux.localTrace_integrable _ 0 dt)
    (hq.2.1 _ _ _) (fun τ _ => hn 0 τ) hel
  have hright := method.interface_error_le unitGrid old (fun _ => trivial) hdt (0 + 1)
    (localTrace (0 + 1)) (LeftStateInformationFlux.localTrace_integrable _ 0 dt)
    (hq.2.1 _ _ _) (fun τ _ => hn (0 + 1) τ) her
  have hold' : ‖old 0 - finiteVolumeCellAverageOn unitGrid
      (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x 0) 0‖ ≤ 0 := by
    rwa [← InformationInterfaceDraft.normalized_spatial_average] at hold
  have hb := (leveque01_riemannInformationInterfaceFlux_sourceContract (by decide)
    unitGrid method old (fun _ => trivial) hq hdt).2.2.2.2 0
  have estimate := hb.2.2.2.2.2.2.2 0 0 0 hold'
    (by simpa using hleft) (by simpa using hright)
  have hbound : ‖riemannFiniteVolumeUpdate unitGrid dt old (method.interfaceFlux old (fun _ => trivial)) 0 -
      cellVolumeAverage volume (Set.Ioc (0 : ℝ) 1)
        (fun x => StationaryRiemannField.reference 0 1 x dt)‖ ≤ 0 := by
    rw [InformationInterfaceDraft.normalized_spatial_average unitGrid
      (fun x => StationaryRiemannField.reference (0 : Fin 1 → ℝ) 1 x dt) 0] at estimate
    simpa [unitGrid] using estimate
  exact sub_eq_zero.mp (norm_eq_zero.mp (le_antisymm hbound (norm_nonneg _)))

end NumStability.NumericsSourceChecks
#check @NumStability.leveque01_finiteVolumeUpdateError_sourceContract
#print axioms NumStability.leveque01_finiteVolumeUpdateError_sourceContract
#check @NumStability.leveque01_riemannInformationInterfaceFlux_sourceContract
#print axioms NumStability.leveque01_riemannInformationInterfaceFlux_sourceContract
#check @NumStability.leveque01_coordinateSplittingBalance_sourceContract
#print axioms NumStability.leveque01_coordinateSplittingBalance_sourceContract
#check @NumStability.leveque01_coordinateSplittingBalance_information
#print axioms NumStability.leveque01_coordinateSplittingBalance_information
#check @NumStability.leveque01_coordinateSplittingBalance_cartesian
#print axioms NumStability.leveque01_coordinateSplittingBalance_cartesian
#check @NumStability.NumericsSourceChecks.wholeType_leveque01_finiteVolumeUpdateError_sourceContract
#print axioms NumStability.NumericsSourceChecks.wholeType_leveque01_finiteVolumeUpdateError_sourceContract
#check @NumStability.NumericsSourceChecks.wholeType_leveque01_riemannInformationInterfaceFlux_sourceContract
#print axioms NumStability.NumericsSourceChecks.wholeType_leveque01_riemannInformationInterfaceFlux_sourceContract
#check @NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_sourceContract
#print axioms NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_sourceContract
#check @NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_information
#print axioms NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_information
#check @NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_cartesian
#print axioms NumStability.NumericsSourceChecks.wholeType_leveque01_coordinateSplittingBalance_cartesian
#check @NumStability.NumericsSourceChecks.cartesian_primary_instantiation
#print axioms NumStability.NumericsSourceChecks.cartesian_primary_instantiation
#check @NumStability.NumericsSourceChecks.independent_reference_weighted_error
#print axioms NumStability.NumericsSourceChecks.independent_reference_weighted_error
#check @NumStability.NumericsSourceChecks.information_capstone_finite_step_comparison
#print axioms NumStability.NumericsSourceChecks.information_capstone_finite_step_comparison
#check @NumStability.LeftStateInformationFlux.concrete_information_only
#print axioms NumStability.LeftStateInformationFlux.concrete_information_only
#check @NumStability.LeftStateCoordinateSweep.left_two_stage_nonvacuity
#print axioms NumStability.LeftStateCoordinateSweep.left_two_stage_nonvacuity
