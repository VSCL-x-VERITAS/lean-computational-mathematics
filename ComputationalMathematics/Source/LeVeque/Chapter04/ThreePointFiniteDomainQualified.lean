/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ThreePointPhysicalDomain
import Mathlib.Data.Int.Interval
import Mathlib.Tactic

/-!
# LeVeque Chapter 4: finite three-point physical sampling envelope

This is a determining-envelope statement for arbitrary state types and
(time-indexed) three-point callbacks. It records the five and nine physical
grid sites for two and four steps at one observation point and the same
physical time. It does not assert essential influence or finite-volume
cell-average dependence.
-/

open Set
namespace NumStability

/-- Physical locations of integer offsets in a radius-`steps` grid window. -/
noncomputable def leveque04_threePointPhysicalGridSites
    (X width : ℝ) (steps : ℕ) : Finset ℝ :=
  threePointPhysicalGridSites X width steps

/-- Closed physical envelope of a radius-`steps` grid window. -/
def leveque04_threePointPhysicalGridEnvelope
    (X width : ℝ) (steps : ℕ) : Set ℝ :=
  threePointPhysicalGridEnvelope X width steps

/-- The five coarse and nine refined physical samples determine the output
of a time-indexed three-point recurrence on any state type. -/
def Leveque04ThreePointFiniteDomainQualifiedTarget : Prop :=
  (∀ (E : Type*) (F : ℕ → ℤ → E → E → E → E)
      (X width : ℝ) (i : ℤ) (left right : ℝ → E),
    (∀ offset ∈ Finset.Icc (-2 : ℤ) 2,
      left (X + (offset : ℝ) * width) = right (X + (offset : ℝ) * width)) →
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1)))
      (fun j => left (X + ((j - i : ℤ) : ℝ) * width)) 2 i =
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1)))
      (fun j => right (X + ((j - i : ℤ) : ℝ) * width)) 2 i) ∧
  (∀ (E : Type*) (F : ℕ → ℤ → E → E → E → E)
      (X width : ℝ) (i : ℤ) (left right : ℝ → E),
    (∀ offset ∈ Finset.Icc (-4 : ℤ) 4,
      left (X + (offset : ℝ) * (width / 2)) =
        right (X + (offset : ℝ) * (width / 2))) →
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1)))
      (fun j => left (X + ((j - i : ℤ) : ℝ) * (width / 2))) 4 i =
    centeredStencilEvolution
      (fun k u j => F k j (u (j - 1)) (u j) (u (j + 1)))
      (fun j => right (X + ((j - i : ℤ) : ℝ) * (width / 2))) 4 i) ∧
  (∀ (X width : ℝ), 0 < width →
    (leveque04_threePointPhysicalGridSites X width 2).card = 5 ∧
    (leveque04_threePointPhysicalGridSites X (width / 2) 4).card = 9) ∧
  (∀ (X width : ℝ),
    leveque04_threePointPhysicalGridEnvelope X width 2 =
      leveque04_threePointPhysicalGridEnvelope X (width / 2) 4) ∧
  (∀ (X T ratio width : ℝ),
    0 < ratio → 0 < width → T = 2 * (ratio * width) →
    0 < ratio * width ∧
    0 < ratio * (width / 2) ∧
    (ratio * width) / width = ratio ∧
    (ratio * (width / 2)) / (width / 2) = ratio ∧
    2 * (ratio * width) = T ∧
    4 * (ratio * (width / 2)) = T ∧
    T / ratio = 2 * width ∧
    Icc (X - T / ratio) (X + T / ratio) =
      leveque04_threePointPhysicalGridEnvelope X width 2)

private theorem threePointPhysicalGridSites_two_card (X width : ℝ)
    (hwidth : 0 < width) :
    (leveque04_threePointPhysicalGridSites X width 2).card = 5 := by
  classical
  have hinj : Set.InjOn (fun offset : ℤ => X + (offset : ℝ) * width)
      (Finset.Icc (-2 : ℤ) 2) := by
    intro a ha b hb heq
    have hmul : (a : ℝ) * width = (b : ℝ) * width := by linarith
    have hcast : (a : ℝ) = (b : ℝ) := mul_right_cancel₀ hwidth.ne' hmul
    exact Int.cast_injective hcast
  unfold leveque04_threePointPhysicalGridSites threePointPhysicalGridSites
  change ((Finset.Icc (-2 : ℤ) 2).image
      (fun offset : ℤ => X + (offset : ℝ) * width)).card = 5
  rw [Finset.card_image_of_injOn hinj]
  rw [Int.card_Icc]
  norm_num [Int.toNat]

