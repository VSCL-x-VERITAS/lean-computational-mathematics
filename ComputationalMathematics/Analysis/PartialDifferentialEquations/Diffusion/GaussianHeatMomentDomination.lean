/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatMomentCalculus
import Mathlib.Analysis.Normed.Operator.Prod

/-!
# Domination of the joint heat moment derivatives

A finite sum of integrable moment envelopes bounds the actual operator norm
of each joint integrand derivative on a common space-time neighborhood.
-/

namespace NumStability

open MeasureTheory

noncomputable def gaussianHeatMomentDifferentialEnvelope (order : ℕ)
    (diffusion lowerTime upperTime radius bound location : ℝ) : ℝ :=
  ((order : ℝ) * gaussianHeatMomentEnvelope (order - 1)
      diffusion lowerTime upperTime radius bound location +
    gaussianHeatMomentEnvelope (order + 1) diffusion lowerTime upperTime radius bound location /
      (2 * diffusion * lowerTime)) +
    (gaussianHeatMomentEnvelope (order + 2) diffusion lowerTime upperTime radius bound location /
        (4 * diffusion * lowerTime ^ 2) +
      gaussianHeatMomentEnvelope order diffusion lowerTime upperTime radius bound location /
        (2 * lowerTime))

theorem integrable_gaussianHeatMomentDifferentialEnvelope (order : ℕ)
    (diffusion lowerTime upperTime radius bound : ℝ)
    (hdiffusion : 0 < diffusion) (hupper : 0 < upperTime) :
    Integrable (gaussianHeatMomentDifferentialEnvelope order
      diffusion lowerTime upperTime radius bound) := by
  have hE (k : ℕ) := integrable_gaussianHeatMomentEnvelope k
    diffusion lowerTime upperTime radius bound hdiffusion hupper
  exact (((hE (order - 1)).const_mul (order : ℝ)).add
    ((hE (order + 1)).div_const (2 * diffusion * lowerTime))).add
      (((hE (order + 2)).div_const (4 * diffusion * lowerTime ^ 2)).add
        ((hE order).div_const (2 * lowerTime)))

private theorem norm_div_le_of_lower_bound (value bound lower denominator : ℝ)
    (hvalue : ‖value‖ ≤ bound) (hbound : 0 ≤ bound)
    (hlower : 0 < lower) (hdenominator : lower ≤ denominator) :
    ‖value / denominator‖ ≤ bound / lower := by
  have hpos := hlower.trans_le hdenominator
  calc
    ‖value / denominator‖ = ‖value‖ / denominator := by
      rw [norm_div, Real.norm_of_nonneg hpos.le]
    _ ≤ bound / denominator := (div_le_div_iff_of_pos_right hpos).2 hvalue
    _ ≤ bound / lower := div_le_div_of_nonneg_left hbound hlower hdenominator

theorem norm_gaussianHeatMomentDifferential_le_envelope (order : ℕ)
    (diffusion lowerTime upperTime radius space time location : ℝ)
    (initial : BoundedContinuousFunction ℝ ℝ)
    (hdiffusion : 0 < diffusion) (hlower : 0 < lowerTime)
    (hbefore : lowerTime ≤ time) (hafter : time ≤ upperTime)
    (hradius : 0 ≤ radius) (hspace : |space| ≤ radius) :
    ‖gaussianHeatMomentDifferential order diffusion initial (space, time) location‖ ≤
      gaussianHeatMomentDifferentialEnvelope order
        diffusion lowerTime upperTime radius ‖initial‖ location := by
  let I := fun k => gaussianHeatMomentIntegrand k diffusion initial (space, time) location
  let E := fun k => gaussianHeatMomentEnvelope k diffusion lowerTime upperTime radius ‖initial‖ location
  let A := gaussianHeatMomentSpaceCoefficient order diffusion initial (space, time) location
  let B := gaussianHeatMomentTimeCoefficient order diffusion initial (space, time) location
  have hI (k : ℕ) : ‖I k‖ ≤ E k :=
    norm_gaussianHeatMoment_integrand_le_envelope k diffusion lowerTime upperTime radius
      space time location initial hdiffusion hlower hbefore hafter hradius hspace
  have hE (k : ℕ) : 0 ≤ E k := gaussianHeatMomentEnvelope_nonneg k
    diffusion lowerTime upperTime radius ‖initial‖ location hradius (norm_nonneg initial)
  have hspaceDen : 2 * diffusion * lowerTime ≤ 2 * diffusion * time :=
    mul_le_mul_of_nonneg_left hbefore (by positivity)
  have htimeDen : 4 * diffusion * lowerTime ^ 2 ≤ 4 * diffusion * time ^ 2 :=
    mul_le_mul_of_nonneg_left (pow_le_pow_left₀ hlower.le hbefore 2) (by positivity)
  have hlastDen : 2 * lowerTime ≤ 2 * time :=
    mul_le_mul_of_nonneg_left hbefore (by norm_num)
  have hA : ‖A‖ ≤ (order : ℝ) * E (order - 1) + E (order + 1) / (2 * diffusion * lowerTime) := by
    change ‖(order : ℝ) * I (order - 1) - I (order + 1) / (2 * diffusion * time)‖ ≤ _
    apply (norm_sub_le _ _).trans
    apply add_le_add
    · rw [norm_mul, Real.norm_of_nonneg (Nat.cast_nonneg order)]
      exact mul_le_mul_of_nonneg_left (hI (order - 1)) (Nat.cast_nonneg order)
    · exact norm_div_le_of_lower_bound _ _ _ _ (hI (order + 1)) (hE (order + 1))
        (by positivity) hspaceDen
  have hB : ‖B‖ ≤ E (order + 2) / (4 * diffusion * lowerTime ^ 2) + E order / (2 * lowerTime) := by
    change ‖I (order + 2) / (4 * diffusion * time ^ 2) - I order / (2 * time)‖ ≤ _
    exact (norm_sub_le _ _).trans (add_le_add
      (norm_div_le_of_lower_bound _ _ _ _ (hI (order + 2)) (hE (order + 2))
        (by positivity) htimeDen)
      (norm_div_le_of_lower_bound _ _ _ _ (hI order) (hE order) (by positivity) hlastDen))
  have hfst (c : ℝ) : ‖c • ContinuousLinearMap.fst ℝ ℝ ℝ‖ ≤ ‖c‖ :=
    (norm_smul_le _ _).trans (mul_le_of_le_one_right (norm_nonneg c)
      (ContinuousLinearMap.norm_fst_le ℝ ℝ ℝ))
  have hsnd (c : ℝ) : ‖c • ContinuousLinearMap.snd ℝ ℝ ℝ‖ ≤ ‖c‖ :=
    (norm_smul_le _ _).trans (mul_le_of_le_one_right (norm_nonneg c)
      (ContinuousLinearMap.norm_snd_le ℝ ℝ ℝ))
  change ‖A • ContinuousLinearMap.fst ℝ ℝ ℝ + B • ContinuousLinearMap.snd ℝ ℝ ℝ‖ ≤ _
  exact ((norm_add_le _ _).trans (add_le_add (hfst A) (hsnd B))).trans (add_le_add hA hB)

end NumStability
