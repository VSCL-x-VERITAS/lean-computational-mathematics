import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageTraceEstimate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.StationaryRiemannField

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannFluxError
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface

/-!
# Returned Riemann fields with conditional flux errors

Scratch generic mathematics. Returned fields have the ordered initial data and
an integrable physical interface trace. They need not solve the original PDE.
No accuracy, convergence, entropy, or source-interpretation claim is bundled.
The result type retains enough information to embed the existing exact method
without trying to reconstruct its certificate from an arbitrary field.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.ReturnedRiemannDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

/-- A field-producing method on an explicit domain. Its result may also contain
wave information or an exact certificate, but no exact certificate is required. -/
structure FieldFluxMethod
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  domain : HyperbolicRiemannProblem law → Prop
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
  field : {problem : HyperbolicRiemannProblem law} → Result problem → ℝ → ℝ → (Fin m → ℝ)
  initial : ∀ {problem} (result : Result problem),
    IsRiemannData (fun x => field result x 0) problem.leftState problem.rightState
  trace_integrable : ∀ {problem} (result : Result problem) (s t : ℝ),
    IntervalIntegrable (fun τ => law.physicalFlux (field result 0 τ)) volume s t
  extract : {problem : HyperbolicRiemannProblem law} → Result problem → Information
  numericalFlux : Information → (Fin m → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent : ∀ state, numericalFlux (extract (solve
    ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
    (constants_in_domain state))) = law.physicalFlux state

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- Information and flux are extracted from the selected solve of the actual
ordered adjacent-cell problem. Admissibility is only required for this array. -/
def interfaceFlux (method : FieldFluxMethod law Result Information)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    (j : ℤ) : Fin m → ℝ :=
  method.numericalFlux (method.extract
    (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)))

/-- The exact method is a special case, retaining its original result and extractor. -/
def ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    FieldFluxMethod law (CertifiedRectangleRiemannSolution law) Information where
  domain := method.domain
  solve := method.solve
  field := fun result => result.solution
  initial := fun result => result.solves.1
  trace_integrable := fun result s t => result.solves.2.2.1 0 s t
  extract := method.extractInformation
  numericalFlux := method.numericalFluxFromInformation
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent_on_constant_states

theorem ofExact_interfaceFlux (method : RectangleRiemannInterfaceFluxMethod law Information)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    interfaceFlux (ofExact method) old hdomain j =
      rectangleRiemannInterfaceFlux method old hdomain j := rfl

theorem ofExact_returnedField (method : RectangleRiemannInterfaceFluxMethod law Information)
    (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (ofExact method).field ((ofExact method).solve problem h) =
      (method.solve problem h).solution := rfl

/-- A trace-level bound does not require a field or an exact local solution.
It can therefore also be used for a method that returns only interface data. -/
theorem flux_error_of_trace {E : Type*}
    [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    {localTrace physicalTrace : ℝ → E} {numerical : E} {s t a b : ℝ}
    (hst : s < t) (hl : IntervalIntegrable localTrace volume s t)
    (hp : IntervalIntegrable physicalTrace volume s t)
    (hn : ∀ τ ∈ Set.uIoc s t, ‖numerical - localTrace τ‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc s t, ‖localTrace τ - physicalTrace τ‖ ≤ b) :
    ‖numerical - oneDimensionalCellAverage physicalTrace s t‖ ≤ a + b := by
  have hc : oneDimensionalCellAverage (fun _ : ℝ => numerical) s t = numerical := by
    simp [oneDimensionalCellAverage, intervalIntegral.integral_const, smul_smul,
      (sub_pos.mpr hst).ne']
  have hn' : ‖numerical - oneDimensionalCellAverage localTrace s t‖ ≤ a := by
    rw [← hc]
    exact norm_oneDimensionalCellAverage_sub_le hst intervalIntegrable_const hl hn
  exact (norm_sub_le_norm_sub_add_norm_sub numerical
    (oneDimensionalCellAverage localTrace s t) _).trans
    (add_le_add hn' (norm_oneDimensionalCellAverage_sub_le hst hl hp he))

/-- Extraction error and returned-field/global-field trace error imply a physical
face-flux error bound. Both errors are hypotheses, not certified accuracy claims. -/
theorem interface_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : FieldFluxMethod law Result Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt a b : ℝ} (hdt : 0 < dt) (j : ℤ)
    (hn : ∀ τ ∈ Set.uIoc 0 dt, ‖interfaceFlux method old hdomain j -
      law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ)‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc 0 dt, ‖law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ) -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b) :
    ‖interfaceFlux method old hdomain j -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ ≤ a + b :=
  flux_error_of_trace hdt (method.trace_integrable _ 0 dt) (hq.2.1 _ _ _) hn he

/-- Error propagation uses the existing physical conservation/update estimate.
The rule is fixed only on the given admitted array; no other admission is inferred. -/
theorem update_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : FieldFluxMethod law Result Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ) (a b : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (hn : ∀ j τ, τ ∈ Set.uIoc 0 dt → ‖interfaceFlux method old hdomain j -
      law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ)‖ ≤ a j)
    (he : ∀ j τ, τ ∈ Set.uIoc 0 dt → ‖law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ) -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b j) :
    ‖riemannFiniteVolumeUpdate grid dt old (interfaceFlux method old hdomain) i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i * ((a i + b i) + (a (i + 1) + b (i + 1))) := by
  simpa using riemannFiniteVolumeUpdate_error_le grid hq
    (fun _ _ _ => interfaceFlux method old hdomain) hdt old i hold
    (interface_error_le grid method hq old hdomain hdt i (hn i) (he i))
    (interface_error_le grid method hq old hdomain hdt (i + 1) (hn (i + 1)) (he (i + 1)))

