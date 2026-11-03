/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.HeatWholeLineDependenceTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowSmoothness
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowEquation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowInfluence

/-!
# LeVeque's researched whole-line heat dependence claim

The fixed Gaussian convolution realizes the full bounded continuous Cauchy
problem selected in the reviewed target. Smooth local perturbations establish
whole-line influence. The analytic constructions live in reusable modules.
-/

namespace NumStability

theorem leveque04_heatWholeLineDependence : Leveque04HeatWholeLineDependenceTarget := by
  intro diffusion hdiffusion
  refine ⟨?_, ?_, ?_⟩
  · intro initial
    refine ⟨(fun space => gaussianHeatFlow_initial diffusion space initial),
      contDiffOn_gaussianHeatFlow diffusion initial hdiffusion,
      (fun origin => gaussianHeatFlow_tendsto_initial diffusion origin initial hdiffusion), ?_⟩
    intro space time htime
    exact ⟨integrable_gaussianHeatFlow_integrand diffusion space time initial hdiffusion htime,
      abs_gaussianHeatFlow_le_norm diffusion space time initial hdiffusion htime,
      (hasDerivAt_gaussianHeatFlow_time diffusion space time initial hdiffusion htime).differentiableAt,
      (hasDerivAt_gaussianHeatFlow_space diffusion space time initial hdiffusion htime).differentiableAt,
      (hasDerivAt_deriv_gaussianHeatFlow_space diffusion space time initial
        hdiffusion htime).differentiableAt,
      gaussianHeatFlow_heat_equation diffusion space time initial hdiffusion htime⟩
  · intro observation time location radius htime hradius
    exact exists_gaussianHeatFlow_localized_profile diffusion observation time location radius
      hdiffusion htime hradius
  · intro observation time htime
    exact gaussianHeatFlow_essentialSet_eq_univ diffusion observation time hdiffusion htime

end NumStability
