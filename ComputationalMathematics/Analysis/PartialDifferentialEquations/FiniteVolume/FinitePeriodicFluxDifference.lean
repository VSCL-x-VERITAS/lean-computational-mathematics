/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# Conservative flux differences on a finite periodic grid

The successor permutation identifies each right face with another cell's left
face. Summing the update therefore cancels all face contributions exactly.
-/

namespace NumStability

/-- A finite periodic conservative update, with `shift` taking a cell to its
right neighbor and `faceFlux i` denoting its left-face flux. -/
def finitePeriodicFluxDifferenceUpdate
    {V : Type*} [Fintype V]
    (shift : V ≃ V) (ratio : ℝ)
    (cellAverage faceFlux : V → ℝ) (i : V) : ℝ :=
  cellAverage i - ratio * (faceFlux (shift i) - faceFlux i)

/-- Every finite periodic flux-difference step preserves the cell sum,
independently of how the face flux was selected. -/
theorem finitePeriodicFluxDifferenceUpdate_conserve
    {V : Type*} [Fintype V]
    (shift : V ≃ V) (ratio : ℝ)
    (cellAverage faceFlux : V → ℝ) :
    (∑ i, finitePeriodicFluxDifferenceUpdate shift ratio
      cellAverage faceFlux i) = ∑ i, cellAverage i := by
  have hshift : (∑ i, faceFlux (shift i)) = ∑ i, faceFlux i := by
    exact Equiv.sum_comp shift faceFlux
  simp only [finitePeriodicFluxDifferenceUpdate, Finset.sum_sub_distrib,
    ← Finset.mul_sum]
  rw [hshift]
  ring

/-- A two-state numerical flux supplies the left-face flux on a finite
periodic scalar grid. -/
noncomputable def finitePeriodicTwoStateFluxStep
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ → ℝ) (ratio : ℝ)
    (u : ZMod n → ℝ) (i : ZMod n) : ℝ :=
  finitePeriodicFluxDifferenceUpdate (Equiv.addRight (1 : ZMod n)) ratio
    u (fun j => flux (u (j - 1)) (u j)) i

/-- A monotone two-state flux gives an order-preserving periodic step when
the sum of its two local self-state effects satisfies the CFL bound. The
conditions refer to the chosen numerical flux, not to an unspecified solver. -/
theorem finitePeriodicTwoStateFluxStep_monotone
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ → ℝ) (ratio : ℝ)
    (hratio : 0 ≤ ratio)
    (hleft : ∀ a b c, a ≤ b → flux a c ≤ flux b c)
    (hright : ∀ a b c, a ≤ b → flux c b ≤ flux c a)
    (hcfl : ∀ a b l r, a ≤ b →
      ratio * ((flux b r - flux a r) + (flux l a - flux l b)) ≤ b - a)
    (u v : ZMod n → ℝ) (huv : ∀ i, u i ≤ v i) (i : ZMod n) :
    finitePeriodicTwoStateFluxStep n flux ratio u i ≤
      finitePeriodicTwoStateFluxStep n flux ratio v i := by
  have hrightNeighbor :
      flux (v i) (v (i + 1)) ≤ flux (v i) (u (i + 1)) :=
    hright (u (i + 1)) (v (i + 1)) (v i) (huv _)
  have hleftNeighbor :
      flux (u (i - 1)) (v i) ≤ flux (v (i - 1)) (v i) :=
    hleft (u (i - 1)) (v (i - 1)) (v i) (huv _)
  have hlocal := hcfl (u i) (v i) (u (i - 1)) (u (i + 1)) (huv i)
  dsimp [finitePeriodicTwoStateFluxStep,
    finitePeriodicFluxDifferenceUpdate, Equiv.addRight] at ⊢
  simp only [add_sub_cancel_right] at ⊢
  have hr := mul_le_mul_of_nonneg_left hrightNeighbor hratio
  have hl := mul_le_mul_of_nonneg_left hleftNeighbor hratio
  linarith