namespace Witness

/-- Unit-speed vector transport supplies a genuine hyperbolic physical law. -/
theorem identity_hyperbolic : IsRealHyperbolicMatrix (1 : Matrix (Fin m) (Fin m) ℝ) := by
  refine ⟨fun _ => 1, Pi.basisFun ℝ (Fin m), ?_⟩
  intro p
  simp only [Matrix.one_mulVec, one_smul]

noncomputable def transportLaw : OneDimensionalHyperbolicConservationLaw (Fin m) :=
  linearHyperbolicConservationLaw 1 identity_hyperbolic

@[simp] theorem physicalFlux (state : Fin m → ℝ) : transportLaw.physicalFlux state = state := by
  simp [transportLaw, linearHyperbolicConservationLaw]

/-- An intentionally inexact stationary return of the ordered initial data. -/
noncomputable def stationary (left right : Fin m → ℝ) (x _t : ℝ) : Fin m → ℝ :=
  riemannData left left right x

theorem stationary_initial (left right : Fin m → ℝ) :
    IsRiemannData (fun x => stationary left right x 0) left right :=
  riemannData_isRiemannData left left right

theorem stationary_trace_integrable (left right : Fin m → ℝ) (s t : ℝ) :
    IntervalIntegrable (fun τ => transportLaw.physicalFlux (stationary left right 0 τ)) volume s t := by
  simp only [physicalFlux, stationary, riemannData_zero]
  exact intervalIntegrable_const

