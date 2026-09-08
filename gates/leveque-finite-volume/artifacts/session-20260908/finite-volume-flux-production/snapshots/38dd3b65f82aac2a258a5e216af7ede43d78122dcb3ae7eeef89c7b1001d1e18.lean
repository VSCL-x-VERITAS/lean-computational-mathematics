/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRectangleRiemannInterface
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds

/-!
# Physical flux averages of selected linear Riemann solves

The actual selected linear method yields the physical flux of its own
positive-time interface trace, for unequal as well as equal states.
Comparison with an independent global field requires a trace-error bound.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability

variable {m : ℕ}

/-- The selected method output is the physical flux of its returned solution at positive times. -/
theorem linearRectangleRiemannInterfaceFluxMethod_flux_eq_physicalTrace (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {τ : ℝ} (hτ : 0 < τ) :
    (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).numericalFluxFromInformation
      ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).extractInformation
        ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial)) =
      A.mulVec (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial).solution 0 τ) :=
  congrArg A.mulVec
    (linearRectangleRiemannInterfaceFluxMethod_information A hA basis speeds heigen problem hτ)

/-- The numerical flux is exactly the physical time-average of the selected solver on ray zero. -/
theorem linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage (A : Matrix (Fin m) (Fin m) ℝ)
    (hA : IsRealHyperbolicMatrix A) (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    (problem : HyperbolicRiemannProblem (linearHyperbolicConservationLaw A hA))
    {dt : ℝ} (hdt : 0 < dt) :
    (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).numericalFluxFromInformation
      ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).extractInformation
        ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial)) =
      oneDimensionalCellAverage
        (fun τ => A.mulVec (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial).solution 0 τ))
        0 dt := by
  have hint : (∫ τ in (0 : ℝ)..dt,
      A.mulVec (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial).solution 0 τ)) =
      ∫ _ in (0 : ℝ)..dt, (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).numericalFluxFromInformation
      ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).extractInformation
        ((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve problem trivial)) := by
    apply intervalIntegral.integral_congr_ae
    exact Filter.Eventually.of_forall (fun τ hτ =>
      (linearRectangleRiemannInterfaceFluxMethod_flux_eq_physicalTrace A hA basis speeds heigen problem
        (by simpa only [min_eq_left hdt.le] using hτ.1)).symm)
  rw [oneDimensionalCellAverage, hint, intervalIntegral.integral_const]
  simp [smul_smul, hdt.ne']

/-- A local-solver/global-field trace-error bound controls the averaged numerical-flux error. -/
theorem linearRectangleRiemannInterfaceFlux_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt bound : ℝ} (hdt : 0 < dt) (j : ℤ)
    (htrace : ∀ τ ∈ Set.uIoc 0 dt,
      ‖A.mulVec (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j) trivial).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ bound) :
    ‖rectangleRiemannInterfaceFlux (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen) old (fun _ => trivial) j -
      timeAveragedPhysicalFaceFlux grid q A.mulVec 0 dt j‖ ≤ bound := by
  unfold rectangleRiemannInterfaceFlux adjacentCellRectangleRiemannInformation
    timeAveragedPhysicalFaceFlux
  rw [linearRectangleRiemannInterfaceFluxMethod_flux_eq_timeAverage A hA basis speeds heigen _ hdt]
  exact norm_oneDimensionalCellAverage_sub_le hdt
    (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve _ trivial).solves.2.2.1 _ _ _)
    (hq.2.1 _ _ _) htrace

/-- Old numerical error and justified solver-trace errors imply a next-step cell-error bound. -/
theorem linearRectangleRiemannInterfaceFlux_update_error_le (grid : OneDimensionalFiniteVolumeGrid)
    (A : Matrix (Fin m) (Fin m) ℝ) (hA : IsRealHyperbolicMatrix A)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, A.mulVec (basis p) = speeds p • basis p)
    {q : ℝ → ℝ → (Fin m → ℝ)} (hq : IsRectangleConservationLawSolution q A.mulVec)
    (old : ℤ → (Fin m → ℝ)) {dt oldBound : ℝ} (hdt : 0 < dt) (i : ℤ)
    (faceBound : ℤ → ℝ)
    (hold : ‖old i - finiteVolumeCellAverageOn grid (fun x => q x 0) i‖ ≤ oldBound)
    (htrace : ∀ j τ, τ ∈ Set.uIoc 0 dt →
      ‖A.mulVec (((linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen).solve
        (adjacentCellRiemannProblem (linearHyperbolicConservationLaw A hA) old j) trivial).solution 0 τ) -
        A.mulVec (q (grid.cellLeft j) τ)‖ ≤ faceBound j) :
    ‖riemannFiniteVolumeUpdate grid dt old
      (rectangleRiemannInterfaceFlux (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen) old (fun _ => trivial)) i -
      finiteVolumeCellAverageOn grid (fun x => q x dt) i‖ ≤
      oldBound + dt / grid.cellVolume i * (faceBound i + faceBound (i + 1)) := by
  simpa using riemannFiniteVolumeUpdate_error_le grid hq (fun _ _ data => rectangleRiemannInterfaceFlux (linearRectangleRiemannInterfaceFluxMethod A hA basis speeds heigen) data (fun _ => trivial))
    hdt old i hold
    (linearRectangleRiemannInterfaceFlux_error_le grid A hA basis speeds heigen hq old hdt i (htrace i))
    (linearRectangleRiemannInterfaceFlux_error_le grid A hA basis speeds heigen hq old hdt (i + 1) (htrace (i + 1)))

end NumStability
