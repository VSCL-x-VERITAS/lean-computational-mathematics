/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowIntegrals
import Mathlib.MeasureTheory.Integral.DominatedConvergence

/-!
# Joint initial trace of Gaussian heat flow

The heat convolution is an affine pushforward of one fixed standard Gaussian
measure. Dominated convergence then gives the joint space-time initial trace
for every bounded continuous profile, without uniform continuity or compact
support of the data.
-/

namespace NumStability

open Filter MeasureTheory ProbabilityTheory
open scoped Topology NNReal

theorem gaussianHeatKernel_sub_eq_gaussianPDFReal (diffusion time space location : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    gaussianHeatKernel diffusion time (space - location) =
      gaussianPDFReal space (Real.toNNReal (2 * diffusion * time)) location := by
  rw [gaussianHeatKernel_eq_gaussianPDFReal diffusion time (space - location)
    hdiffusion htime]
  have hsq : (space - location) ^ 2 = (location - space) ^ 2 := by ring
  simp only [gaussianPDFReal, sub_zero, hsq]

theorem gaussianHeatFlow_eq_gaussianReal_integral (diffusion space time : ℝ)
    (initial : ℝ → ℝ) (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    gaussianHeatFlow diffusion initial space time =
      ∫ location : ℝ, initial location ∂gaussianReal space
        (Real.toNNReal (2 * diffusion * time)) := by
  have hvariance : Real.toNNReal (2 * diffusion * time) ≠ 0 :=
    ne_of_gt (Real.toNNReal_pos.mpr (by positivity))
  rw [gaussianHeatFlow, if_pos htime, integral_gaussianReal_eq_integral_smul hvariance]
  apply integral_congr_ae
  apply ae_of_all
  intro location
  dsimp only
  rw [gaussianHeatKernel_sub_eq_gaussianPDFReal diffusion time space location hdiffusion htime]
  rfl

theorem gaussianReal_map_heat_affine (diffusion space time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (gaussianReal 0 1).map (fun z : ℝ => space + Real.sqrt (2 * diffusion * time) * z) =
      gaussianReal space (Real.toNNReal (2 * diffusion * time)) := by
  have hv : 0 ≤ 2 * diffusion * time := by positivity
  have hvariance : (⟨(Real.sqrt (2 * diffusion * time)) ^ 2, sq_nonneg _⟩ : ℝ≥0) =
      Real.toNNReal (2 * diffusion * time) := by
    apply Subtype.ext
    exact (Real.sq_sqrt hv).trans (Real.coe_toNNReal _ hv).symm
  change (gaussianReal 0 1).map
    ((fun z : ℝ => space + z) ∘ (fun z : ℝ => Real.sqrt (2 * diffusion * time) * z)) = _
  rw [← Measure.map_map (by fun_prop) (by fun_prop), gaussianReal_map_const_mul,
    gaussianReal_map_const_add]
  simp only [mul_zero, mul_one, zero_add, hvariance]

theorem gaussianHeatFlow_eq_standardGaussian_integral (diffusion space time : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    gaussianHeatFlow diffusion initial space time =
      ∫ z : ℝ, initial (space + Real.sqrt (2 * diffusion * time) * z)
        ∂gaussianReal 0 1 := by
  rw [gaussianHeatFlow_eq_gaussianReal_integral diffusion space time initial hdiffusion htime,
    ← gaussianReal_map_heat_affine diffusion space time hdiffusion htime]
  exact integral_map (by fun_prop) initial.continuous.aestronglyMeasurable

/-- The trace is joint in space and positive time, for the full bounded
continuous class. -/
theorem gaussianHeatFlow_tendsto_initial (diffusion origin : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (hdiffusion : 0 < diffusion) :
    Tendsto (fun point : ℝ × ℝ => gaussianHeatFlow diffusion initial point.1 point.2)
      (nhdsWithin (origin, 0) {point : ℝ × ℝ | 0 < point.2}) (𝓝 (initial origin)) := by
  let l := nhdsWithin (origin, (0 : ℝ)) {point : ℝ × ℝ | 0 < point.2}
  have hmeas : ∀ᶠ point : ℝ × ℝ in l, AEStronglyMeasurable
      (fun z : ℝ => initial (point.1 + Real.sqrt (2 * diffusion * point.2) * z))
      (gaussianReal 0 1) := by
    apply Eventually.of_forall
    intro point
    exact (initial.continuous.comp
      (continuous_const.add (continuous_const.mul continuous_id))).aestronglyMeasurable
  have hbound : ∀ᶠ point : ℝ × ℝ in l, ∀ᵐ z : ℝ ∂gaussianReal 0 1,
      ‖initial (point.1 + Real.sqrt (2 * diffusion * point.2) * z)‖ ≤ ‖initial‖ :=
    Eventually.of_forall (fun point => ae_of_all _ (fun z => initial.norm_coe_le_norm _))
  have hpointwise : ∀ᵐ z : ℝ ∂gaussianReal 0 1,
      Tendsto (fun point : ℝ × ℝ =>
        initial (point.1 + Real.sqrt (2 * diffusion * point.2) * z)) l (𝓝 (initial origin)) := by
    apply ae_of_all
    intro z
    have hc : Continuous (fun point : ℝ × ℝ =>
        point.1 + Real.sqrt (2 * diffusion * point.2) * z) := by fun_prop
    have hargument : Tendsto (fun point : ℝ × ℝ =>
        point.1 + Real.sqrt (2 * diffusion * point.2) * z) l (𝓝 origin) := by
      simpa using (hc.tendsto (origin, (0 : ℝ))).mono_left nhdsWithin_le_nhds
    exact initial.continuous.continuousAt.tendsto.comp hargument
  have hlimit := tendsto_integral_filter_of_dominated_convergence
    (fun _ : ℝ => ‖initial‖) hmeas hbound (integrable_const _) hpointwise
  have heq : ∀ᶠ point : ℝ × ℝ in l,
      gaussianHeatFlow diffusion initial point.1 point.2 =
        ∫ z : ℝ, initial (point.1 + Real.sqrt (2 * diffusion * point.2) * z)
          ∂gaussianReal 0 1 := by
    filter_upwards [self_mem_nhdsWithin] with point hpoint
    exact gaussianHeatFlow_eq_standardGaussian_integral diffusion point.1 point.2 initial
      hdiffusion hpoint
  simpa using hlimit.congr' (Filter.EventuallyEq.symm heq)

end NumStability
