/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TranslatedMeshWindow
import Mathlib.Analysis.Normed.Lp.lpSpace
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic

/-!
# Physical norm bounds on translated mesh windows

A closed physical window contains at most its length divided by the mesh width
plus one lattice site. A sequence supported in this window therefore satisfies
the corresponding physical weighted `lp` bound from its coordinate bounds.
The results allow arbitrary mesh origins, empty windows, generic normed additive
groups, and every exponent at least one, including infinity.

Applications must establish the stated support and coordinate bounds separately.
-/

open scoped BigOperators ENNReal

universe u
namespace NumStability

/-- The upper physical mass bound includes empty windows and arbitrary origins. -/
theorem translatedMeshWindow_width_card_le
    (a b origin width : ℝ) (hab : a ≤ b) (hwidth : 0 < width) :
    width * ((translatedMeshWindow a b origin width).card : ℝ) ≤
      b - a + width := by
  let α : ℝ := (a - origin) / width
  let β : ℝ := (b - origin) / width
  let lo : ℤ := ⌈α⌉
  let hi : ℤ := ⌊β⌋
  have hαβ : α ≤ β := by
    dsimp [α, β]
    exact div_le_div_of_nonneg_right (sub_le_sub_right hab origin) hwidth.le
  have hlohi : lo ≤ hi + 1 :=
    (Int.ceil_le_floor_add_one α).trans
      (Int.add_le_add_right (Int.floor_mono hαβ) 1)
  have hcardZ : ((Finset.Icc lo hi).card : ℤ) = hi + 1 - lo :=
    Int.card_Icc_of_le lo hi hlohi
  have hcardR : ((Finset.Icc lo hi).card : ℝ) =
      (hi : ℝ) + 1 - (lo : ℝ) := by
    have h := congrArg (fun z : ℤ => (z : ℝ)) hcardZ
    simpa only [Int.cast_natCast, Int.cast_sub, Int.cast_add, Int.cast_one] using h
  have hceil : α ≤ (lo : ℝ) := Int.le_ceil α
  have hfloor : (hi : ℝ) ≤ β := Int.floor_le β
  have hcount : ((Finset.Icc lo hi).card : ℝ) ≤ β - α + 1 := by
    rw [hcardR]
    linarith
  have hmass := mul_le_mul_of_nonneg_left hcount hwidth.le
  have hα : α * width = a - origin := by
    dsimp [α]
    exact div_mul_cancel₀ _ hwidth.ne'
  have hβ : β * width = b - origin := by
    dsimp [β]
    exact div_mul_cancel₀ _ hwidth.ne'
  have hlength : width * (β - α + 1) = b - a + width := by
    calc
      width * (β - α + 1) = β * width - α * width + width := by ring
      _ = b - a + width := by rw [hβ, hα]; ring
  rw [hlength] at hmass
  exact hmass

/-- Existing `lp` with exact finite physical-window support; no new norm or state type. -/
def PhysicalLpWindowUpperBound : Prop :=
  ∀ (E : Type u) [NormedAddCommGroup E] (p : ENNReal) [Fact (1 ≤ p)]
    (a b origin width C : ℝ) (u : lp (fun _ : ℤ => E) p),
    a ≤ b → 0 < width → 0 ≤ C →
    (∀ j, j ∉ translatedMeshWindow a b origin width → u j = 0) →
    (∀ j ∈ translatedMeshWindow a b origin width, ‖u j‖ ≤ C) →
    width ^ (1 / p.toReal) * ‖u‖ ≤ (b - a + width) ^ (1 / p.toReal) * C

theorem physicalLpWindowUpperBound : PhysicalLpWindowUpperBound.{u} := by
  intro E hE p hp a b origin width C u hab hwidth hC hsupp hbound
  classical
  let W : Finset ℤ := translatedMeshWindow a b origin width
  have hN : 0 ≤ (W.card : ℝ) := Nat.cast_nonneg _
  have hmass : width * (W.card : ℝ) ≤ b - a + width :=
    translatedMeshWindow_width_card_le a b origin width hab hwidth
  by_cases hpinf : p = ∞
  · subst p
    have hn : ‖u‖ ≤ C := lp.norm_le_of_forall_le hC (fun j => by
      by_cases hj : j ∈ W
      · exact hbound j hj
      · simpa [hsupp j hj] using hC)
    simpa using hn
  · have hpr : 0 < p.toReal := (ENNReal.toReal_pos_iff_ne_top p).mpr hpinf
    have hrepr : (∑ j ∈ W, lp.single p j (u j)) = u := by
      ext j
      simp only [lp.coeFn_sum, lp.coeFn_single, Finset.sum_apply, Finset.sum_pi_single]
      by_cases hj : j ∈ W
      · simp [hj]
      · simp [hj, hsupp j hj]
    have hnorm : ‖u‖ ^ p.toReal = ∑ j ∈ W, ‖u j‖ ^ p.toReal := by
      have h := lp.norm_sum_single (p := p) hpr (fun j : ℤ => u j) W
      rw [hrepr] at h
      exact h
    have hpower : ‖u‖ ^ p.toReal ≤ (W.card : ℝ) * C ^ p.toReal := by
      rw [hnorm]
      calc
        (∑ j ∈ W, ‖u j‖ ^ p.toReal) ≤ ∑ _j ∈ W, C ^ p.toReal := by
          apply Finset.sum_le_sum
          intro j hj
          exact Real.rpow_le_rpow (norm_nonneg _) (hbound j hj) hpr.le
        _ = (W.card : ℝ) * C ^ p.toReal := by simp
    have hroot : ((W.card : ℝ) ^ (1 / p.toReal)) ^ p.toReal = (W.card : ℝ) := by
      rw [one_div, Real.rpow_inv_rpow hN hpr.ne']
    have hK : 0 ≤ (W.card : ℝ) ^ (1 / p.toReal) * C :=
      mul_nonneg (Real.rpow_nonneg hN _) hC
    have hn : ‖u‖ ≤ (W.card : ℝ) ^ (1 / p.toReal) * C := by
      apply (Real.rpow_le_rpow_iff (norm_nonneg u) hK hpr).mp
      rw [Real.mul_rpow (Real.rpow_nonneg hN _) hC, hroot]
      exact hpower
    calc
      width ^ (1 / p.toReal) * ‖u‖ ≤
          width ^ (1 / p.toReal) * ((W.card : ℝ) ^ (1 / p.toReal) * C) :=
        mul_le_mul_of_nonneg_left hn (Real.rpow_nonneg hwidth.le _)
      _ = (width * (W.card : ℝ)) ^ (1 / p.toReal) * C := by
        rw [Real.mul_rpow hwidth.le hN]
        ring
      _ ≤ (b - a + width) ^ (1 / p.toReal) * C := by
        apply mul_le_mul_of_nonneg_right _ hC
        exact Real.rpow_le_rpow (mul_nonneg hwidth.le hN) hmass
          (one_div_nonneg.mpr hpr.le)

end NumStability
