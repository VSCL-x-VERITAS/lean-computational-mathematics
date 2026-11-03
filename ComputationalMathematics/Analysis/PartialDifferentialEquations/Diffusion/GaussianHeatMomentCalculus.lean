/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatMomentBounds
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Joint derivatives of the heat moment integrands

These are derivatives in the full space-time parameter, before integration.
The initial profile is never differentiated. Its regularity is therefore not
an applicability hypothesis for these fixed-integration-point identities.
-/

namespace NumStability

open Filter MeasureTheory
open scoped Topology ContDiff

/-- The actual integrand of the displacement moment. -/
noncomputable def gaussianHeatMomentIntegrand (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (point : ℝ × ℝ) (location : ℝ) : ℝ :=
  (point.1 - location) ^ order * gaussianHeatKernel diffusion point.2 (point.1 - location) *
    initial location

/-- The spatial coefficient in the joint derivative. -/
noncomputable def gaussianHeatMomentSpaceCoefficient (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (point : ℝ × ℝ) (location : ℝ) : ℝ :=
  (order : ℝ) * gaussianHeatMomentIntegrand (order - 1) diffusion initial point location -
    gaussianHeatMomentIntegrand (order + 1) diffusion initial point location /
      (2 * diffusion * point.2)

/-- The temporal coefficient in the joint derivative. -/
noncomputable def gaussianHeatMomentTimeCoefficient (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (point : ℝ × ℝ) (location : ℝ) : ℝ :=
  gaussianHeatMomentIntegrand (order + 2) diffusion initial point location /
      (4 * diffusion * point.2 ^ 2) -
    gaussianHeatMomentIntegrand order diffusion initial point location / (2 * point.2)

/-- The full two-coordinate derivative, not a pair of unassembled partials. -/
noncomputable def gaussianHeatMomentDifferential (order : ℕ) (diffusion : ℝ)
    (initial : ℝ → ℝ) (point : ℝ × ℝ) (location : ℝ) : (ℝ × ℝ) →L[ℝ] ℝ :=
  gaussianHeatMomentSpaceCoefficient order diffusion initial point location •
      ContinuousLinearMap.fst ℝ ℝ ℝ +
    gaussianHeatMomentTimeCoefficient order diffusion initial point location •
      ContinuousLinearMap.snd ℝ ℝ ℝ

theorem gaussianHeatMomentIntegrand_continuous_location (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (point : ℝ × ℝ) :
    Continuous (gaussianHeatMomentIntegrand order diffusion initial point) := by
  have hf : Continuous (initial : ℝ → ℝ) := initial.continuous
  unfold gaussianHeatMomentIntegrand gaussianHeatKernel
  fun_prop

theorem gaussianHeatMomentSpaceCoefficient_continuous_location (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (point : ℝ × ℝ) :
    Continuous (gaussianHeatMomentSpaceCoefficient order diffusion initial point) := by
  have hI (k : ℕ) := gaussianHeatMomentIntegrand_continuous_location k diffusion initial point
  exact ((hI (order - 1)).const_mul (order : ℝ)).sub
    ((hI (order + 1)).div_const (2 * diffusion * point.2))

theorem gaussianHeatMomentTimeCoefficient_continuous_location (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (point : ℝ × ℝ) :
    Continuous (gaussianHeatMomentTimeCoefficient order diffusion initial point) := by
  have hI (k : ℕ) := gaussianHeatMomentIntegrand_continuous_location k diffusion initial point
  exact ((hI (order + 2)).div_const (4 * diffusion * point.2 ^ 2)).sub
    ((hI order).div_const (2 * point.2))

theorem gaussianHeatMomentDifferential_continuous_location (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (point : ℝ × ℝ) :
    Continuous (gaussianHeatMomentDifferential order diffusion initial point) := by
  have hspace := gaussianHeatMomentSpaceCoefficient_continuous_location order diffusion initial point
  have htime := gaussianHeatMomentTimeCoefficient_continuous_location order diffusion initial point
  exact (hspace.smul continuous_const).add (htime.smul continuous_const)

private theorem hasFDerivAt_of_coordinates
    (f : (ℝ × ℝ) → ℝ) (space time spaceDerivative timeDerivative : ℝ)
    (hdiff : DifferentiableAt ℝ f (space, time))
    (hspace : HasDerivAt (fun z : ℝ => f (z, time)) spaceDerivative space)
    (htime : HasDerivAt (fun t : ℝ => f (space, t)) timeDerivative time) :
    HasFDerivAt f
      (spaceDerivative • ContinuousLinearMap.fst ℝ ℝ ℝ +
        timeDerivative • ContinuousLinearMap.snd ℝ ℝ ℝ) (space, time) := by
  let L := fderiv ℝ f (space, time)
  have hF : HasFDerivAt f L (space, time) := hdiff.hasFDerivAt
  have hx : L (1, 0) = spaceDerivative :=
    (hF.comp_hasDerivAt space
      ((hasDerivAt_id space).prodMk (hasDerivAt_const space time))).unique hspace
  have ht : L (0, 1) = timeDerivative :=
    (hF.comp_hasDerivAt time
      ((hasDerivAt_const time space).prodMk (hasDerivAt_id time))).unique htime
  apply hF.congr_fderiv
  apply ContinuousLinearMap.ext
  intro v
  have hsplit : v = v.1 • ((1, 0) : ℝ × ℝ) + v.2 • ((0, 1) : ℝ × ℝ) := by
    ext <;> simp
  calc
    L v = L (v.1 • (1, 0) + v.2 • (0, 1)) := congrArg L hsplit
    _ = v.1 * L (1, 0) + v.2 * L (0, 1) := by
      simp only [map_add, map_smul, smul_eq_mul]
    _ = _ := by simp [hx, ht, mul_comm]

theorem hasDerivAt_gaussianHeatMomentIntegrand_space (order : ℕ)
    (diffusion location space time : ℝ) (initial : ℝ → ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt
      (fun z : ℝ => gaussianHeatMomentIntegrand order diffusion initial (z, time) location)
      (gaussianHeatMomentSpaceCoefficient order diffusion initial (space, time) location) space := by
  have hz : HasDerivAt (fun z : ℝ => z - location) 1 space :=
    (hasDerivAt_id space).sub_const location
  have hk := (hasDerivAt_gaussianHeatKernel_space diffusion time (space - location)
    hdiffusion htime).comp space hz
  apply (((hz.pow order).mul hk).mul_const (initial location)).congr_deriv
  dsimp [gaussianHeatMomentSpaceCoefficient, gaussianHeatMomentIntegrand]
  simp only [mul_one, pow_succ]
  ring

theorem hasDerivAt_gaussianHeatMomentIntegrand_time (order : ℕ)
    (diffusion location space time : ℝ) (initial : ℝ → ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasDerivAt
      (fun t : ℝ => gaussianHeatMomentIntegrand order diffusion initial (space, t) location)
      (gaussianHeatMomentTimeCoefficient order diffusion initial (space, time) location) time := by
  have hk := hasDerivAt_gaussianHeatKernel_time diffusion time (space - location)
    hdiffusion htime
  apply ((hk.const_mul ((space - location) ^ order)).mul_const (initial location)).congr_deriv
  dsimp [gaussianHeatMomentTimeCoefficient, gaussianHeatMomentIntegrand]
  rw [pow_add]
  ring

theorem hasFDerivAt_gaussianHeatMomentIntegrand (order : ℕ)
    (diffusion location space time : ℝ) (initial : ℝ → ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    HasFDerivAt (fun point : ℝ × ℝ =>
        gaussianHeatMomentIntegrand order diffusion initial point location)
      (gaussianHeatMomentDifferential order diffusion initial (space, time) location)
      (space, time) := by
  have hneighborhood : {point : ℝ × ℝ | 0 < point.2} ∈ 𝓝 (space, time) :=
    (isOpen_lt continuous_const continuous_snd).mem_nhds htime
  have hd := ((gaussianHeatMoment_integrand_contDiffOn order diffusion location initial
    hdiffusion).differentiableOn (by simp)).differentiableAt hneighborhood
  exact hasFDerivAt_of_coordinates _ space time _ _ hd
    (hasDerivAt_gaussianHeatMomentIntegrand_space order diffusion location space time initial
      hdiffusion htime)
    (hasDerivAt_gaussianHeatMomentIntegrand_time order diffusion location space time initial
      hdiffusion htime)

end NumStability
