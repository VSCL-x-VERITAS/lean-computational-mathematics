/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionLabelBoundaries
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionTimeCone

/-!
# Time regularity of the actual finite-action label boundaries

Two true action minima and the initial primitive's Lipschitz bound give
cross-time order of the SAME selected feet. Both actual label boundaries are
therefore globally Lipschitz in time, including their initial anchors and
constant past extension. This establishes genuine absolute-continuity
regularity for subsequent wave-speed arguments. The analytic constant K is
not used as a replacement for an arbitrary encountered propagation bound S.
-/

noncomputable section
open Set
open scoped NNReal

namespace NumStability

theorem leveque04_burgersFiniteActionFoot_timeCone_ordered {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width s t x₁ x₂ : ℝ)
    (hwidth : 0 ≤ width) (hs : 0 < s) (ht : 0 < t)
    (hcone : leveque04_burgersPrimitiveBound old * |t - s| < x₂ - x₁) :
    leveque04_burgersFiniteActionFoot old origin width x₁ s ≤
      leveque04_burgersFiniteActionFoot old origin width x₂ t := by
  exact quadraticAction_minimizers_timeCone_ordered (leveque04_burgersInitialPrimitive old origin width)
    (leveque04_burgersPrimitiveBound old) s t x₁ x₂
    (leveque04_burgersFiniteActionFoot old origin width x₁ s)
    (leveque04_burgersFiniteActionFoot old origin width x₂ t) hs ht
    (fun y z => leveque04_burgersInitialPrimitive_abs_sub_le old origin width y z)
    (fun y => leveque04_burgersFiniteActionFoot_global_min old origin width x₁ s hwidth hs y)
    (fun y => leveque04_burgersFiniteActionFoot_global_min old origin width x₂ t hwidth ht y) hcone

private theorem positive_time_bounds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label s t : ℝ)
    (hwidth : 0 ≤ width) (hs : 0 < s) (ht : 0 < t) :
    |leveque04_burgersFiniteActionLabelLeft old origin width label s -
      leveque04_burgersFiniteActionLabelLeft old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| ∧
    |leveque04_burgersFiniteActionLabelRight old origin width label s -
      leveque04_burgersFiniteActionLabelRight old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| := by
  let F := fun x => leveque04_burgersFiniteActionFoot old origin width x s
  let G := fun x => leveque04_burgersFiniteActionFoot old origin width x t
  let K := leveque04_burgersPrimitiveBound old
  have hF (x : ℝ) : |x - F x| ≤ K * s :=
    leveque04_burgersFiniteActionFoot_displacement_le old origin width x s hwidth hs
  have hG (x : ℝ) : |x - G x| ≤ K * t :=
    leveque04_burgersFiniteActionFoot_displacement_le old origin width x t hwidth ht
  have hmF : Monotone F := leveque04_burgersFiniteActionFoot_monotone old origin width s hwidth hs
  have hmG : Monotone G := leveque04_burgersFiniteActionFoot_monotone old origin width t hwidth ht
  have hFG (x y : ℝ) (hxy : K * |t - s| < y - x) : F x ≤ G y :=
    leveque04_burgersFiniteActionFoot_timeCone_ordered old origin width s t x y hwidth hs ht hxy
  have hGF (x y : ℝ) (hxy : K * |t - s| < y - x) : G x ≤ F y := by
    apply leveque04_burgersFiniteActionFoot_timeCone_ordered old origin width t s x y hwidth ht hs
    rwa [abs_sub_comm]
  have hL := footThresholdLeft_sub_le_of_timeCone F G label (K * s) (K * t) (K * |t - s|) hmG hF hG hFG
  have hL' := footThresholdLeft_sub_le_of_timeCone G F label (K * t) (K * s) (K * |t - s|) hmF hG hF hGF
  have hR := footThresholdRight_sub_le_of_timeCone F G label (K * s) (K * t) (K * |t - s|) hmF hF hG hFG
  have hR' := footThresholdRight_sub_le_of_timeCone G F label (K * t) (K * s) (K * |t - s|) hmG hG hF hGF
  simp only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
    if_neg (not_le_of_gt hs), if_neg (not_le_of_gt ht)]
  rw [abs_sub_comm s t]
  exact ⟨abs_le.mpr ⟨by linarith, hL'⟩, abs_le.mpr ⟨by linarith, hR'⟩⟩

