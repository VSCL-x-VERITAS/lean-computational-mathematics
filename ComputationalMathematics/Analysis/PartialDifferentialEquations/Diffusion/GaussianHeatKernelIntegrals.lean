/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernelCalculus
import Mathlib.MeasureTheory.Group.Integral

/-!
# Mass and integrability of the Gaussian heat kernel

The positive-time kernel is a probability density. Translation and reflection
preserve its mass and integrability on the entire real line.
-/

namespace NumStability

open MeasureTheory

theorem gaussianHeatKernel_pos (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    0 < gaussianHeatKernel diffusion time displacement := by
  exact div_pos (Real.exp_pos _)
    (gaussianHeatKernel_normalization_pos diffusion time hdiffusion htime)

theorem integrable_gaussianHeatKernel (diffusion time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    Integrable (gaussianHeatKernel diffusion time) := by
  have heq : gaussianHeatKernel diffusion time =
      ProbabilityTheory.gaussianPDFReal 0 (Real.toNNReal (2 * diffusion * time)) := by
    funext displacement
    exact gaussianHeatKernel_eq_gaussianPDFReal diffusion time displacement hdiffusion htime
  rw [heq]
  exact ProbabilityTheory.integrable_gaussianPDFReal _ _

theorem integral_gaussianHeatKernel (diffusion time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (∫ displacement : ℝ, gaussianHeatKernel diffusion time displacement) = 1 := by
  have heq : gaussianHeatKernel diffusion time =
      ProbabilityTheory.gaussianPDFReal 0 (Real.toNNReal (2 * diffusion * time)) := by
    funext displacement
    exact gaussianHeatKernel_eq_gaussianPDFReal diffusion time displacement hdiffusion htime
  rw [heq]
  apply ProbabilityTheory.integral_gaussianPDFReal_eq_one
  exact ne_of_gt (Real.toNNReal_pos.mpr (by positivity))

theorem integrable_gaussianHeatKernel_sub (diffusion time space : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    Integrable (fun location : ℝ => gaussianHeatKernel diffusion time (space - location)) :=
  (integrable_gaussianHeatKernel diffusion time hdiffusion htime).comp_sub_left space

theorem integral_gaussianHeatKernel_sub (diffusion time space : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (∫ location : ℝ, gaussianHeatKernel diffusion time (space - location)) = 1 := by
  rw [integral_sub_left_eq_self (gaussianHeatKernel diffusion time) volume space]
  exact integral_gaussianHeatKernel diffusion time hdiffusion htime

/-- Every polynomial moment needed in repeated Gaussian differentiation is
integrable, without a support restriction. -/
theorem integrable_pow_mul_gaussianHeatKernel (order : ℕ) (diffusion time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    Integrable (fun displacement : ℝ =>
      displacement ^ order * gaussianHeatKernel diffusion time displacement) := by
  have hdecay : 0 < 1 / (4 * diffusion * time) := by positivity
  have horder : (-1 : ℝ) < (order : ℝ) := lt_of_lt_of_le (by norm_num) (Nat.cast_nonneg order)
  have hmoment : Integrable (fun z : ℝ =>
      z ^ order * Real.exp (-(1 / (4 * diffusion * time)) * z ^ 2)) := by
    simpa only [Real.rpow_natCast] using integrable_rpow_mul_exp_neg_mul_sq hdecay horder
  have heq : (fun z : ℝ => z ^ order * gaussianHeatKernel diffusion time z) =
      (fun z : ℝ => (z ^ order * Real.exp (-(1 / (4 * diffusion * time)) * z ^ 2)) /
        Real.sqrt (4 * Real.pi * diffusion * time)) := by
    funext z
    unfold gaussianHeatKernel
    rw [mul_div_assoc]
    congr 2
    congr 1
    ring
  rw [heq]
  exact hmoment.div_const _

end NumStability