/-- Separate one-sided Lipschitz bounds on the two flux arguments imply
the local CFL condition needed for an order-preserving periodic step. -/
theorem finitePeriodicTwoStateFluxStep_monotone_of_lipschitz
    (n : ℕ) [NeZero n] (flux : ℝ → ℝ → ℝ)
    (ratio leftBound rightBound : ℝ)
    (hratio : 0 ≤ ratio)
    (hcfl : ratio * (leftBound + rightBound) ≤ 1)
    (hleft : ∀ a b c, a ≤ b → flux a c ≤ flux b c)
    (hright : ∀ a b c, a ≤ b → flux c b ≤ flux c a)
    (hleftBound : ∀ a b c, a ≤ b →
      flux b c - flux a c ≤ leftBound * (b - a))
    (hrightBound : ∀ a b c, a ≤ b →
      flux c a - flux c b ≤ rightBound * (b - a))
    (u v : ZMod n → ℝ) (huv : ∀ i, u i ≤ v i)
    (i : ZMod n) :
    finitePeriodicTwoStateFluxStep n flux ratio u i ≤
      finitePeriodicTwoStateFluxStep n flux ratio v i := by
  have hcflLocal : ∀ a b l r, a ≤ b →
      ratio * ((flux b r - flux a r) +
        (flux l a - flux l b)) ≤ b - a := by
    intro a b l r hab
    have hsum :
        (flux b r - flux a r) + (flux l a - flux l b) ≤
          (leftBound + rightBound) * (b - a) := by
      nlinarith [hleftBound a b r hab, hrightBound a b l hab]
    have hscaled := mul_le_mul_of_nonneg_left hsum hratio
    have hgap : 0 ≤ b - a := sub_nonneg.mpr hab
    have hlimit := mul_le_mul_of_nonneg_right hcfl hgap
    nlinarith [hscaled, hlimit]
  exact finitePeriodicTwoStateFluxStep_monotone n flux ratio
    hratio hleft hright hcflLocal u v huv i

/-- Adjacent face-error cancellation controls the one-step defect on any
finite periodic grid. The exact comparison state uses the same conservative
update with its ideal face flux. -/
theorem finitePeriodicFluxDifferenceUpdate_localDefect_of_faceDifference
    {V : Type*} [Fintype V]
    (shift : V ≃ V)
    (old exactFace numericalFace exactNext : V → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hexact : ∀ i, exactNext i =
      finitePeriodicFluxDifferenceUpdate shift (timeStep / width)
        old exactFace i)
    (hface : ∀ i,
      |((numericalFace (shift i) - exactFace (shift i)) -
          (numericalFace i - exactFace i))| ≤ bound * width ^ 2)
    (i : V) :
    |finitePeriodicFluxDifferenceUpdate shift (timeStep / width)
        old numericalFace i - exactNext i| ≤
      timeStep * bound * width := by
  have hidentity :
      (finitePeriodicFluxDifferenceUpdate shift (timeStep / width)
          old numericalFace i - exactNext i) / timeStep =
        -((numericalFace (shift i) - exactFace (shift i)) -
          (numericalFace i - exactFace i)) / width := by
    rw [hexact i]
    simp only [finitePeriodicFluxDifferenceUpdate]
    field_simp
    ring
  have hnormalized :
      |(finitePeriodicFluxDifferenceUpdate shift (timeStep / width)
          old numericalFace i - exactNext i) / timeStep| ≤
        bound * width := by
    rw [hidentity, abs_div, abs_neg, abs_of_pos hwidth]
    apply (div_le_iff₀ hwidth).2
    calc
      _ ≤ bound * width ^ 2 := hface i
      _ = (bound * width) * width := by ring
  have hscaled := mul_le_mul_of_nonneg_right hnormalized htime.le
  rw [abs_div, abs_of_pos htime, div_mul_cancel₀ _ (ne_of_gt htime)] at hscaled
  nlinarith [hscaled]

end NumStability
