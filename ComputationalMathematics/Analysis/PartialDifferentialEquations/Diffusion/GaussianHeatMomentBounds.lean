/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernelBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowMoments

/-!
# Integrable local envelopes for every heat moment

The same positive compact time interval and bounded spatial set give an
integrable envelope for each moment, uniformly in the space-time parameter.
The profile enters only through its finite supremum norm.
-/

namespace NumStability

open MeasureTheory

/-- A Gaussian times a polynomial majorizes the specified moment locally. -/
noncomputable def gaussianHeatMomentEnvelope (order : ℕ)
    (diffusion lowerTime upperTime radius bound location : ℝ) : ℝ :=
  (Real.exp (radius ^ 2 / (4 * diffusion * upperTime)) /
    Real.sqrt (4 * Real.pi * diffusion * lowerTime)) * bound *
      2 ^ (order - 1) * (|location| ^ order + radius ^ order) *
        Real.exp (-(location ^ 2) / (8 * diffusion * upperTime))

theorem gaussianHeatMomentEnvelope_nonneg (order : ℕ)
    (diffusion lowerTime upperTime radius bound location : ℝ)
    (hradius : 0 ≤ radius) (hbound : 0 ≤ bound) :
    0 ≤ gaussianHeatMomentEnvelope order diffusion lowerTime upperTime radius bound location := by
  unfold gaussianHeatMomentEnvelope
  positivity

theorem integrable_gaussianHeatMomentEnvelope (order : ℕ)
    (diffusion lowerTime upperTime radius bound : ℝ)
    (hdiffusion : 0 < diffusion) (hupper : 0 < upperTime) :
    Integrable (gaussianHeatMomentEnvelope order diffusion lowerTime upperTime radius bound) := by
  have hdecay : 0 < 1 / (8 * diffusion * upperTime) := by positivity
  have horder : (-1 : ℝ) < (order : ℝ) := lt_of_lt_of_le (by norm_num) (Nat.cast_nonneg order)
  have hexponent (z : ℝ) : -(z ^ 2) / (8 * diffusion * upperTime) =
      -(1 / (8 * diffusion * upperTime)) * z ^ 2 := by ring
  have hmoment : Integrable (fun z : ℝ => z ^ order *
      Real.exp (-(z ^ 2) / (8 * diffusion * upperTime))) := by
    simpa only [hexponent, Real.rpow_natCast] using
      integrable_rpow_mul_exp_neg_mul_sq hdecay horder
  have habsolute : Integrable (fun z : ℝ => |z| ^ order *
      Real.exp (-(z ^ 2) / (8 * diffusion * upperTime))) := by
    simpa only [Real.norm_eq_abs, abs_mul, abs_pow, abs_of_pos (Real.exp_pos _)] using
      hmoment.norm
  have hgaussian : Integrable (fun z : ℝ =>
      Real.exp (-(z ^ 2) / (8 * diffusion * upperTime))) := by
    simpa only [hexponent] using integrable_exp_neg_mul_sq hdecay
  have hsum := habsolute.add (hgaussian.const_mul (radius ^ order))
  convert hsum.const_mul
    ((Real.exp (radius ^ 2 / (4 * diffusion * upperTime)) /
      Real.sqrt (4 * Real.pi * diffusion * lowerTime)) * bound * 2 ^ (order - 1)) using 1
  funext location
  dsimp only [Pi.add_apply]
  unfold gaussianHeatMomentEnvelope
  ring

/-- The majorant is uniform on the chosen space-time neighborhood and covers
every integration point on the real line. -/
theorem norm_gaussianHeatMoment_integrand_le_envelope (order : ℕ)
    (diffusion lowerTime upperTime radius space time location : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (hlower : 0 < lowerTime)
    (hbefore : lowerTime ≤ time) (hafter : time ≤ upperTime)
    (hradius : 0 ≤ radius) (hspace : |space| ≤ radius) :
    ‖(space - location) ^ order * gaussianHeatKernel diffusion time (space - location) *
      initial location‖ ≤
        gaussianHeatMomentEnvelope order diffusion lowerTime upperTime radius ‖initial‖ location := by
  let C := Real.exp (radius ^ 2 / (4 * diffusion * upperTime)) /
    Real.sqrt (4 * Real.pi * diffusion * lowerTime)
  let P := 2 ^ (order - 1) * (|location| ^ order + radius ^ order)
  let e := Real.exp (-(location ^ 2) / (8 * diffusion * upperTime))
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have hP : 0 ≤ P := by dsimp [P]; positivity
  have he : 0 ≤ e := (Real.exp_pos _).le
  have htime : 0 < time := hlower.trans_le hbefore
  have hkpos := (gaussianHeatKernel_pos diffusion time (space - location) hdiffusion htime).le
  have hkernel := gaussianHeatKernel_le_uniform_envelope diffusion lowerTime upperTime radius
    space time location hdiffusion hlower hbefore hafter hradius hspace
  change gaussianHeatKernel diffusion time (space - location) ≤ C * e at hkernel
  have hdist : |space - location| ≤ |location| + radius := by
    have h := abs_sub_le space 0 location
    simp only [sub_zero, zero_sub, abs_neg] at h
    linarith
  have hpower : |space - location| ^ order ≤ P :=
    (pow_le_pow_left₀ (abs_nonneg _) hdist order).trans
      (add_pow_le (abs_nonneg location) hradius order)
  have hdata : |initial location| ≤ ‖initial‖ := by
    simpa only [Real.norm_eq_abs] using initial.norm_coe_le_norm location
  calc
    _ = |space - location| ^ order *
        gaussianHeatKernel diffusion time (space - location) * |initial location| := by
      rw [Real.norm_eq_abs, abs_mul, abs_mul, abs_pow, abs_of_nonneg hkpos]
    _ ≤ (P * (C * e)) * ‖initial‖ :=
      mul_le_mul (mul_le_mul hpower hkernel hkpos hP) hdata (abs_nonneg _)
        (mul_nonneg hP (mul_nonneg hC he))
    _ = _ := by
      dsimp [P, C, e, gaussianHeatMomentEnvelope]
      ring

end NumStability
