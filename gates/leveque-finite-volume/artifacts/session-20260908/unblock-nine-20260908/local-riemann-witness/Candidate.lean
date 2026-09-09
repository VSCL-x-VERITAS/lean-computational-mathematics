import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRiemannInformation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateInformationFlux

open MeasureTheory NumStability

namespace LocalRiemannWitness
open LocalRiemannInformation

/-- Unit-speed scalar transport restricted to the proper state interval [0,1]. -/
noncomputable def law : Law 1 where
  positive_dimension := by decide
  states := {state | 0 ≤ state 0 ∧ state 0 ≤ 1}
  flux := StationaryRiemannField.transportLaw.physicalFlux
  hyperbolic := fun state _ => hyperbolicConservationLaw_isHyperbolicFluxAt _ state

theorem proper_states : (0 : Fin 1 → ℝ) ∈ law.states ∧
    (1 : Fin 1 → ℝ) ∈ law.states ∧ (2 : Fin 1 → ℝ) ∉ law.states := by
  norm_num [law]

def globalProblem (problem : Problem law) :
    HyperbolicRiemannProblem (StationaryRiemannField.transportLaw (m := 1)) :=
  ⟨problem.left, problem.right⟩

/-- Existing information-only output type: two values and their ordering facts. -/
abbrev Result (problem : Problem law) :=
  LeftStateInformationFlux.OrderedResult (globalProblem problem)

/-- Restriction of the existing actual transport solution to this problem's slab. -/
noncomputable def reference (problem : Problem law) : Reference problem where
  field := StationaryRiemannField.reference problem.left problem.right
  initial := StationaryRiemannField.reference_initial _ _
  admissible := by
    intro x τ _ _
    unfold StationaryRiemannField.reference travelingWave riemannData
    split_ifs <;> first | exact problem.left_mem | exact problem.right_mem
  spatial_integrable := fun a b τ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).1 a b τ
  face_integrable := fun x s t _ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).2.1 x s t
  rectangle := fun a b s t _ _ _ =>
    (StationaryRiemannField.reference_rectangle problem.left problem.right).2.2 a b s t

theorem reference_mean (problem : Problem law) : (reference problem).meanFlux = problem.left := by
  have h := LeftStateInformationFlux.selected_flux_eq_reference_average
    (globalProblem problem) problem.duration_pos
  simpa only [Reference.meanFlux, reference, globalProblem, LeftStateInformationFlux.method,
    StationaryRiemannField.physicalFlux, law] using h.symm

/-- A jump-dependent perturbation of the exact left-state flux. Only horizons
at most one are admitted; no result contains the physical reference field. -/
noncomputable def method (θ : ℝ) :
    Method law Result ((Fin 1 → ℝ) × (Fin 1 → ℝ)) where
  domain := fun problem => problem.duration ≤ 1
  solve := fun problem _ => (LeftStateInformationFlux.method
    StationaryRiemannField.transportLaw).solve (globalProblem problem) trivial
  extract := fun result => (result.left, result.right)
  numericalFlux := fun info => info.1 + θ • (info.2 - info.1)
  errorBound := fun problem => |θ| * ‖problem.right - problem.left‖
  accurate := by
    intro problem _
    refine ⟨reference problem, ?_⟩
    rw [reference_mean]
    change ‖problem.left + θ • (problem.right - problem.left) - problem.left‖ ≤ _
    simpa only [add_sub_cancel_left, norm_smul, Real.norm_eq_abs] using
      (le_rfl : |θ| * ‖problem.right - problem.left‖ ≤ _)
  consistent := by
    intro problem _ hequal
    change problem.left + θ • (problem.right - problem.left) =
      StationaryRiemannField.transportLaw.physicalFlux problem.left
    rw [← hequal]
    simp

theorem selected_values (θ : ℝ) (problem : Problem law) (h : (method θ).domain problem) :
    (method θ).extract ((method θ).solve problem h) = (problem.left, problem.right) := rfl

theorem selected_flux (θ : ℝ) (problem : Problem law) (h : (method θ).domain problem) :
    (method θ).flux problem h = problem.left + θ • (problem.right - problem.left) := rfl

theorem actual_error (θ : ℝ) (problem : Problem law) (h : (method θ).domain problem) :
    ‖(method θ).flux problem h - (reference problem).meanFlux‖ =
      (method θ).errorBound problem := by
  rw [selected_flux, reference_mean]
  simp only [add_sub_cancel_left, norm_smul, Real.norm_eq_abs, method]

