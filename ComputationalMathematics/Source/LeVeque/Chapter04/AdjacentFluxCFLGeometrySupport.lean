/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AdjacentFluxCFLGeometryTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.UniformReconstructionShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity

/-!
# Physical integral calculations for the adjacent-flux geometry

The upstream-step data have an actual ceiling reconstruction equal to a
translated Heaviside step. Its physical face flux is integrated in time;
its new cell mean is integrated in space.
-/

namespace NumStability
open MeasureTheory Set

theorem leveque04_upstreamStep_reconstruction
    (origin width : ℝ) (hw : 0 < width) (i : ℤ) (x : ℝ) :
    leveque04_uniformReconstruction origin width
      (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0) x =
      if x ≤ leveque04_uniformInterface origin width (i - 2) then 1 else 0 := by
  have hindex : ⌈(x - origin) / width⌉ ≤ i - 2 ↔
      x ≤ leveque04_uniformInterface origin width (i - 2) := by
    rw [Int.ceil_le, div_le_iff₀ hw]
    simp only [leveque04_uniformInterface]
    constructor <;> intro h <;> linarith
  simp only [leveque04_uniformReconstruction, hindex]

theorem leveque04_positiveAdvection_smallStep_faceFlux
    (origin width speed dt : ℝ) (hw : 0 < width) (hu : 0 < speed)
    (ht : 0 < dt) (hcfl : speed * dt ≤ width) (old : ℤ → ℝ) (i : ℤ) :
    leveque04_scalarTimeFaceFluxAverage
      (leveque04_uniformReconstruction origin width old) speed dt
      (leveque04_uniformInterface origin width (i - 1)) = speed * old (i - 1) := by
  have hvalue (t : ℝ) (ht0 : 0 < t) (htt : t < dt) :
      leveque04_uniformReconstruction origin width old
        (leveque04_uniformInterface origin width (i - 1) - speed * t) = old (i - 1) := by
    apply leveque04_uniformReconstruction_cell origin width hw old (i - 1)
    constructor
    · have htravel : speed * t < width := (mul_lt_mul_of_pos_left htt hu).trans_le hcfl
      simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one]
      nlinarith
    · exact sub_lt_self _ (mul_pos hu ht0)
  have hint : (∫ t in (0 : ℝ)..dt, speed *
      leveque04_uniformReconstruction origin width old
        (leveque04_uniformInterface origin width (i - 1) - speed * t)) =
      dt * (speed * old (i - 1)) := by
    calc
      _ = ∫ _t in (0 : ℝ)..dt, speed * old (i - 1) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [volume.ae_ne dt] with t hne hmem
        have hm : t ∈ Ioc 0 dt := by simpa only [uIoc_of_le ht.le] using hmem
        rw [hvalue t hm.1 (lt_of_le_of_ne hm.2 hne)]
      _ = _ := by simp only [intervalIntegral.integral_const, sub_zero, smul_eq_mul]
  simp only [leveque04_scalarTimeFaceFluxAverage, leveque04_scalarPhysicalFlux,
    leveque04_scalarAdvectedField, hint]
  field_simp

theorem leveque04_upstreamStep_faceFlux
    (origin width speed dt : ℝ) (hw : 0 < width) (hu : 0 < speed)
    (ht : 0 < dt) (hlarge : width < speed * dt) (i : ℤ) :
    leveque04_scalarTimeFaceFluxAverage
      (leveque04_uniformReconstruction origin width
        (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0)) speed dt
      (leveque04_uniformInterface origin width (i - 1)) = speed - width / dt := by
  have hcut0 : 0 ≤ width / speed := (div_pos hw hu).le
  have hcutdt : width / speed ≤ dt := (div_le_iff₀ hu).2 (by nlinarith)
  have hfunction (t : ℝ) : speed * leveque04_uniformReconstruction origin width
      (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0)
      (leveque04_uniformInterface origin width (i - 1) - speed * t) =
      riemannData 0 speed speed (t - width / speed) := by
    rw [leveque04_upstreamStep_reconstruction origin width hw i]
    have hgeom : leveque04_uniformInterface origin width (i - 1) - speed * t ≤
        leveque04_uniformInterface origin width (i - 2) ↔ width / speed ≤ t := by
      rw [div_le_iff₀ hu]
      simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one, Int.cast_ofNat]
      constructor <;> intro h <;> nlinarith
    simp only [hgeom]
    by_cases h : t < width / speed
    · simp [riemannData, not_le.mpr h, sub_neg.mpr h]
    · have hle := le_of_not_gt h
      by_cases heq : t = width / speed
      · simp [heq, riemannData]
      · have hlt : width / speed < t := lt_of_le_of_ne hle (Ne.symm heq)
        simp [hle, riemannData, sub_pos.mpr hlt, not_lt.mpr (sub_nonneg.mpr hle)]
  have hint := riemannData_shifted_intervalIntegral (0 : ℝ) speed speed 0
    (width / speed) dt hcut0 hcutdt
  unfold leveque04_scalarTimeFaceFluxAverage leveque04_scalarPhysicalFlux
    leveque04_scalarAdvectedField
  simp_rw [hfunction]
  rw [hint.2]
  simp only [smul_eq_mul, mul_zero, zero_add]
  field_simp

