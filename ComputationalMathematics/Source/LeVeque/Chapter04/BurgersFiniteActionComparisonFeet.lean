/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionInitialSpeedBounds
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionCompatiblePrimitive

/-!
# Actual primitive and action at the two local Godunov comparison feet

The necessary directional state bounds propagate through equal-state cells.
The outgoing positive-left and negative-right comparison feet consequently stay
on the original side of every foreign active jump throughout the open CFL time
interval. Their primitive and action values are therefore the genuine original
two-state values, including unbounded constant tails and stationary shocks.
-/

noncomputable section
open Set

namespace NumStability

private theorem upper_after_jump (q : ℕ → ℝ) (bound : ℝ) (cap k n : ℕ)
    (hdir : ∀ i < cap, q i ≠ q (i + 1) → q (i + 1) ≤ bound)
    (hjump : q k ≠ q (k + 1)) (hkn : k < n) (hn : n ≤ cap) : q n ≤ bound := by
  have H : ∀ m, m ≤ cap → k < m → q m ≤ bound := by
    intro m
    induction m with
    | zero => intro _ hk; omega
    | succ m ih =>
      intro hm hk
      by_cases heq : q m = q (m + 1)
      · have hkm : k < m := by
          by_contra hnot
          have hsame : k = m := by omega
          exact hjump (by simpa only [hsame] using heq)
        rw [← heq]
        exact ih (by omega) hkm
      · exact hdir m (by omega) heq
  exact H n hn hkn

private theorem lower_before_jump (q : ℕ → ℝ) (bound : ℝ) (cap j k : ℕ)
    (hdir : ∀ i < cap, q i ≠ q (i + 1) → -bound ≤ q i)
    (hk : k < cap) (hjump : q k ≠ q (k + 1)) (hjk : j ≤ k) : -bound ≤ q j := by
  by_contra hn
  have hbelow : q j < -bound := lt_of_not_ge hn
  have H : ∀ m, m ≤ cap → j ≤ m → q m = q j := by
    intro m
    induction m with
    | zero =>
      intro _ hj
      have hz : j = 0 := by omega
      rw [hz]
    | succ m ih =>
      intro hm hj
      by_cases heq : j = m + 1
      · rw [heq]
      · have hjm : j ≤ m := by omega
        have hprev := ih (by omega) hjm
        have hflat : q m = q (m + 1) := by
          by_contra hchange
          have hb := hdir m (by omega) hchange
          rw [hprev] at hb
          linarith
        exact hflat.symm.trans hprev
  have hb := hdir k hk hjump
  rw [H k hk.le hjk] at hb
  linarith

private theorem face_gap (origin width : ℝ) {i j : ℕ} (hwidth : 0 < width) (hij : i < j) :
    leveque04_burgersActionFace origin width i + width ≤ leveque04_burgersActionFace origin width j := by
  have hi : (i : ℝ) + 1 ≤ (j : ℝ) := by exact_mod_cast (show i + 1 ≤ j by omega)
  have hm := mul_le_mul_of_nonneg_right hi hwidth.le
  simp only [leveque04_burgersActionFace_eq]
  nlinarith

