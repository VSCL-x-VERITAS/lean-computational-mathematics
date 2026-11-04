/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UniformReconstructionShift
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannWaveStrength
import Mathlib.Tactic.Module

/-!
# The actual three-wave characteristic field inside one cell

Two positive modes enter from the left interface and one negative mode enters
from the right. The full one-cell travel bound gives an exact field formula
even when the fronts meet or cross. A separate strict separation condition
identifies the four open constant regions.
-/

namespace NumStability

/-- The actual characteristic evolution is the current cell state with the
two incoming left-face waves subtracted before their fronts and the incoming
right-face wave added after its front. Moving-front values retain the actual
left-continuous reconstruction representative. -/
theorem leveque04_threeWaveEvolution_formula
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcfl : ∀ p, |speeds p * time| ≤ width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) (x : ℝ)
    (hx : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i) :
    linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time =
      old i -
        (if x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time
          then leveque03_riemannWave basis (old (i - 1)) (old i) 1 else 0) -
        (if x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time
          then leveque03_riemannWave basis (old (i - 1)) (old i) 2 else 0) +
        (if leveque04_uniformInterface origin width i + speeds 0 * time < x
          then leveque03_riemannWave basis (old i) (old (i + 1)) 0 else 0) := by
  have hsample0 := leveque04_uniformReconstruction_shift_nonpos
    origin width hwidth old i x (speeds 0 * time) hx
    ⟨(abs_le.mp (hcfl 0)).1, mul_nonpos_of_nonpos_of_nonneg hs0.le htime.le⟩
  have hsample1 := leveque04_uniformReconstruction_shift_nonneg
    origin width hwidth old i x (speeds 1 * time) hx
    ⟨mul_nonneg hs1.le htime.le, (le_abs_self _).trans (hcfl 1)⟩
  have hsample2 := leveque04_uniformReconstruction_shift_nonneg
    origin width hwidth old i x (speeds 2 * time) hx
    ⟨mul_nonneg (lt_trans hs1 hs12).le htime.le, (le_abs_self _).trans (hcfl 2)⟩
  have hwave (left right : Fin 3 → ℝ) (p : Fin 3) :
      leveque03_riemannWave basis left right p =
        (basis.equivFun right p - basis.equivFun left p) • basis p := by
    simp only [leveque03_riemannWave, leveque03_waveStrength,
      leveque03_characteristicVariables, leveque03_characteristicCoordinates]
  have hbase :
      (basis.equivFun (old i) 0) • basis 0 +
        (basis.equivFun (old i) 1) • basis 1 +
        (basis.equivFun (old i) 2) • basis 2 = old i := by
    simpa only [Fin.sum_univ_three] using basis.sum_equivFun (old i)
  conv_rhs =>
    lhs
    lhs
    lhs
    rw [← hbase]
  simp only [linearCharacteristicEvolution, Fin.sum_univ_three,
    hsample0, hsample1, hsample2, hwave, apply_ite]
  split_ifs <;> module

/-- The ordered left/right fronts bound four nonempty open regions exactly
when the fastest positive and negative fronts have not met. The statement is
geometric and requires neither a coefficient matrix nor wave amplitudes. -/
theorem leveque04_threeWaveEvolution_strict_separation_iff
    (speeds : Fin 3 → ℝ) (origin width time : ℝ) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (i : ℤ) :
    let a := leveque04_uniformInterface origin width (i - 1)
    let b := leveque04_uniformInterface origin width i
    let c1 := a + speeds 1 * time
    let c2 := a + speeds 2 * time
    let d0 := b + speeds 0 * time
    a < c1 ∧ c1 < c2 ∧ c2 < d0 ∧ d0 < b ↔
      (speeds 2 - speeds 0) * time < width := by
  dsimp only
  have hspan : leveque04_uniformInterface origin width i -
      leveque04_uniformInterface origin width (i - 1) = width := by
    simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one]
    ring
  have hpositive : 0 < speeds 1 * time := mul_pos hs1 htime
  have hordered : speeds 1 * time < speeds 2 * time :=
    mul_lt_mul_of_pos_right hs12 htime
  have hnegative : speeds 0 * time < 0 := mul_neg_of_neg_of_pos hs0 htime
  constructor
  · intro h
    nlinarith [h.2.2.1]
  · intro h
    exact ⟨by linarith, by linarith, by nlinarith, by linarith⟩

