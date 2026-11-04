/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionBounds
import Mathlib.Topology.Order.Compact

/-!
# All real minimizing feet of the actual finite Burgers action

Strict quadratic convexity on each original affine segment proves that every
global minimizer is one of the existing clamped candidates. The fixed selected
foot is therefore largest among all real global minimizers, not merely among
the finite candidate indices. The actual minimizing-foot set is finite and
compact, and every one of its feet obeys the existing analytic displacement
bound. No change is made to the actual field or its tie rule.

These are minimizer geometry facts, not a wave-propagation bound or a Godunov
flux identity. The analytic bound K is not identified with encountered speed S.
-/

noncomputable section
open Set

namespace NumStability

private theorem actionSegment_midpoint {N : ℕ} (origin width y z : ℝ)
    (k : Fin (N + 2)) (hy : leveque04_burgersActionSegment origin width k y)
    (hz : leveque04_burgersActionSegment origin width k z) :
    leveque04_burgersActionSegment origin width k ((y + z) / 2) := by
  intro j
  constructor
  · intro hj
    linarith [(hy j).1 hj, (hz j).1 hj]
  · intro hj
    linarith [(hy j).2 hj, (hz j).2 hj]

private theorem globalMin_same_segment_eq {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y z : ℝ) (htime : 0 < time)
    (k : Fin (N + 2)) (hy : leveque04_burgersActionSegment origin width k y)
    (hz : leveque04_burgersActionSegment origin width k z)
    (hminy : ∀ r, leveque04_burgersAction old origin width x time y ≤
      leveque04_burgersAction old origin width x time r)
    (hminz : ∀ r, leveque04_burgersAction old origin width x time z ≤
      leveque04_burgersAction old origin width x time r) : y = z := by
  let m := (y + z) / 2
  have hm := actionSegment_midpoint origin width y z k hy hz
  have hequal := le_antisymm (hminz y) (hminy z)
  have hzid := (eq_div_iff (by positivity : 2 * time ≠ 0)).mp
    (leveque04_burgersAction_completeSquare old origin width x time htime k z y hz hy)
  rw [hequal, sub_self, zero_mul] at hzid
  have hmidid := (eq_div_iff (by positivity : 2 * time ≠ 0)).mp
    (leveque04_burgersAction_completeSquare old origin width x time htime k m y hm hy)
  have hmid : 0 ≤ (m - (x - old k * time)) ^ 2 - (y - (x - old k * time)) ^ 2 := by
    rw [← hmidid]
    exact mul_nonneg (sub_nonneg.mpr (hminy m)) (by positivity)
  have hsq : (y - z) ^ 2 = 0 := by
    dsimp [m] at hmid
    nlinarith [sq_nonneg (y - z)]
  exact sub_eq_zero.mp (sq_eq_zero_iff.mp hsq)

/-- Every true global minimizing real foot is one of the actual finite
clamped candidates, including either supplied constant tail. -/
theorem leveque04_burgersAction_global_min_eq_clampedFoot {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hmin : ∀ z, leveque04_burgersAction old origin width x time y ≤
      leveque04_burgersAction old origin width x time z) :
    ∃ k : Fin (N + 2), y = leveque04_burgersClampedFoot old origin width x time k := by
  obtain ⟨k, hy⟩ := leveque04_burgersActionSegment_cover origin width hwidth y
  let c := leveque04_burgersClampedFoot old origin width x time k
  have hc : leveque04_burgersActionSegment origin width k c :=
    leveque04_burgersClampedFoot_mem old origin width x time hwidth k
  have hcle : leveque04_burgersAction old origin width x time c ≤
      leveque04_burgersAction old origin width x time y :=
    leveque04_burgersActionCandidate_le old origin width x time hwidth htime k y hy
  have hminc (z : ℝ) : leveque04_burgersAction old origin width x time c ≤
      leveque04_burgersAction old origin width x time z := hcle.trans (hmin z)
  exact ⟨k, globalMin_same_segment_eq old origin width x time y c htime k hy hc hmin hminc⟩