/-- All problems are admitted; the actual returned field provides the interface
information. Its upwind flux is consistent even though its field is inexact. -/
def StationaryResult (problem : HyperbolicRiemannProblem (transportLaw (m := m))) :=
  {field : ℝ → ℝ → (Fin m → ℝ) // field = stationary problem.leftState problem.rightState}

noncomputable def method : FieldFluxMethod (transportLaw (m := m)) StationaryResult (Fin m → ℝ) where
  domain := fun _ => True
  solve := fun problem _ => ⟨stationary problem.leftState problem.rightState, rfl⟩
  field := fun result => result.val
  initial := fun result => by rw [result.property]; exact stationary_initial _ _
  trace_integrable := fun result s t => by
    rw [result.property]
    exact stationary_trace_integrable _ _ s t
  extract := fun result => result.val 0 1
  numericalFlux := transportLaw.physicalFlux
  constants_in_domain := fun _ => True.intro
  consistent := by intro state; simp [stationary]

/-- The exact reference with the same initial data translates at the physical speed. -/
noncomputable def reference (left right : Fin m → ℝ) : ℝ → ℝ → (Fin m → ℝ) :=
  travelingWave (riemannData left left right) 1

theorem reference_rectangle (left right : Fin m → ℝ) :
    IsRectangleConservationLawSolution (reference left right) transportLaw.physicalFlux := by
  have hflux : (transportLaw (m := m)).physicalFlux = fun state => state := funext physicalFlux
  rw [hflux]
  simpa [reference] using travelingWave_isRectangleConservationLawSolution
    (riemannData left left right) (riemannData_intervalIntegrable left left right) 1

theorem reference_initial (left right : Fin m → ℝ) :
    IsRiemannData (fun x => reference left right x 0) left right := by
  simpa [reference, travelingWave] using riemannData_isRiemannData left left right

/-- The stationary output is not a conserved field for unequal states. -/
theorem stationary_not_rectangle {left right : Fin m → ℝ} (hne : left ≠ right) :
    ¬ IsRectangleConservationLawSolution (stationary left right) transportLaw.physicalFlux := by
  intro h
  have hb := h.2.2 (-1) 1 0 1
  have hz : (0 : Fin m → ℝ) = left - right := by
    norm_num [stationary, riemannData, intervalIntegral.integral_const] at hb
    ext j
    have hj := congrFun hb j
    change (0 : ℝ) = (1 : ℝ) * left j - (1 : ℝ) * right j at hj
    simpa using hj
  exact hne (sub_eq_zero.mp hz.symm)

/-- No extraction error occurs at the interface for this deliberately inexact field. -/
theorem method_flux_eq_returned_trace
    (problem : HyperbolicRiemannProblem (transportLaw (m := m))) (t : ℝ) :
    (method (m := m)).numericalFlux
      (method.extract (problem := problem) (method.solve problem trivial)) =
      transportLaw.physicalFlux
        (method.field (problem := problem) (method.solve problem trivial) 0 t) := rfl

/-- At positive time its interface trace also agrees with the exact local reference.
This does not make the two space-time fields equal. -/
theorem stationary_trace_eq_reference (left right : Fin m → ℝ) {t : ℝ} (ht : 0 < t) :
    stationary left right 0 t = reference left right 0 t := by
  simp [stationary, reference, travelingWave, riemannData, neg_lt_zero.mpr ht]

/-- A uniform state error bound follows from the two possible states; no chosen
accuracy tolerance is assumed. For nonzero jumps this is still an inexact field. -/
theorem stationary_reference_error_le (left right : Fin m → ℝ) (x t : ℝ) :
    ‖stationary left right x t - reference left right x t‖ ≤ ‖left - right‖ := by
  unfold stationary reference travelingWave riemannData
  split_ifs <;> simp [norm_sub_rev]

theorem nonexact_instance : ∃ problem : HyperbolicRiemannProblem (transportLaw (m := 1)),
    (method (m := 1)).domain problem ∧
    ¬ IsRectangleConservationLawSolution
      (method.field (problem := problem) (method.solve problem trivial))
      transportLaw.physicalFlux := by
  refine ⟨⟨0, 1⟩, trivial, ?_⟩
  exact stationary_not_rectangle (by intro h; have := congrFun h (0 : Fin 1); norm_num at this)

end Witness
end NumStability.ReturnedRiemannDraft

-- Proof-free declaration signatures and exact foundational axiom checks.
#print NumStability.ReturnedRiemannDraft.FieldFluxMethod
#check NumStability.ReturnedRiemannDraft.FieldFluxMethod
#print axioms NumStability.ReturnedRiemannDraft.FieldFluxMethod
#check NumStability.ReturnedRiemannDraft.interfaceFlux
#print axioms NumStability.ReturnedRiemannDraft.interfaceFlux
#check NumStability.ReturnedRiemannDraft.ofExact
#print axioms NumStability.ReturnedRiemannDraft.ofExact
#check NumStability.ReturnedRiemannDraft.ofExact_interfaceFlux
#print axioms NumStability.ReturnedRiemannDraft.ofExact_interfaceFlux
#check NumStability.ReturnedRiemannDraft.ofExact_returnedField
#print axioms NumStability.ReturnedRiemannDraft.ofExact_returnedField
#check NumStability.ReturnedRiemannDraft.flux_error_of_trace
#print axioms NumStability.ReturnedRiemannDraft.flux_error_of_trace
#check NumStability.ReturnedRiemannDraft.interface_error_le
#print axioms NumStability.ReturnedRiemannDraft.interface_error_le
#check NumStability.ReturnedRiemannDraft.update_error_le
#print axioms NumStability.ReturnedRiemannDraft.update_error_le
#check NumStability.ReturnedRiemannDraft.Witness.identity_hyperbolic
#print axioms NumStability.ReturnedRiemannDraft.Witness.identity_hyperbolic
#check NumStability.ReturnedRiemannDraft.Witness.transportLaw
#print axioms NumStability.ReturnedRiemannDraft.Witness.transportLaw
#check NumStability.ReturnedRiemannDraft.Witness.physicalFlux
#print axioms NumStability.ReturnedRiemannDraft.Witness.physicalFlux
#check NumStability.ReturnedRiemannDraft.Witness.stationary
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary
#check NumStability.ReturnedRiemannDraft.Witness.stationary_initial
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary_initial
#check NumStability.ReturnedRiemannDraft.Witness.stationary_trace_integrable
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary_trace_integrable
#check NumStability.ReturnedRiemannDraft.Witness.StationaryResult
#print axioms NumStability.ReturnedRiemannDraft.Witness.StationaryResult
#check NumStability.ReturnedRiemannDraft.Witness.method
#print axioms NumStability.ReturnedRiemannDraft.Witness.method
#check NumStability.ReturnedRiemannDraft.Witness.reference
#print axioms NumStability.ReturnedRiemannDraft.Witness.reference
#check NumStability.ReturnedRiemannDraft.Witness.reference_rectangle
#print axioms NumStability.ReturnedRiemannDraft.Witness.reference_rectangle
#check NumStability.ReturnedRiemannDraft.Witness.reference_initial
#print axioms NumStability.ReturnedRiemannDraft.Witness.reference_initial
#check NumStability.ReturnedRiemannDraft.Witness.stationary_not_rectangle
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary_not_rectangle
#check NumStability.ReturnedRiemannDraft.Witness.method_flux_eq_returned_trace
#print axioms NumStability.ReturnedRiemannDraft.Witness.method_flux_eq_returned_trace
#check NumStability.ReturnedRiemannDraft.Witness.stationary_trace_eq_reference
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary_trace_eq_reference
#check NumStability.ReturnedRiemannDraft.Witness.stationary_reference_error_le
#print axioms NumStability.ReturnedRiemannDraft.Witness.stationary_reference_error_le
#check NumStability.ReturnedRiemannDraft.Witness.nonexact_instance
#print axioms NumStability.ReturnedRiemannDraft.Witness.nonexact_instance
#check NumStability.norm_oneDimensionalCellAverage_sub_le
#print axioms NumStability.norm_oneDimensionalCellAverage_sub_le
#check NumStability.riemannFiniteVolumeUpdate_error_le
#print axioms NumStability.riemannFiniteVolumeUpdate_error_le
#check NumStability.rectangleRiemannInterfaceFlux_error_le
#print axioms NumStability.rectangleRiemannInterfaceFlux_error_le
#check NumStability.riemannData_isRiemannData
#print axioms NumStability.riemannData_isRiemannData
#check NumStability.riemannData_intervalIntegrable
#print axioms NumStability.riemannData_intervalIntegrable
#check NumStability.travelingWave_isRectangleConservationLawSolution
#print axioms NumStability.travelingWave_isRectangleConservationLawSolution
#check NumStability.linearHyperbolicConservationLaw
#print axioms NumStability.linearHyperbolicConservationLaw
#check Matrix.one_mulVec
#print axioms Matrix.one_mulVec
#check intervalIntegral.integral_const
#print axioms intervalIntegral.integral_const


namespace NumStability.ReturnedFieldPlacementChecks

open ReturnedRiemannDraft

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

-- The two structures are nominally distinct. Both conversions preserve every
-- field explicitly, including all-real trace integrability and proof fields.
def toDraft (method : RiemannFieldFluxMethod law Result Information) :
    ReturnedRiemannDraft.FieldFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  field := method.field
  initial := method.initial
  trace_integrable := method.trace_integrable
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

def fromDraft (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) :
    RiemannFieldFluxMethod law Result Information where
  domain := method.domain
  solve := method.solve
  field := method.field
  initial := method.initial
  trace_integrable := method.trace_integrable
  extract := method.extract
  numericalFlux := method.numericalFlux
  constants_in_domain := method.constants_in_domain
  consistent := method.consistent

theorem fromDraft_toDraft (method : RiemannFieldFluxMethod law Result Information) :
    fromDraft (toDraft method) = method := by cases method; rfl

theorem toDraft_fromDraft (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) :
    toDraft (fromDraft method) = method := by cases method; rfl

def methodEquiv : RiemannFieldFluxMethod law Result Information ≃
    ReturnedRiemannDraft.FieldFluxMethod law Result Information where
  toFun := toDraft
  invFun := fromDraft
  left_inv := fromDraft_toDraft
  right_inv := toDraft_fromDraft

theorem toDraft_domain (method : RiemannFieldFluxMethod law Result Information) :
    (toDraft method).domain = method.domain := rfl

theorem toDraft_solve (method : RiemannFieldFluxMethod law Result Information) (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (toDraft method).solve problem h = method.solve problem h := rfl

theorem toDraft_field (method : RiemannFieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) (x t : ℝ) :
    (toDraft method).field result x t = method.field result x t := rfl

theorem toDraft_initial (method : RiemannFieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) :
    (toDraft method).initial result = method.initial result := rfl

theorem toDraft_trace_integrable (method : RiemannFieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) (s t : ℝ) :
    (toDraft method).trace_integrable result s t = method.trace_integrable result s t := rfl

theorem toDraft_extract (method : RiemannFieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) :
    (toDraft method).extract result = method.extract result := rfl

theorem toDraft_numericalFlux (method : RiemannFieldFluxMethod law Result Information) (info : Information) :
    (toDraft method).numericalFlux info = method.numericalFlux info := rfl

theorem toDraft_constants_in_domain (method : RiemannFieldFluxMethod law Result Information) (state : Fin m → ℝ) :
    (toDraft method).constants_in_domain state = method.constants_in_domain state := rfl

theorem toDraft_consistent (method : RiemannFieldFluxMethod law Result Information) (state : Fin m → ℝ) :
    (toDraft method).consistent state = method.consistent state := rfl

theorem fromDraft_domain (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) :
    (fromDraft method).domain = method.domain := rfl

theorem fromDraft_solve (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (fromDraft method).solve problem h = method.solve problem h := rfl

theorem fromDraft_field (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) (x t : ℝ) :
    (fromDraft method).field result x t = method.field result x t := rfl

theorem fromDraft_initial (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) :
    (fromDraft method).initial result = method.initial result := rfl

theorem fromDraft_trace_integrable (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) (s t : ℝ) :
    (fromDraft method).trace_integrable result s t = method.trace_integrable result s t := rfl

theorem fromDraft_extract (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) {problem : HyperbolicRiemannProblem law} (result : Result problem) :
    (fromDraft method).extract result = method.extract result := rfl

theorem fromDraft_numericalFlux (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) (info : Information) :
    (fromDraft method).numericalFlux info = method.numericalFlux info := rfl

theorem fromDraft_constants_in_domain (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) (state : Fin m → ℝ) :
    (fromDraft method).constants_in_domain state = method.constants_in_domain state := rfl

theorem fromDraft_consistent (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information) (state : Fin m → ℝ) :
    (fromDraft method).consistent state = method.consistent state := rfl

theorem toDraft_interfaceFlux (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    ReturnedRiemannDraft.interfaceFlux (toDraft method) old hdomain j =
      RiemannFieldFluxMethod.interfaceFlux method old hdomain j := rfl

theorem fromDraft_interfaceFlux (method : ReturnedRiemannDraft.FieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    RiemannFieldFluxMethod.interfaceFlux (fromDraft method) old hdomain j =
      ReturnedRiemannDraft.interfaceFlux method old hdomain j := rfl

theorem toDraft_ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    toDraft (RiemannFieldFluxMethod.ofExact method) = ReturnedRiemannDraft.ofExact method := rfl

theorem fromDraft_ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    fromDraft (ReturnedRiemannDraft.ofExact method) = RiemannFieldFluxMethod.ofExact method := rfl

theorem ofExact_returnedField_commutes
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (problem : HyperbolicRiemannProblem law) (h : method.domain problem) :
    (toDraft (RiemannFieldFluxMethod.ofExact method)).field
      ((toDraft (RiemannFieldFluxMethod.ofExact method)).solve problem h) =
        (method.solve problem h).solution := rfl

theorem interface_error_le_fromDraft (grid : OneDimensionalFiniteVolumeGrid)
    (method : FieldFluxMethod law Result Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt a b : ℝ} (hdt : 0 < dt) (j : ℤ)
    (hn : ∀ τ ∈ Set.uIoc 0 dt, ‖interfaceFlux method old hdomain j -
      law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ)‖ ≤ a)
    (he : ∀ τ ∈ Set.uIoc 0 dt, ‖law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ) -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b) :
    ‖interfaceFlux method old hdomain j -
      timeAveragedPhysicalFaceFlux grid q law.physicalFlux 0 dt j‖ ≤ a + b :=
  RiemannFieldFluxMethod.interface_error_le grid (fromDraft method) hq old hdomain hdt j hn he

theorem interface_error_le_type_comparison :
    @interface_error_le_fromDraft = @ReturnedRiemannDraft.interface_error_le := rfl

theorem update_error_le_fromDraft (grid : OneDimensionalFiniteVolumeGrid)
    (method : FieldFluxMethod law Result Information)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q law.physicalFlux)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ) (a b : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (hn : ∀ j τ, τ ∈ Set.uIoc 0 dt → ‖interfaceFlux method old hdomain j -
      law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ)‖ ≤ a j)
    (he : ∀ j τ, τ ∈ Set.uIoc 0 dt → ‖law.physicalFlux (method.field
        (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)) 0 τ) -
      law.physicalFlux (q (grid.cellLeft j) τ)‖ ≤ b j) :
    ‖riemannFiniteVolumeUpdate grid dt old (interfaceFlux method old hdomain) i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i * ((a i + b i) + (a (i + 1) + b (i + 1))) :=
  RiemannFieldFluxMethod.update_error_le grid (fromDraft method) hq old hdomain hdt i a b hold hn he

