/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ThreeWaveTraceGeometry
import Mathlib.Data.Set.Card

/-!
# Active discontinuities of the actual three-wave field inside a cell

The global characteristic-coordinate criterion identifies the three possible
incoming waves without assuming any ordering between their translated fronts.
Strict separation makes their locations distinct; contact merges two locations
without allowing cancellation between their independent basis modes.
-/

namespace NumStability

/-- A bound on the total positive-to-negative spread implies the full
one-cell travel bound for every mode. -/
theorem leveque04_threeWaveEvolution_cfl_of_spread_le
    (speeds : Fin 3 → ℝ) (width time : ℝ) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width) :
    ∀ p, |speeds p * time| ≤ width := by
  have hpositive : 0 < speeds 1 * time := mul_pos hs1 htime
  have hordered : speeds 1 * time < speeds 2 * time :=
    mul_lt_mul_of_pos_right hs12 htime
  have hnegative : speeds 0 * time < 0 := mul_neg_of_neg_of_pos hs0 htime
  intro p
  fin_cases p
  · change |speeds 0 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith
  · change |speeds 1 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith
  · change |speeds 2 * time| ≤ width
    apply abs_le.mpr
    constructor <;> nlinarith

private theorem positive_shift_interface_in_cell
    (origin width shift : ℝ) (hwidth : 0 < width)
    (hshift : 0 < shift) (hbound : shift ≤ width) (i j : ℤ)
    (hz : leveque04_uniformInterface origin width j + shift ∈
      leveque04_cell (leveque04_uniformInterface origin width) i) :
    j = i - 1 := by
  change leveque04_uniformInterface origin width (i - 1) <
      leveque04_uniformInterface origin width j + shift ∧
    leveque04_uniformInterface origin width j + shift <
      leveque04_uniformInterface origin width i at hz
  simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one] at hz
  have hupper : j < i := by
    by_contra h
    have hji : (i : ℝ) ≤ (j : ℝ) := by exact_mod_cast (le_of_not_gt h)
    have hm := mul_le_mul_of_nonneg_right hji hwidth.le
    linarith [hz.2]
  have hlower : i - 2 < j := by
    by_contra h
    have hji : (j : ℝ) ≤ (i : ℝ) - 2 := by exact_mod_cast (le_of_not_gt h)
    have hm := mul_le_mul_of_nonneg_right hji hwidth.le
    nlinarith [hz.1]
  omega

private theorem negative_shift_interface_in_cell
    (origin width shift : ℝ) (hwidth : 0 < width)
    (hshift : shift < 0) (hbound : -width ≤ shift) (i j : ℤ)
    (hz : leveque04_uniformInterface origin width j + shift ∈
      leveque04_cell (leveque04_uniformInterface origin width) i) :
    j = i := by
  change leveque04_uniformInterface origin width (i - 1) <
      leveque04_uniformInterface origin width j + shift ∧
    leveque04_uniformInterface origin width j + shift <
      leveque04_uniformInterface origin width i at hz
  simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one] at hz
  have hupper : j < i + 1 := by
    by_contra h
    have hji : (i : ℝ) + 1 ≤ (j : ℝ) := by exact_mod_cast (le_of_not_gt h)
    have hm := mul_le_mul_of_nonneg_right hji hwidth.le
    nlinarith [hz.2]
  have hlower : i - 1 < j := by
    by_contra h
    have hji : (j : ℝ) ≤ (i : ℝ) - 1 := by exact_mod_cast (le_of_not_gt h)
    have hm := mul_le_mul_of_nonneg_right hji hwidth.le
    nlinarith [hz.1]
  omega

