/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPotentialRegularity

/-!
# Positive-time regularity of the same finite action potential

Global action comparison proves that the potential decreases in time.
Rescaling an actual minimizing foot gives a global time Lipschitz bound on
positive times. The bound uses only the already proved analytic constant;
it is not an encountered-wave propagation bound.
-/

noncomputable section
open Set

namespace NumStability

theorem leveque04_burgersFiniteActionPotential_time_antitone {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) (hwidth : 0 ≤ width) :
    AntitoneOn (fun time => leveque04_burgersFiniteActionPotential old origin width x time)
      (Ioi 0) := by
  intro s hs t _ hst
  change 0 < s at hs
  let foot := leveque04_burgersFiniteActionFoot old origin width x s
  have ht : 0 < t := hs.trans_le hst
  have hm := leveque04_burgersFiniteActionPotential_le old origin width x t hwidth ht foot
  have hc : (x - foot) ^ 2 / (2 * t) ≤ (x - foot) ^ 2 / (2 * s) :=
    div_le_div_of_nonneg_left (sq_nonneg _) (by positivity) (by linarith)
  change leveque04_burgersFiniteActionPotential old origin width x t ≤
    leveque04_burgersInitialPrimitive old origin width foot + (x - foot) ^ 2 / (2 * s)
  linarith

/-- Rescale the later actual foot to compare with an earlier positive time. -/
theorem leveque04_burgersFiniteActionPotential_time_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x s t : ℝ)
    (hwidth : 0 ≤ width) (hs : 0 < s) (hst : s ≤ t) :
    leveque04_burgersFiniteActionPotential old origin width x s -
      leveque04_burgersFiniteActionPotential old origin width x t ≤
        leveque04_burgersPrimitiveBound old ^ 2 * (t - s) := by
  have ht : 0 < t := hs.trans_le hst
  let foot := leveque04_burgersFiniteActionFoot old origin width x t
  let u := leveque04_burgersFiniteActionVelocity old origin width x t
  let K := leveque04_burgersPrimitiveBound old
  have hK : 0 ≤ K := leveque04_burgersPrimitiveBound_nonneg old
  have hu : |u| ≤ K := leveque04_burgersFiniteActionVelocity_abs_le old origin width x t hwidth ht
  have hfoot : x - foot = u * t := by
    dsimp [u, foot, leveque04_burgersFiniteActionVelocity]
    field_simp [ne_of_gt ht]
  have hcost (r : ℝ) (hr : 0 < r) :
      (x - (x - u * r)) ^ 2 / (2 * r) = u ^ 2 * r / 2 := by
    field_simp [ne_of_gt hr]
    ring
  have hm := leveque04_burgersFiniteActionPotential_le old origin width x s hwidth hs (x - u * s)
  rw [hcost s hs] at hm
  have hPt : leveque04_burgersFiniteActionPotential old origin width x t =
      leveque04_burgersInitialPrimitive old origin width foot + u ^ 2 * t / 2 := by
    change leveque04_burgersInitialPrimitive old origin width foot + (x - foot) ^ 2 / (2 * t) = _
    rw [hfoot]
    field_simp [ne_of_gt ht]
  have hdiff : (x - u * s) - foot = u * (t - s) := by nlinarith [hfoot]
  have hlip := leveque04_burgersInitialPrimitive_abs_sub_le old origin width (x - u * s) foot
  rw [hdiff, abs_mul, abs_of_nonneg (sub_nonneg.mpr hst)] at hlip
  have hlinear := (le_abs_self _).trans hlip
  have hku : K * |u| ≤ K ^ 2 := by
    nlinarith [mul_le_mul_of_nonneg_left hu hK]
  have hproduct := mul_le_mul_of_nonneg_right hku (sub_nonneg.mpr hst)
  have hnonneg : 0 ≤ u ^ 2 * (t - s) / 2 :=
    div_nonneg (mul_nonneg (sq_nonneg _) (sub_nonneg.mpr hst)) (by norm_num)
  change leveque04_burgersFiniteActionPotential old origin width x s -
    leveque04_burgersFiniteActionPotential old origin width x t ≤ K ^ 2 * (t - s)
  nlinarith

theorem leveque04_burgersFiniteActionPotential_time_abs_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x s t : ℝ)
    (hwidth : 0 ≤ width) (hs : 0 < s) (ht : 0 < t) :
    |leveque04_burgersFiniteActionPotential old origin width x s -
      leveque04_burgersFiniteActionPotential old origin width x t| ≤
        leveque04_burgersPrimitiveBound old ^ 2 * |s - t| := by
  have hant := leveque04_burgersFiniteActionPotential_time_antitone old origin width x hwidth
  rcases le_total s t with hst | hts
  · rw [abs_of_nonneg (sub_nonneg.mpr (hant hs ht hst)),
      abs_of_nonpos (sub_nonpos.mpr hst), neg_sub]
    exact leveque04_burgersFiniteActionPotential_time_sub_le old origin width x s t hwidth hs hst
  · rw [abs_of_nonpos (sub_nonpos.mpr (hant ht hs hts)), neg_sub,
      abs_of_nonneg (sub_nonneg.mpr hts)]
    exact leveque04_burgersFiniteActionPotential_time_sub_le old origin width x t s hwidth ht hts

theorem leveque04_burgersFiniteActionPotential_time_lipschitzOn {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) (hwidth : 0 ≤ width) :
    LipschitzOnWith ⟨leveque04_burgersPrimitiveBound old ^ 2, sq_nonneg _⟩
      (fun time => leveque04_burgersFiniteActionPotential old origin width x time) (Ioi 0) := by
  apply LipschitzOnWith.of_dist_le_mul
  intro s hs t ht
  simpa only [Real.dist_eq, NNReal.coe_mk] using
    leveque04_burgersFiniteActionPotential_time_abs_sub_le old origin width x s t hwidth hs ht

end NumStability