private theorem threePointPhysicalGridSites_four_card (X width : ℝ)
    (hwidth : 0 < width) :
    (leveque04_threePointPhysicalGridSites X width 4).card = 9 := by
  classical
  have hinj : Set.InjOn (fun offset : ℤ => X + (offset : ℝ) * width)
      (Finset.Icc (-4 : ℤ) 4) := by
    intro a ha b hb heq
    have hmul : (a : ℝ) * width = (b : ℝ) * width := by linarith
    have hcast : (a : ℝ) = (b : ℝ) := mul_right_cancel₀ hwidth.ne' hmul
    exact Int.cast_injective hcast
  unfold leveque04_threePointPhysicalGridSites threePointPhysicalGridSites
  change ((Finset.Icc (-4 : ℤ) 4).image
      (fun offset : ℤ => X + (offset : ℝ) * width)).card = 9
  rw [Finset.card_image_of_injOn hinj]
  rw [Int.card_Icc]
  norm_num [Int.toNat]

/-- The generic three-point locality theorem supplies the physical five/nine
sample determination claims; the remaining conjuncts are finite geometry. -/
theorem leveque04_threePointFiniteDomainQualified :
    Leveque04ThreePointFiniteDomainQualifiedTarget := by
  constructor
  · intro E F X width i left right hagree
    apply centeredStencilEvolution_threePoint_locality F
    intro j hj
    change left (X + ((j - i : ℤ) : ℝ) * width) =
      right (X + ((j - i : ℤ) : ℝ) * width)
    have hj' : i - 2 ≤ j ∧ j ≤ i + 2 := by
      simpa [Set.mem_Icc] using hj
    have hoff : j - i ∈ Finset.Icc (-2 : ℤ) 2 := by
      simp only [Finset.mem_Icc]
      omega
    exact hagree (j - i) hoff
  · constructor
    · intro E F X width i left right hagree
      apply centeredStencilEvolution_threePoint_locality F
      intro j hj
      change left (X + ((j - i : ℤ) : ℝ) * (width / 2)) =
        right (X + ((j - i : ℤ) : ℝ) * (width / 2))
      have hj' : i - 4 ≤ j ∧ j ≤ i + 4 := by
        simpa [Set.mem_Icc] using hj
      have hoff : j - i ∈ Finset.Icc (-4 : ℤ) 4 := by
        simp only [Finset.mem_Icc]
        omega
      exact hagree (j - i) hoff
    · constructor
      · intro X width hwidth
        have hwidth2 : 0 < width / 2 := by linarith
        exact ⟨threePointPhysicalGridSites_two_card X width hwidth,
          threePointPhysicalGridSites_four_card X (width / 2) hwidth2⟩
      · constructor
        · intro X width
          unfold leveque04_threePointPhysicalGridEnvelope threePointPhysicalGridEnvelope
          congr 1 <;> ring
        · intro X T ratio width hratio hwidth hT
          have hratio0 : ratio ≠ 0 := hratio.ne'
          have hwidth0 : width ≠ 0 := hwidth.ne'
          have hwidthHalf : width / 2 ≠ 0 := (div_pos hwidth (by norm_num)).ne'
          have htime : 0 < ratio * width := mul_pos hratio hwidth
          have htimeHalf : 0 < ratio * (width / 2) :=
            mul_pos hratio (div_pos hwidth (by norm_num))
          have hcoarseRatio : (ratio * width) / width = ratio := by
            field_simp [hwidth0]
          have hfineRatio : (ratio * (width / 2)) / (width / 2) = ratio := by
            field_simp [hwidthHalf]
          have hfineTime : 4 * (ratio * (width / 2)) = T := by
            calc
              4 * (ratio * (width / 2)) = 2 * (ratio * width) := by ring
              _ = T := hT.symm
          have hscale : T / ratio = 2 * width := by
            rw [hT]
            field_simp [hratio0]
          refine ⟨htime, htimeHalf, hcoarseRatio, hfineRatio, hT.symm,
            hfineTime, hscale, ?_⟩
          rw [hscale]
          simp [leveque04_threePointPhysicalGridEnvelope, threePointPhysicalGridEnvelope]

end NumStability