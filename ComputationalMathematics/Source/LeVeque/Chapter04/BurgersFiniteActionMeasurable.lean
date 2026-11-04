/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionField
import Mathlib.MeasureTheory.Constructions.BorelSpace.Order

/-!
# Joint measurability of the actual selected finite-action field

The selected index itself is not assumed measurable. Each candidate foot and
action is measurable. The finite measurable sets on which a candidate minimizes
the action and has largest tied foot cover spacetime; on overlaps their foot
values agree. This proves measurability of the same existing selected foot,
potential and velocity without replacing their selection rule.

The total formulas are measurable on all real spacetime. Their physical
positive-time meaning and the initial-data branch are separate matters.
-/

noncomputable section
open Set MeasureTheory

namespace NumStability

theorem leveque04_burgersClampedFoot_joint_continuous {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (k : Fin (N + 2)) :
    Continuous (fun z : ℝ × ℝ => leveque04_burgersClampedFoot old origin width z.1 z.2 k) := by
  unfold leveque04_burgersClampedFoot
  split_ifs <;> fun_prop

theorem leveque04_burgersActionCandidate_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (k : Fin (N + 2)) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersActionCandidate old origin width z.1 z.2 k) := by
  have hf := (leveque04_burgersClampedFoot_joint_continuous old origin width k).measurable
  have hp := (leveque04_burgersInitialPrimitive_continuous old origin width).measurable
  unfold leveque04_burgersActionCandidate leveque04_burgersAction
  exact (hp.comp hf).add (((measurable_fst.sub hf).pow_const 2).div
    (measurable_const.mul measurable_snd))

theorem leveque04_burgersFiniteActionFoot_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersFiniteActionFoot old origin width z.1 z.2) := by
  let F (k : Fin (N + 2)) (z : ℝ × ℝ) :=
    leveque04_burgersClampedFoot old origin width z.1 z.2 k
  let C (k : Fin (N + 2)) (z : ℝ × ℝ) :=
    leveque04_burgersActionCandidate old origin width z.1 z.2 k
  let G (z : ℝ × ℝ) := leveque04_burgersFiniteActionFoot old origin width z.1 z.2
  let S (k : Fin (N + 2)) : Set (ℝ × ℝ) :=
    {z | (∀ j, C k z ≤ C j z) ∧ (∀ j, C j z = C k z → F j z ≤ F k z)}
  have hF (k : Fin (N + 2)) : Measurable (F k) :=
    (leveque04_burgersClampedFoot_joint_continuous old origin width k).measurable
  have hC (k : Fin (N + 2)) : Measurable (C k) :=
    leveque04_burgersActionCandidate_joint_measurable old origin width k
  have hS (k : Fin (N + 2)) : MeasurableSet (S k) := by
    dsimp only [S]
    simp only [setOf_and, setOf_forall, imp_iff_not_or, setOf_or]
    exact (MeasurableSet.iInter (fun j => measurableSet_le (hC k) (hC j))).inter
      (MeasurableSet.iInter (fun j =>
        (measurableSet_eq_fun (hC j) (hC k)).compl.union (measurableSet_le (hF j) (hF k))))
  have hcover (z : ℝ × ℝ) : ∃ k, z ∈ S k := by
    refine ⟨leveque04_burgersFiniteActionMinIndex old origin width z.1 z.2, ?_, ?_⟩
    · exact fun j => leveque04_burgersFiniteActionMinIndex_min old origin width z.1 z.2 j
    · exact fun j hj => leveque04_burgersFiniteActionFoot_largest_candidate
        old origin width z.1 z.2 j hj
  have hagree (k : Fin (N + 2)) (z : ℝ × ℝ) (hz : z ∈ S k) : G z = F k z := by
    let i := leveque04_burgersFiniteActionMinIndex old origin width z.1 z.2
    have hmin : C i z ≤ C k z :=
      leveque04_burgersFiniteActionMinIndex_min old origin width z.1 z.2 k
    have heq : C k z = C i z := le_antisymm (hz.1 i) hmin
    have hle : F k z ≤ G z :=
      leveque04_burgersFiniteActionFoot_largest_candidate old origin width z.1 z.2 k heq
    exact le_antisymm (hz.2 i heq.symm) hle
  change Measurable G
  intro B hB
  have hpreimage : G ⁻¹' B = ⋃ k, S k ∩ (F k ⁻¹' B) := by
    ext z
    constructor
    · intro hz
      obtain ⟨k, hk⟩ := hcover z
      apply mem_iUnion.mpr
      refine ⟨k, hk, ?_⟩
      change F k z ∈ B
      rw [← hagree k z hk]
      exact hz
    · intro hz
      obtain ⟨k, hk, hmem⟩ := mem_iUnion.mp hz
      change G z ∈ B
      rw [hagree k z hk]
      exact hmem
  rw [hpreimage]
  exact MeasurableSet.iUnion (fun k => (hS k).inter (hF k hB))

theorem leveque04_burgersFiniteActionPotential_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersFiniteActionPotential old origin width z.1 z.2) := by
  have hf := leveque04_burgersFiniteActionFoot_joint_measurable old origin width
  have hp := (leveque04_burgersInitialPrimitive_continuous old origin width).measurable
  unfold leveque04_burgersFiniteActionPotential leveque04_burgersAction
  exact (hp.comp hf).add (((measurable_fst.sub hf).pow_const 2).div
    (measurable_const.mul measurable_snd))

theorem leveque04_burgersFiniteActionVelocity_joint_measurable {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) :
    Measurable (fun z : ℝ × ℝ => leveque04_burgersFiniteActionVelocity old origin width z.1 z.2) := by
  exact (measurable_fst.sub
    (leveque04_burgersFiniteActionFoot_joint_measurable old origin width)).div measurable_snd

end NumStability
