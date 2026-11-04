/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.IntrinsicBurgersWaveBound
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPropagationBound

/-!
# Intrinsic encountered waves of the actual finite-action Burgers field

A local rarefaction formula forces a constant actual foot on an open spatial
neighborhood. Such a plateau originates at an original nonzero jump, even after
unrestricted interactions. Actual one-sided trace uniqueness then identifies
all genuine shocks with the trace pairs used by the propagation bound. The
resulting equivalence introduces no stronger speed assumption.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

/-- Every point inside an actual open label fan has an intrinsic local patch. -/
theorem leveque04_burgersFiniteAction_localRarefactionPatch_of_open_fan {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x label : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hleft : leveque04_burgersFiniteActionLabelLeft old origin width label time < x)
    (hright : x < leveque04_burgersFiniteActionLabelRight old origin width label time) :
    Burgers.LocalRarefactionPatch
      (leveque04_burgersFiniteActionEvolution old origin width) x time := by
  let L := leveque04_burgersFiniteActionLabelLeft old origin width label time
  let R := leveque04_burgersFiniteActionLabelRight old origin width label time
  let ε := min (x - L) (R - x) / 2
  change L < x at hleft
  change x < R at hright
  have hε : 0 < ε :=
    div_pos (lt_min (sub_pos.mpr hleft) (sub_pos.mpr hright)) (by norm_num)
  refine ⟨ε, hε, label, ?_⟩
  intro y hy
  have hεL : ε ≤ (x - L) / 2 := div_le_div_of_nonneg_right (min_le_left _ _) (by norm_num)
  have hεR : ε ≤ (R - x) / 2 := div_le_div_of_nonneg_right (min_le_right _ _) (by norm_num)
  exact (leveque04_burgersFiniteActionEvolution_label_plateau old origin width label time y
    hwidth htime (by change L < y; linarith [hy.1])
      (by change y < R; linarith [hy.2])).2

/-- A local affine fan patch determines its actual characteristic foot. -/
theorem leveque04_burgersFiniteActionFoot_eq_of_local_fan_formula {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time y center : ℝ)
    (htime : 0 < time)
    (hformula : leveque04_burgersFiniteActionEvolution old origin width y time =
      (y - center) / time) :
    leveque04_burgersFiniteActionFoot old origin width y time = center := by
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width y time htime,
    leveque04_burgersFiniteActionVelocity] at hformula
  have hnum := (div_left_inj' htime.ne').mp hformula
  linarith