/-- Inside the actual open cell, discontinuities are exactly the nonzero
incoming basis waves at their translated fronts. The fronts may cross or
coincide, and a front at a cell endpoint is excluded by the open-cell premise. -/
theorem leveque04_threeWaveEvolution_interior_not_continuousAt_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcfl : ∀ p, |speeds p * time| ≤ width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) (z : ℝ)
    (hzcell : z ∈ leveque04_cell (leveque04_uniformInterface origin width) i) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let c1 := leveque04_uniformInterface origin width (i - 1) + speeds 1 * time
    let c2 := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
    let d0 := leveque04_uniformInterface origin width i + speeds 0 * time
    ¬ ContinuousAt U z ↔
      (z = c1 ∧ WL 1 ≠ 0) ∨ (z = c2 ∧ WL 2 ≠ 0) ∨ (z = d0 ∧ WR 0 ≠ 0) := by
  dsimp only
  rw [leveque04_linearUniformEvolution_not_continuousAt_iff
    basis speeds origin width hwidth old time z]
  constructor
  · rintro ⟨p, j, hz, hactive⟩
    fin_cases p
    · change z = leveque04_uniformInterface origin width j + speeds 0 * time at hz
      have hj := negative_shift_interface_in_cell origin width (speeds 0 * time)
        hwidth (mul_neg_of_neg_of_pos hs0 htime) (abs_le.mp (hcfl 0)).1 i j
        (by rw [← hz]; exact hzcell)
      subst j
      exact Or.inr (Or.inr ⟨hz, hactive⟩)
    · change z = leveque04_uniformInterface origin width j + speeds 1 * time at hz
      have hj := positive_shift_interface_in_cell origin width (speeds 1 * time)
        hwidth (mul_pos hs1 htime) (abs_le.mp (hcfl 1)).2 i j
        (by rw [← hz]; exact hzcell)
      subst j
      exact Or.inl ⟨hz, by simpa only [sub_add_cancel] using hactive⟩
    · change z = leveque04_uniformInterface origin width j + speeds 2 * time at hz
      have hj := positive_shift_interface_in_cell origin width (speeds 2 * time)
        hwidth (mul_pos (lt_trans hs1 hs12) htime) (abs_le.mp (hcfl 2)).2 i j
        (by rw [← hz]; exact hzcell)
      subst j
      exact Or.inr (Or.inl ⟨hz, by simpa only [sub_add_cancel] using hactive⟩)
  · rintro (⟨hz, hactive⟩ | ⟨hz, hactive⟩ | ⟨hz, hactive⟩)
    · exact ⟨1, i - 1, hz, by simpa only [sub_add_cancel] using hactive⟩
    · exact ⟨2, i - 1, hz, by simpa only [sub_add_cancel] using hactive⟩
    · exact ⟨0, i, hz, hactive⟩

private theorem ncard_active_three_eq_three_iff
    {α : Type*} (a b c : α) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (P Q R : Prop) :
    ({z | (z = a ∧ P) ∨ (z = b ∧ Q) ∨ (z = c ∧ R)} : Set α).ncard = 3 ↔
      P ∧ Q ∧ R := by
  classical
  have hs : ({z | (z = a ∧ P) ∨ (z = b ∧ Q) ∨ (z = c ∧ R)} : Set α) =
      (if P then {a} else ∅) ∪ ((if Q then {b} else ∅) ∪
        (if R then {c} else ∅)) := by
    ext z
    by_cases hp : P <;> by_cases hq : Q <;> by_cases hr : R <;>
      simp [hp, hq, hr, or_comm, or_left_comm]
  rw [hs]
  by_cases hp : P <;> by_cases hq : Q <;> by_cases hr : R <;>
    simp [hp, hq, hr, Set.ncard_insert_of_notMem, hab.symm, hac.symm, hbc.symm]

