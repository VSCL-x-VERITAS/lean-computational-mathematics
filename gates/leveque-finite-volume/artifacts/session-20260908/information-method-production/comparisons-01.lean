import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethodInformation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField

/-!
# Execution of information-returning Riemann routines

This interface records a routine on an explicit domain, its actual dependent
result, information extraction and constant consistency. It has no returned
field, initial-trace certificate, or temporal-integrability requirement.
It does not certify that an arbitrary consistent routine solves a physical PDE.
-/

open MeasureTheory

namespace NumStability.InformationOnlyRiemannDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

structure Method (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
  extract : {problem : HyperbolicRiemannProblem law} → Result problem → Information
  numericalFlux : Information → (Fin m → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent : ∀ state, numericalFlux (extract (solve
    ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
    (constants_in_domain state))) = law.physicalFlux state

namespace Method

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

def selectedResult (method : Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Result (adjacentCellRiemannProblem law old j) :=
  method.solve (adjacentCellRiemannProblem law old j) (hdomain j)

def interfaceFlux (method : Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Fin m → ℝ :=
  method.numericalFlux (method.extract (selectedResult method old hdomain j))

/-- The ordered input and information belong to this selected result. No
physical solution, returned field or accuracy property is concluded. -/
theorem interface_execution (method : Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let result := method.solve problem (hdomain j)
    problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    selectedResult method old hdomain j = result ∧
    interfaceFlux method old hdomain j = method.numericalFlux (method.extract result) :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem interfaceFlux_constant (method : Method law Result Information) (state : Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law (fun _ => state) j)) (j : ℤ) :
    interfaceFlux method (fun _ => state) hdomain j = law.physicalFlux state := by
  exact method.consistent state

/-- Forget the extra field obligations while retaining the original result,
solve function, extractor, flux map, domain and consistency proof. -/
def ofField (method : RiemannFieldFluxMethod law Result Information) :
    Method law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

theorem ofField_solve (method : RiemannFieldFluxMethod law Result Information)
    (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (ofField method).solve problem h = method.solve problem h := rfl

theorem ofField_extract (method : RiemannFieldFluxMethod law Result Information)
    {problem : HyperbolicRiemannProblem law} (result : Result problem) :
    (ofField method).extract result = method.extract result := rfl

theorem ofField_numericalFlux (method : RiemannFieldFluxMethod law Result Information)
    (info : Information) :
    (ofField method).numericalFlux info = method.numericalFlux info := rfl

theorem ofField_interfaceFlux (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    interfaceFlux (ofField method) old hdomain j = method.interfaceFlux old hdomain j := rfl

/-- Optional traces can be recovered from an embedded field method on the
particular requested finite interval. They are not part of `Method`. -/
theorem ofField_finite_trace_integrable
    (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) (s t : ℝ) :
    IntervalIntegrable (fun τ => law.physicalFlux
      (method.field (selectedResult (ofField method) old hdomain j) 0 τ)) volume s t :=
  method.trace_integrable _ s t

end Method
end NumStability.InformationOnlyRiemannDraft


/-!
# Conditional comparison through an optional finite-step flux trace

The trace is supplied separately and evaluated on the selected dependent result.
Only the actual interval and faces used by an estimate carry assumptions.
Values of its real-parameter extension outside that interval are unrestricted.
-/

namespace NumStability.InformationOnlyRiemannDraft.Method

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

theorem interface_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : Method law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} {s t a b : ℝ} (hst : s < t) (j : ℤ)
    (localTrace : Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hl : IntervalIntegrable (localTrace (selectedResult method old hdomain j)) volume s t)
    (hp : IntervalIntegrable (fun τ => law.physicalFlux (q (grid.cellLeft j) τ)) volume s t)
    (hn : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain j -
      localTrace (selectedResult method old hdomain j) τ‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc s t, ‖localTrace (selectedResult method old hdomain j) τ -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b) :
    ‖interfaceFlux method old hdomain j -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t j‖ ≤ a + b :=
  norm_sub_oneDimensionalCellAverage_le_of_trace hst hl hp hn he

/-- Only the two used faces need optional trace integrability and comparison
bounds. The separate physical reference supplies the actual rectangle law. -/
theorem update_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : Method law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t oldBound aLeft bLeft aRight bRight : ℝ} (hst : s < t) (i : ℤ)
    (localTrace : (j : ℤ) → Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound)
    (hl : IntervalIntegrable (localTrace i (selectedResult method old hdomain i)) volume s t)
    (hr : IntervalIntegrable (localTrace (i + 1) (selectedResult method old hdomain (i + 1))) volume s t)
    (hnl : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain i -
      localTrace i (selectedResult method old hdomain i) τ‖ ≤ aLeft)
    (hel : ∀ τ ∈ Set.uIoc s t, ‖localTrace i (selectedResult method old hdomain i) τ -
      law.physicalFlux (q (grid.cellLeft i) τ)‖ ≤ bLeft)
    (hnr : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain (i + 1) -
      localTrace (i + 1) (selectedResult method old hdomain (i + 1)) τ‖ ≤ aRight)
    (her : ∀ τ ∈ Set.uIoc s t, ‖localTrace (i + 1) (selectedResult method old hdomain (i + 1)) τ -
      law.physicalFlux (q (grid.cellLeft (i + 1)) τ)‖ ≤ bRight) :
    ‖riemannFiniteVolumeUpdate grid (t - s) old (interfaceFlux method old hdomain) i -
      finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
      oldBound + (t - s) / grid.cellVolume i * ((aLeft + bLeft) + (aRight + bRight)) := by
  exact riemannFiniteVolumeUpdate_error_le grid hq
    (fun _ _ _ => interfaceFlux method old hdomain) hst old i hold
    (interface_error_le grid method old hdomain hst i (localTrace i) hl (hq.2.1 _ _ _) hnl hel)
    (interface_error_le grid method old hdomain hst (i + 1) (localTrace (i + 1)) hr
      (hq.2.1 _ _ _) hnr her)

end NumStability.InformationOnlyRiemannDraft.Method


/-!
# Information-only and existing-field instances

The first routine stores the two ordered states, not a space-time field.
Its optional unit-speed comparison uses an independently supplied exact
reference. The second instance retains an existing field method unchanged.
-/

namespace NumStability.InformationOnlyRiemannDraft.Witness

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

structure OrderedResult (problem : HyperbolicRiemannProblem law) where
  left : Fin m → ℝ
  right : Fin m → ℝ
  left_eq : left = problem.leftState
  right_eq : right = problem.rightState

/-- A concrete routine returning only two ordered vectors and their indexing
facts. Constant consistency does not claim physical accuracy for every law. -/
def method (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    Method law OrderedResult ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := fun _ => True
  solve := fun problem _ => ⟨problem.leftState, problem.rightState, rfl, rfl⟩
  extract := fun result => (result.left, result.right)
  numericalFlux := fun info => law.physicalFlux info.1
  constants_in_domain := fun _ => trivial
  consistent := fun _ => rfl

theorem selected_pair (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    (method law).extract (Method.selectedResult (method law) old (fun _ => trivial) j) =
      (old (j - 1), old j) := rfl

theorem selected_flux (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    Method.interfaceFlux (method law) old (fun _ => trivial) j =
      law.physicalFlux (old (j - 1)) := rfl

/-- The nonconstant one-component problem returns the actual pair `(0,1)`.
The flux is zero for unit-speed transport; no returned field is part of it. -/
theorem concrete_information_only :
    let law := StationaryRiemannField.transportLaw (m := 1)
    let problem : HyperbolicRiemannProblem law := ⟨0, 1⟩
    let result := (method law).solve problem trivial
    (method law).domain problem ∧ (method law).extract result = (0, 1) ∧
      (method law).numericalFlux ((method law).extract result) = 0 := by
  exact ⟨trivial, rfl, StationaryRiemannField.physicalFlux 0⟩

/-- This optional trace is computed from the actual returned left component.
Its introduction is separate from the method's execution contract. -/
def localTrace {problem : HyperbolicRiemannProblem law} (result : OrderedResult problem)
    (_τ : ℝ) : Fin m → ℝ := law.physicalFlux result.left

theorem localTrace_integrable {problem : HyperbolicRiemannProblem law}
    (result : OrderedResult problem) (s t : ℝ) :
    IntervalIntegrable (localTrace result) volume s t := intervalIntegrable_const

theorem extraction_eq_localTrace {problem : HyperbolicRiemannProblem law}
    (result : OrderedResult problem) (τ : ℝ) :
    (method law).numericalFlux ((method law).extract result) = localTrace result τ := rfl

/-- Separate physical evidence is available for this specific unit-speed law.
It compares the optional result trace with the existing conserved reference. -/
theorem localTrace_eq_transport_reference
    {problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := m))}
    (result : OrderedResult problem) {τ : ℝ} (hτ : 0 < τ) :
    localTrace result τ = StationaryRiemannField.transportLaw.physicalFlux
      (StationaryRiemannField.reference problem.leftState problem.rightState 0 τ) := by
  simpa only [localTrace, result.left_eq, StationaryRiemannField.stationary, riemannData_zero] using
    congrArg StationaryRiemannField.transportLaw.physicalFlux
      (StationaryRiemannField.stationary_trace_eq_reference problem.leftState problem.rightState hτ)

/-- The finite-step comparison assumptions are themselves inhabited: both
trace errors vanish for the independent translating unit-speed reference. -/
theorem selected_flux_eq_reference_average
    (problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := m)))
    {dt : ℝ} (hdt : 0 < dt) :
    (method StationaryRiemannField.transportLaw).numericalFlux
      ((method StationaryRiemannField.transportLaw).extract
        ((method StationaryRiemannField.transportLaw).solve problem trivial)) =
    oneDimensionalCellAverage (fun τ => StationaryRiemannField.transportLaw.physicalFlux
      (StationaryRiemannField.reference problem.leftState problem.rightState 0 τ)) 0 dt := by
  let result := (method StationaryRiemannField.transportLaw).solve problem trivial
  have hl := localTrace_integrable result 0 dt
  have hp := (StationaryRiemannField.reference_rectangle problem.leftState problem.rightState).2.1 0 0 dt
  have hn : ∀ τ ∈ Set.uIoc 0 dt,
      ‖(method StationaryRiemannField.transportLaw).numericalFlux
        ((method StationaryRiemannField.transportLaw).extract result) - localTrace result τ‖ ≤ 0 := by
    intro τ _
    rw [extraction_eq_localTrace result τ]
    simp
  have he : ∀ τ ∈ Set.uIoc 0 dt, ‖localTrace result τ -
      StationaryRiemannField.transportLaw.physicalFlux
        (StationaryRiemannField.reference problem.leftState problem.rightState 0 τ)‖ ≤ 0 := by
    intro τ hτ
    rw [Set.uIoc_of_le hdt.le] at hτ
    rw [localTrace_eq_transport_reference result hτ.1]
    simp
  have hb := norm_sub_oneDimensionalCellAverage_le_of_trace hdt hl hp hn he
  apply sub_eq_zero.mp
  apply norm_eq_zero.mp
  exact le_antisymm (by simpa using hb) (norm_nonneg _)

/-- The existing field method embeds with its original selected result and
its established nonexactness. No field is manufactured by the adapter. -/
theorem existing_field_embedding :
    ∃ problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := 1)),
      (Method.ofField StationaryRiemannField.method).domain problem ∧
      (Method.ofField StationaryRiemannField.method).solve problem trivial =
        StationaryRiemannField.method.solve problem trivial ∧
      ¬ IsRectangleConservationLawSolution
        (StationaryRiemannField.method.field
          ((Method.ofField StationaryRiemannField.method).solve problem trivial))
        StationaryRiemannField.transportLaw.physicalFlux := by
  obtain ⟨problem, hp, hnot⟩ := StationaryRiemannField.nonexact_instance
  exact ⟨problem, hp, rfl, hnot⟩

end NumStability.InformationOnlyRiemannDraft.Witness


#check NumStability.InformationOnlyRiemannDraft.Method
#print axioms NumStability.InformationOnlyRiemannDraft.Method
#check NumStability.InformationOnlyRiemannDraft.Method.selectedResult
#print axioms NumStability.InformationOnlyRiemannDraft.Method.selectedResult
#check NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux
#print axioms NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux
#check NumStability.InformationOnlyRiemannDraft.Method.interface_execution
#print axioms NumStability.InformationOnlyRiemannDraft.Method.interface_execution
#check NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux_constant
#print axioms NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux_constant
#check NumStability.InformationOnlyRiemannDraft.Method.ofField
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField
#check NumStability.InformationOnlyRiemannDraft.Method.ofField_solve
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField_solve
#check NumStability.InformationOnlyRiemannDraft.Method.ofField_extract
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField_extract
#check NumStability.InformationOnlyRiemannDraft.Method.ofField_numericalFlux
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField_numericalFlux
#check NumStability.InformationOnlyRiemannDraft.Method.ofField_interfaceFlux
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField_interfaceFlux
#check NumStability.InformationOnlyRiemannDraft.Method.ofField_finite_trace_integrable
#print axioms NumStability.InformationOnlyRiemannDraft.Method.ofField_finite_trace_integrable
#check NumStability.InformationOnlyRiemannDraft.Method.interface_error_le
#print axioms NumStability.InformationOnlyRiemannDraft.Method.interface_error_le
#check NumStability.InformationOnlyRiemannDraft.Method.update_error_le
#print axioms NumStability.InformationOnlyRiemannDraft.Method.update_error_le
#check NumStability.InformationOnlyRiemannDraft.Witness.OrderedResult
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.OrderedResult
#check NumStability.InformationOnlyRiemannDraft.Witness.method
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.method
#check NumStability.InformationOnlyRiemannDraft.Witness.selected_pair
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.selected_pair
#check NumStability.InformationOnlyRiemannDraft.Witness.selected_flux
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.selected_flux
#check NumStability.InformationOnlyRiemannDraft.Witness.concrete_information_only
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.concrete_information_only
#check NumStability.InformationOnlyRiemannDraft.Witness.localTrace
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.localTrace
#check NumStability.InformationOnlyRiemannDraft.Witness.localTrace_integrable
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.localTrace_integrable
#check NumStability.InformationOnlyRiemannDraft.Witness.extraction_eq_localTrace
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.extraction_eq_localTrace
#check NumStability.InformationOnlyRiemannDraft.Witness.localTrace_eq_transport_reference
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.localTrace_eq_transport_reference
#check NumStability.InformationOnlyRiemannDraft.Witness.selected_flux_eq_reference_average
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.selected_flux_eq_reference_average
#check NumStability.InformationOnlyRiemannDraft.Witness.existing_field_embedding
#print axioms NumStability.InformationOnlyRiemannDraft.Witness.existing_field_embedding
#check NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace
#print axioms NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace
#check NumStability.riemannFiniteVolumeUpdate_error_le
#print axioms NumStability.riemannFiniteVolumeUpdate_error_le
#check NumStability.StationaryRiemannField.reference_rectangle
#print axioms NumStability.StationaryRiemannField.reference_rectangle
#check NumStability.StationaryRiemannField.stationary_trace_eq_reference
#print axioms NumStability.StationaryRiemannField.stationary_trace_eq_reference
#check NumStability.StationaryRiemannField.nonexact_instance
#print axioms NumStability.StationaryRiemannField.nonexact_instance
#print NumStability.InformationOnlyRiemannDraft.Method
#print NumStability.InformationOnlyRiemannDraft.Witness.OrderedResult
#print NumStability.InformationOnlyRiemannDraft.Method.selectedResult
#print NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux


namespace NumStability.InformationMethodPlacementChecks

open InformationOnlyRiemannDraft InformationOnlyRiemannDraft.Method

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

-- Explicit maps preserve all six fields. The structure types are nominally distinct.
def fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information) :
    RiemannInformationFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

