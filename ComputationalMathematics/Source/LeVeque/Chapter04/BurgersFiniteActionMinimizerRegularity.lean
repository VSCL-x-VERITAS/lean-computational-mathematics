/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMinimizers
import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionMeasurable

/-!
# Stability of the actual finite-action minimizing-foot set

At positive time each actual candidate cost is continuous. A currently
nonminimal candidate stays excluded by its strict cost gap, while the feet of
currently minimal candidates remain in any prescribed open neighborhood of the
whole minimizing set. Finiteness gives this statement jointly in space and time.
No continuity of the largest selected foot is asserted at a shock.
-/

noncomputable section
open Set Filter
open scoped Topology

namespace NumStability

theorem leveque04_burgersActionCandidate_joint_continuousAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (k : Fin (N + 2))
    (z : ℝ × ℝ) (htime : 0 < z.2) :
    ContinuousAt (fun w : ℝ × ℝ =>
      leveque04_burgersActionCandidate old origin width w.1 w.2 k) z := by
  let F (w : ℝ × ℝ) := leveque04_burgersClampedFoot old origin width w.1 w.2 k
  have hf : Continuous F := leveque04_burgersClampedFoot_joint_continuous old origin width k
  have hb : Continuous (fun w : ℝ × ℝ => leveque04_burgersInitialPrimitive old origin width (F w)) :=
    (leveque04_burgersInitialPrimitive_continuous old origin width).comp hf
  have hn : Continuous (fun w : ℝ × ℝ => (w.1 - F w) ^ 2) :=
    (continuous_fst.sub hf).pow 2
  have hd : Continuous (fun w : ℝ × ℝ => 2 * w.2) := continuous_const.mul continuous_snd
  exact hb.continuousAt.add (hn.continuousAt.div hd.continuousAt
    (mul_ne_zero two_ne_zero (ne_of_gt htime)))

/-- Joint upper semicontinuity of ALL actual real minimizing feet. This is
an open-set containment conclusion, including tied alternatives at shocks. -/
theorem leveque04_burgersFiniteActionMinimizingFeet_eventually_subset {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (U : Set ℝ) (hU : IsOpen U)
    (hcontain : leveque04_burgersFiniteActionMinimizingFeet old origin width x time ⊆ U) :
    ∀ᶠ z : ℝ × ℝ in 𝓝 (x, time),
      leveque04_burgersFiniteActionMinimizingFeet old origin width z.1 z.2 ⊆ U := by
  let F (k : Fin (N + 2)) (z : ℝ × ℝ) :=
    leveque04_burgersClampedFoot old origin width z.1 z.2 k
  let C (k : Fin (N + 2)) (z : ℝ × ℝ) :=
    leveque04_burgersActionCandidate old origin width z.1 z.2 k
  let i := leveque04_burgersFiniteActionMinIndex old origin width x time
  have hC (k : Fin (N + 2)) : ContinuousAt (C k) (x, time) :=
    leveque04_burgersActionCandidate_joint_continuousAt old origin width k (x, time) htime
  have hnear (k : Fin (N + 2)) :
      ∀ᶠ z in 𝓝 (x, time), C i z < C k z ∨ F k z ∈ U := by
    by_cases heq : C k (x, time) = C i (x, time)
    · have hmem : F k (x, time) ∈
          leveque04_burgersFiniteActionMinimizingFeet old origin width x time := heq
      have hFk : ContinuousAt (F k) (x, time) :=
        (leveque04_burgersClampedFoot_joint_continuous old origin width k).continuousAt
      have hinside : ∀ᶠ z in 𝓝 (x, time), F k z ∈ U :=
        hFk.preimage_mem_nhds (hU.mem_nhds (hcontain hmem))
      exact hinside.mono (fun _ hz => Or.inr hz)
    · have hlt : C i (x, time) < C k (x, time) :=
        lt_of_le_of_ne (leveque04_burgersFiniteActionMinIndex_min old origin width x time k)
          (Ne.symm heq)
      exact ((hC i).eventually_lt (hC k) hlt).mono (fun _ hz => Or.inl hz)
  have hpos : ∀ᶠ z : ℝ × ℝ in 𝓝 (x, time), 0 < z.2 :=
    continuous_snd.continuousAt.preimage_mem_nhds (Ioi_mem_nhds htime)
  filter_upwards [Filter.eventually_all.mpr hnear, hpos] with z hz htz
  intro y hy
  have hmin := (leveque04_burgersFiniteActionMinimizingFeet_iff_global_min
    old origin width z.1 z.2 y hwidth htz).mp hy
  obtain ⟨k, hk⟩ := leveque04_burgersAction_global_min_eq_clampedFoot
    old origin width z.1 z.2 y hwidth htz hmin
  rcases hz k with hgap | hinside
  · have hle : C k z ≤ C i z := by
      simpa only [C, leveque04_burgersActionCandidate, ← hk] using hmin (F i z)
    exact False.elim (not_lt_of_ge hle hgap)
  · simpa only [F, ← hk] using hinside

/-- Hitting a closed foot set is a closed condition on a fixed positive-time
spatial slice, for the actual real minimizing-foot set. -/
theorem leveque04_burgersFiniteActionMinimizingFeet_isClosed_hit {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (D : Set ℝ) (hD : IsClosed D) :
    IsClosed {x : ℝ | ∃ y ∈
      leveque04_burgersFiniteActionMinimizingFeet old origin width x time, y ∈ D} := by
  rw [← isOpen_compl_iff]
  apply isOpen_iff_mem_nhds.mpr
  intro x hx
  have hcontain : leveque04_burgersFiniteActionMinimizingFeet old origin width x time ⊆ Dᶜ := by
    intro y hy hdy
    exact hx ⟨y, hy, hdy⟩
  have hnear := leveque04_burgersFiniteActionMinimizingFeet_eventually_subset
    old origin width x time hwidth htime Dᶜ hD.isOpen_compl hcontain
  have hline : Tendsto (fun y : ℝ => (y, time)) (𝓝 x) (𝓝 (x, time)) :=
    (continuous_id.prodMk continuous_const).continuousAt
  exact (hline.eventually hnear).mono (fun y hy ⟨z, hz, hzD⟩ => hy hz hzD)

end NumStability
