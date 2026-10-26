/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Analysis.Calculus.ContDiff.RCLike
import Mathlib.Tactic.Linarith

/-!
# Derivative variation budgets near a smooth point

Twice continuous differentiability at a point supplies a positive closed
neighborhood where derivatives exist and vary by a uniform linear budget.
The producer uses Mathlib's local Lipschitz consequence of continuous
differentiability, applied to the derivative.
-/

namespace NumStability

theorem contDiffAt_two_exists_local_deriv_variation
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f : ℝ → E) (center : ℝ) (hf : ContDiffAt ℝ 2 f center) :
    ∃ radius K : ℝ, 0 < radius ∧ 0 ≤ K ∧
      ∀ y ∈ Set.Icc (center - radius) (center + radius),
        HasDerivAt f (deriv f y) y ∧ ‖deriv f y - deriv f center‖ ≤ K * |y - center| := by
  have hderivSmooth : ContDiffAt ℝ 1 (deriv f) center := hf.derivWithin (by norm_num)
  obtain ⟨K, region, hregion, hLip⟩ := hderivSmooth.exists_lipschitzOnWith
  have hdiff : ∀ᶠ y in nhds center, DifferentiableAt ℝ f y :=
    (hf.eventually (by simp)).mono (fun y hy => hy.differentiableAt (by decide))
  have hneighborhood : region ∩ {y | DifferentiableAt ℝ f y} ∈ nhds center := Filter.inter_mem hregion hdiff
  obtain ⟨ε, hε, hinside⟩ := Metric.mem_nhds_iff.mp hneighborhood
  refine ⟨ε / 2, K, by linarith, K.coe_nonneg, ?_⟩
  intro y hy
  have habs : |y - center| ≤ ε / 2 := abs_le.mpr ⟨by linarith [hy.1], by linarith [hy.2]⟩
  have hyinside : y ∈ region ∩ {z | DifferentiableAt ℝ f z} := hinside (by
    rw [Metric.mem_ball, Real.dist_eq]
    linarith)
  constructor
  · exact hyinside.2.hasDerivAt
  · have hcenter : center ∈ region := mem_of_mem_nhds hregion
    simpa only [Real.norm_eq_abs] using hLip.norm_sub_le hyinside.1 hcenter

end NumStability
