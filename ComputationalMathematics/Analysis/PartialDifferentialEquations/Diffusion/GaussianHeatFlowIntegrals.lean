/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernelIntegrals

/-!
# Integral estimates for the whole-line Gaussian heat evolution

Every bounded continuous real profile has an integrable positive-time
convolution. The evolution preserves constants and contracts the supremum norm.
No compact-support assumption is imposed on the initial data.
-/

namespace NumStability

open MeasureTheory

theorem integrable_gaussianHeatFlow_integrand (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    Integrable (fun location : ℝ =>
      gaussianHeatKernel diffusion time (space - location) * initial location) := by
  apply (integrable_gaussianHeatKernel_sub diffusion time space hdiffusion htime).mul_bdd
    initial.continuous.aestronglyMeasurable
  exact ae_of_all _ (fun location => initial.norm_coe_le_norm location)

@[simp]
theorem gaussianHeatFlow_initial (diffusion space : ℝ) (initial : ℝ → ℝ) :
    gaussianHeatFlow diffusion initial space 0 = initial space := by
  simp [gaussianHeatFlow]

@[simp]
theorem gaussianHeatFlow_zero (diffusion space time : ℝ) :
    gaussianHeatFlow diffusion (fun _ : ℝ => 0) space time = 0 := by
  simp [gaussianHeatFlow]

theorem gaussianHeatFlow_const (diffusion space time value : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    gaussianHeatFlow diffusion (fun _ : ℝ => value) space time = value := by
  simp only [gaussianHeatFlow, if_pos htime, integral_mul_const,
    integral_gaussianHeatKernel_sub diffusion time space hdiffusion htime, one_mul]

theorem abs_gaussianHeatFlow_le_norm (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    |gaussianHeatFlow diffusion initial space time| ≤ ‖initial‖ := by
  have hk := integrable_gaussianHeatKernel_sub diffusion time space hdiffusion htime
  have hbound : ∀ᵐ location : ℝ, ‖gaussianHeatKernel diffusion time (space - location) *
      initial location‖ ≤ gaussianHeatKernel diffusion time (space - location) * ‖initial‖ := by
    apply ae_of_all
    intro location
    rw [norm_mul, Real.norm_of_nonneg
      (gaussianHeatKernel_pos diffusion time (space - location) hdiffusion htime).le]
    exact mul_le_mul_of_nonneg_left (initial.norm_coe_le_norm location)
      (gaussianHeatKernel_pos diffusion time (space - location) hdiffusion htime).le
  have h := norm_integral_le_of_norm_le (hk.mul_const ‖initial‖) hbound
  simpa only [gaussianHeatFlow, if_pos htime, Real.norm_eq_abs, integral_mul_const,
    integral_gaussianHeatKernel_sub diffusion time space hdiffusion htime, one_mul] using h

/-- A nonnegative continuous profile that is positive somewhere has positive
output at every positive-time observation. -/
theorem gaussianHeatFlow_pos (diffusion space time location : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time)
    (hnonneg : ∀ z : ℝ, 0 ≤ initial z) (hpositive : 0 < initial location) :
    0 < gaussianHeatFlow diffusion initial space time := by
  have hkernel : Continuous (gaussianHeatKernel diffusion time) :=
    continuous_iff_continuousAt.mpr (fun displacement =>
      (hasDerivAt_gaussianHeatKernel_space diffusion time displacement
        hdiffusion htime).continuousAt)
  rw [gaussianHeatFlow, if_pos htime]
  apply integral_pos_of_integrable_nonneg_nonzero
    ((hkernel.comp (continuous_const.sub continuous_id)).mul initial.continuous)
    (integrable_gaussianHeatFlow_integrand diffusion space time initial hdiffusion htime)
    (fun z => mul_nonneg (gaussianHeatKernel_pos diffusion time (space - z)
      hdiffusion htime).le (hnonneg z))
  exact ne_of_gt (mul_pos
    (gaussianHeatKernel_pos diffusion time (space - location) hdiffusion htime) hpositive)

end NumStability