def nonconstantProblem : Problem law where
  left := 0
  right := 1
  left_mem := proper_states.1
  right_mem := proper_states.2.1
  duration := 1
  duration_pos := by norm_num

theorem nonconstant_states : nonconstantProblem.left ≠ nonconstantProblem.right := by
  intro h
  have hzero := congrFun h (0 : Fin 1)
  norm_num [nonconstantProblem] at hzero

theorem exact_information_only :
    (method 0).domain nonconstantProblem ∧
    (method 0).extract ((method 0).solve nonconstantProblem (by norm_num [method, nonconstantProblem])) =
      (0, 1) ∧
    (method 0).flux nonconstantProblem (by norm_num [method, nonconstantProblem]) = 0 ∧
    (method 0).errorBound nonconstantProblem = 0 ∧
    ‖(method 0).flux nonconstantProblem (by norm_num [method, nonconstantProblem]) -
      (reference nonconstantProblem).meanFlux‖ = 0 := by
  simp [method, nonconstantProblem, Method.flux, globalProblem,
    LeftStateInformationFlux.method, reference_mean]

theorem approximate_information_only :
    (method (1 / 2)).domain nonconstantProblem ∧
    (method (1 / 2)).extract ((method (1 / 2)).solve nonconstantProblem
      (by norm_num [method, nonconstantProblem])) = (0, 1) ∧
    (method (1 / 2)).flux nonconstantProblem (by norm_num [method, nonconstantProblem]) =
      (fun _ => (1 / 2 : ℝ)) ∧
    (method (1 / 2)).errorBound nonconstantProblem = 1 / 2 ∧
    ‖(method (1 / 2)).flux nonconstantProblem (by norm_num [method, nonconstantProblem]) -
      (reference nonconstantProblem).meanFlux‖ = 1 / 2 := by
  simp [method, nonconstantProblem, Method.flux, globalProblem,
    LeftStateInformationFlux.method, reference_mean, Pi.one_def, Pi.smul_def, smul_eq_mul]

theorem approximate_is_nonexact :
    (method (1 / 2)).flux nonconstantProblem (by norm_num [method, nonconstantProblem]) ≠
      (reference nonconstantProblem).meanFlux := by
  intro h
  have herr := approximate_information_only.2.2.2.2
  rw [h, sub_self, norm_zero] at herr
  norm_num at herr

def longerProblem : Problem law := {nonconstantProblem with duration := 2, duration_pos := by norm_num}

theorem proper_method_domain (θ : ℝ) :
    (method θ).domain nonconstantProblem ∧ ¬ (method θ).domain longerProblem := by
  norm_num [method, nonconstantProblem, longerProblem]

end LocalRiemannWitness

#check LocalRiemannWitness.law
#print axioms LocalRiemannWitness.law
#check LocalRiemannWitness.globalProblem
#print axioms LocalRiemannWitness.globalProblem
#check LocalRiemannWitness.Result
#print axioms LocalRiemannWitness.Result
#check LocalRiemannWitness.nonconstantProblem
#print axioms LocalRiemannWitness.nonconstantProblem
#check LocalRiemannWitness.longerProblem
#print axioms LocalRiemannWitness.longerProblem
#check LocalRiemannWitness.proper_states
#print axioms LocalRiemannWitness.proper_states
#check LocalRiemannWitness.reference
#print axioms LocalRiemannWitness.reference
#check LocalRiemannWitness.reference_mean
#print axioms LocalRiemannWitness.reference_mean
#check LocalRiemannWitness.method
#print axioms LocalRiemannWitness.method
#check LocalRiemannWitness.selected_values
#print axioms LocalRiemannWitness.selected_values
#check LocalRiemannWitness.selected_flux
#print axioms LocalRiemannWitness.selected_flux
#check LocalRiemannWitness.actual_error
#print axioms LocalRiemannWitness.actual_error
#check LocalRiemannWitness.nonconstant_states
#print axioms LocalRiemannWitness.nonconstant_states
#check LocalRiemannWitness.exact_information_only
#print axioms LocalRiemannWitness.exact_information_only
#check LocalRiemannWitness.approximate_information_only
#print axioms LocalRiemannWitness.approximate_information_only
#check LocalRiemannWitness.approximate_is_nonexact
#print axioms LocalRiemannWitness.approximate_is_nonexact
#check LocalRiemannWitness.proper_method_domain
#print axioms LocalRiemannWitness.proper_method_domain
