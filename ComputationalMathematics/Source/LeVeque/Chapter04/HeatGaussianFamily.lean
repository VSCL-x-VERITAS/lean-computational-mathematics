/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernelCalculus
import ComputationalMathematics.Source.LeVeque.Chapter04.HeatGaussianFamilyTarget

/-!
# The one-dimensional positive-time Gaussian heat family

This wrapper proves the unchanged supporting target. The full Cauchy evolution,
initial trace, whole-line dependence and uniqueness remain separate results.
-/

namespace NumStability

/-- The actual Gaussian family has the prescribed normalization, smoothness,
classical derivatives and heat identity for every positive diffusion and time. -/
theorem leveque04_heatGaussianFamily : Leveque04HeatGaussianFamilyTarget := by
  intro diffusion hdiffusion
  refine ⟨gaussianHeatKernel_contDiffOn diffusion hdiffusion, ?_⟩
  intro time displacement htime
  exact ⟨gaussianHeatKernel_eq_gaussianPDFReal diffusion time displacement hdiffusion htime,
    hasDerivAt_gaussianHeatKernel_time diffusion time displacement hdiffusion htime,
    hasDerivAt_gaussianHeatKernel_space diffusion time displacement hdiffusion htime,
    hasDerivAt_deriv_gaussianHeatKernel_space diffusion time displacement hdiffusion htime,
    gaussianHeatKernel_heat_equation diffusion time displacement hdiffusion htime⟩

end NumStability
