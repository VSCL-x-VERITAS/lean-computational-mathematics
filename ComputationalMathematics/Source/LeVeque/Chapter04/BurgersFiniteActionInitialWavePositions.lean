/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionNearFace
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPropagationBound

/-!
# Genuine initial wave positions of the actual finite Burgers field

At a sufficiently small positive time the actual physical S-cones and analytic
minimizer displacement K put all boundary feet in the two adjacent original
cells. Ascending corners then give the original characteristic fan edges;
descending corners give the original mean-speed shock position. This small-time
lemma is used only to extract necessary initial-speed information. The full
Godunov horizon remains unrestricted by K and may include interactions.
-/

noncomputable section
open Set

namespace NumStability

private theorem min_near_label {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time label bound y : ℝ)
    (hwidth : 0 < width) (htime : 0 < time)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
    (hx : |x - label| ≤ bound * time)
    (hsmall : (leveque04_burgersPrimitiveBound old + bound) * time < width) :
    y ∈ Ioo (label - width) (label + width) := by
  have hb := leveque04_burgersFiniteActionMinimizingFeet_displacement_le
    old origin width x time y hwidth.le htime hy
  have habs : |y - label| < width := by
    calc
      _ ≤ |y - x| + |x - label| := abs_sub_le y x label
      _ ≤ leveque04_burgersPrimitiveBound old * time + bound * time :=
        add_le_add (by simpa only [abs_sub_comm] using hb) hx
      _ = (leveque04_burgersPrimitiveBound old + bound) * time := (add_mul _ _ _).symm
      _ < width := hsmall
  constructor <;> linarith [(abs_lt.mp habs).1, (abs_lt.mp habs).2]

theorem leveque04_burgersFiniteAction_initialLabel_minimizers_nearFace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hjump : leveque04_burgersActionState old j.val ≠ leveque04_burgersActionState old (j.val + 1))
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (htime : time ∈ Ioc (0 : ℝ) horizon)
    (hsmall : (leveque04_burgersPrimitiveBound old + bound) * time < width) :
    (∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelLeft old origin width
          (leveque04_burgersActionFace origin width j.val) time) time,
      y ∈ Ioo (leveque04_burgersActionFace origin width j.val - width)
        (leveque04_burgersActionFace origin width j.val + width)) ∧
    (∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width
        (leveque04_burgersFiniteActionLabelRight old origin width
          (leveque04_burgersActionFace origin width j.val) time) time,
      y ∈ Ioo (leveque04_burgersActionFace origin width j.val - width)
        (leveque04_burgersActionFace origin width j.val + width)) := by
  have hc := leveque04_burgersFiniteActionPropagationBound_label_cones old origin width horizon bound time j
    hwidth hjump hprop ⟨htime.1.le, htime.2⟩
  exact ⟨fun y hy => min_near_label old origin width _ time _ bound y hwidth htime.1 hy hc.1 hsmall,
    fun y hy => min_near_label old origin width _ time _ bound y hwidth htime.1 hy hc.2 hsmall⟩

private theorem unique_bracket {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time label : ℝ)
    (hw : 0 < width) (ht : 0 < time)
    (hunique : ∀ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time,
      ∀ z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y = z)
    (hbracket : (∃ y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y ≤ label) ∧
      (∃ z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time, label ≤ z)) :
    sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width x time) = label ∧
      leveque04_burgersFiniteActionFoot old origin width x time = label := by
  obtain ⟨⟨y, hy, hyl⟩, ⟨z, hz, hlz⟩⟩ := hbracket
  have hyz := hunique y hy z hz
  have hly : label ≤ y := by rw [hyz]; exact hlz
  have hyeq := le_antisymm hyl hly
  have hi := leveque04_burgersFiniteActionMinimizingFeet_sInf_isLeast old origin width x time hw.le ht
  have hg := leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time
  exact ⟨(hunique _ hi.1 y hy).trans hyeq, (hunique _ hg y hy).trans hyeq⟩

