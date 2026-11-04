/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REALinearCauchyRegions
import ComputationalMathematics.Source.LeVeque.Chapter04.UniformReconstructionShift
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveStrength
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Module

/-!
# Actual three-mode Riemann fans and gaps under the exact spread bound

Noninteraction uses the difference of the extreme speeds. Inside a fan the
actual characteristic field equals the adjacent-state Riemann solution,
including its left representative on every internal ray. In a gap it is the
stored state of the intervening cell. No symmetric half-cell CFL bound,
coefficient matrix, bounded data or assumed field identification is needed.
-/

open scoped BigOperators

namespace NumStability

private theorem threeWave_ordered_speed_bounds
    (speeds : Fin 3 → ℝ) (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2) :
    ∀ p, speeds 0 ≤ speeds p ∧ speeds p ≤ speeds 2 := by
  intro p
  fin_cases p
  · change speeds 0 ≤ speeds 0 ∧ speeds 0 ≤ speeds 2
    exact ⟨le_rfl, hs01.trans hs12⟩
  · change speeds 0 ≤ speeds 1 ∧ speeds 1 ≤ speeds 2
    exact ⟨hs01, hs12⟩
  · change speeds 0 ≤ speeds 2 ∧ speeds 2 ≤ speeds 2
    exact ⟨hs01.trans hs12, le_rfl⟩

/-- Under the exact spread bound, every characteristic foot in the open
fan lies strictly between the two neighboring outer grid faces. -/
theorem leveque04_threeWaveEvolution_fan_feet
    (speeds : Fin 3 → ℝ) (origin width time : ℝ) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 0 * time)
      (leveque04_uniformInterface origin width j + speeds 2 * time)) :
    ∀ p, x - speeds p * time ∈
      Set.Ioo (leveque04_uniformInterface origin width (j - 1))
        (leveque04_uniformInterface origin width (j + 1)) := by
  intro p
  have hb := threeWave_ordered_speed_bounds speeds hs01 hs12 p
  have hp0 := mul_le_mul_of_nonneg_right hb.1 htime
  have hp2 := mul_le_mul_of_nonneg_right hb.2 htime
  simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_add, Int.cast_one,
    Set.mem_Ioo] at hx ⊢
  constructor <;> nlinarith [hx.1, hx.2]

/-- Each actual reconstruction sample in the open fan selects its left
adjacent state at and before the moving front, and its right state after it. -/
theorem leveque04_threeWaveEvolution_fan_samples
    {E : Type*} (speeds : Fin 3 → ℝ) (origin width time : ℝ)
    (hwidth : 0 < width) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width)
    (old : ℤ → E) (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 0 * time)
      (leveque04_uniformInterface origin width j + speeds 2 * time)) :
    ∀ p, leveque04_uniformReconstruction origin width old (x - speeds p * time) =
      if x ≤ leveque04_uniformInterface origin width j + speeds p * time
        then old j else old (j + 1) := by
  intro p
  have hfeet := leveque04_threeWaveEvolution_fan_feet speeds origin width time
    htime hs01 hs12 hspread j x hx p
  by_cases hfront : x ≤ leveque04_uniformInterface origin width j + speeds p * time
  · rw [if_pos hfront]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old j
    exact ⟨hfeet.1, by linarith⟩
  · rw [if_neg hfront]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old (j + 1)
    simp only [add_sub_cancel_right]
    exact ⟨by linarith [lt_of_not_ge hfront], hfeet.2.le⟩

/-- The actual field in the open fan is the existing two-state Riemann
solution at that interface, with the left state as its selected origin value. -/
theorem leveque04_threeWaveEvolution_fan_eq_riemann
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width)
    (old : ℤ → Fin 3 → ℝ) (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 0 * time)
      (leveque04_uniformInterface origin width j + speeds 2 * time)) :
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time =
      linearRiemannSolution basis speeds (old j) (old j) (old (j + 1))
        (x - leveque04_uniformInterface origin width j) time := by
  exact leveque04_linearCharacteristic_eq_localFan basis speeds old origin width
    (speeds 0) (speeds 2) time hwidth htime
    (threeWave_ordered_speed_bounds speeds hs01 hs12) hspread j x hx

