/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannFigure33

/-!
# Single jumps and the two-family Hugoniot locus

Printed page 55/raw PDF page 77. A nontrivial single discontinuity follows
one eigenvector direction. The connected states form two complete affine
lines through the left state.
-/

namespace NumStability

private theorem leveque03_twoFamilySingleJump
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ)
    (hsingle : leveque03_waveStrength eigenbasis left right 0 = 0 ∨
      leveque03_waveStrength eigenbasis left right 1 = 0) :
    (∃ α : ℝ, right - left = α • eigenbasis 0) ∨
      (∃ β : ℝ, right - left = β • eigenbasis 1) := by
  have hsum := leveque03_sumRiemannWaves eigenbasis left right
  simp only [Fin.sum_univ_succ, Fin.sum_univ_zero, add_zero] at hsum
  rcases hsingle with hzero | hzero
  · right
    refine ⟨leveque03_waveStrength eigenbasis left right 1, ?_⟩
    simpa [leveque03_riemannWave, hzero] using hsum.symm
  · left
    refine ⟨leveque03_waveStrength eigenbasis left right 0, ?_⟩
    simpa [leveque03_riemannWave, hzero] using hsum.symm

private theorem leveque03_twoFamilySingleJump_converse
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ)
    (hparallel : (∃ α : ℝ, right - left = α • eigenbasis 0) ∨
      (∃ β : ℝ, right - left = β • eigenbasis 1)) :
    leveque03_waveStrength eigenbasis left right 0 = 0 ∨
      leveque03_waveStrength eigenbasis left right 1 = 0 := by
  have hcoord (p : Fin 2) :
      leveque03_waveStrength eigenbasis left right p =
        eigenbasis.equivFun (right - left) p := by
    have h := (leveque03_waveStrength_fromJump eigenbasis left right).2.2 p
    rw [← h.2]
    exact congrFun (leveque03_characteristicCoordinates eigenbasis (right - left)) p
  rcases hparallel with ⟨α, hdir⟩ | ⟨β, hdir⟩
  · right
    rw [hcoord, hdir]
    simp
  · left
    rw [hcoord, hdir]
    simp

/-- At most one family carries the jump exactly when the state difference
is parallel to the first or second right eigenvector. -/
theorem leveque03_twoFamilySingleJump_iff
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) :
    (leveque03_waveStrength eigenbasis left right 0 = 0 ∨
      leveque03_waveStrength eigenbasis left right 1 = 0) ↔
    ((∃ α : ℝ, right - left = α • eigenbasis 0) ∨
      (∃ β : ℝ, right - left = β • eigenbasis 1)) := by
  constructor
  · exact leveque03_twoFamilySingleJump eigenbasis left right
  · exact leveque03_twoFamilySingleJump_converse eigenbasis left right

/-- For distinct endpoint states, the active direction has nonzero strength,
so the jump is a genuine nonzero eigenvector multiple. -/
theorem leveque03_twoFamilySingleJump_nonzero
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left right : Fin 2 → ℝ) (hne : right ≠ left)
    (hsingle : leveque03_waveStrength eigenbasis left right 0 = 0 ∨
      leveque03_waveStrength eigenbasis left right 1 = 0) :
    ∃ p : Fin 2, ∃ α : ℝ,
      α ≠ 0 ∧ right - left = α • eigenbasis p := by
  rcases (leveque03_twoFamilySingleJump_iff eigenbasis left right).mp hsingle with
    ⟨α, h⟩ | ⟨β, h⟩
  · refine ⟨0, α, ?_, h⟩
    intro hz
    apply hne
    exact sub_eq_zero.mp (by simpa [hz] using h)
  · refine ⟨1, β, ?_, h⟩
    intro hz
    apply hne
    exact sub_eq_zero.mp (by simpa [hz] using h)

/-- The Hugoniot locus is the union of the full two eigenvector lines. -/
theorem leveque03_twoFamilyHugoniotLocus
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (left : Fin 2 → ℝ) :
    {right : Fin 2 → ℝ |
      leveque03_waveStrength eigenbasis left right 0 = 0 ∨
        leveque03_waveStrength eigenbasis left right 1 = 0} =
    {right | ∃ α : ℝ, right = left + α • eigenbasis 0} ∪
      {right | ∃ β : ℝ, right = left + β • eigenbasis 1} := by
  ext right
  rw [Set.mem_setOf_eq, Set.mem_union, Set.mem_setOf_eq, Set.mem_setOf_eq,
    leveque03_twoFamilySingleJump_iff]
  constructor
  · rintro (⟨α, h⟩ | ⟨β, h⟩)
    · left
      exact ⟨α, by simpa only [add_comm] using (sub_eq_iff_eq_add).mp h⟩
    · right
      exact ⟨β, by simpa only [add_comm] using (sub_eq_iff_eq_add).mp h⟩
  · rintro (⟨α, h⟩ | ⟨β, h⟩)
    · left
      exact ⟨α, (sub_eq_iff_eq_add).mpr (by simpa only [add_comm] using h)⟩
    · right
      exact ⟨β, (sub_eq_iff_eq_add).mpr (by simpa only [add_comm] using h)⟩

end NumStability