theorem update_error_le_type_comparison :
    @update_error_le_fromDraft = @ReturnedRiemannDraft.update_error_le := rfl

theorem stationary_method_commutes :
    toDraft (StationaryRiemannField.method (m := m)) =
      ReturnedRiemannDraft.Witness.method (m := m) := rfl

-- Here the types themselves are definitionally equal (concrete method
-- projections reduce); equality of theorem values additionally uses Lean's
-- proof irrelevance. This is not a claim of nominal structure identity.
theorem identity_01 : @NumStability.ReturnedRiemannDraft.ofExact_interfaceFlux = @NumStability.RiemannFieldFluxMethod.ofExact_interfaceFlux := rfl

theorem identity_02 : @NumStability.ReturnedRiemannDraft.ofExact_returnedField = @NumStability.RiemannFieldFluxMethod.ofExact_returnedField := rfl

theorem identity_03 : @NumStability.ReturnedRiemannDraft.flux_error_of_trace = @NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace := rfl

theorem identity_04 : @NumStability.ReturnedRiemannDraft.Witness.transportLaw = @NumStability.StationaryRiemannField.transportLaw := rfl

theorem identity_05 : @NumStability.ReturnedRiemannDraft.Witness.physicalFlux = @NumStability.StationaryRiemannField.physicalFlux := rfl

