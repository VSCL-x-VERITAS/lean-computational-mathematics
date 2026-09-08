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

structure RiemannInformationFluxMethod (law : OneDimensionalHyperbolicConservationLaw (Fin m))
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

namespace RiemannInformationFluxMethod

variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

def selectedResult (method : RiemannInformationFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) :
    Result (adjacentCellRiemannProblem law old j) :=
  method.solve (adjacentCellRiemannProblem law old j) (hdomain j)

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
