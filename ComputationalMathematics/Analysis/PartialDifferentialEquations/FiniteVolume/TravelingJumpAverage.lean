/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# Cell averages of a traveling two-state jump

The spatial integral splits at the moving front. Its point value is arbitrary
and contributes no mass. For a positive-speed front entering a cell, the
normalized average changes by the swept fraction times the opposite jump.
-/

namespace NumStability
open Set MeasureTheory
variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

/-- Actual integral of a translated two-state jump, with arbitrary jump value. -/
theorem riemannData_shifted_intervalIntegral
    (left valueAtJump right : E) (a cut b : ℝ)
    (hac : a ≤ cut) (hcb : cut ≤ b) :
    IntervalIntegrable (fun x => riemannData left valueAtJump right (x-cut))
      volume a b ∧
    (∫ x in a..b, riemannData left valueAtJump right (x-cut)) =
      (cut-a) • left + (b-cut) • right := by
  have hi (u v : ℝ) :
      IntervalIntegrable (fun x => riemannData left valueAtJump right (x-cut))
        volume u v := by
    simpa only [sub_add_cancel] using
      (riemannData_intervalIntegrable left valueAtJump right (u-cut) (v-cut)).comp_sub_right cut
  have hl : (∫ x in a..cut, riemannData left valueAtJump right (x-cut)) =
      (cut-a) • left := by
    calc
      _ = ∫ _ in a..cut, left := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [volume.ae_ne cut] with x hne hx
        have hx' : x ∈ Ioc a cut := by simpa only [uIoc_of_le hac] using hx
        have hneg : x-cut < 0 := sub_neg.mpr (lt_of_le_of_ne hx'.2 hne)
        simp [riemannData, hneg]
      _ = _ := intervalIntegral.integral_const left
  have hr : (∫ x in cut..b, riemannData left valueAtJump right (x-cut)) =
      (b-cut) • right := by
    calc
      _ = ∫ _ in cut..b, right := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with x hx
        have hx' : x ∈ Ioc cut b := by simpa only [uIoc_of_le hcb] using hx
        have hpos : 0 < x-cut := sub_pos.mpr hx'.1
        simp [riemannData, hpos, not_lt.mpr hpos.le]
      _ = _ := intervalIntegral.integral_const right
  exact ⟨hi a b, by simpa only [hl, hr] using
    (intervalIntegral.integral_add_adjacent_intervals (hi a cut) (hi cut b)).symm⟩

/-- The actual initial and evolved averages of a front entering a positive-width cell. -/
theorem travelingWave_entering_cellAverage
    (m : ℕ) (left valueAtJump right : Fin (m+1) → ℝ)
    (face width speed elapsedTime : ℝ)
    (hwidth : 0 < width) (hspeed : 0 < speed) (htime : 0 ≤ elapsedTime)
    (htravel : speed * elapsedTime ≤ width) :
    let q := fun x t => travelingWave (riemannData left valueAtJump right) speed (x-face) t
    IntervalIntegrable (fun x => q x 0) volume face (face+width) ∧
    IntervalIntegrable (fun x => q x elapsedTime) volume face (face+width) ∧
    oneDimensionalCellAverage (fun x => q x 0) face (face+width) = right ∧
    oneDimensionalCellAverage (fun x => q x elapsedTime) face (face+width) =
      right - (speed * elapsedTime / width) • (right-left) := by
  let q := fun x t => travelingWave (riemannData left valueAtJump right) speed (x-face) t
  have hz := riemannData_shifted_intervalIntegral left valueAtJump right
    face face (face+width) le_rfl (by linarith)
  have hd : 0 ≤ speed*elapsedTime := mul_nonneg hspeed.le htime
  have ht := riemannData_shifted_intervalIntegral left valueAtJump right
    face (face+speed*elapsedTime) (face+width) (by linarith) (by linarith)
  have hi0 : IntervalIntegrable (fun x => q x 0) volume face (face+width) := by
    simpa only [q, travelingWave, mul_zero, sub_zero] using hz.1
  have hit : IntervalIntegrable (fun x => q x elapsedTime) volume face (face+width) := by
    simpa only [q, travelingWave, sub_sub] using ht.1
  have hav0 : oneDimensionalCellAverage (fun x => q x 0) face (face+width) = right := by
    simp only [oneDimensionalCellAverage, q, travelingWave, mul_zero, sub_zero]
    rw [hz.2]
    simp [hwidth.ne', smul_smul]
  have havt : oneDimensionalCellAverage (fun x => q x elapsedTime) face (face+width) =
      right - (speed*elapsedTime/width) • (right-left) := by
    simp only [oneDimensionalCellAverage, q, travelingWave, sub_sub]
    rw [ht.2]
    funext k
    simp only [Pi.smul_apply, Pi.add_apply, Pi.sub_apply, smul_eq_mul]
    simp only [add_sub_cancel_left]
    field_simp [hwidth.ne']
    ring
  exact ⟨hi0, hit, hav0, havt⟩


end NumStability
