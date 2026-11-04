/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatMomentDomination
import Mathlib.Analysis.Calculus.ParametricIntegral
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap

/-!
# Differentiation of the actual Gaussian heat moments

Local dominated differentiation gives the joint derivative on positive time
for every bounded continuous initial profile. The derivative is then identified
with explicit neighboring moments of the same fixed convolution.
-/

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology

/-- The neighboring-moment formula, proved to be the derivative below. -/
noncomputable def gaussianHeatMomentDerivative (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (point : ℝ × ℝ) : (ℝ × ℝ) →L[ℝ] ℝ :=
  ((order : ℝ) * gaussianHeatMoment (order - 1) diffusion initial point.1 point.2 -
      gaussianHeatMoment (order + 1) diffusion initial point.1 point.2 /
        (2 * diffusion * point.2)) • ContinuousLinearMap.fst ℝ ℝ ℝ +
    (gaussianHeatMoment (order + 2) diffusion initial point.1 point.2 /
        (4 * diffusion * point.2 ^ 2) -
      gaussianHeatMoment order diffusion initial point.1 point.2 / (2 * point.2)) •
        ContinuousLinearMap.snd ℝ ℝ ℝ

theorem integral_gaussianHeatMomentSpaceCoefficient (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (∫ location : ℝ, gaussianHeatMomentSpaceCoefficient order diffusion initial
      (space, time) location) =
      (order : ℝ) * gaussianHeatMoment (order - 1) diffusion initial space time -
        gaussianHeatMoment (order + 1) diffusion initial space time / (2 * diffusion * time) := by
  have hI (k : ℕ) : Integrable (gaussianHeatMomentIntegrand k diffusion initial (space, time)) :=
    integrable_gaussianHeatMoment_integrand k diffusion space time initial hdiffusion htime
  change (∫ location : ℝ, (order : ℝ) *
    gaussianHeatMomentIntegrand (order - 1) diffusion initial (space, time) location -
      gaussianHeatMomentIntegrand (order + 1) diffusion initial (space, time) location /
        (2 * diffusion * time)) = _
  rw [integral_sub ((hI (order - 1)).const_mul _) ((hI (order + 1)).div_const _),
    integral_const_mul, integral_div]
  rfl

theorem integral_gaussianHeatMomentTimeCoefficient (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (∫ location : ℝ, gaussianHeatMomentTimeCoefficient order diffusion initial
      (space, time) location) =
      gaussianHeatMoment (order + 2) diffusion initial space time / (4 * diffusion * time ^ 2) -
        gaussianHeatMoment order diffusion initial space time / (2 * time) := by
  have hI (k : ℕ) : Integrable (gaussianHeatMomentIntegrand k diffusion initial (space, time)) :=
    integrable_gaussianHeatMoment_integrand k diffusion space time initial hdiffusion htime
  change (∫ location : ℝ,
    gaussianHeatMomentIntegrand (order + 2) diffusion initial (space, time) location /
        (4 * diffusion * time ^ 2) -
      gaussianHeatMomentIntegrand order diffusion initial (space, time) location / (2 * time)) = _
  rw [integral_sub ((hI (order + 2)).div_const _) ((hI order).div_const _), integral_div,
    integral_div]
  rfl

theorem integral_gaussianHeatMomentDifferential (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    (∫ location : ℝ, gaussianHeatMomentDifferential order diffusion initial
      (space, time) location) = gaussianHeatMomentDerivative order diffusion initial (space, time) := by
  have hI (k : ℕ) : Integrable (gaussianHeatMomentIntegrand k diffusion initial (space, time)) :=
    integrable_gaussianHeatMoment_integrand k diffusion space time initial hdiffusion htime
  have hA : Integrable (gaussianHeatMomentSpaceCoefficient order diffusion initial (space, time)) :=
    ((hI (order - 1)).const_mul (order : ℝ)).sub
      ((hI (order + 1)).div_const (2 * diffusion * time))
  have hB : Integrable (gaussianHeatMomentTimeCoefficient order diffusion initial (space, time)) :=
    ((hI (order + 2)).div_const (4 * diffusion * time ^ 2)).sub
      ((hI order).div_const (2 * time))
  change (∫ location : ℝ,
    gaussianHeatMomentSpaceCoefficient order diffusion initial (space, time) location •
        ContinuousLinearMap.fst ℝ ℝ ℝ +
      gaussianHeatMomentTimeCoefficient order diffusion initial (space, time) location •
        ContinuousLinearMap.snd ℝ ℝ ℝ) = _
  rw [integral_add (hA.smul_const (ContinuousLinearMap.fst ℝ ℝ ℝ))
      (hB.smul_const (ContinuousLinearMap.snd ℝ ℝ ℝ)),
    integral_smul_const, integral_smul_const,
    integral_gaussianHeatMomentSpaceCoefficient order diffusion space time initial hdiffusion htime,
    integral_gaussianHeatMomentTimeCoefficient order diffusion space time initial hdiffusion htime]
  rfl

/-- The actual joint derivative follows by dominated differentiation on a
neighborhood independent of the integration point. -/
theorem hasFDerivAt_gaussianHeatMoment (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasFDerivAt (fun point : ℝ × ℝ =>
        gaussianHeatMoment order diffusion initial point.1 point.2)
      (gaussianHeatMomentDerivative order diffusion initial (space, time)) (space, time) := by
  let lower := time / 2
  let upper := 3 * time / 2
  let radius := |space| + 1
  let s : Set (ℝ × ℝ) := Ioo (space - 1) (space + 1) ×ˢ Ioo lower upper
  have hlower : 0 < lower := by dsimp [lower]; linarith
  have hupper : 0 < upper := by dsimp [upper]; linarith
  have hradius : 0 ≤ radius := by dsimp [radius]; positivity
  have hcenter : (space, time) ∈ s := by
    constructor <;> constructor <;> dsimp [lower, upper] <;> linarith
  have hs : s ∈ 𝓝 (space, time) := (isOpen_Ioo.prod isOpen_Ioo).mem_nhds hcenter
  have hspatial (point : ℝ × ℝ) (hpoint : point ∈ s) : |point.1| ≤ radius := by
    dsimp [radius]
    exact abs_le.mpr ⟨by linarith [neg_abs_le space, hpoint.1.1],
      by linarith [le_abs_self space, hpoint.1.2]⟩
  have hmeas (point : ℝ × ℝ) :
      AEStronglyMeasurable (gaussianHeatMomentIntegrand order diffusion initial point) :=
    (gaussianHeatMomentIntegrand_continuous_location order diffusion initial point).aestronglyMeasurable
  have hmeasDerivative : AEStronglyMeasurable
      (gaussianHeatMomentDifferential order diffusion initial (space, time)) :=
    (gaussianHeatMomentDifferential_continuous_location order diffusion initial
      (space, time)).aestronglyMeasurable
  have hinterchange := hasFDerivAt_integral_of_dominated_of_fderiv_le
    (F := gaussianHeatMomentIntegrand order diffusion initial)
    (F' := gaussianHeatMomentDifferential order diffusion initial)
    (bound := gaussianHeatMomentDifferentialEnvelope order diffusion lower upper radius ‖initial‖)
    hs
    (Eventually.of_forall hmeas)
    (integrable_gaussianHeatMoment_integrand order diffusion space time initial hdiffusion htime)
    hmeasDerivative
    (ae_of_all _ (fun location point hpoint =>
      norm_gaussianHeatMomentDifferential_le_envelope order diffusion lower upper radius
        point.1 point.2 location initial hdiffusion hlower hpoint.2.1.le hpoint.2.2.le hradius
        (hspatial point hpoint)))
    (integrable_gaussianHeatMomentDifferentialEnvelope order diffusion lower upper radius ‖initial‖
      hdiffusion hupper)
    (ae_of_all _ (fun location point hpoint =>
      hasFDerivAt_gaussianHeatMomentIntegrand order diffusion location point.1 point.2 initial
        hdiffusion (hlower.trans hpoint.2.1)))
  exact hinterchange.congr_fderiv
    (integral_gaussianHeatMomentDifferential order diffusion space time initial hdiffusion htime)

theorem fderiv_gaussianHeatMoment (order : ℕ)
    (diffusion space time : ℝ) (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    fderiv ℝ (fun point : ℝ × ℝ => gaussianHeatMoment order diffusion initial point.1 point.2)
      (space, time) = gaussianHeatMomentDerivative order diffusion initial (space, time) :=
  (hasFDerivAt_gaussianHeatMoment order diffusion space time initial hdiffusion htime).fderiv

theorem differentiableOn_gaussianHeatMoment (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (hdiffusion : 0 < diffusion) :
    DifferentiableOn ℝ
      (fun point : ℝ × ℝ => gaussianHeatMoment order diffusion initial point.1 point.2)
      {point : ℝ × ℝ | 0 < point.2} := by
  intro point hpoint
  exact (hasFDerivAt_gaussianHeatMoment order diffusion point.1 point.2 initial
    hdiffusion hpoint).differentiableAt.differentiableWithinAt

end NumStability