theorem identity_06 : @NumStability.ReturnedRiemannDraft.Witness.stationary = @NumStability.StationaryRiemannField.stationary := rfl

theorem identity_07 : @NumStability.ReturnedRiemannDraft.Witness.stationary_initial = @NumStability.StationaryRiemannField.stationary_initial := rfl

theorem identity_08 : @NumStability.ReturnedRiemannDraft.Witness.stationary_trace_integrable = @NumStability.StationaryRiemannField.stationary_trace_integrable := rfl

theorem identity_09 : @NumStability.ReturnedRiemannDraft.Witness.StationaryResult = @NumStability.StationaryRiemannField.StationaryResult := rfl

theorem identity_10 : @NumStability.ReturnedRiemannDraft.Witness.reference = @NumStability.StationaryRiemannField.reference := rfl

theorem identity_11 : @NumStability.ReturnedRiemannDraft.Witness.reference_rectangle = @NumStability.StationaryRiemannField.reference_rectangle := rfl

theorem identity_12 : @NumStability.ReturnedRiemannDraft.Witness.reference_initial = @NumStability.StationaryRiemannField.reference_initial := rfl

theorem identity_13 : @NumStability.ReturnedRiemannDraft.Witness.stationary_not_rectangle = @NumStability.StationaryRiemannField.stationary_not_rectangle := rfl