/-- In the strictly separated case the actual characteristic field has the
four stated constant values on the four open regions. Wave amplitudes may
vanish, so neighboring constant values need not be distinct. -/
theorem leveque04_threeWaveEvolution_open_regions
    (basis : Module.Basis (Fin 3) ℝ (Fin 3 → ℝ)) (speeds : Fin 3 → ℝ)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 < time)
    (hs0 : speeds 0 < 0) (hs1 : 0 < speeds 1) (hs12 : speeds 1 < speeds 2)
    (hcfl : ∀ p, |speeds p * time| ≤ width)
    (hsep : (speeds 2 - speeds 0) * time < width)
    (old : ℤ → Fin 3 → ℝ) (i : ℤ) :
    let U := fun x => linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width old) x time
    let WL := leveque03_riemannWave basis (old (i - 1)) (old i)
    let WR := leveque03_riemannWave basis (old i) (old (i + 1))
    let a := leveque04_uniformInterface origin width (i - 1)
    let b := leveque04_uniformInterface origin width i
    let c1 := a + speeds 1 * time
    let c2 := a + speeds 2 * time
    let d0 := b + speeds 0 * time
    (∀ x ∈ Set.Ioo a c1, U x = old i - WL 1 - WL 2) ∧
      (∀ x ∈ Set.Ioo c1 c2, U x = old i - WL 2) ∧
      (∀ x ∈ Set.Ioo c2 d0, U x = old i) ∧
      (∀ x ∈ Set.Ioo d0 b, U x = old i + WR 0) := by
  dsimp only
  have hgeometry := (leveque04_threeWaveEvolution_strict_separation_iff
    speeds origin width time htime hs0 hs1 hs12 i).2 hsep
  rcases hgeometry with ⟨ha1, h12, h20, h0b⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨hx.1, by linarith [hx.2]⟩
    have hformula := leveque04_threeWaveEvolution_formula basis speeds
      origin width time hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have hc1 : x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      hx.2.le
    have hc2 : x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      by linarith [hx.2]
    have hd0 : ¬ leveque04_uniformInterface origin width i + speeds 0 * time < x :=
      not_lt.mpr (by linarith [hx.2])
    simpa only [if_pos hc1, if_pos hc2, if_neg hd0, add_zero] using hformula
  · intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hformula := leveque04_threeWaveEvolution_formula basis speeds
      origin width time hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have hc1 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      not_le.mpr hx.1
    have hc2 : x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      hx.2.le
    have hd0 : ¬ leveque04_uniformInterface origin width i + speeds 0 * time < x :=
      not_lt.mpr (by linarith [hx.2])
    simpa only [if_neg hc1, if_pos hc2, if_neg hd0, sub_zero, add_zero] using hformula
  · intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hformula := leveque04_threeWaveEvolution_formula basis speeds
      origin width time hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have hc1 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      not_le.mpr (by linarith [hx.1])
    have hc2 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      not_le.mpr hx.1
    have hd0 : ¬ leveque04_uniformInterface origin width i + speeds 0 * time < x :=
      not_lt.mpr hx.2.le
    simpa only [if_neg hc1, if_neg hc2, if_neg hd0, sub_zero, add_zero] using hformula
  · intro x hx
    have hcell : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i :=
      ⟨by linarith [hx.1], hx.2⟩
    have hformula := leveque04_threeWaveEvolution_formula basis speeds
      origin width time hwidth htime hs0 hs1 hs12 hcfl old i x hcell
    have hc1 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 1 * time :=
      not_le.mpr (by linarith [hx.1])
    have hc2 : ¬ x ≤ leveque04_uniformInterface origin width (i - 1) + speeds 2 * time :=
      not_le.mpr (by linarith [hx.1])
    have hd0 : leveque04_uniformInterface origin width i + speeds 0 * time < x := hx.1
    simpa only [if_neg hc1, if_neg hc2, if_pos hd0, sub_zero] using hformula

end NumStability