def toDraft (method : RiemannInformationFluxMethod law Result Information) :
    InformationOnlyRiemannDraft.Method law Result Information where
  domain := method.domain
  solve := method.solve
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

theorem fromDraft_toDraft (method : RiemannInformationFluxMethod law Result Information) :
    fromDraft (toDraft method) = method := by cases method; rfl

theorem toDraft_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information) :
    toDraft (fromDraft method) = method := by cases method; rfl

def methodEquiv : InformationOnlyRiemannDraft.Method law Result Information ≃
    RiemannInformationFluxMethod law Result Information where
  toFun := fromDraft
  invFun := toDraft
  left_inv := toDraft_fromDraft
  right_inv := fromDraft_toDraft

theorem fromDraft_fields (method : InformationOnlyRiemannDraft.Method law Result Information) :
    (fromDraft method).domain = method.domain ∧
    (fromDraft method).solve = method.solve ∧
    (fromDraft method).extract = method.extract ∧
    (fromDraft method).numericalFlux = method.numericalFlux ∧
    (fromDraft method).constants_in_domain = method.constants_in_domain ∧
    (fromDraft method).consistent = method.consistent := ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem toDraft_fields (method : RiemannInformationFluxMethod law Result Information) :
    (toDraft method).domain = method.domain ∧
    (toDraft method).solve = method.solve ∧
    (toDraft method).extract = method.extract ∧
    (toDraft method).numericalFlux = method.numericalFlux ∧
    (toDraft method).constants_in_domain = method.constants_in_domain ∧
    (toDraft method).consistent = method.consistent := ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

