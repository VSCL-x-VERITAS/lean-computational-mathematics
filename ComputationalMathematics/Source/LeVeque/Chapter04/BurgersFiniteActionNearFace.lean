/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionCornerStates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionConvexMidpoint

/-!
# Actual primitive and minimizers near an original Burgers face

The original primitive is its two adjacent affine pieces on a width-sized
window about any face, including either supplied tail. An ascending corner
is convex on that window, so two true global action minimizers there coincide.
At a strictly interior foot on either side, actual stationarity gives the
corresponding original characteristic equation. No horizon restriction is a
hypothesis of the global field or its final intended CFL theorem.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

private theorem face_succ (origin width : ℝ) (i : ℕ) :
    leveque04_burgersActionFace origin width (i + 1) =
      leveque04_burgersActionFace origin width i + width := by
  simp only [leveque04_burgersActionFace_eq, Nat.cast_add, Nat.cast_one]
  ring

private theorem left_segment {N : ℕ} (origin width y : ℝ) (j : Fin (N + 1))
    (hw : 0 < width) (hylo : leveque04_burgersActionFace origin width j.val - width ≤ y)
    (hyhi : y ≤ leveque04_burgersActionFace origin width j.val) :
    leveque04_burgersActionSegment origin width (⟨j.val, by omega⟩ : Fin (N + 2)) y := by
  have hm := (leveque04_burgersActionFace_strictMono origin width hw).monotone
  intro i
  constructor
  · intro hij
    have hg := hm (show i.val + 1 ≤ j.val by change i.val < j.val at hij; omega)
    rw [face_succ] at hg
    linarith
  · intro hji
    exact hyhi.trans (hm hji)

private theorem right_segment {N : ℕ} (origin width y : ℝ) (j : Fin (N + 1))
    (hw : 0 < width) (hylo : leveque04_burgersActionFace origin width j.val ≤ y)
    (hyhi : y ≤ leveque04_burgersActionFace origin width j.val + width) :
    leveque04_burgersActionSegment origin width (⟨j.val + 1, by omega⟩ : Fin (N + 2)) y := by
  have hm := (leveque04_burgersActionFace_strictMono origin width hw).monotone
  intro i
  constructor
  · intro hij
    exact (hm (show i.val ≤ j.val by change i.val < j.val + 1 at hij; omega)).trans hylo
  · intro hji
    have hg := hm hji
    rw [face_succ] at hg
    exact hyhi.trans hg

theorem leveque04_burgersInitialPrimitive_nearFace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width y : ℝ) (j : Fin (N + 1)) (hwidth : 0 < width)
    (hy : y ∈ Icc (leveque04_burgersActionFace origin width j.val - width)
      (leveque04_burgersActionFace origin width j.val + width)) :
    leveque04_burgersInitialPrimitive old origin width y =
      leveque04_burgersInitialPrimitive old origin width (leveque04_burgersActionFace origin width j.val) +
        leveque04_burgersActionState old j.val * (y - leveque04_burgersActionFace origin width j.val) +
        (leveque04_burgersActionState old (j.val + 1) - leveque04_burgersActionState old j.val) *
          max (y - leveque04_burgersActionFace origin width j.val) 0 := by
  let a := leveque04_burgersActionFace origin width j.val
  by_cases hya : y ≤ a
  · let k : Fin (N + 2) := ⟨j.val, by omega⟩
    have hs := leveque04_burgersInitialPrimitive_sub_on_segment old origin width k y a
      (left_segment origin width y j hwidth hy.1 hya)
      (left_segment origin width a j hwidth (by linarith) (le_refl a))
    have hk : old k = leveque04_burgersActionState old j.val := (leveque04_burgersActionState_eq old k).symm
    rw [hk] at hs
    rw [max_eq_right (sub_nonpos.mpr hya), mul_zero, add_zero]
    linarith
  · have hay := (lt_of_not_ge hya).le
    let k : Fin (N + 2) := ⟨j.val + 1, by omega⟩
    have hs := leveque04_burgersInitialPrimitive_sub_on_segment old origin width k y a
      (right_segment origin width y j hwidth hay hy.2)
      (right_segment origin width a j hwidth (le_refl a) (by linarith))
    have hk : old k = leveque04_burgersActionState old (j.val + 1) := (leveque04_burgersActionState_eq old k).symm
    rw [hk] at hs
    rw [max_eq_left (sub_nonneg.mpr hay)]
    nlinarith

