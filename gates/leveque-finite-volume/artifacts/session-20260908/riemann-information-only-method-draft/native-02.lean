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
