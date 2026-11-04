/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity

/-!
# A researched whole-line constant-diffusion dependence target

LeVeque's explicit scalar heat model is supplemented by the bounded continuous
Cauchy construction in Stanford Math220B Theorem 9. The every-neighborhood
meaning of influence and the named canonical solution are recorded researched
conventions. This does not close the broader generic parabolic prose or assert
unrestricted uniqueness. This module contains only the proof-free proposition.
-/

namespace NumStability

open Filter MeasureTheory
open scoped Topology ContDiff

/-- Full Cauchy realization for every bounded continuous profile, and localized
smooth witnesses proving that every initial location is essential at every
positive-time observation for the actual Gaussian convolution. -/
def Leveque04HeatWholeLineDependenceTarget : Prop :=
  ∀ diffusion : ℝ, 0 < diffusion →
    (∀ initial : BoundedContinuousFunction ℝ ℝ,
      (∀ space : ℝ, gaussianHeatFlow diffusion initial space 0 = initial space) ∧
      ContDiffOn ℝ ∞
        (fun point : ℝ × ℝ => gaussianHeatFlow diffusion initial point.1 point.2)
        {point : ℝ × ℝ | 0 < point.2} ∧
      (∀ origin : ℝ,
        Tendsto
          (fun point : ℝ × ℝ => gaussianHeatFlow diffusion initial point.1 point.2)
          (nhdsWithin (origin, 0) {point : ℝ × ℝ | 0 < point.2})
          (𝓝 (initial origin))) ∧
      ∀ space time : ℝ, 0 < time →
        Integrable (fun location : ℝ =>
          gaussianHeatKernel diffusion time (space - location) * initial location) ∧
        |gaussianHeatFlow diffusion initial space time| ≤ ‖initial‖ ∧
        DifferentiableAt ℝ (fun τ : ℝ => gaussianHeatFlow diffusion initial space τ) time ∧
        DifferentiableAt ℝ (fun z : ℝ => gaussianHeatFlow diffusion initial z time) space ∧
        DifferentiableAt ℝ
          (deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time)) space ∧
        deriv (fun τ : ℝ => gaussianHeatFlow diffusion initial space τ) time =
          diffusion * deriv (deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time))
            space) ∧
    (∀ observation time location radius : ℝ, 0 < time → 0 < radius →
      ∃ profile : BoundedContinuousFunction ℝ ℝ,
        ContDiff ℝ ∞ (profile : ℝ → ℝ) ∧
        HasCompactSupport (profile : ℝ → ℝ) ∧
        (∀ z : ℝ, 0 ≤ profile z ∧ profile z ≤ 1) ∧
        profile location = 1 ∧
        tsupport (profile : ℝ → ℝ) ⊆ Metric.ball location radius ∧
        gaussianHeatFlow diffusion (fun _ : ℝ => 0) observation time = 0 ∧
        0 < gaussianHeatFlow diffusion profile observation time) ∧
    ∀ observation time : ℝ, 0 < time →
      {location : ℝ | IsEssentialPointOnClass IsBoundedContinuousHeatData
        (fun initial : ℝ → ℝ => gaussianHeatFlow diffusion initial observation time)
        location} = Set.univ

end NumStability