theorem identity_14 : @NumStability.ReturnedRiemannDraft.Witness.method_flux_eq_returned_trace = @NumStability.StationaryRiemannField.method_flux_eq_returned_trace := rfl

theorem identity_15 : @NumStability.ReturnedRiemannDraft.Witness.stationary_trace_eq_reference = @NumStability.StationaryRiemannField.stationary_trace_eq_reference := rfl

theorem identity_16 : @NumStability.ReturnedRiemannDraft.Witness.stationary_reference_error_le = @NumStability.StationaryRiemannField.stationary_reference_error_le := rfl

theorem identity_17 : @NumStability.ReturnedRiemannDraft.Witness.nonexact_instance = @NumStability.StationaryRiemannField.nonexact_instance := rfl

end NumStability.ReturnedFieldPlacementChecks

#check NumStability.ReturnedFieldPlacementChecks.toDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft
#check NumStability.ReturnedFieldPlacementChecks.fromDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_toDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_toDraft
#check NumStability.ReturnedFieldPlacementChecks.toDraft_fromDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_fromDraft
#check NumStability.ReturnedFieldPlacementChecks.methodEquiv
#print axioms NumStability.ReturnedFieldPlacementChecks.methodEquiv
#check NumStability.ReturnedFieldPlacementChecks.toDraft_domain
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_domain
#check NumStability.ReturnedFieldPlacementChecks.toDraft_solve
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_solve
#check NumStability.ReturnedFieldPlacementChecks.toDraft_field
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_field
#check NumStability.ReturnedFieldPlacementChecks.toDraft_initial
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_initial
#check NumStability.ReturnedFieldPlacementChecks.toDraft_trace_integrable
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_trace_integrable
#check NumStability.ReturnedFieldPlacementChecks.toDraft_extract
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_extract
#check NumStability.ReturnedFieldPlacementChecks.toDraft_numericalFlux
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_numericalFlux
#check NumStability.ReturnedFieldPlacementChecks.toDraft_constants_in_domain
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_constants_in_domain
#check NumStability.ReturnedFieldPlacementChecks.toDraft_consistent
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_consistent
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_domain
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_domain
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_solve
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_solve
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_field
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_field
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_initial
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_initial
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_trace_integrable
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_trace_integrable
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_extract
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_extract
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_numericalFlux
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_numericalFlux
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_constants_in_domain
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_constants_in_domain
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_consistent
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_consistent
#check NumStability.ReturnedFieldPlacementChecks.toDraft_interfaceFlux
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_interfaceFlux
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_interfaceFlux
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_interfaceFlux
#check NumStability.ReturnedFieldPlacementChecks.toDraft_ofExact
#print axioms NumStability.ReturnedFieldPlacementChecks.toDraft_ofExact
#check NumStability.ReturnedFieldPlacementChecks.fromDraft_ofExact
#print axioms NumStability.ReturnedFieldPlacementChecks.fromDraft_ofExact
#check NumStability.ReturnedFieldPlacementChecks.ofExact_returnedField_commutes
#print axioms NumStability.ReturnedFieldPlacementChecks.ofExact_returnedField_commutes
#check NumStability.ReturnedFieldPlacementChecks.interface_error_le_fromDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.interface_error_le_fromDraft
#check NumStability.ReturnedFieldPlacementChecks.interface_error_le_type_comparison
#print axioms NumStability.ReturnedFieldPlacementChecks.interface_error_le_type_comparison
#check NumStability.ReturnedFieldPlacementChecks.update_error_le_fromDraft
#print axioms NumStability.ReturnedFieldPlacementChecks.update_error_le_fromDraft
#check NumStability.ReturnedFieldPlacementChecks.update_error_le_type_comparison
#print axioms NumStability.ReturnedFieldPlacementChecks.update_error_le_type_comparison
#check NumStability.ReturnedFieldPlacementChecks.stationary_method_commutes
#print axioms NumStability.ReturnedFieldPlacementChecks.stationary_method_commutes
#check NumStability.ReturnedFieldPlacementChecks.identity_01
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_01
#check NumStability.ReturnedFieldPlacementChecks.identity_02
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_02
#check NumStability.ReturnedFieldPlacementChecks.identity_03
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_03
#check NumStability.ReturnedFieldPlacementChecks.identity_04
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_04
#check NumStability.ReturnedFieldPlacementChecks.identity_05
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_05
#check NumStability.ReturnedFieldPlacementChecks.identity_06
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_06
#check NumStability.ReturnedFieldPlacementChecks.identity_07
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_07
#check NumStability.ReturnedFieldPlacementChecks.identity_08
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_08
#check NumStability.ReturnedFieldPlacementChecks.identity_09
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_09
#check NumStability.ReturnedFieldPlacementChecks.identity_10
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_10
#check NumStability.ReturnedFieldPlacementChecks.identity_11
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_11
#check NumStability.ReturnedFieldPlacementChecks.identity_12
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_12
#check NumStability.ReturnedFieldPlacementChecks.identity_13
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_13
#check NumStability.ReturnedFieldPlacementChecks.identity_14
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_14
#check NumStability.ReturnedFieldPlacementChecks.identity_15
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_15
#check NumStability.ReturnedFieldPlacementChecks.identity_16
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_16
#check NumStability.ReturnedFieldPlacementChecks.identity_17
#print axioms NumStability.ReturnedFieldPlacementChecks.identity_17

