/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInterface

/-!
# Riemann routines returning information

A routine on an explicit problem domain returns a dependent result, extracts
information and computes a constant-consistent flux. No returned field or PDE
certificate is required. Consistency alone does not assert physical accuracy.
-/

namespace NumStability

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}

/-- A Riemann-interface method on an explicit problem domain whose solver returns a
dependent result from which flux information is extracted. Unlike `RiemannFieldFluxMethod`,
no space-time field or PDE certificate is required of a result; consistency on constant
states is the only physical qualification, and it asserts no accuracy on other problems. -/
structure RiemannInformationFluxMethod (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (Result : HyperbolicRiemannProblem law → Type*) (Information : Type*) where
  /-- The ordered Riemann problems the method is able to solve. `constants_in_domain`
  guarantees that every constant-state problem belongs to it. -/
  domain : HyperbolicRiemannProblem law → Prop
  /-- Solve an ordered Riemann problem, given evidence that it lies in the method domain,
  returning the method's own result type for that problem. -/
  solve : (problem : HyperbolicRiemannProblem law) → domain problem → Result problem
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

namespace RiemannInformationFluxMethod

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- The solver result selected at interface `j`: the method's solve of the ordered
adjacent-cell Riemann problem from cell `j - 1` to cell `j` of the array `old`, using the
supplied admissibility evidence `hdomain j`. -/
def selectedResult (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Result (adjacentCellRiemannProblem law old j) :=
  method.solve (adjacentCellRiemannProblem law old j) (hdomain j)

/-- The numerical flux at interface `j`, obtained by extracting information from the
selected result of the ordered adjacent-cell problem and converting it to a flux vector.
Admissibility is only required for the array `old`. -/
def interfaceFlux (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Fin m → ℝ :=
  method.numericalFlux (method.extract (selectedResult method old hdomain j))

/-- The ordered input and information belong to this selected result. No
physical solution, returned field or accuracy property is concluded. -/
theorem interface_execution (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    let problem := adjacentCellRiemannProblem law old j
    let result := method.solve problem (hdomain j)
    problem.leftState = old (j - 1) ∧ problem.rightState = old j ∧
    selectedResult method old hdomain j = result ∧
    interfaceFlux method old hdomain j = method.numericalFlux (method.extract result) :=
  ⟨rfl, rfl, rfl, rfl⟩

theorem interfaceFlux_constant (method : RiemannInformationFluxMethod law Result Information) (state : Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law (fun _ => state) j)) (j : ℤ) :
    interfaceFlux method (fun _ => state) hdomain j = law.physicalFlux state := by
  exact method.consistent state

end RiemannInformationFluxMethod
end NumStability
