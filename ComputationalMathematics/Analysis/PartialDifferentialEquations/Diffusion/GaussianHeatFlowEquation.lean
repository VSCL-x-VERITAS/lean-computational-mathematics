/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatMomentDerivatives
import Mathlib.Tactic.FieldSimp

/-!
# The classical heat equation for the actual Gaussian convolution

The moment differentiation theorem gives the actual time and spatial
derivatives for every bounded continuous initial profile. Differentiating the
first moment identifies the second spatial derivative and proves the PDE.
-/

namespace NumStability

open Filter
open scoped Topology

theorem hasDerivAt_gaussianHeatMoment_space (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun z : ℝ => gaussianHeatMoment order diffusion initial z time)
      ((order : ℝ) * gaussianHeatMoment (order - 1) diffusion initial space time -
        gaussianHeatMoment (order + 1) diffusion initial space time / (2 * diffusion * time))
      space := by
  have hF := hasFDerivAt_gaussianHeatMoment order diffusion space time initial hdiffusion htime
  have h := hF.comp_hasDerivAt space
    ((hasDerivAt_id space).prodMk (hasDerivAt_const space time))
  simpa [gaussianHeatMomentDerivative] using h

theorem hasDerivAt_gaussianHeatMoment_time (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun τ : ℝ => gaussianHeatMoment order diffusion initial space τ)
      (gaussianHeatMoment (order + 2) diffusion initial space time / (4 * diffusion * time ^ 2) -
        gaussianHeatMoment order diffusion initial space time / (2 * time)) time := by
  have hF := hasFDerivAt_gaussianHeatMoment order diffusion space time initial hdiffusion htime
  have h := hF.comp_hasDerivAt time
    ((hasDerivAt_const time space).prodMk (hasDerivAt_id time))
  simpa [gaussianHeatMomentDerivative] using h

theorem hasDerivAt_gaussianHeatFlow_space (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun z : ℝ => gaussianHeatFlow diffusion initial z time)
      (-(gaussianHeatMoment 1 diffusion initial space time / (2 * diffusion * time))) space := by
  have h := hasDerivAt_gaussianHeatMoment_space 0 diffusion space time initial hdiffusion htime
  have heq : (fun z : ℝ => gaussianHeatFlow diffusion initial z time) =ᶠ[𝓝 space]
      (fun z : ℝ => gaussianHeatMoment 0 diffusion initial z time) :=
    Eventually.of_forall (fun z => (gaussianHeatMoment_zero diffusion z time initial htime).symm)
  simpa using h.congr_of_eventuallyEq heq

theorem deriv_gaussianHeatFlow_space (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time) space =
      -(gaussianHeatMoment 1 diffusion initial space time / (2 * diffusion * time)) :=
  (hasDerivAt_gaussianHeatFlow_space diffusion space time initial hdiffusion htime).deriv

theorem hasDerivAt_gaussianHeatFlow_time (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun τ : ℝ => gaussianHeatFlow diffusion initial space τ)
      (gaussianHeatMoment 2 diffusion initial space time / (4 * diffusion * time ^ 2) -
        gaussianHeatMoment 0 diffusion initial space time / (2 * time)) time := by
  have heq : (fun τ : ℝ => gaussianHeatFlow diffusion initial space τ) =ᶠ[𝓝 time]
      (fun τ : ℝ => gaussianHeatMoment 0 diffusion initial space τ) := by
    filter_upwards [eventually_gt_nhds htime] with τ hτ
    exact (gaussianHeatMoment_zero diffusion space τ initial hτ).symm
  simpa using (hasDerivAt_gaussianHeatMoment_time 0 diffusion space time initial
    hdiffusion htime).congr_of_eventuallyEq heq

/-- The derivative here is the actual first derivative of the heat flow. -/
theorem hasDerivAt_deriv_gaussianHeatFlow_space (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time))
      (gaussianHeatMoment 2 diffusion initial space time / (4 * diffusion ^ 2 * time ^ 2) -
        gaussianHeatMoment 0 diffusion initial space time / (2 * diffusion * time)) space := by
  have heq : deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time) =
      fun z : ℝ => -(gaussianHeatMoment 1 diffusion initial z time / (2 * diffusion * time)) := by
    funext z
    exact deriv_gaussianHeatFlow_space diffusion z time initial hdiffusion htime
  rw [heq]
  have hM := hasDerivAt_gaussianHeatMoment_space 1 diffusion space time initial hdiffusion htime
  apply (hM.div_const (2 * diffusion * time)).neg.congr_deriv
  norm_num only [Nat.cast_one, Nat.reduceSub, Nat.reduceAdd, one_mul]
  field_simp [ne_of_gt hdiffusion, ne_of_gt htime]
  ring

theorem gaussianHeatFlow_heat_equation (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    deriv (fun τ : ℝ => gaussianHeatFlow diffusion initial space τ) time =
      diffusion * deriv (deriv (fun z : ℝ => gaussianHeatFlow diffusion initial z time)) space := by
  rw [(hasDerivAt_gaussianHeatFlow_time diffusion space time initial hdiffusion htime).deriv,
    (hasDerivAt_deriv_gaussianHeatFlow_space diffusion space time initial hdiffusion htime).deriv]
  field_simp [ne_of_gt hdiffusion, ne_of_gt htime]

end NumStability
