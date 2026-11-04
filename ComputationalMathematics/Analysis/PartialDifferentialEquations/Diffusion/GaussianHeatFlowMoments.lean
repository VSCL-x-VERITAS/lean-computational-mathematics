/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowIntegrals

/-!
# Polynomial moments of Gaussian heat flow

All polynomially weighted convolutions exist for every bounded continuous
initial profile. They provide the hierarchy used to differentiate the actual
heat evolution without differentiating the initial data.
-/

namespace NumStability

open MeasureTheory
open scoped ContDiff

/-- The displacement moment of the fixed Gaussian evolution. -/
noncomputable def gaussianHeatMoment (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (space time : ℝ) : ℝ :=
  ∫ location : ℝ, (space - location) ^ order *
    gaussianHeatKernel diffusion time (space - location) * initial location

theorem integrable_gaussianHeatMoment_integrand (order : ℕ) (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    Integrable (fun location : ℝ => (space - location) ^ order *
      gaussianHeatKernel diffusion time (space - location) * initial location) := by
  have hmoment := integrable_pow_mul_gaussianHeatKernel order diffusion time hdiffusion htime
  apply (hmoment.comp_sub_left space).mul_bdd initial.continuous.aestronglyMeasurable
  exact ae_of_all _ (fun location => initial.norm_coe_le_norm location)

theorem gaussianHeatMoment_zero (diffusion space time : ℝ) (initial : ℝ → ℝ)
    (htime : 0 < time) :
    gaussianHeatMoment 0 diffusion initial space time =
      gaussianHeatFlow diffusion initial space time := by
  simp [gaussianHeatMoment, gaussianHeatFlow, htime]

/-- For a fixed integration point, the moment integrand is jointly smooth in
space and positive time, even when the initial profile is only continuous. -/
theorem gaussianHeatMoment_integrand_contDiffOn (order : ℕ) (diffusion location : ℝ)
    (initial : ℝ → ℝ) (hdiffusion : 0 < diffusion) :
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => (point.1 - location) ^ order *
        gaussianHeatKernel diffusion point.2 (point.1 - location) * initial location)
      {point : ℝ × ℝ | 0 < point.2} := by
  have hspace : ContDiffOn ℝ ∞ (fun point : ℝ × ℝ => point.1 - location)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_fst.sub contDiffOn_const
  have htime : ContDiffOn ℝ ∞ (fun point : ℝ × ℝ => point.2)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_snd
  have hkernel := (gaussianHeatKernel_contDiffOn diffusion hdiffusion).comp
    (hspace.prodMk htime) (fun _ h => h)
  exact ((hspace.pow order).mul hkernel).mul contDiffOn_const

end NumStability
