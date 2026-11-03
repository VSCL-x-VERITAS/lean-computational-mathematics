/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionBoundaryMinimizers
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionSpatialTraces

/-!
# Original characteristic positions at continuous label edges

If the least minimizing foot at a left label boundary is the original face,
the actual field immediately to its left is the original left state. The
proved spatial trace then forces the original left characteristic position.
The right edge has the analogous greatest-foot statement. Tails are included;
no time restriction, no absence of interactions and no speed bound are assumed.
These are pointwise position identities, not yet derivative identities on all
sets of times where an edge is continuous.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

theorem leveque04_burgersFiniteActionLabelLeft_eq_characteristic_of_leastFoot_eq_face {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hfoot : sInf (leveque04_burgersFiniteActionMinimizingFeet old origin width
      (leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time) time) =
        leveque04_burgersActionFace origin width j.val) :
    leveque04_burgersFiniteActionLabelLeft old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val +
        leveque04_burgersActionState old j.val * time := by
  let a := leveque04_burgersActionFace origin width j.val
  let b := leveque04_burgersFiniteActionLabelLeft old origin width a time
  have hF := leveque04_burgersFiniteActionFoot_leftTrace old origin width b time hwidth.le htime
  rw [hfoot] at hF
  have hevent : ∀ᶠ r in 𝓝[<] b, leveque04_burgersFiniteActionEvolution old origin width r time =
      leveque04_burgersActionState old j.val := by
    by_cases hj0 : j.val = 0
    · filter_upwards [self_mem_nhdsWithin] with r hr
      have hlt := (leveque04_burgersFiniteActionLabelBoundaries_regions
        old origin width a time r hwidth.le htime).1 hr
      have hlt' : leveque04_burgersFiniteActionFoot old origin width r time < origin := by
        simpa only [a, leveque04_burgersActionFace_eq, hj0, Nat.cast_zero, zero_mul, add_zero] using hlt
      have hu := leveque04_burgersFiniteActionEvolution_eq_left_state_of_foot_lt
        old origin width r time hwidth.le htime hlt'
      have hs : leveque04_burgersActionState old j.val = old 0 := by
        simpa only [hj0, Fin.val_zero] using leveque04_burgersActionState_eq old 0
      exact hu.trans hs.symm
    · have hprev : leveque04_burgersActionFace origin width (j.val - 1) < a :=
        leveque04_burgersActionFace_strictMono origin width hwidth (show j.val - 1 < j.val by omega)
      have hnear := (tendsto_order.mp hF).1 _ hprev
      filter_upwards [self_mem_nhdsWithin, hnear] with r hr hlo
      have hhi := (leveque04_burgersFiniteActionLabelBoundaries_regions
        old origin width a time r hwidth.le htime).1 hr
      let k : Fin (N + 2) := ⟨j.val, by omega⟩
      have hu := leveque04_burgersFiniteActionEvolution_eq_state_of_foot_in_cell
        old origin width r time k hwidth.le htime (by dsimp [k]; omega)
        (by dsimp [k]; omega) hlo hhi
      exact hu.trans (leveque04_burgersActionState_eq old k).symm
  have hconst : Tendsto (fun r => leveque04_burgersFiniteActionEvolution old origin width r time)
      (𝓝[<] b) (𝓝 (leveque04_burgersActionState old j.val)) :=
    (tendsto_congr' hevent).mpr tendsto_const_nhds
  have htrace := leveque04_burgersFiniteActionEvolution_leftTrace old origin width b time hwidth.le htime
  rw [hfoot] at htrace
  have heq : (b - a) / time = leveque04_burgersActionState old j.val :=
    tendsto_nhds_unique htrace hconst
  have hm := (div_eq_iff htime.ne').mp heq
  change b = a + leveque04_burgersActionState old j.val * time
  linarith

theorem leveque04_burgersFiniteActionLabelRight_eq_characteristic_of_greatestFoot_eq_face {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (j : Fin (N + 1))
    (hwidth : 0 < width) (htime : 0 < time)
    (hfoot : leveque04_burgersFiniteActionFoot old origin width
      (leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time) time =
        leveque04_burgersActionFace origin width j.val) :
    leveque04_burgersFiniteActionLabelRight old origin width
        (leveque04_burgersActionFace origin width j.val) time =
      leveque04_burgersActionFace origin width j.val +
        leveque04_burgersActionState old (j.val + 1) * time := by
  let a := leveque04_burgersActionFace origin width j.val
  let b := leveque04_burgersFiniteActionLabelRight old origin width a time
  have hF := leveque04_burgersFiniteActionFoot_rightTrace old origin width b time hwidth.le htime
  rw [hfoot] at hF
  have hevent : ∀ᶠ r in 𝓝[>] b, leveque04_burgersFiniteActionEvolution old origin width r time =
      leveque04_burgersActionState old (j.val + 1) := by
    by_cases hjN : j.val = N
    · filter_upwards [self_mem_nhdsWithin] with r hr
      have hgt := (leveque04_burgersFiniteActionLabelBoundaries_regions
        old origin width a time r hwidth.le htime).2.2.2 hr
      have hgt' : origin + (N : ℝ) * width < leveque04_burgersFiniteActionFoot old origin width r time := by
        simpa only [a, leveque04_burgersActionFace_eq, hjN] using hgt
      have hu := leveque04_burgersFiniteActionEvolution_eq_right_state_of_foot_gt
        old origin width r time hwidth.le htime hgt'
      have hs : leveque04_burgersActionState old (j.val + 1) = old ⟨N + 1, by omega⟩ := by
        simpa only [hjN] using leveque04_burgersActionState_eq old ⟨N + 1, by omega⟩
      exact hu.trans hs.symm
    · have hnext : a < leveque04_burgersActionFace origin width (j.val + 1) :=
        leveque04_burgersActionFace_strictMono origin width hwidth (Nat.lt_succ_self j.val)
      have hnear := (tendsto_order.mp hF).2 _ hnext
      filter_upwards [self_mem_nhdsWithin, hnear] with r hr hhi
      have hlo := (leveque04_burgersFiniteActionLabelBoundaries_regions
        old origin width a time r hwidth.le htime).2.2.2 hr
      let k : Fin (N + 2) := ⟨j.val + 1, by omega⟩
      have hlo' : origin + ((k.val - 1 : ℕ) : ℝ) * width <
          leveque04_burgersFiniteActionFoot old origin width r time := by
        simpa only [k, Nat.add_sub_cancel, a, leveque04_burgersActionFace_eq] using hlo
      have hu := leveque04_burgersFiniteActionEvolution_eq_state_of_foot_in_cell
        old origin width r time k hwidth.le htime (by dsimp [k]; omega)
        (by dsimp [k]; omega) hlo' hhi
      exact hu.trans (leveque04_burgersActionState_eq old k).symm
  have hconst : Tendsto (fun r => leveque04_burgersFiniteActionEvolution old origin width r time)
      (𝓝[>] b) (𝓝 (leveque04_burgersActionState old (j.val + 1))) :=
    (tendsto_congr' hevent).mpr tendsto_const_nhds
  have htrace := leveque04_burgersFiniteActionEvolution_rightTrace old origin width b time hwidth.le htime
  have heqU := tendsto_nhds_unique htrace hconst
  rw [leveque04_burgersFiniteActionEvolution_positive old origin width b time htime,
    leveque04_burgersFiniteActionVelocity, hfoot] at heqU
  have hm := (div_eq_iff htime.ne').mp heqU
  change b = a + leveque04_burgersActionState old (j.val + 1) * time
  linarith

end NumStability
