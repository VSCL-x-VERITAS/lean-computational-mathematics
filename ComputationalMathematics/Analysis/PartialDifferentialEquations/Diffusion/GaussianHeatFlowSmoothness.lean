/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatMomentDerivatives
import Mathlib.Analysis.Calculus.ContDiff.Operations

/-!
# Joint smoothness of Gaussian heat flow

The actual derivatives of every displacement moment involve only neighboring
moments and rational functions of positive time. Simultaneous induction over
all moment indices therefore gives every finite joint derivative order for
arbitrary bounded continuous initial data, without differentiating those data.
-/

namespace NumStability

open scoped ContDiff

/-- All moments have every finite joint regularity order on positive time. The
induction is simultaneous in the moment index, since differentiation raises it. -/
theorem contDiffOn_gaussianHeatMoment_nat (regularity order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (hdiffusion : 0 < diffusion) :
    ContDiffOn ℝ regularity
      (fun point : ℝ × ℝ => gaussianHeatMoment order diffusion initial point.1 point.2)
      {point : ℝ × ℝ | 0 < point.2} := by
  induction regularity generalizing order with
  | zero =>
      exact contDiffOn_zero.mpr
        (differentiableOn_gaussianHeatMoment order diffusion initial hdiffusion).continuousOn
  | succ regularity ih =>
      have htime : ContDiffOn ℝ regularity (fun point : ℝ × ℝ => point.2)
          {point : ℝ × ℝ | 0 < point.2} := contDiffOn_snd
      have hspaceCoefficient : ContDiffOn ℝ regularity
          (fun point : ℝ × ℝ =>
            (order : ℝ) * gaussianHeatMoment (order - 1) diffusion initial point.1 point.2 -
              gaussianHeatMoment (order + 1) diffusion initial point.1 point.2 /
                (2 * diffusion * point.2)) {point : ℝ × ℝ | 0 < point.2} :=
        (contDiffOn_const.mul (ih (order - 1))).sub
          ((ih (order + 1)).div (contDiffOn_const.mul htime)
            (fun point hpoint => ne_of_gt (mul_pos (mul_pos (by norm_num) hdiffusion) hpoint)))
      have htimeCoefficient : ContDiffOn ℝ regularity
          (fun point : ℝ × ℝ =>
            gaussianHeatMoment (order + 2) diffusion initial point.1 point.2 /
                (4 * diffusion * point.2 ^ 2) -
              gaussianHeatMoment order diffusion initial point.1 point.2 / (2 * point.2))
          {point : ℝ × ℝ | 0 < point.2} :=
        ((ih (order + 2)).div (contDiffOn_const.mul (htime.pow 2))
          (fun point hpoint => ne_of_gt
            (mul_pos (mul_pos (by norm_num) hdiffusion) (sq_pos_of_pos hpoint)))).sub
          ((ih order).div (contDiffOn_const.mul htime)
            (fun point hpoint => ne_of_gt (mul_pos (by norm_num) hpoint)))
      have hformula : ContDiffOn ℝ regularity
          (gaussianHeatMomentDerivative order diffusion initial)
          {point : ℝ × ℝ | 0 < point.2} :=
        (hspaceCoefficient.smul_const (ContinuousLinearMap.fst ℝ ℝ ℝ)).add
          (htimeCoefficient.smul_const (ContinuousLinearMap.snd ℝ ℝ ℝ))
      have hderivative : ContDiffOn ℝ regularity
          (fderiv ℝ (fun point : ℝ × ℝ =>
            gaussianHeatMoment order diffusion initial point.1 point.2))
          {point : ℝ × ℝ | 0 < point.2} :=
        hformula.congr (fun point hpoint =>
          fderiv_gaussianHeatMoment order diffusion point.1 point.2 initial hdiffusion hpoint)
      have hsuccessor := (contDiffOn_succ_iff_fderiv_of_isOpen
        (isOpen_lt continuous_const continuous_snd)).mpr
          ⟨differentiableOn_gaussianHeatMoment order diffusion initial hdiffusion,
            by simp, hderivative⟩
      simpa only [Nat.cast_add, Nat.cast_one] using hsuccessor

/-- Every displacement moment of the actual convolution is jointly smooth in
space and positive time for arbitrary bounded continuous initial data. -/
theorem contDiffOn_gaussianHeatMoment (order : ℕ) (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (hdiffusion : 0 < diffusion) :
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => gaussianHeatMoment order diffusion initial point.1 point.2)
      {point : ℝ × ℝ | 0 < point.2} :=
  contDiffOn_infty.mpr (fun regularity =>
    contDiffOn_gaussianHeatMoment_nat regularity order diffusion initial hdiffusion)

/-- The actual heat evolution is jointly smooth throughout positive time. -/
theorem contDiffOn_gaussianHeatFlow (diffusion : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ) (hdiffusion : 0 < diffusion) :
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => gaussianHeatFlow diffusion initial point.1 point.2)
      {point : ℝ × ℝ | 0 < point.2} :=
  (contDiffOn_gaussianHeatMoment 0 diffusion initial hdiffusion).congr
    (fun point hpoint => (gaussianHeatMoment_zero diffusion point.1 point.2 initial hpoint).symm)

/-- Unbundled bounded continuous data have the same full joint smoothness. -/
theorem contDiffOn_gaussianHeatFlow_of_isBoundedContinuousHeatData (diffusion : ℝ)
    (initial : ℝ → ℝ) (hdiffusion : 0 < diffusion)
    (hinitial : IsBoundedContinuousHeatData initial) :
    ContDiffOn ℝ ∞
      (fun point : ℝ × ℝ => gaussianHeatFlow diffusion initial point.1 point.2)
      {point : ℝ × ℝ | 0 < point.2} := by
  obtain ⟨bundled, rfl⟩ := hinitial
  exact contDiffOn_gaussianHeatFlow diffusion bundled hdiffusion

end NumStability