theorem leveque04_burgersFiniteAction_initial_ascending_edge_positions {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (horder : leveque04_burgersActionState old j.val < leveque04_burgersActionState old (j.val + 1))
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (htime : time ∈ Ioc (0 : ℝ) horizon)
    (hsmall : (leveque04_burgersPrimitiveBound old + bound) * time < width) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val + leveque04_burgersActionState old j.val * time ∧
    leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val + leveque04_burgersActionState old (j.val + 1) * time := by
  let a := leveque04_burgersActionFace origin width j.val
  have hn := leveque04_burgersFiniteAction_initialLabel_minimizers_nearFace old origin width horizon bound time j
    hwidth (ne_of_lt horder) hprop htime hsmall
  have huL := fun y hy z hz => leveque04_burgersFiniteActionMinimizingFeet_eq_near_ascendingFace
    old origin width (leveque04_burgersFiniteActionLabelLeft old origin width a time) time y z j
    hwidth htime.1 horder.le hy hz (Ioo_subset_Icc_self (hn.1 y hy)) (Ioo_subset_Icc_self (hn.1 z hz))
  have huR := fun y hy z hz => leveque04_burgersFiniteActionMinimizingFeet_eq_near_ascendingFace
    old origin width (leveque04_burgersFiniteActionLabelRight old origin width a time) time y z j
    hwidth htime.1 horder.le hy hz (Ioo_subset_Icc_self (hn.2 y hy)) (Ioo_subset_Icc_self (hn.2 z hz))
  have hL := unique_bracket old origin width _ time a hwidth htime.1 huL
    (leveque04_burgersFiniteActionLabelLeft_minimizers_bracket old origin width a time hwidth.le htime.1)
  have hR := unique_bracket old origin width _ time a hwidth htime.1 huR
    (leveque04_burgersFiniteActionLabelRight_minimizers_bracket old origin width a time hwidth.le htime.1)
  exact ⟨leveque04_burgersFiniteActionLabelLeft_eq_characteristic_of_leastFoot_eq_face
      old origin width time j hwidth htime.1 hL.1,
    leveque04_burgersFiniteActionLabelRight_eq_characteristic_of_greatestFoot_eq_face
      old origin width time j hwidth htime.1 hR.2⟩

private theorem action_at_characteristic_foot (P : ℝ → ℝ) (a q x y time : ℝ)
    (ht : 0 < time) (hy : x = y + q * time) (hP : P y = P a + q * (y - a)) :
    P y + (x - y) ^ 2 / (2 * time) = P a + q * (x - a) - q ^ 2 * time / 2 := by
  rw [hP, hy]
  field_simp [ht.ne']
  ring

theorem leveque04_burgersFiniteAction_initial_descending_shock_position {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (horder : leveque04_burgersActionState old (j.val + 1) < leveque04_burgersActionState old j.val)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (htime : time ∈ Ioc (0 : ℝ) horizon)
    (hsmall : (leveque04_burgersPrimitiveBound old + bound) * time < width) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val +
        ((leveque04_burgersActionState old j.val + leveque04_burgersActionState old (j.val + 1)) / 2) * time := by
  let a := leveque04_burgersActionFace origin width j.val
  let x := leveque04_burgersFiniteActionLabelLeft old origin width a time
  let qL := leveque04_burgersActionState old j.val
  let qR := leveque04_burgersActionState old (j.val + 1)
  have hn := (leveque04_burgersFiniteAction_initialLabel_minimizers_nearFace old origin width horizon bound time j
    hwidth (Ne.symm (ne_of_lt horder)) hprop htime hsmall).1
  obtain ⟨_, y, z, hy, hz, hya, haz⟩ := leveque04_burgersFiniteAction_descendingFace_shock_minimizers
    old origin width time j hwidth htime.1 horder
  have hny := hn y hy
  have hnz := hn z hz
  have hxy := (leveque04_burgersFiniteAction_minimizer_nearFace_characteristics
    old origin width x time y j hwidth htime.1 hy).1 ⟨hny.1, hya⟩
  have hxz := (leveque04_burgersFiniteAction_minimizer_nearFace_characteristics
    old origin width x time z j hwidth htime.1 hz).2 ⟨haz, hnz.2⟩
  have hPy : leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersInitialPrimitive old origin width a + qL * (y - a) := by
    have hp := leveque04_burgersInitialPrimitive_nearFace old origin width y j hwidth (Ioo_subset_Icc_self hny)
    simpa only [max_eq_right (sub_nonpos.mpr hya.le), mul_zero, add_zero] using hp
  have hPz : leveque04_burgersInitialPrimitive old origin width z =
      leveque04_burgersInitialPrimitive old origin width a + qR * (z - a) := by
    have hp := leveque04_burgersInitialPrimitive_nearFace old origin width z j hwidth (Ioo_subset_Icc_self hnz)
    rw [max_eq_left (sub_nonneg.mpr haz.le)] at hp
    dsimp [a, qR]
    nlinarith
  have hY := action_at_characteristic_foot (leveque04_burgersInitialPrimitive old origin width)
    a qL x y time htime.1 hxy hPy
  have hZ := action_at_characteristic_foot (leveque04_burgersInitialPrimitive old origin width)
    a qR x z time htime.1 hxz hPz
  have hequal : leveque04_burgersAction old origin width x time y =
      leveque04_burgersAction old origin width x time z := hy.trans hz.symm
  have hcost : leveque04_burgersInitialPrimitive old origin width a + qL * (x - a) - qL ^ 2 * time / 2 =
      leveque04_burgersInitialPrimitive old origin width a + qR * (x - a) - qR ^ 2 * time / 2 :=
    hY.symm.trans (hequal.trans hZ)
  have hprod : (qL - qR) * (x - a - (qL + qR) / 2 * time) = 0 := by nlinarith
  have hq : qL - qR ≠ 0 := sub_ne_zero.mpr (Ne.symm (ne_of_lt horder))
  have hx := (mul_eq_zero.mp hprod).resolve_left hq
  change x = a + (qL + qR) / 2 * time
  linarith

end NumStability
