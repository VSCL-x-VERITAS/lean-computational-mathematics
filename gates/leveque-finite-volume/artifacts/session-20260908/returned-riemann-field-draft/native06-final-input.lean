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