/-- In the strictly separated case, there are exactly three discontinuities
in the open cell precisely when all three actual incoming waves are nonzero. -/
theorem leveque04_threeWaveEvolution_strict_interior_ncard_eq_three_iff
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hsep : (speeds 2 - speeds 0) * time < width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let a := leveque04_uniformInterface origin width (i - 1)
    let b := leveque04_uniformInterface origin width i
    ({z | ¬ ContinuousAt U z} ∩ Set.Ioo a b).ncard = 3 ↔
      WL 1 ≠ 0 ∧ WL 2 ≠ 0 ∧ WR 0 ≠ 0 := by
  dsimp only
  let U := fun x => linearCharacteristicEvolution basis speeds
    (leveque04_uniformReconstruction origin width old) x time
  let c1 := leveque04_uniformInterface origin width (i - 1) + speeds 1 * time
  let c2 := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
  let d0 := leveque04_uniformInterface origin width i + speeds 0 * time
  have hcfl := leveque04_threeWaveEvolution_cfl_of_spread_le speeds width time
    htime hs0 hs1 hs12 hsep.le
  rcases (leveque04_threeWaveEvolution_strict_separation_iff
    speeds origin width time htime hs0 hs1 hs12 i).2 hsep with ⟨ha1, h12, h20, h0b⟩
  have hs : {z | ¬ ContinuousAt U z} ∩
      Set.Ioo (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i) =
      {z | (z = c1 ∧ leveque03_riemannWave basis (old (i - 1)) (old i) 1 ≠ 0) ∨
        (z = c2 ∧ leveque03_riemannWave basis (old (i - 1)) (old i) 2 ≠ 0) ∨
        (z = d0 ∧ leveque03_riemannWave basis (old i) (old (i + 1)) 0 ≠ 0)} := by
    ext z
    constructor
    · intro hz
      exact (leveque04_threeWaveEvolution_interior_not_continuousAt_iff basis speeds
        origin width time hwidth htime hs0 hs1 hs12 hcfl old i z hz.2).1 hz.1
    · intro hz
      have hzcell : z ∈ leveque04_cell (leveque04_uniformInterface origin width) i := by
        rcases hz with (⟨rfl, _⟩ | ⟨rfl, _⟩ | ⟨rfl, _⟩)
        · exact ⟨ha1, by linarith⟩
        · exact ⟨by linarith, by linarith⟩
        · exact ⟨by linarith, h0b⟩
      exact ⟨(leveque04_threeWaveEvolution_interior_not_continuousAt_iff basis speeds
        origin width time hwidth htime hs0 hs1 hs12 hcfl old i z hzcell).2 hz, hzcell⟩
  change ({z | ¬ ContinuousAt U z} ∩ _).ncard = 3 ↔ _
  rw [hs]
  exact ncard_active_three_eq_three_iff c1 c2 d0 h12.ne (lt_trans h12 h20).ne h20.ne
    _ _ _

/-- At contact, at most two discontinuity locations lie in the open cell,
regardless of which actual incoming waves vanish. -/
theorem leveque04_threeWaveEvolution_contact_interior_ncard_le_two
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcontact : (speeds 2 - speeds 0) * time = width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let a := leveque04_uniformInterface origin width (i - 1)
    let b := leveque04_uniformInterface origin width i
    ({z | ¬ ContinuousAt U z} ∩ Set.Ioo a b).ncard ≤ 2 := by
  dsimp only
  let c1 := leveque04_uniformInterface origin width (i - 1) + speeds 1 * time
  let c2 := leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
  rcases leveque04_threeWaveEvolution_contact_geometry speeds origin width time
    hwidth htime hs0 hs1 hs12 hcontact i with ⟨hcfl, _, h12, h20, _⟩
  have hsubset : {z | ¬ ContinuousAt (fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time) z} ∩
      Set.Ioo (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i) ⊆ ({c1, c2} : Set ℝ) := by
    intro z hz
    have h := (leveque04_threeWaveEvolution_interior_not_continuousAt_iff basis speeds
      origin width time hwidth htime hs0 hs1 hs12 hcfl old i z hz.2).1 hz.1
    rcases h with (⟨hz, _⟩ | ⟨hz, _⟩ | ⟨hz, _⟩)
    · exact Set.mem_insert_iff.mpr (Or.inl hz)
    · exact Set.mem_insert_iff.mpr (Or.inr (Set.mem_singleton_iff.mpr hz))
    · exact Set.mem_insert_iff.mpr
        (Or.inr (Set.mem_singleton_iff.mpr (hz.trans h20.symm)))
  calc
    _ ≤ ({c1, c2} : Set ℝ).ncard :=
      Set.ncard_le_ncard hsubset ((Set.finite_singleton c2).insert c1)
    _ = 2 := Set.ncard_pair h12.ne

end NumStability