theorem leveque04_burgersFiniteActionFoot_largest_global_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hmin : ∀ z, leveque04_burgersAction old origin width x time y ≤
      leveque04_burgersAction old origin width x time z) :
    y ≤ leveque04_burgersFiniteActionFoot old origin width x time := by
  obtain ⟨k, hk⟩ := leveque04_burgersAction_global_min_eq_clampedFoot
    old origin width x time y hwidth htime hmin
  have hcost : leveque04_burgersActionCandidate old origin width x time k =
      leveque04_burgersActionCandidate old origin width x time
        (leveque04_burgersFiniteActionMinIndex old origin width x time) := by
    apply le_antisymm
    · simpa only [leveque04_burgersActionCandidate, ← hk, leveque04_burgersFiniteActionFoot] using
        hmin (leveque04_burgersFiniteActionFoot old origin width x time)
    · exact leveque04_burgersFiniteActionMinIndex_min old origin width x time k
  rw [hk]
  exact leveque04_burgersFiniteActionFoot_largest_candidate old origin width x time k hcost

/-- Real feet attaining the SAME actual selected action value. At positive
time and nonnegative width these are exactly all global real minimizers. -/
def leveque04_burgersFiniteActionMinimizingFeet {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : Set ℝ :=
  {y | leveque04_burgersAction old origin width x time y =
    leveque04_burgersFiniteActionPotential old origin width x time}

theorem leveque04_burgersFiniteActionFoot_mem_minimizingFeet {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) :
    leveque04_burgersFiniteActionFoot old origin width x time ∈
      leveque04_burgersFiniteActionMinimizingFeet old origin width x time := rfl

theorem leveque04_burgersFiniteActionMinimizingFeet_iff_global_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time ↔
      ∀ z, leveque04_burgersAction old origin width x time y ≤
        leveque04_burgersAction old origin width x time z := by
  constructor
  · intro hy z
    change leveque04_burgersAction old origin width x time y =
      leveque04_burgersFiniteActionPotential old origin width x time at hy
    rw [hy]
    exact leveque04_burgersFiniteActionFoot_global_min old origin width x time hwidth htime z
  · intro hy
    exact le_antisymm (hy (leveque04_burgersFiniteActionFoot old origin width x time))
      (leveque04_burgersFiniteActionFoot_global_min old origin width x time hwidth htime y)

theorem leveque04_burgersFiniteActionMinimizingFeet_finite {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    (leveque04_burgersFiniteActionMinimizingFeet old origin width x time).Finite := by
  apply (Set.finite_range (fun k : Fin (N + 2) =>
    leveque04_burgersClampedFoot old origin width x time k)).subset
  intro y hy
  obtain ⟨k, hk⟩ := leveque04_burgersAction_global_min_eq_clampedFoot old origin width x time y
    hwidth htime ((leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
      old origin width x time y hwidth htime).mp hy)
  exact ⟨k, hk.symm⟩

theorem leveque04_burgersFiniteActionMinimizingFeet_isCompact {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    IsCompact (leveque04_burgersFiniteActionMinimizingFeet old origin width x time) :=
  (leveque04_burgersFiniteActionMinimizingFeet_finite old origin width x time hwidth htime).isCompact

theorem leveque04_burgersFiniteActionFoot_isGreatest {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    IsGreatest (leveque04_burgersFiniteActionMinimizingFeet old origin width x time)
      (leveque04_burgersFiniteActionFoot old origin width x time) := by
  refine ⟨leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time, ?_⟩
  intro y hy
  exact leveque04_burgersFiniteActionFoot_largest_global_min old origin width x time y hwidth htime
    ((leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
      old origin width x time y hwidth htime).mp hy)

theorem leveque04_burgersFiniteActionMinimizingFeet_sSup {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    sSup (leveque04_burgersFiniteActionMinimizingFeet old origin width x time) =
      leveque04_burgersFiniteActionFoot old origin width x time :=
  (leveque04_burgersFiniteActionFoot_isGreatest old origin width x time hwidth htime).isLUB.csSup_eq
    ⟨_, leveque04_burgersFiniteActionFoot_mem_minimizingFeet old origin width x time⟩

/-- Every real minimizer, including tied alternatives, obeys the analytic
cone bound. This makes no assertion about actual encountered wave speeds. -/
theorem leveque04_burgersFiniteActionMinimizingFeet_displacement_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time y : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time)
    (hy : y ∈ leveque04_burgersFiniteActionMinimizingFeet old origin width x time) :
    |x - y| ≤ leveque04_burgersPrimitiveBound old * time := by
  exact quadraticAction_minimizer_displacement_le (leveque04_burgersInitialPrimitive old origin width)
    (leveque04_burgersPrimitiveBound old) time x y (leveque04_burgersPrimitiveBound_nonneg old) htime
    (fun z r => leveque04_burgersInitialPrimitive_abs_sub_le old origin width z r)
    ((leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
      old origin width x time y hwidth htime).mp hy)

end NumStability
