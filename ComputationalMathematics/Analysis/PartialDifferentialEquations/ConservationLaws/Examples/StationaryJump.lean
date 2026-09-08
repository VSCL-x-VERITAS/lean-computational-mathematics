/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump

/-!
# Stationary jumps with constant flux

The conservative residual differentiates temporal state and spatial flux.
A stationary jump with constant flux can therefore satisfy this residual and
rectangle balance while its spatial state is discontinuous.
-/

open MeasureTheory

namespace NumStability

variable {ι : Type*} [Fintype ι]

/-- A stationary state with constant flux satisfies the conservative residual
even when the spatial profile is discontinuous. -/
theorem stationaryField_constantFlux_residual
    (profile : ℝ → ι → ℝ) (fluxValue : ι → ℝ) (x t : ℝ) :
    IsConservationLawSolutionAt (fun ξ _ => profile ξ) (fun _ => fluxValue) x t := by
  refine ⟨0, 0, hasDerivAt_const t (profile x), hasDerivAt_const x fluxValue, ?_⟩
  simp

/-- A discontinuous conserved vector state can satisfy the existing conservative
residual, because that predicate does not require a spatial state derivative. -/
theorem discontinuous_stationary_conservative_residual
    (left valueAtJump right : ι → ℝ) (hne : left ≠ right) :
    IsRectangleConservationLawSolution
      (fun x _ => riemannData left valueAtJump right x) (fun _ => 0) ∧
    (∀ x t, IsConservationLawSolutionAt
      (fun ξ _ => riemannData left valueAtJump right ξ) (fun _ => 0) x t) ∧
    (¬ ContinuousAt (riemannData left valueAtJump right) 0) := by
  refine ⟨?_, stationaryField_constantFlux_residual _ 0, ?_⟩
  · have hfield : travelingWave (riemannData left valueAtJump right) 0 =
        (fun x _ => riemannData left valueAtJump right x) := by
      funext x t
      simp only [travelingWave, zero_mul, sub_zero]
    simpa only [hfield, zero_smul] using
      travelingWave_isRectangleConservationLawSolution
        (riemannData left valueAtJump right)
        (riemannData_intervalIntegrable left valueAtJump right) 0
  · exact (riemannData_isRiemannData left valueAtJump right).not_continuousAt_zero hne

end NumStability