theorem leveque04_burgersFiniteAction_CFL_comparison_feet_primitive {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) (htime : time ∈ Ioo (0 : ℝ) horizon) :
    let a := leveque04_burgersActionFace origin width j.val
    let qL := leveque04_burgersActionState old j.val
    let qR := leveque04_burgersActionState old (j.val + 1)
    let yL := a - max 0 qL * time
    let yR := a - min 0 qR * time
    leveque04_burgersInitialPrimitive old origin width yL =
        leveque04_burgersInitialPrimitive old origin width a + qL * (yL - a) ∧
      leveque04_burgersInitialPrimitive old origin width yR =
        leveque04_burgersInitialPrimitive old origin width a + qR * (yR - a) := by
  let q := leveque04_burgersActionState old
  let a := leveque04_burgersActionFace origin width j.val
  let yL := a - max 0 (q j.val) * time
  let yR := a - min 0 (q (j.val + 1)) * time
  have hd (k : ℕ) (hk : k < N + 1) (hne : q k ≠ q (k + 1)) :
      -bound ≤ q k ∧ q (k + 1) ≤ bound :=
    leveque04_burgersFiniteActionPropagationBound_initial_jump_directional_states
      old origin width horizon bound ⟨k, hk⟩ hwidth (htime.1.trans htime.2) hprop hne
  have hstrict : bound * time < width := by
    by_cases hb : 0 < bound
    · exact (mul_lt_mul_of_pos_left htime.2 hb).trans_le hCFL
    · have hz : bound = 0 := le_antisymm (le_of_not_gt hb) hprop.1
      simpa only [hz, zero_mul] using hwidth
  have hLy : yL ≤ a := by
    dsimp [yL]
    nlinarith [mul_nonneg (le_max_left (0 : ℝ) (q j.val)) htime.1.le]
  have hRa : a ≤ yR := by
    dsimp [yR]
    nlinarith [mul_nonpos_of_nonpos_of_nonneg (min_le_left (0 : ℝ) (q (j.val + 1))) htime.1.le]
  have hbefore (k : Fin (N + 1)) (hk : q k.val ≠ q (k.val + 1)) (hkj : k.val < j.val) :
      leveque04_burgersActionFace origin width k.val ≤ yL ∧
        leveque04_burgersActionFace origin width k.val ≤ yR := by
    have hq := upper_after_jump q bound (N + 1) k.val j.val (fun i hi hne => (hd i hi hne).2)
      hk hkj (by omega)
    have hmax : max 0 (q j.val) ≤ bound := max_le hprop.1 hq
    have hm := mul_le_mul_of_nonneg_right hmax htime.1.le
    have hgap := face_gap origin width hwidth hkj
    constructor
    · dsimp [yL]
      linarith
    · exact ((leveque04_burgersActionFace_strictMono origin width hwidth hkj).le).trans hRa
  have hafter (k : Fin (N + 1)) (hk : q k.val ≠ q (k.val + 1)) (hjk : j.val < k.val) :
      yL ≤ leveque04_burgersActionFace origin width k.val ∧
        yR ≤ leveque04_burgersActionFace origin width k.val := by
    have hq := lower_before_jump q bound (N + 1) (j.val + 1) k.val
      (fun i hi hne => (hd i hi hne).1) k.isLt hk (by omega)
    have hmin : -bound ≤ min 0 (q (j.val + 1)) := le_min (neg_nonpos.mpr hprop.1) hq
    have hm := mul_le_mul_of_nonneg_right hmin htime.1.le
    have hgap := face_gap origin width hwidth hjk
    constructor
    · exact hLy.trans ((leveque04_burgersActionFace_strictMono origin width hwidth hjk).le)
    · dsimp [yR]
      linarith
  have hPL := leveque04_burgersInitialPrimitive_of_compatible_foot old origin width yL j hwidth
    (fun k hk => ⟨fun hkj => (hbefore k hk hkj).1, fun hjk => (hafter k hk hjk).1⟩)
  have hPR := leveque04_burgersInitialPrimitive_of_compatible_foot old origin width yR j hwidth
    (fun k hk => ⟨fun hkj => (hbefore k hk hkj).2, fun hjk => (hafter k hk hjk).2⟩)
  change leveque04_burgersInitialPrimitive old origin width yL =
      leveque04_burgersInitialPrimitive old origin width a + q j.val * (yL - a) +
        (q (j.val + 1) - q j.val) * max (yL - a) 0 at hPL
  change leveque04_burgersInitialPrimitive old origin width yR =
      leveque04_burgersInitialPrimitive old origin width a + q j.val * (yR - a) +
        (q (j.val + 1) - q j.val) * max (yR - a) 0 at hPR
  rw [max_eq_right (sub_nonpos.mpr hLy), mul_zero, add_zero] at hPL
  rw [max_eq_left (sub_nonneg.mpr hRa)] at hPR
  exact ⟨hPL, by nlinarith [hPR]⟩

/-- These are actual global primitive/action values at the comparison feet,
not values of a substituted local solver. -/
theorem leveque04_burgersFiniteAction_CFL_comparison_action_values {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width horizon bound time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width)
    (hprop : leveque04_burgersFiniteActionPropagationBound old origin width horizon bound)
    (hCFL : bound * horizon ≤ width) (htime : time ∈ Ioo (0 : ℝ) horizon) :
    let a := leveque04_burgersActionFace origin width j.val
    let qL := leveque04_burgersActionState old j.val
    let qR := leveque04_burgersActionState old (j.val + 1)
    leveque04_burgersAction old origin width a time (a - max 0 qL * time) =
        leveque04_burgersInitialPrimitive old origin width a - (max 0 qL) ^ 2 * time / 2 ∧
      leveque04_burgersAction old origin width a time (a - min 0 qR * time) =
        leveque04_burgersInitialPrimitive old origin width a - (min 0 qR) ^ 2 * time / 2 := by
  let a := leveque04_burgersActionFace origin width j.val
  let qL := leveque04_burgersActionState old j.val
  let qR := leveque04_burgersActionState old (j.val + 1)
  have hp := leveque04_burgersFiniteAction_CFL_comparison_feet_primitive
    old origin width horizon bound time j hwidth hprop hCFL htime
  constructor
  · unfold leveque04_burgersAction
    rw [hp.1]
    by_cases hq : 0 ≤ qL
    · rw [max_eq_right hq]
      field_simp [htime.1.ne']
      ring
    · rw [max_eq_left (le_of_not_ge hq)]
      simp
  · unfold leveque04_burgersAction
    rw [hp.2]
    by_cases hq : qR ≤ 0
    · rw [min_eq_right hq]
      field_simp [htime.1.ne']
      ring
    · rw [min_eq_left (le_of_not_ge hq)]
      simp

end NumStability
