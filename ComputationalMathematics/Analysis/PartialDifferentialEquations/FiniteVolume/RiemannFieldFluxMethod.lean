/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RectangleRiemannInterface

/-!
# Methods returning Riemann fields

The selected result supplies both the returned field and extracted information.
Fields have the ordered initial data and integrable physical interface traces
on every finite real time interval. Exact conservation is not required.
-/

open MeasureTheory

namespace NumStability

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

/-- A field-producing method on an explicit domain. Its result may also contain
wave information or an exact certificate, but no exact certificate is required. -/
structure RiemannFieldFluxMethod
    (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  /-- The ordered Riemann problems the method is able to solve. `constants_in_domain`
  guarantees that every constant-state problem belongs to it. -/
  domain : HyperbolicRiemannProblem law → Prop
  /-- Solve an ordered Riemann problem, given evidence that it lies in the method domain,
  returning the method's own result type for that problem. -/
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
  /-- The space-time field `x ↦ t ↦ state` read off a result; `initial` certifies its
  ordered Riemann initial trace and `trace_integrable` the integrability of its
  interface flux trace at `x = 0` over every finite time interval. -/
  field : {problem : HyperbolicRiemannProblem law} → Result problem → ℝ → ℝ → (Fin m → ℝ)
  initial : ∀ {problem} (result : Result problem),
    IsRiemannData (fun x => field result x 0) problem.leftState problem.rightState
  trace_integrable : ∀ {problem} (result : Result problem) (s t : ℝ),
    IntervalIntegrable (fun τ => law.physicalFlux (field result 0 τ)) volume s t
  /-- Extract the method-specific information used to form an interface flux from a
  result of the solver. -/
  extract : {problem : HyperbolicRiemannProblem law} → Result problem → Information
  /-- Convert extracted Riemann information into a numerical flux vector. -/
  numericalFlux : Information → (Fin m → ℝ)
  constants_in_domain : ∀ state,
    domain ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
  consistent : ∀ state, numericalFlux (extract (solve
    ({ leftState := state, rightState := state } : HyperbolicRiemannProblem law)
    (constants_in_domain state))) = law.physicalFlux state

namespace RiemannFieldFluxMethod

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- Information and flux are extracted from the selected solve of the actual
ordered adjacent-cell problem. Admissibility is only required for this array. -/
def interfaceFlux (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → (Fin m → ℝ))
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j))
    (j : ℤ) : Fin m → ℝ :=
  method.numericalFlux (method.extract
    (method.solve (adjacentCellRiemannProblem law old j) (hdomain j)))

/-- The exact method is a special case, retaining its original result and extractor. -/
def ofExact (method : RectangleRiemannInterfaceFluxMethod law Information) :
    RiemannFieldFluxMethod law (CertifiedRectangleRiemannSolution law) Information where
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

end RiemannFieldFluxMethod
end NumStability