/-- Every intrinsic patch lies in a surviving fan of an actual original jump.
The center is identified, rather than chosen from a representation afterward. -/
theorem leveque04_burgersFiniteAction_local_fan_formula_origin {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x ε center : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (hε : 0 < ε)
    (hformula : ∀ y ∈ Ioo (x - ε) (x + ε),
      leveque04_burgersFiniteActionEvolution old origin width y time = (y - center) / time) :
    ∃ j : Fin (N + 1),
      center = leveque04_burgersActionFace origin width j.val ∧
      leveque04_burgersActionState old (j.val + 1) ≠ leveque04_burgersActionState old j.val ∧
      leveque04_burgersFiniteActionLabelLeft old origin width center time < x ∧
      x < leveque04_burgersFiniteActionLabelRight old origin width center time := by
  have hfoot (y : ℝ) (hy : y ∈ Ioo (x - ε) (x + ε)) :
      leveque04_burgersFiniteActionFoot old origin width y time = center :=
    leveque04_burgersFiniteActionFoot_eq_of_local_fan_formula old origin width time y center
      htime (hformula y hy)
  have hminus := hfoot (x - ε / 2) ⟨by linarith, by linarith⟩
  have hplus := hfoot (x + ε / 2) ⟨by linarith, by linarith⟩
  have hL : leveque04_burgersFiniteActionLabelLeft old origin width center time ≤ x - ε / 2 := by
    by_contra hn
    have hf := (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width center time (x - ε / 2) hwidth htime).1 (lt_of_not_ge hn)
    rw [hminus] at hf
    exact lt_irrefl _ hf
  have hR : x + ε / 2 ≤ leveque04_burgersFiniteActionLabelRight old origin width center time := by
    by_contra hn
    have hf := (leveque04_burgersFiniteActionLabelBoundaries_regions
      old origin width center time (x + ε / 2) hwidth htime).2.2.2 (lt_of_not_ge hn)
    rw [hplus] at hf
    exact lt_irrefl _ hf
  have hleft : leveque04_burgersFiniteActionLabelLeft old origin width center time < x := by linarith
  have hright : x < leveque04_burgersFiniteActionLabelRight old origin width center time := by linarith
  obtain ⟨j, hj, hnonzero⟩ := leveque04_burgersFiniteActionLabelPlateau_exists_initial_jump
    old origin width center time hwidth htime (hleft.trans hright)
  exact ⟨j, hj, hnonzero, hleft, hright⟩

/-- The intrinsic local fan condition exactly describes the actual open fan
intervals of this field, with no restriction on interactions or positive time. -/
theorem leveque04_burgersFiniteAction_localRarefactionPatch_iff {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Burgers.LocalRarefactionPatch
        (leveque04_burgersFiniteActionEvolution old origin width) x time ↔
      ∃ j : Fin (N + 1),
        leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time < x ∧
        x < leveque04_burgersFiniteActionLabelRight old origin width
          (leveque04_burgersActionFace origin width j.val) time := by
  constructor
  · rintro ⟨ε, hε, center, hf⟩
    obtain ⟨j, hj, _, hL, hR⟩ := leveque04_burgersFiniteAction_local_fan_formula_origin
      old origin width time x ε center hwidth htime hε hf
    exact ⟨j, by simpa only [hj] using hL, by simpa only [hj] using hR⟩
  · rintro ⟨j, hL, hR⟩
    exact leveque04_burgersFiniteAction_localRarefactionPatch_of_open_fan
      old origin width time x _ hwidth htime hL hR

/-- Every actual trace pair equals the represented left trace and actual right
representative, including shocks created by interactions. -/
theorem leveque04_burgersFiniteAction_spatialTracePair_iff {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x left right : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Burgers.SpatialTracePair (leveque04_burgersFiniteActionEvolution old origin width)
        x time left right ↔
      left = (x - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time ∧
      right = leveque04_burgersFiniteActionEvolution old origin width x time := by
  have hactual : Burgers.SpatialTracePair
      (leveque04_burgersFiniteActionEvolution old origin width) x time
      ((x - sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)) / time)
      (leveque04_burgersFiniteActionEvolution old origin width x time) :=
    ⟨leveque04_burgersFiniteActionEvolution_leftTrace old origin width x time hwidth htime,
      leveque04_burgersFiniteActionEvolution_rightTrace old origin width x time hwidth htime⟩
  constructor
  · intro h
    exact h.unique hactual
  · rintro ⟨rfl, rfl⟩
    exact hactual

/-- The existing propagation premise bounds exactly all intrinsic actual shocks
and fan patches. Neither direction adds a bound on constant-state velocities. -/
theorem leveque04_burgersFiniteActionPropagationBound_iff_intrinsic {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound : ℝ)
    (hwidth : 0 < width) :
    leveque04_burgersFiniteActionPropagationBound old origin width horizon bound ↔
      Burgers.IntrinsicWaveBound
        (leveque04_burgersFiniteActionEvolution old origin width) horizon bound := by
  constructor
  · rintro ⟨hbound, hb⟩
    refine ⟨hbound, ?_⟩
    intro time ht
    refine ⟨?_, ?_⟩
    · intro x left right htr hshock
      obtain ⟨rfl, rfl⟩ := (leveque04_burgersFiniteAction_spatialTracePair_iff
        old origin width time x left right hwidth.le ht.1).1 htr
      exact (hb time ht).1 x hshock
    · intro x hpatch
      obtain ⟨j, hL, hR⟩ := (leveque04_burgersFiniteAction_localRarefactionPatch_iff
        old origin width time x hwidth.le ht.1).1 hpatch
      rw [(leveque04_burgersFiniteActionEvolution_label_plateau old origin width
        (leveque04_burgersActionFace origin width j.val) time x hwidth.le ht.1 hL hR).2]
      exact (hb time ht).2 j x hL hR
  · rintro ⟨hbound, hb⟩
    refine ⟨hbound, ?_⟩
    intro time ht
    refine ⟨?_, ?_⟩
    · intro x hshock
      apply (hb time ht).1 x _ _ ?_ hshock
      exact (leveque04_burgersFiniteAction_spatialTracePair_iff old origin width time x _ _
        hwidth.le ht.1).2 ⟨rfl, rfl⟩
    · intro j x hL hR
      have hpatch := leveque04_burgersFiniteAction_localRarefactionPatch_of_open_fan
        old origin width time x (leveque04_burgersActionFace origin width j.val) hwidth.le ht.1 hL hR
      have hv := (hb time ht).2 x hpatch
      rwa [(leveque04_burgersFiniteActionEvolution_label_plateau old origin width
        (leveque04_burgersActionFace origin width j.val) time x hwidth.le ht.1 hL hR).2] at hv

end NumStability
