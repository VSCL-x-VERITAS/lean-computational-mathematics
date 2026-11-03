/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernel
import Mathlib.Probability.Distributions.Gaussian.Real

/-!
# A supporting positive-time Gaussian heat-family target

This is the one-dimensional instance of the fundamental solution in Stanford
Math220B, Section 2.4.2, used for LeVeque's scalar diffusion equation. It concerns
the actual fixed Gaussian family and its classical derivatives. Convolution,
initial trace and whole-line dependence remain separate obligations.
-/

namespace NumStability

open scoped ContDiff

/-- Joint smoothness, Gaussian normalization, actual derivative formulas and
the classical heat equation for every positive diffusion coefficient and time. -/
def Leveque04HeatGaussianFamilyTarget : Prop :=
  ∀ diffusion : ℝ, 0 < diffusion →
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => gaussianHeatKernel diffusion point.2 point.1)
      {point : ℝ × ℝ | 0 < point.2} ∧
    ∀ time displacement : ℝ, 0 < time →
      gaussianHeatKernel diffusion time displacement =
        ProbabilityTheory.gaussianPDFReal 0
          (Real.toNNReal (2 * diffusion * time)) displacement ∧
      HasDerivAt (fun τ : ℝ => gaussianHeatKernel diffusion τ displacement)
        ((displacement ^ 2 / (4 * diffusion * time ^ 2) - 1 / (2 * time)) *
          gaussianHeatKernel diffusion time displacement) time ∧
      HasDerivAt (gaussianHeatKernel diffusion time)
        (-(displacement / (2 * diffusion * time)) *
          gaussianHeatKernel diffusion time displacement) displacement ∧
      HasDerivAt (fun z : ℝ => deriv (gaussianHeatKernel diffusion time) z)
        ((displacement ^ 2 / (4 * diffusion ^ 2 * time ^ 2) -
            1 / (2 * diffusion * time)) *
          gaussianHeatKernel diffusion time displacement) displacement ∧
      deriv (fun τ : ℝ => gaussianHeatKernel diffusion τ displacement) time =
        diffusion * deriv (deriv (gaussianHeatKernel diffusion time)) displacement

end NumStability