theorem leveque04_upstreamStep_newMean
    (origin width speed dt : ℝ) (hw : 0 < width)
    (hlarge : width < speed * dt) (i : ℤ) :
    leveque04_scalarNewCellAverage
      (leveque04_uniformReconstruction origin width
        (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0)) speed dt
      (leveque04_uniformInterface origin width (i - 1)) width =
      min ((speed * dt - width) / width) 1 := by
  let a := leveque04_uniformInterface origin width (i - 1)
  let cut := leveque04_uniformInterface origin width (i - 2) + speed * dt
  have hac : a ≤ cut := by
    dsimp [a, cut, leveque04_uniformInterface]
    push_cast
    nlinarith
  have hspan : cut - a = speed * dt - width := by
    dsimp [a, cut, leveque04_uniformInterface]
    push_cast
    ring
  have hfunction (x : ℝ) : leveque04_uniformReconstruction origin width
      (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0) (x - speed * dt) =
      riemannData 1 1 0 (x - cut) := by
    rw [leveque04_upstreamStep_reconstruction origin width hw i]
    have hgeom : x - speed * dt ≤ leveque04_uniformInterface origin width (i - 2) ↔
        x ≤ cut := by dsimp [cut]; constructor <;> intro h <;> linarith
    simp only [hgeom]
    by_cases h : x < cut
    · simp [riemannData, h.le, sub_neg.mpr h]
    · by_cases heq : x = cut
      · simp [heq, riemannData]
      · have hlt : cut < x := lt_of_le_of_ne (le_of_not_gt h) (Ne.symm heq)
        simp [riemannData, not_le.mpr hlt, sub_pos.mpr hlt, not_lt.mpr (sub_nonneg.mpr hlt.le)]
  unfold leveque04_scalarNewCellAverage leveque04_scalarAdvectedField
  change oneDimensionalCellAverage
    (fun x => leveque04_uniformReconstruction origin width
      (fun j : ℤ => if j ≤ i - 2 then (1 : ℝ) else 0) (x - speed * dt))
    a (a + width) = _
  simp_rw [hfunction]
  by_cases hcb : cut ≤ a + width
  · have hint := riemannData_shifted_intervalIntegral (1 : ℝ) 1 0 a cut (a + width) hac hcb
    have hratio : (speed * dt - width) / width ≤ 1 := by
      rw [div_le_iff₀ hw]
      linarith [hspan]
    rw [min_eq_left hratio]
    simp only [oneDimensionalCellAverage, hint.2, smul_eq_mul, mul_one, mul_zero,
      add_zero, add_sub_cancel_left, hspan]
    ring
  · have hcut : a + width < cut := lt_of_not_ge hcb
    have hratio : 1 ≤ (speed * dt - width) / width := by
      rw [le_div_iff₀ hw]
      linarith [hspan]
    rw [min_eq_right hratio]
    have hint : (∫ x in a..a + width, riemannData (1 : ℝ) 1 0 (x - cut)) = width := by
      calc
        _ = ∫ _x in a..a + width, (1 : ℝ) := by
          apply intervalIntegral.integral_congr_ae
          filter_upwards [] with x hx
          have hmem : x ∈ Ioc a (a + width) := by
            simpa only [uIoc_of_le (by linarith : a ≤ a + width)] using hx
          have hlt : x - cut < 0 := by linarith [hmem.2]
          simp only [riemannData, if_pos hlt]
        _ = _ := by simp
    simp only [oneDimensionalCellAverage, hint, add_sub_cancel_left, smul_eq_mul]
    exact inv_mul_cancel₀ hw.ne'

end NumStability
