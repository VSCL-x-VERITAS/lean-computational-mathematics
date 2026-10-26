/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TravelingJumpAverage
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# Averages of translated local piecewise constant reconstructions

Only the two upstream open cells are prescribed. Interface values and the
field elsewhere are arbitrary; almost-everywhere comparison with a traveling
jump gives integrability and the exact normalized overlap weights.
-/

namespace NumStability
open Set MeasureTheory

/-- Translating between one and two widths averages precisely two upstream cells. -/
theorem translated_adjacent_cellAverage :
  ∀ (m : ℕ) (q : ℝ → Fin (m+1) → ℝ)
      (far near : Fin (m+1) → ℝ) (width distance : ℝ),
    0 < width → width ≤ distance → distance ≤ 2*width →
    (∀ x ∈ Ioo (-2*width) (-width), q x = far) →
    (∀ x ∈ Ioo (-width) 0, q x = near) →
    IntervalIntegrable (fun x => q (x-distance)) volume 0 width ∧
    oneDimensionalCellAverage (fun x => q (x-distance)) 0 width =
      ((distance-width)/width) • far + ((2*width-distance)/width) • near := by
  intro m q far near width distance hw hlow hupp hfar hnear
  have hc0 : 0 ≤ distance-width := by linarith
  have hcw : distance-width ≤ width := by linarith
  have hj := riemannData_shifted_intervalIntegral far near near
    0 (distance-width) width hc0 hcw
  have heq : ∀ᵐ x ∂volume, x ∈ Set.uIoc 0 width →
      riemannData far near near (x-(distance-width)) = q (x-distance) := by
    filter_upwards [volume.ae_ne width, volume.ae_ne (distance-width)] with x hxw hxc hx
    have hx' : x ∈ Ioc 0 width := by simpa only [uIoc_of_le hw.le] using hx
    have hxlt : x < width := lt_of_le_of_ne hx'.2 hxw
    by_cases hleft : x < distance-width
    · have hy : x-distance ∈ Ioo (-2*width) (-width) := by
        constructor <;> linarith [hx'.1]
      rw [hfar _ hy]
      simp [riemannData, sub_neg.mpr hleft]
    · have hright : distance-width < x := lt_of_le_of_ne (le_of_not_gt hleft) (Ne.symm hxc)
      have hy : x-distance ∈ Ioo (-width) 0 := by
        constructor <;> linarith
      rw [hnear _ hy]
      have hh : 0 < x-(distance-width) := sub_pos.mpr hright
      simp [riemannData, hh, not_lt.mpr hh.le]
  have hre : (fun x => riemannData far near near (x-(distance-width)))
      =ᵐ[volume.restrict (Set.uIoc 0 width)] (fun x => q (x-distance)) := by
    filter_upwards [ae_restrict_of_ae heq, ae_restrict_mem measurableSet_uIoc] with x hx hmem
    exact hx hmem
  refine ⟨hj.1.congr_ae hre, ?_⟩
  have hi : (∫ x in (0:ℝ)..width, q (x-distance)) =
      (distance-width) • far + (2*width-distance) • near := by
    rw [← intervalIntegral.integral_congr_ae heq, hj.2]
    congr 1 <;> congr 1 <;> ring
  unfold oneDimensionalCellAverage
  rw [hi]
  funext k
  simp only [Pi.smul_apply, Pi.add_apply, smul_eq_mul, sub_zero]
  field_simp [hw.ne']


end NumStability
