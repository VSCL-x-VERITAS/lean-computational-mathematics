/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernel
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Classical calculus of the Gaussian heat kernel

Joint smoothness, the centered normal-density representation, and the actual
time and spatial derivatives of the fixed one-dimensional Gaussian family.
All analytic assertions concern positive diffusion and positive time.
-/

namespace NumStability

open scoped ContDiff

theorem gaussianHeatKernel_normalization_pos (diffusion time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    0 < Real.sqrt (4 * Real.pi * diffusion * time) := by
  apply Real.sqrt_pos.2
  positivity

/-- The kernel is jointly smooth in `(displacement,time)` at positive times. -/
theorem gaussianHeatKernel_contDiffOn (diffusion : ℝ) (hdiffusion : 0 < diffusion) :
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => gaussianHeatKernel diffusion point.2 point.1)
      {point : ℝ × ℝ | 0 < point.2} := by
  have hx : ContDiffOn ℝ ∞ (fun point : ℝ × ℝ => point.1)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_fst
  have ht : ContDiffOn ℝ ∞ (fun point : ℝ × ℝ => point.2)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_snd
  have hden : ContDiffOn ℝ ∞ (fun point : ℝ × ℝ => 4 * diffusion * point.2)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_const.mul ht
  have hrad : ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => 4 * Real.pi * diffusion * point.2)
      {point : ℝ × ℝ | 0 < point.2} := contDiffOn_const.mul ht
  have hden_ne : ∀ point : ℝ × ℝ, point ∈ {point : ℝ × ℝ | 0 < point.2} →
      4 * diffusion * point.2 ≠ 0 := by
    intro point hpoint
    change 0 < point.2 at hpoint
    positivity
  have hrad_ne : ∀ point : ℝ × ℝ, point ∈ {point : ℝ × ℝ | 0 < point.2} →
      4 * Real.pi * diffusion * point.2 ≠ 0 := by
    intro point hpoint
    change 0 < point.2 at hpoint
    positivity
  have hroot_ne : ∀ point : ℝ × ℝ, point ∈ {point : ℝ × ℝ | 0 < point.2} →
      Real.sqrt (4 * Real.pi * diffusion * point.2) ≠ 0 := by
    intro point hpoint
    exact ne_of_gt (gaussianHeatKernel_normalization_pos diffusion point.2
      hdiffusion hpoint)
  exact (((hx.pow 2).neg.div hden hden_ne).exp).div
    (hrad.sqrt hrad_ne) hroot_ne