theorem leveque04_burgersFiniteActionMinimizingFeet_eq_near_ascendingFace {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y z : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (horder : leveque04_burgersActionState old j.val ≤ leveque04_burgersActionState old (j.val + 1))
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
    (hz : z ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
    (hynear : y ∈ Icc (leveque04_burgersActionFace origin width j.val - width)
      (leveque04_burgersActionFace origin width j.val + width))
    (hznear : z ∈ Icc (leveque04_burgersActionFace origin width j.val - width)
      (leveque04_burgersActionFace origin width j.val + width)) : y = z := by
  let a := leveque04_burgersActionFace origin width j.val
  have hmnear : (y + z) / 2 ∈ Icc (a - width) (a + width) := by
    constructor <;> linarith [hynear.1, hynear.2, hznear.1, hznear.2]
  have hyP := leveque04_burgersInitialPrimitive_nearFace old origin width y j hwidth hynear
  have hzP := leveque04_burgersInitialPrimitive_nearFace old origin width z j hwidth hznear
  have hmP := leveque04_burgersInitialPrimitive_nearFace old origin width ((y + z) / 2) j hwidth hmnear
  have hmax : max ((y + z) / 2 - a) 0 ≤ (max (y - a) 0 + max (z - a) 0) / 2 := by
    apply max_le
    · linarith [le_max_left (y - a) 0, le_max_left (z - a) 0]
    · linarith [le_max_right (y - a) 0, le_max_right (z - a) 0]
  have hconvex : leveque04_burgersInitialPrimitive old origin width ((y + z) / 2) ≤
      (leveque04_burgersInitialPrimitive old origin width y + leveque04_burgersInitialPrimitive old origin width z) / 2 := by
    rw [hyP, hzP, hmP]
    have hw := mul_le_mul_of_nonneg_left hmax (sub_nonneg.mpr horder)
    dsimp [a] at hw
    nlinarith
  have hminy := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
    old origin width x time y hwidth.le htime).mp hy
  have hminz := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
    old origin width x time z hwidth.le htime).mp hz
  exact quadraticAction_minimizers_eq_of_convex_midpoint
    (leveque04_burgersInitialPrimitive old origin width) time x y z htime hconvex (hminy _) (hminz _)

private theorem primitive_left_deriv {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width y : ℝ) (j : Fin (N + 1)) (hw : 0 < width)
    (hy : y ∈ Ioo (leveque04_burgersActionFace origin width j.val - width)
      (leveque04_burgersActionFace origin width j.val)) :
    HasDerivAt (leveque04_burgersInitialPrimitive old origin width) (leveque04_burgersActionState old j.val) y := by
  let a := leveque04_burgersActionFace origin width j.val
  let q := leveque04_burgersActionState old j.val
  have hd : HasDerivAt (fun z : ℝ => leveque04_burgersInitialPrimitive old origin width a + q * (z - a)) q y := by
    simpa only [mul_one, sub_zero] using
      ((((hasDerivAt_id y).sub_const a).const_mul q).const_add (leveque04_burgersInitialPrimitive old origin width a))
  apply hd.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hy.1, eventually_lt_nhds hy.2] with z hzlo hzhi
  have hp := leveque04_burgersInitialPrimitive_nearFace old origin width z j hw ⟨hzlo.le, by linarith⟩
  rw [max_eq_right (sub_nonpos.mpr hzhi.le), mul_zero, add_zero] at hp
  exact hp

private theorem primitive_right_deriv {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width y : ℝ) (j : Fin (N + 1)) (hw : 0 < width)
    (hy : y ∈ Ioo (leveque04_burgersActionFace origin width j.val)
      (leveque04_burgersActionFace origin width j.val + width)) :
    HasDerivAt (leveque04_burgersInitialPrimitive old origin width) (leveque04_burgersActionState old (j.val + 1)) y := by
  let a := leveque04_burgersActionFace origin width j.val
  let q := leveque04_burgersActionState old (j.val + 1)
  have hd : HasDerivAt (fun z : ℝ => leveque04_burgersInitialPrimitive old origin width a + q * (z - a)) q y := by
    simpa only [mul_one, sub_zero] using
      ((((hasDerivAt_id y).sub_const a).const_mul q).const_add (leveque04_burgersInitialPrimitive old origin width a))
  apply hd.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hy.1, eventually_lt_nhds hy.2] with z hzlo hzhi
  have hp := leveque04_burgersInitialPrimitive_nearFace old origin width z j hw ⟨by linarith, hzhi.le⟩
  rw [max_eq_left (sub_nonneg.mpr hzlo.le)] at hp
  dsimp [a, q]
  nlinarith

/-- Strictly interior actual minimizing feet follow the corresponding
original state characteristic on either side of a face. -/
theorem leveque04_burgersFiniteAction_minimizer_nearFace_characteristics {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time) :
    (y ∈ Ioo (leveque04_burgersActionFace origin width j.val - width)
        (leveque04_burgersActionFace origin width j.val) →
      x = y + leveque04_burgersActionState old j.val * time) ∧
    (y ∈ Ioo (leveque04_burgersActionFace origin width j.val)
        (leveque04_burgersActionFace origin width j.val + width) →
      x = y + leveque04_burgersActionState old (j.val + 1) * time) := by
  exact ⟨fun hn => leveque04_burgersFiniteAction_minimizingLabel_observation_eq
    old origin width y time x _ hwidth.le htime hy (primitive_left_deriv old origin width y j hwidth hn),
    fun hn => leveque04_burgersFiniteAction_minimizingLabel_observation_eq
      old origin width y time x _ hwidth.le htime hy (primitive_right_deriv old origin width y j hwidth hn)⟩

end NumStability
