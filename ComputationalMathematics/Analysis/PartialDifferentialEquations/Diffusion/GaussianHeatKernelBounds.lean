/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatKernelIntegrals

/-!
# Local uniform Gaussian envelopes

On bounded spatial sets and positive compact time intervals, a single
integrable Gaussian dominates every translated heat kernel. The interval
and spatial bounds are local parameters, not restrictions on the Cauchy data.
-/

namespace NumStability

theorem gaussianHeatKernel_le_uniform_envelope
    (diffusion lowerTime upperTime radius space time location : ℝ)
    (hdiffusion : 0 < diffusion) (hlower : 0 < lowerTime)
    (hbefore : lowerTime ≤ time) (hafter : time ≤ upperTime)
    (hradius : 0 ≤ radius) (hspace : |space| ≤ radius) :
    gaussianHeatKernel diffusion time (space - location) ≤
      (Real.exp (radius ^ 2 / (4 * diffusion * upperTime)) /
        Real.sqrt (4 * Real.pi * diffusion * lowerTime)) *
        Real.exp (-(location ^ 2) / (8 * diffusion * upperTime)) := by
  have htime : 0 < time := hlower.trans_le hbefore
  have hupper : 0 < upperTime := htime.trans_le hafter
  have hroot : Real.sqrt (4 * Real.pi * diffusion * lowerTime) ≤
      Real.sqrt (4 * Real.pi * diffusion * time) :=
    Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_left hbefore (by positivity))
  have hroot_pos := gaussianHeatKernel_normalization_pos diffusion lowerTime hdiffusion hlower
  have hspace_sq : space ^ 2 ≤ radius ^ 2 := by
    nlinarith [mul_le_mul hspace hspace (abs_nonneg space) hradius, sq_abs space]
  have hquadratic : location ^ 2 / 2 - space ^ 2 ≤ (space - location) ^ 2 := by
    nlinarith [sq_nonneg (location - 2 * space)]
  have hden : 4 * diffusion * time ≤ 4 * diffusion * upperTime :=
    mul_le_mul_of_nonneg_left hafter (by positivity)
  have hnegative : -(space - location) ^ 2 / (4 * diffusion * time) ≤
      -(space - location) ^ 2 / (4 * diffusion * upperTime) := by
    apply (div_le_div_iff₀ (by positivity) (by positivity)).2
    simpa only [neg_mul] using
      neg_le_neg (mul_le_mul_of_nonneg_left hden (sq_nonneg (space - location)))
  have hquad : -(space - location) ^ 2 ≤ radius ^ 2 - location ^ 2 / 2 := by
    linarith
  have hdiv := (div_le_div_iff_of_pos_right
    (show 0 < 4 * diffusion * upperTime by positivity)).2 hquad
  have hrewrite : (radius ^ 2 - location ^ 2 / 2) / (4 * diffusion * upperTime) =
      radius ^ 2 / (4 * diffusion * upperTime) -
        location ^ 2 / (8 * diffusion * upperTime) := by
    field_simp [ne_of_gt hdiffusion, ne_of_gt hupper]
    ring
  rw [hrewrite] at hdiv
  have hexponent := hnegative.trans hdiv
  unfold gaussianHeatKernel
  calc
    _ ≤ Real.exp (-(space - location) ^ 2 / (4 * diffusion * time)) /
        Real.sqrt (4 * Real.pi * diffusion * lowerTime) :=
      div_le_div_of_nonneg_left (Real.exp_pos _).le hroot_pos hroot
    _ ≤ Real.exp (radius ^ 2 / (4 * diffusion * upperTime) -
        location ^ 2 / (8 * diffusion * upperTime)) /
        Real.sqrt (4 * Real.pi * diffusion * lowerTime) :=
      (div_le_div_iff_of_pos_right hroot_pos).2 (Real.exp_le_exp.mpr hexponent)
    _ = _ := by
      rw [sub_eq_add_neg, Real.exp_add, neg_div]
      ring

theorem norm_gaussianHeatKernel_le_uniform_envelope
    (diffusion lowerTime upperTime radius space time location : ℝ)
    (hdiffusion : 0 < diffusion) (hlower : 0 < lowerTime)
    (hbefore : lowerTime ≤ time) (hafter : time ≤ upperTime)
    (hradius : 0 ≤ radius) (hspace : |space| ≤ radius) :
    ‖gaussianHeatKernel diffusion time (space - location)‖ ≤
      (Real.exp (radius ^ 2 / (4 * diffusion * upperTime)) /
        Real.sqrt (4 * Real.pi * diffusion * lowerTime)) *
        Real.exp (-(location ^ 2) / (8 * diffusion * upperTime)) := by
  rw [Real.norm_of_nonneg
    (gaussianHeatKernel_pos diffusion time (space - location) hdiffusion
      (hlower.trans_le hbefore)).le]
  exact gaussianHeatKernel_le_uniform_envelope diffusion lowerTime upperTime radius space time
    location hdiffusion hlower hbefore hafter hradius hspace

end NumStability