/-- Its variance is exactly `2 * diffusion * time`. -/
theorem gaussianHeatKernel_eq_gaussianPDFReal (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    gaussianHeatKernel diffusion time displacement =
      ProbabilityTheory.gaussianPDFReal 0
        (Real.toNNReal (2 * diffusion * time)) displacement := by
  have hvariance : 0 ≤ 2 * diffusion * time := by positivity
  unfold gaussianHeatKernel ProbabilityTheory.gaussianPDFReal
  rw [Real.coe_toNNReal _ hvariance]
  simp only [sub_zero]
  have hnorm : 2 * Real.pi * (2 * diffusion * time) =
      4 * Real.pi * diffusion * time := by ring
  have hexponent : 2 * (2 * diffusion * time) = 4 * diffusion * time := by ring
  rw [hnorm, hexponent]
  rw [div_eq_mul_inv, mul_comm]

/-- The actual first spatial derivative, at every real displacement. -/
theorem hasDerivAt_gaussianHeatKernel_space (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (gaussianHeatKernel diffusion time)
      (-(displacement / (2 * diffusion * time)) *
        gaussianHeatKernel diffusion time displacement) displacement := by
  have hdiffusion_ne : diffusion ≠ 0 := ne_of_gt hdiffusion
  have htime_ne : time ≠ 0 := ne_of_gt htime
  have hroot_ne : Real.sqrt (4 * Real.pi * diffusion * time) ≠ 0 :=
    ne_of_gt (gaussianHeatKernel_normalization_pos diffusion time hdiffusion htime)
  have hargument : HasDerivAt
      (fun z : ℝ => -(z ^ 2) / (4 * diffusion * time))
      (-(2 * displacement) / (4 * diffusion * time)) displacement := by
    simpa using ((hasDerivAt_pow 2 displacement).neg.div_const (4 * diffusion * time))
  apply (hargument.exp.div_const (Real.sqrt (4 * Real.pi * diffusion * time))).congr_deriv
  unfold gaussianHeatKernel
  field_simp [hdiffusion_ne, htime_ne, hroot_ne]
  ring

theorem deriv_gaussianHeatKernel_space (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    deriv (gaussianHeatKernel diffusion time) displacement =
      -(displacement / (2 * diffusion * time)) *
        gaussianHeatKernel diffusion time displacement :=
  (hasDerivAt_gaussianHeatKernel_space diffusion time displacement hdiffusion htime).deriv

/-- The derivative of the actual first spatial derivative. -/
theorem hasDerivAt_deriv_gaussianHeatKernel_space (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun z : ℝ => deriv (gaussianHeatKernel diffusion time) z)
      ((displacement ^ 2 / (4 * diffusion ^ 2 * time ^ 2) -
          1 / (2 * diffusion * time)) *
        gaussianHeatKernel diffusion time displacement) displacement := by
  have hderiv : (fun z : ℝ => deriv (gaussianHeatKernel diffusion time) z) =
      fun z => -(z / (2 * diffusion * time)) * gaussianHeatKernel diffusion time z := by
    funext z
    exact deriv_gaussianHeatKernel_space diffusion time z hdiffusion htime
  rw [hderiv]
  have hlinear : HasDerivAt (fun z : ℝ => -(z / (2 * diffusion * time)))
      (-(1 / (2 * diffusion * time))) displacement := by
    simpa using ((hasDerivAt_id displacement).div_const (2 * diffusion * time)).neg
  apply (hlinear.mul
    (hasDerivAt_gaussianHeatKernel_space diffusion time displacement hdiffusion htime)).congr_deriv
  field_simp [ne_of_gt hdiffusion, ne_of_gt htime]
  ring

private theorem hasDerivAt_heatNormalization (diffusion time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun τ : ℝ => Real.sqrt (4 * Real.pi * diffusion * τ))
      (Real.sqrt (4 * Real.pi * diffusion * time) / (2 * time)) time := by
  have hrad : 0 < 4 * Real.pi * diffusion * time := by positivity
  have hroot : 0 < Real.sqrt (4 * Real.pi * diffusion * time) := Real.sqrt_pos.2 hrad
  have hsquare := Real.sq_sqrt (le_of_lt hrad)
  apply (((hasDerivAt_id time).const_mul (4 * Real.pi * diffusion)).sqrt
    (ne_of_gt hrad)).congr_deriv
  apply (div_eq_div_iff (by positivity : 2 * Real.sqrt (4 * Real.pi * diffusion * time) ≠ 0)
    (by positivity : 2 * time ≠ 0)).2
  nlinarith [hsquare]

/-- The actual time derivative at fixed displacement. -/
theorem hasDerivAt_gaussianHeatKernel_time (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt (fun τ : ℝ => gaussianHeatKernel diffusion τ displacement)
      ((displacement ^ 2 / (4 * diffusion * time ^ 2) - 1 / (2 * time)) *
        gaussianHeatKernel diffusion time displacement) time := by
  have hdiffusion_ne : diffusion ≠ 0 := ne_of_gt hdiffusion
  have htime_ne : time ≠ 0 := ne_of_gt htime
  have hden_ne : 4 * diffusion * time ≠ 0 := by positivity
  have hroot_ne : Real.sqrt (4 * Real.pi * diffusion * time) ≠ 0 :=
    ne_of_gt (gaussianHeatKernel_normalization_pos diffusion time hdiffusion htime)
  have hargument : HasDerivAt
      (fun τ : ℝ => -(displacement ^ 2) / (4 * diffusion * τ))
      (displacement ^ 2 / (4 * diffusion * time ^ 2)) time := by
    apply ((hasDerivAt_const time (-(displacement ^ 2))).div
      ((hasDerivAt_id time).const_mul (4 * diffusion)) hden_ne).congr_deriv
    simp only [id_eq]
    field_simp [hdiffusion_ne, htime_ne]
    ring
  apply (hargument.exp.div
    (hasDerivAt_heatNormalization diffusion time hdiffusion htime) hroot_ne).congr_deriv
  unfold gaussianHeatKernel
  field_simp [hdiffusion_ne, htime_ne, hroot_ne]

/-- The fixed kernel satisfies the classical heat equation at positive times. -/
theorem gaussianHeatKernel_heat_equation (diffusion time displacement : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    deriv (fun τ : ℝ => gaussianHeatKernel diffusion τ displacement) time =
      diffusion * deriv (deriv (gaussianHeatKernel diffusion time)) displacement := by
  rw [(hasDerivAt_gaussianHeatKernel_time diffusion time displacement hdiffusion htime).deriv,
    (hasDerivAt_deriv_gaussianHeatKernel_space diffusion time displacement hdiffusion htime).deriv]
  field_simp [ne_of_gt hdiffusion, ne_of_gt htime]

end NumStability