private theorem cross_zero_bound (value label K s t : ℝ) (hK : 0 ≤ K)
    (hs : s ≤ 0) (ht : 0 < t)
    (hvalue : value ∈ Icc (label - K * t) (label + K * t)) :
    |label - value| ≤ K * |s - t| := by
  have hb : |label - value| ≤ K * t := abs_le.mpr ⟨by linarith [hvalue.2], by linarith [hvalue.1]⟩
  have htime : t ≤ |s - t| := by
    rw [abs_of_nonpos (by linarith : s - t ≤ 0)]
    linarith
  exact hb.trans (mul_le_mul_of_nonneg_left htime hK)

private theorem ordered_time_bounds {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label s t : ℝ)
    (hwidth : 0 ≤ width) (hst : s ≤ t) :
    |leveque04_burgersFiniteActionLabelLeft old origin width label s -
      leveque04_burgersFiniteActionLabelLeft old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| ∧
    |leveque04_burgersFiniteActionLabelRight old origin width label s -
      leveque04_burgersFiniteActionLabelRight old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| := by
  by_cases ht : t ≤ 0
  · simp only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
      if_pos ht, if_pos (hst.trans ht), sub_self, abs_zero]
    exact ⟨mul_nonneg (leveque04_burgersPrimitiveBound_nonneg old) (abs_nonneg _),
      mul_nonneg (leveque04_burgersPrimitiveBound_nonneg old) (abs_nonneg _)⟩
  · have htpos : 0 < t := lt_of_not_ge ht
    by_cases hs : s ≤ 0
    · have hb := leveque04_burgersFiniteActionLabelBoundaries_bounds old origin width label t hwidth htpos
      have hL := cross_zero_bound _ label (leveque04_burgersPrimitiveBound old) s t
        (leveque04_burgersPrimitiveBound_nonneg old) hs htpos hb.1
      have hR := cross_zero_bound _ label (leveque04_burgersPrimitiveBound old) s t
        (leveque04_burgersPrimitiveBound_nonneg old) hs htpos hb.2
      simpa only [leveque04_burgersFiniteActionLabelLeft, leveque04_burgersFiniteActionLabelRight,
        if_pos hs, if_neg ht] using And.intro hL hR
    · exact positive_time_bounds old origin width label s t hwidth (lt_of_not_ge hs) htpos

theorem leveque04_burgersFiniteActionLabelBoundaries_time_abs_sub_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label s t : ℝ) (hwidth : 0 ≤ width) :
    |leveque04_burgersFiniteActionLabelLeft old origin width label s -
      leveque04_burgersFiniteActionLabelLeft old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| ∧
    |leveque04_burgersFiniteActionLabelRight old origin width label s -
      leveque04_burgersFiniteActionLabelRight old origin width label t| ≤
        leveque04_burgersPrimitiveBound old * |s - t| := by
  rcases le_total s t with hst | hts
  · exact ordered_time_bounds old origin width label s t hwidth hst
  · simpa only [abs_sub_comm] using ordered_time_bounds old origin width label t s hwidth hts

theorem leveque04_burgersFiniteActionLabelBoundaries_time_lipschitz {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width label : ℝ) (hwidth : 0 ≤ width) :
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old, leveque04_burgersPrimitiveBound_nonneg old⟩
      (leveque04_burgersFiniteActionLabelLeft old origin width label) ∧
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old, leveque04_burgersPrimitiveBound_nonneg old⟩
      (leveque04_burgersFiniteActionLabelRight old origin width label) := by
  constructor
  · apply LipschitzWith.of_dist_le_mul
    intro s t
    simpa only [Real.dist_eq, NNReal.coe_mk] using
      (leveque04_burgersFiniteActionLabelBoundaries_time_abs_sub_le old origin width label s t hwidth).1
  · apply LipschitzWith.of_dist_le_mul
    intro s t
    simpa only [Real.dist_eq, NNReal.coe_mk] using
      (leveque04_burgersFiniteActionLabelBoundaries_time_abs_sub_le old origin width label s t hwidth).2

end NumStability