#check NumStability.RiemannFieldFluxMethod
#print axioms NumStability.RiemannFieldFluxMethod
#check NumStability.RiemannFieldFluxMethod.interfaceFlux
#print axioms NumStability.RiemannFieldFluxMethod.interfaceFlux
#check NumStability.RiemannFieldFluxMethod.ofExact
#print axioms NumStability.RiemannFieldFluxMethod.ofExact
#check NumStability.RiemannFieldFluxMethod.ofExact_interfaceFlux
#print axioms NumStability.RiemannFieldFluxMethod.ofExact_interfaceFlux
#check NumStability.RiemannFieldFluxMethod.ofExact_returnedField
#print axioms NumStability.RiemannFieldFluxMethod.ofExact_returnedField
#check NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace
#print axioms NumStability.norm_sub_oneDimensionalCellAverage_le_of_trace
#check NumStability.RiemannFieldFluxMethod.interface_error_le
#print axioms NumStability.RiemannFieldFluxMethod.interface_error_le
#check NumStability.RiemannFieldFluxMethod.update_error_le
#print axioms NumStability.RiemannFieldFluxMethod.update_error_le
#check NumStability.StationaryRiemannField.transportLaw
#print axioms NumStability.StationaryRiemannField.transportLaw
#check NumStability.StationaryRiemannField.physicalFlux
#print axioms NumStability.StationaryRiemannField.physicalFlux
#check NumStability.StationaryRiemannField.stationary
#print axioms NumStability.StationaryRiemannField.stationary
#check NumStability.StationaryRiemannField.stationary_initial
#print axioms NumStability.StationaryRiemannField.stationary_initial
#check NumStability.StationaryRiemannField.stationary_trace_integrable
#print axioms NumStability.StationaryRiemannField.stationary_trace_integrable
#check NumStability.StationaryRiemannField.StationaryResult
#print axioms NumStability.StationaryRiemannField.StationaryResult
#check NumStability.StationaryRiemannField.method
#print axioms NumStability.StationaryRiemannField.method
#check NumStability.StationaryRiemannField.reference
#print axioms NumStability.StationaryRiemannField.reference
#check NumStability.StationaryRiemannField.reference_rectangle
#print axioms NumStability.StationaryRiemannField.reference_rectangle
#check NumStability.StationaryRiemannField.reference_initial
#print axioms NumStability.StationaryRiemannField.reference_initial
#check NumStability.StationaryRiemannField.stationary_not_rectangle
#print axioms NumStability.StationaryRiemannField.stationary_not_rectangle
#check NumStability.StationaryRiemannField.method_flux_eq_returned_trace
#print axioms NumStability.StationaryRiemannField.method_flux_eq_returned_trace
#check NumStability.StationaryRiemannField.stationary_trace_eq_reference
#print axioms NumStability.StationaryRiemannField.stationary_trace_eq_reference
#check NumStability.StationaryRiemannField.stationary_reference_error_le
#print axioms NumStability.StationaryRiemannField.stationary_reference_error_le
#check NumStability.StationaryRiemannField.nonexact_instance
#print axioms NumStability.StationaryRiemannField.nonexact_instance
