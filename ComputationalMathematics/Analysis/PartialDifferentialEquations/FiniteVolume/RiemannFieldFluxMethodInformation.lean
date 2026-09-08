/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod

/-!
# Information interface of a field-returning Riemann method

The adapter preserves the original dependent result, solve function, extractor
and flux. A finite-interval trace fact can be recovered separately from the
stronger field method; it is not an information-interface obligation.
-/

open MeasureTheory

namespace NumStability.RiemannInformationFluxMethod

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- Forget the extra field obligations while retaining the original result,
solve function, extractor, flux map, domain and consistency proof. -/
def ofField (method : RiemannFieldFluxMethod law Result Information) :
    RiemannInformationFluxMethod law Result Information where
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
particular requested finite interval. They are not part of `RiemannInformationFluxMethod`. -/
theorem ofField_finite_trace_integrable
    (method : RiemannFieldFluxMethod law Result Information)
    (old : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law old j)) (j : ℤ) (s t : ℝ) :
    IntervalIntegrable (fun τ => law.physicalFlux
      (method.field (selectedResult (ofField method) old hdomain j) 0 τ)) volume s t :=
  method.trace_integrable _ s t

end NumStability.RiemannInformationFluxMethod