theorem selectedResult_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannInformationFluxMethod.selectedResult (fromDraft method) old hdomain j =
      InformationOnlyRiemannDraft.Method.selectedResult method old hdomain j := rfl

theorem selectedResult_toDraft (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    InformationOnlyRiemannDraft.Method.selectedResult (toDraft method) old hdomain j =
      RiemannInformationFluxMethod.selectedResult method old hdomain j := rfl

theorem interfaceFlux_fromDraft (method : InformationOnlyRiemannDraft.Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannInformationFluxMethod.interfaceFlux (fromDraft method) old hdomain j =
      InformationOnlyRiemannDraft.Method.interfaceFlux method old hdomain j := rfl

theorem interfaceFlux_toDraft (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    InformationOnlyRiemannDraft.Method.interfaceFlux (toDraft method) old hdomain j =
      RiemannInformationFluxMethod.interfaceFlux method old hdomain j := rfl

theorem ofField_fromDraft (method : RiemannFieldFluxMethod law Result Information) :
    fromDraft (InformationOnlyRiemannDraft.Method.ofField method) =
      RiemannInformationFluxMethod.ofField method := rfl

theorem ofField_toDraft (method : RiemannFieldFluxMethod law Result Information) :
    toDraft (RiemannInformationFluxMethod.ofField method) =
      InformationOnlyRiemannDraft.Method.ofField method := rfl

-- Explicit maps preserve all four result fields, including both indexing facts.
def resultFromDraft {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    LeftStateInformationFlux.OrderedResult problem where
  left := result.left
  right := result.right
  left_eq := result.left_eq
  right_eq := result.right_eq

def resultToDraft {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    InformationOnlyRiemannDraft.Witness.OrderedResult problem where
  left := result.left
  right := result.right
  left_eq := result.left_eq
  right_eq := result.right_eq

theorem resultFromDraft_toDraft {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    resultFromDraft (resultToDraft result) = result := by cases result; rfl

theorem resultToDraft_fromDraft {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    resultToDraft (resultFromDraft result) = result := by cases result; rfl

def resultEquiv (problem : HyperbolicRiemannProblem law) :
    InformationOnlyRiemannDraft.Witness.OrderedResult problem ≃
      LeftStateInformationFlux.OrderedResult problem where
  toFun := resultFromDraft
  invFun := resultToDraft
  left_inv := resultToDraft_fromDraft
  right_inv := resultFromDraft_toDraft

theorem resultFromDraft_fields {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    (resultFromDraft result).left = result.left ∧
    (resultFromDraft result).right = result.right ∧
    (resultFromDraft result).left_eq = result.left_eq ∧
    (resultFromDraft result).right_eq = result.right_eq := ⟨rfl, rfl, rfl, rfl⟩

theorem resultToDraft_fields {problem : HyperbolicRiemannProblem law}
    (result : LeftStateInformationFlux.OrderedResult problem) :
    (resultToDraft result).left = result.left ∧
    (resultToDraft result).right = result.right ∧
    (resultToDraft result).left_eq = result.left_eq ∧
    (resultToDraft result).right_eq = result.right_eq := ⟨rfl, rfl, rfl, rfl⟩

-- The example changes both nominal types; transport its result as well as its method.
def witnessFromDraft (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    RiemannInformationFluxMethod law LeftStateInformationFlux.OrderedResult
      ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := (InformationOnlyRiemannDraft.Witness.method law).domain
  solve := fun problem h => resultFromDraft ((InformationOnlyRiemannDraft.Witness.method law).solve problem h)
  extract := fun result => (InformationOnlyRiemannDraft.Witness.method law).extract (resultToDraft result)
  numericalFlux := (InformationOnlyRiemannDraft.Witness.method law).numericalFlux
  constants_in_domain := (InformationOnlyRiemannDraft.Witness.method law).constants_in_domain
  consistent := fun _ => rfl

def witnessToDraft (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    InformationOnlyRiemannDraft.Method law InformationOnlyRiemannDraft.Witness.OrderedResult
      ((Fin m → ℝ) × (Fin m → ℝ)) where
  domain := (LeftStateInformationFlux.method law).domain
  solve := fun problem h => resultToDraft ((LeftStateInformationFlux.method law).solve problem h)
  extract := fun result => (LeftStateInformationFlux.method law).extract (resultFromDraft result)
  numericalFlux := (LeftStateInformationFlux.method law).numericalFlux
  constants_in_domain := (LeftStateInformationFlux.method law).constants_in_domain
  consistent := fun _ => rfl

theorem witnessFromDraft_eq (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    witnessFromDraft law = LeftStateInformationFlux.method law := rfl

theorem witnessToDraft_eq (law : OneDimensionalHyperbolicConservationLaw (Fin m)) :
    witnessToDraft law = InformationOnlyRiemannDraft.Witness.method law := rfl

theorem witness_selectedResult_commutes (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    resultFromDraft (InformationOnlyRiemannDraft.Method.selectedResult
      (InformationOnlyRiemannDraft.Witness.method law) old (fun _ => trivial) j) =
    RiemannInformationFluxMethod.selectedResult (LeftStateInformationFlux.method law)
      old (fun _ => trivial) j := rfl

theorem witness_extract_commutes {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) :
    (LeftStateInformationFlux.method law).extract (resultFromDraft result) =
      (InformationOnlyRiemannDraft.Witness.method law).extract result := rfl

theorem witness_localTrace_commutes {problem : HyperbolicRiemannProblem law}
    (result : InformationOnlyRiemannDraft.Witness.OrderedResult problem) (τ : ℝ) :
    LeftStateInformationFlux.localTrace (resultFromDraft result) τ =
      InformationOnlyRiemannDraft.Witness.localTrace result τ := rfl

theorem witness_interfaceFlux_commutes (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (old : ℤ → Fin m → ℝ) (j : ℤ) :
    RiemannInformationFluxMethod.interfaceFlux (LeftStateInformationFlux.method law)
      old (fun _ => trivial) j = InformationOnlyRiemannDraft.Method.interfaceFlux
        (InformationOnlyRiemannDraft.Witness.method law) old (fun _ => trivial) j := rfl

theorem interface_execution_fromDraft (method : Method law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let result := method.solve problem (hdomain j)
    problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    selectedResult method old hdomain j = result ∧
    interfaceFlux method old hdomain j = method.numericalFlux (method.extract result) :=
  RiemannInformationFluxMethod.interface_execution (fromDraft method) old hdomain j

theorem interface_execution_type_comparison : @interface_execution_fromDraft = @NumStability.InformationOnlyRiemannDraft.Method.interface_execution := rfl

theorem interfaceFlux_constant_fromDraft (method : Method law Result Information) (state : Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law (fun _ => state) j)) (j : ℤ) :
    interfaceFlux method (fun _ => state) hdomain j = law.physicalFlux state :=
  RiemannInformationFluxMethod.interfaceFlux_constant (fromDraft method) state hdomain j

theorem interfaceFlux_constant_type_comparison : @interfaceFlux_constant_fromDraft = @NumStability.InformationOnlyRiemannDraft.Method.interfaceFlux_constant := rfl

theorem interface_error_le_fromDraft (grid : OneDimensionalFiniteVolumeGrid)
    (method : Method law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} {s t a b : ℝ} (hst : s < t) (j : ℤ)
    (localTrace : Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hl : IntervalIntegrable (localTrace (selectedResult method old hdomain j)) volume s t)
    (hp : IntervalIntegrable (fun τ => law.physicalFlux (q (grid.cellLeft j) τ)) volume s t)
    (hn : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain j -
      localTrace (selectedResult method old hdomain j) τ‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc s t, ‖localTrace (selectedResult method old hdomain j) τ -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b) :
    ‖interfaceFlux method old hdomain j -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux s t j‖ ≤ a + b :=
  RiemannInformationFluxMethod.interface_error_le grid (fromDraft method) old hdomain hst j localTrace hl hp hn he

theorem interface_error_le_type_comparison : @interface_error_le_fromDraft = @NumStability.InformationOnlyRiemannDraft.Method.interface_error_le := rfl

theorem update_error_le_fromDraft (grid : OneDimensionalFiniteVolumeGrid)
    (method : Method law Result Information) (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {q : ℝ → ℝ → Fin m → ℝ} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    {s t oldBound aLeft bLeft aRight bRight : ℝ} (hst : s < t) (i : ℤ)
    (localTrace : (j : ℤ) → Result (adjacentCellRiemannProblem law old j) → ℝ → Fin m → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x s) i‖ ≤ oldBound)
    (hl : IntervalIntegrable (localTrace i (selectedResult method old hdomain i)) volume s t)
    (hr : IntervalIntegrable (localTrace (i + 1) (selectedResult method old hdomain (i + 1))) volume s t)
    (hnl : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain i -
      localTrace i (selectedResult method old hdomain i) τ‖ ≤ aLeft)
    (hel : ∀ τ ∈ Set.uIoc s t, ‖localTrace i (selectedResult method old hdomain i) τ -
      law.physicalFlux (q (grid.cellLeft i) τ)‖ ≤ bLeft)
    (hnr : ∀ τ ∈ Set.uIoc s t, ‖interfaceFlux method old hdomain (i + 1) -
      localTrace (i + 1) (selectedResult method old hdomain (i + 1)) τ‖ ≤ aRight)
    (her : ∀ τ ∈ Set.uIoc s t, ‖localTrace (i + 1) (selectedResult method old hdomain (i + 1)) τ -
      law.physicalFlux (q (grid.cellLeft (i + 1)) τ)‖ ≤ bRight) :
    ‖riemannFiniteVolumeUpdate grid (t - s) old (interfaceFlux method old hdomain) i -
      finiteVolumeCellAverageOn grid (fun x => q x t) i‖ ≤
      oldBound + (t - s) / grid.cellVolume i * ((aLeft + bLeft) + (aRight + bRight)) :=
  RiemannInformationFluxMethod.update_error_le grid (fromDraft method) old hdomain hq hst i localTrace hold hl hr hnl hel hnr her

theorem update_error_le_type_comparison : @update_error_le_fromDraft = @NumStability.InformationOnlyRiemannDraft.Method.update_error_le := rfl

open InformationOnlyRiemannDraft.Witness

theorem localTrace_integrable_fromDraft {problem : HyperbolicRiemannProblem law}
    (result : OrderedResult problem) (s t : ℝ) :
    IntervalIntegrable (localTrace result) volume s t :=
  LeftStateInformationFlux.localTrace_integrable (resultFromDraft result) s t

theorem localTrace_integrable_type_comparison : @localTrace_integrable_fromDraft = @NumStability.InformationOnlyRiemannDraft.Witness.localTrace_integrable := rfl

theorem extraction_eq_localTrace_fromDraft {problem : HyperbolicRiemannProblem law}
    (result : OrderedResult problem) (τ : ℝ) :
    (method law).numericalFlux ((method law).extract result) = localTrace result τ :=
  LeftStateInformationFlux.extraction_eq_localTrace (resultFromDraft result) τ

theorem extraction_eq_localTrace_type_comparison : @extraction_eq_localTrace_fromDraft = @NumStability.InformationOnlyRiemannDraft.Witness.extraction_eq_localTrace := rfl

theorem localTrace_eq_transport_reference_fromDraft
    {problem : HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := m))}
    (result : OrderedResult problem) {τ : ℝ} (hτ : 0 < τ) :
    localTrace result τ = StationaryRiemannField.transportLaw.physicalFlux
      (StationaryRiemannField.reference problem.leftState problem.rightState 0 τ) :=
  LeftStateInformationFlux.localTrace_eq_transport_reference (resultFromDraft result) hτ

theorem localTrace_eq_transport_reference_type_comparison : @localTrace_eq_transport_reference_fromDraft = @NumStability.InformationOnlyRiemannDraft.Witness.localTrace_eq_transport_reference := rfl

theorem exact_type_01 : @NumStability.InformationOnlyRiemannDraft.Method.ofField_solve = @NumStability.RiemannInformationFluxMethod.ofField_solve := rfl

theorem exact_type_02 : @NumStability.InformationOnlyRiemannDraft.Method.ofField_extract = @NumStability.RiemannInformationFluxMethod.ofField_extract := rfl

theorem exact_type_03 : @NumStability.InformationOnlyRiemannDraft.Method.ofField_numericalFlux = @NumStability.RiemannInformationFluxMethod.ofField_numericalFlux := rfl

theorem exact_type_04 : @NumStability.InformationOnlyRiemannDraft.Method.ofField_interfaceFlux = @NumStability.RiemannInformationFluxMethod.ofField_interfaceFlux := rfl

theorem exact_type_05 : @NumStability.InformationOnlyRiemannDraft.Method.ofField_finite_trace_integrable = @NumStability.RiemannInformationFluxMethod.ofField_finite_trace_integrable := rfl

theorem exact_type_06 : @NumStability.InformationOnlyRiemannDraft.Witness.selected_pair = @NumStability.LeftStateInformationFlux.selected_pair := rfl

theorem exact_type_07 : @NumStability.InformationOnlyRiemannDraft.Witness.selected_flux = @NumStability.LeftStateInformationFlux.selected_flux := rfl

theorem exact_type_08 : @NumStability.InformationOnlyRiemannDraft.Witness.concrete_information_only = @NumStability.LeftStateInformationFlux.concrete_information_only := rfl

theorem exact_type_09 : @NumStability.InformationOnlyRiemannDraft.Witness.selected_flux_eq_reference_average = @NumStability.LeftStateInformationFlux.selected_flux_eq_reference_average := rfl

theorem exact_type_10 : @NumStability.InformationOnlyRiemannDraft.Witness.existing_field_embedding = @NumStability.LeftStateInformationFlux.existing_field_embedding := rfl

end NumStability.InformationMethodPlacementChecks

#check NumStability.InformationMethodPlacementChecks.fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.fromDraft
#check NumStability.InformationMethodPlacementChecks.toDraft
#print axioms NumStability.InformationMethodPlacementChecks.toDraft
#check NumStability.InformationMethodPlacementChecks.fromDraft_toDraft
#print axioms NumStability.InformationMethodPlacementChecks.fromDraft_toDraft
#check NumStability.InformationMethodPlacementChecks.toDraft_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.toDraft_fromDraft
#check NumStability.InformationMethodPlacementChecks.methodEquiv
#print axioms NumStability.InformationMethodPlacementChecks.methodEquiv
#check NumStability.InformationMethodPlacementChecks.fromDraft_fields
#print axioms NumStability.InformationMethodPlacementChecks.fromDraft_fields
#check NumStability.InformationMethodPlacementChecks.toDraft_fields
#print axioms NumStability.InformationMethodPlacementChecks.toDraft_fields
#check NumStability.InformationMethodPlacementChecks.selectedResult_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.selectedResult_fromDraft
#check NumStability.InformationMethodPlacementChecks.selectedResult_toDraft
#print axioms NumStability.InformationMethodPlacementChecks.selectedResult_toDraft
#check NumStability.InformationMethodPlacementChecks.interfaceFlux_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.interfaceFlux_fromDraft
#check NumStability.InformationMethodPlacementChecks.interfaceFlux_toDraft
#print axioms NumStability.InformationMethodPlacementChecks.interfaceFlux_toDraft
#check NumStability.InformationMethodPlacementChecks.ofField_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.ofField_fromDraft
#check NumStability.InformationMethodPlacementChecks.ofField_toDraft
#print axioms NumStability.InformationMethodPlacementChecks.ofField_toDraft
#check NumStability.InformationMethodPlacementChecks.resultFromDraft
#print axioms NumStability.InformationMethodPlacementChecks.resultFromDraft
#check NumStability.InformationMethodPlacementChecks.resultToDraft
#print axioms NumStability.InformationMethodPlacementChecks.resultToDraft
#check NumStability.InformationMethodPlacementChecks.resultFromDraft_toDraft
#print axioms NumStability.InformationMethodPlacementChecks.resultFromDraft_toDraft
#check NumStability.InformationMethodPlacementChecks.resultToDraft_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.resultToDraft_fromDraft
#check NumStability.InformationMethodPlacementChecks.resultEquiv
#print axioms NumStability.InformationMethodPlacementChecks.resultEquiv
#check NumStability.InformationMethodPlacementChecks.resultFromDraft_fields
#print axioms NumStability.InformationMethodPlacementChecks.resultFromDraft_fields
#check NumStability.InformationMethodPlacementChecks.resultToDraft_fields
#print axioms NumStability.InformationMethodPlacementChecks.resultToDraft_fields
#check NumStability.InformationMethodPlacementChecks.witnessFromDraft
#print axioms NumStability.InformationMethodPlacementChecks.witnessFromDraft
#check NumStability.InformationMethodPlacementChecks.witnessToDraft
#print axioms NumStability.InformationMethodPlacementChecks.witnessToDraft
#check NumStability.InformationMethodPlacementChecks.witnessFromDraft_eq
#print axioms NumStability.InformationMethodPlacementChecks.witnessFromDraft_eq
#check NumStability.InformationMethodPlacementChecks.witnessToDraft_eq
#print axioms NumStability.InformationMethodPlacementChecks.witnessToDraft_eq
#check NumStability.InformationMethodPlacementChecks.witness_selectedResult_commutes
#print axioms NumStability.InformationMethodPlacementChecks.witness_selectedResult_commutes
#check NumStability.InformationMethodPlacementChecks.witness_extract_commutes
#print axioms NumStability.InformationMethodPlacementChecks.witness_extract_commutes
#check NumStability.InformationMethodPlacementChecks.witness_localTrace_commutes
#print axioms NumStability.InformationMethodPlacementChecks.witness_localTrace_commutes
#check NumStability.InformationMethodPlacementChecks.witness_interfaceFlux_commutes
#print axioms NumStability.InformationMethodPlacementChecks.witness_interfaceFlux_commutes
#check NumStability.InformationMethodPlacementChecks.interface_execution_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.interface_execution_fromDraft
#check NumStability.InformationMethodPlacementChecks.interface_execution_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.interface_execution_type_comparison
#check NumStability.InformationMethodPlacementChecks.interfaceFlux_constant_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.interfaceFlux_constant_fromDraft
#check NumStability.InformationMethodPlacementChecks.interfaceFlux_constant_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.interfaceFlux_constant_type_comparison
#check NumStability.InformationMethodPlacementChecks.interface_error_le_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.interface_error_le_fromDraft
#check NumStability.InformationMethodPlacementChecks.interface_error_le_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.interface_error_le_type_comparison
#check NumStability.InformationMethodPlacementChecks.update_error_le_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.update_error_le_fromDraft
#check NumStability.InformationMethodPlacementChecks.update_error_le_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.update_error_le_type_comparison
#check NumStability.InformationMethodPlacementChecks.localTrace_integrable_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.localTrace_integrable_fromDraft
#check NumStability.InformationMethodPlacementChecks.localTrace_integrable_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.localTrace_integrable_type_comparison
#check NumStability.InformationMethodPlacementChecks.extraction_eq_localTrace_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.extraction_eq_localTrace_fromDraft
#check NumStability.InformationMethodPlacementChecks.extraction_eq_localTrace_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.extraction_eq_localTrace_type_comparison
#check NumStability.InformationMethodPlacementChecks.localTrace_eq_transport_reference_fromDraft
#print axioms NumStability.InformationMethodPlacementChecks.localTrace_eq_transport_reference_fromDraft
#check NumStability.InformationMethodPlacementChecks.localTrace_eq_transport_reference_type_comparison
#print axioms NumStability.InformationMethodPlacementChecks.localTrace_eq_transport_reference_type_comparison
#check NumStability.InformationMethodPlacementChecks.exact_type_01
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_01
#check NumStability.InformationMethodPlacementChecks.exact_type_02
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_02
#check NumStability.InformationMethodPlacementChecks.exact_type_03
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_03
#check NumStability.InformationMethodPlacementChecks.exact_type_04
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_04
#check NumStability.InformationMethodPlacementChecks.exact_type_05
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_05
#check NumStability.InformationMethodPlacementChecks.exact_type_06
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_06
#check NumStability.InformationMethodPlacementChecks.exact_type_07
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_07
#check NumStability.InformationMethodPlacementChecks.exact_type_08
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_08
#check NumStability.InformationMethodPlacementChecks.exact_type_09
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_09
#check NumStability.InformationMethodPlacementChecks.exact_type_10
#print axioms NumStability.InformationMethodPlacementChecks.exact_type_10
