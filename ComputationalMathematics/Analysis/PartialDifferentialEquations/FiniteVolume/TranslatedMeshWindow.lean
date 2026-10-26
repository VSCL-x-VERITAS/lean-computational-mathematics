/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.Data.Finset.Card
import Mathlib.Data.Int.Interval
import Mathlib.Data.Real.Archimedean
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Integer windows in translated real meshes

Counting bounds for sites in a closed physical interval, uniform in every real
mesh origin. Positive width and interval-length bounds give a uniform physical
mass lower bound and nonemptiness.
-/

namespace NumStability

/-- Integer sites of an arbitrary translated
positive-width mesh whose physical positions lie in a closed real interval. -/
noncomputable def translatedMeshWindow
    (a b origin width : ℝ) : Finset ℤ :=
  Finset.Icc ⌈(a - origin) / width⌉ ⌊(b - origin) / width⌋

/-- Both physical endpoints are included, with no
restriction on the sign or grid phase of the real origin or interval. -/
theorem mem_translatedMeshWindow_iff
    (a b origin width : ℝ) (hwidth : 0 < width) (j : ℤ) :
    j ∈ translatedMeshWindow a b origin width ↔
      a ≤ origin + (j : ℝ) * width ∧
        origin + (j : ℝ) * width ≤ b := by
  rw [translatedMeshWindow, Finset.mem_Icc, Int.ceil_le, Int.le_floor]
  constructor
  · rintro ⟨hleft, hright⟩
    have hleft' := (div_le_iff₀ hwidth).mp hleft
    have hright' := (le_div_iff₀ hwidth).mp hright
    constructor <;> linarith
  · rintro ⟨hleft, hright⟩
    constructor
    · apply (div_le_iff₀ hwidth).mpr
      linarith
    · apply (le_div_iff₀ hwidth).mpr
      linarith

/-- The strict length-minus-width lower bound holds
for every positive width; this theorem does not assume nonemptiness. -/
theorem translatedMeshWindow_width_card_gt
    (a b origin width : ℝ) (hab : a < b) (hwidth : 0 < width) :
    b - a - width <
      width * ((translatedMeshWindow a b origin width).card : ℝ) := by
  let α : ℝ := (a - origin) / width
  let β : ℝ := (b - origin) / width
  let p : ℤ := ⌈α⌉
  let q : ℤ := ⌊β⌋
  have hαβ : α ≤ β := by
    dsimp [α, β]
    exact div_le_div_of_nonneg_right
      (sub_le_sub_right hab.le origin) hwidth.le
  have hpq : p ≤ q + 1 :=
    (Int.ceil_le_floor_add_one α).trans
      (Int.add_le_add_right (Int.floor_mono hαβ) 1)
  have hcardZ : ((Finset.Icc p q).card : ℤ) = q + 1 - p :=
    Int.card_Icc_of_le p q hpq
  have hcardR : ((Finset.Icc p q).card : ℝ) =
      (q : ℝ) + 1 - (p : ℝ) := by
    have h := congrArg (fun z : ℤ => (z : ℝ)) hcardZ
    simpa only [Int.cast_natCast, Int.cast_sub, Int.cast_add,
      Int.cast_one] using h
  have hceil : (p : ℝ) < α + 1 := Int.ceil_lt_add_one α
  have hfloor : β - 1 < (q : ℝ) := Int.sub_one_lt_floor β
  have hcount : β - α - 1 < ((Finset.Icc p q).card : ℝ) := by
    rw [hcardR]
    linarith
  have hmass := mul_lt_mul_of_pos_right hcount hwidth
  have hα : α * width = a - origin := by
    dsimp [α]
    exact div_mul_cancel₀ _ hwidth.ne'
  have hβ : β * width = b - origin := by
    dsimp [β]
    exact div_mul_cancel₀ _ hwidth.ne'
  have hlength : (β - α - 1) * width = b - a - width := by
    calc
      (β - α - 1) * width = β * width - α * width - width := by ring
      _ = b - a - width := by rw [hβ, hα]; ring
  rw [hlength] at hmass
  change b - a - width < width * ((Finset.Icc p q).card : ℝ)
  calc
    b - a - width < ((Finset.Icc p q).card : ℝ) * width := hmass
    _ = width * ((Finset.Icc p q).card : ℝ) := mul_comm _ _

/-- The threshold and positive lower bound depend
only on interval length, uniformly in every real mesh origin. -/
theorem translatedMeshWindow_half_length_le
    (a b origin width : ℝ) (hab : a < b) (hwidth : 0 < width)
    (hsmall : width ≤ (b - a) / 2) :
    (b - a) / 2 ≤
      width * ((translatedMeshWindow a b origin width).card : ℝ) := by
  have h := translatedMeshWindow_width_card_gt a b origin width hab hwidth
  linarith

/-- Nonemptiness follows from the positive physical
mass bound rather than being a hidden premise of the cardinality formula. -/
theorem translatedMeshWindow_nonempty
    (a b origin width : ℝ) (hab : a < b) (hwidth : 0 < width)
    (hsmall : width ≤ (b - a) / 2) :
    (translatedMeshWindow a b origin width).Nonempty := by
  have hhalf : 0 < (b - a) / 2 := half_pos (sub_pos.mpr hab)
  have hmass : 0 <
      width * ((translatedMeshWindow a b origin width).card : ℝ) :=
    hhalf.trans_le
      (translatedMeshWindow_half_length_le a b origin width hab hwidth hsmall)
  have hcard : 0 < ((translatedMeshWindow a b origin width).card : ℝ) :=
    (mul_pos_iff_of_pos_left hwidth).mp hmass
  exact Finset.card_pos.mp (Nat.cast_pos.mp hcard)

end NumStability
