/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageTraceEstimate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannInformationFluxMethod

/-!
# Conditional errors for information-returning Riemann routines

An optional flux trace of the selected result requires integrability only on
the chosen finite step. Extraction and physical-reference errors imply face
and cell-update bounds; only the two used faces carry update hypotheses.
-/

open MeasureTheory

namespace NumStability.RiemannInformationFluxMethod

variable {m : ℕ} {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
variable {Result : HyperbolicRiemannProblem law → Type*} {Information : Type*}

theorem interface_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (method : RiemannInformationFluxMethod law Result Information) (old : ℤ → Fin m → ℝ)
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
    (method : RiemannInformationFluxMethod law Result Information) (old : ℤ → Fin m → ℝ)
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

end NumStability.RiemannInformationFluxMethod