/-- The actual fan is the left state plus the actual basis waves already
passed. The strict comparison preserves the left value on each moving ray. -/
theorem leveque04_threeWaveEvolution_fan_eq_wave_sum
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (hspread : (speeds 2 - speeds 0) * time ≤ width)
    (old : ℤ → Fin 3 → ℝ) (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 0 * time)
      (leveque04_uniformInterface origin width j + speeds 2 * time)) :
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time =
      old j + ∑ p, if leveque04_uniformInterface origin width j + speeds p * time < x
        then leveque03_riemannWave basis (old j) (old (j + 1)) p else 0 := by
  classical
  have hsamples := leveque04_threeWaveEvolution_fan_samples speeds origin width time
    hwidth htime hs01 hs12 hspread old j x hx
  have hwave (p : Fin 3) : leveque03_riemannWave basis (old j) (old (j + 1)) p =
      (basis.equivFun (old (j + 1)) p - basis.equivFun (old j) p) • basis p := by
    simp only [leveque03_riemannWave, leveque03_waveStrength,
      leveque03_characteristicVariables, leveque03_characteristicCoordinates]
  calc
    linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time =
        ∑ p, ((basis.equivFun (old j) p) • basis p +
          (if leveque04_uniformInterface origin width j + speeds p * time < x
            then leveque03_riemannWave basis (old j) (old (j + 1)) p else 0)) := by
      unfold linearCharacteristicEvolution
      apply Finset.sum_congr rfl
      intro p _
      rw [hsamples p]
      by_cases hp : leveque04_uniformInterface origin width j + speeds p * time < x
      · rw [if_neg (not_le.mpr hp), if_pos hp, hwave p]
        module
      · rw [if_pos (le_of_not_gt hp), if_neg hp, add_zero]
    _ = old j + ∑ p,
        if leveque04_uniformInterface origin width j + speeds p * time < x
          then leveque03_riemannWave basis (old j) (old (j + 1)) p else 0 := by
      rw [Finset.sum_add_distrib, basis.sum_equivFun]

/-- In an open gap every foot lies in the open intervening cell. This
fact needs no additional CFL bound once the gap membership is given. -/
theorem leveque04_threeWaveEvolution_gap_feet
    (speeds : Fin 3 → ℝ) (origin width time : ℝ) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 2 * time)
      (leveque04_uniformInterface origin width (j + 1) + speeds 0 * time)) :
    ∀ p, x - speeds p * time ∈
      leveque04_cell (leveque04_uniformInterface origin width) (j + 1) := by
  intro p
  have hb := threeWave_ordered_speed_bounds speeds hs01 hs12 p
  have hp0 := mul_le_mul_of_nonneg_right hb.1 htime
  have hp2 := mul_le_mul_of_nonneg_right hb.2 htime
  change leveque04_uniformInterface origin width (j + 1 - 1) < x - speeds p * time ∧
    x - speeds p * time < leveque04_uniformInterface origin width (j + 1)
  simp only [add_sub_cancel_right]
  constructor <;> linarith [hx.1, hx.2]

/-- In the open gap the actual field is the stored state of the intervening
cell. Gap membership itself is sufficient; no symmetric or spread CFL is added. -/
theorem leveque04_threeWaveEvolution_gap_eq_state
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hs01 : speeds 0 ≤ speeds 1) (hs12 : speeds 1 ≤ speeds 2)
    (old : ℤ → Fin 3 → ℝ) (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (leveque04_uniformInterface origin width j + speeds 2 * time)
      (leveque04_uniformInterface origin width (j + 1) + speeds 0 * time)) :
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time = old (j + 1) := by
  apply leveque04_linearCharacteristic_eq_gapState basis speeds old origin width
    (speeds 0) (speeds 2) time hwidth htime
    (threeWave_ordered_speed_bounds speeds hs01 hs12) (j + 1) x
  simpa only [add_sub_cancel_right] using hx

/-- Equality in the spread bound makes the open gap empty. The fan and gap
statements therefore retain the nonstrict noninteraction condition at contact. -/
theorem leveque04_threeWaveEvolution_gap_eq_empty_of_contact
    (speeds : Fin 3 → ℝ) (origin width time : ℝ)
    (hcontact : (speeds 2 - speeds 0) * time = width) (j : ℤ) :
    Set.Ioo (leveque04_uniformInterface origin width j + speeds 2 * time)
      (leveque04_uniformInterface origin width (j + 1) + speeds 0 * time) = ∅ := by
  have hfront : leveque04_uniformInterface origin width j + speeds 2 * time =
      leveque04_uniformInterface origin width (j + 1) + speeds 0 * time := by
    simp only [leveque04_uniformInterface, Int.cast_add, Int.cast_one]
    nlinarith [hcontact]
  rw [hfront, Set.Ioo_self]

end NumStability
