/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageTraceEstimate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannFieldFluxMethod

/-!
# Conditional errors for returned Riemann fields

Extraction and returned-field trace errors are independent hypotheses.
The resulting interface bound feeds the existing conservative update estimate.
-/

open MeasureTheory

namespace NumStability.RiemannFieldFluxMethod

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

/-- Extraction error and returned-field/global-field trace error imply a physical
face-flux error bound. Both errors are hypotheses, not certified accuracy claims. -/
theorem interface_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannFieldFluxMethod law Result Information)
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
  norm_sub_oneDimensionalCellAverage_le_of_trace hdt (method.trace_integrable _ 0 dt) (hq.2.1 _ _ _) hn he

/-- Error propagation uses the existing physical conservation/update estimate.
The rule is fixed only on the given admitted array; no other admission is inferred. -/
theorem update_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannFieldFluxMethod law Result Information)
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

end NumStability.RiemannFieldFluxMethod
