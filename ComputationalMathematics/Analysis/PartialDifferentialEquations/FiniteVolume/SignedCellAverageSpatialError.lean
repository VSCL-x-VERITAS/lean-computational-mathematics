/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageSpatialSlope

/-!
# Signed cell-average slope consistency
-/

namespace NumStability

open Set Filter MeasureTheory Topology
open scoped BigOperators Topology NNReal

theorem trueCellAverage_signedSlope_error_le
    (f f' : ℝ → ℝ) (K center width speed : ℝ)
    (hK : 0 ≤ K) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    |max speed 0 * ((avg center-avg (center-width))/width) +
      min speed 0 * ((avg (center+width)-avg center)/width) -
      speed * f' center| ≤ |speed| *((3*K/2)*width) := by
  have hb := trueCellAverage_backwardSlope_error_le f f' K center width hK hw hf hLip
  have hfwd := trueCellAverage_forwardSlope_error_le f f' K center width hK hw hf hLip
  dsimp only at hb hfwd ⊢
  by_cases hs : 0 ≤ speed
  · simp only [max_eq_left hs,min_eq_right hs,zero_mul,add_zero,abs_of_nonneg hs]
    rw [← mul_sub,abs_mul,abs_of_nonneg hs]
    exact mul_le_mul_of_nonneg_left hb hs
  · have hs' : speed ≤ 0 := le_of_not_ge hs
    simp only [max_eq_right hs',min_eq_left hs',zero_mul,zero_add]
    rw [← mul_sub,abs_mul]
    exact mul_le_mul_of_nonneg_left hfwd (abs_nonneg speed)

/-- Spatial consistency against the actual smooth field for a coefficient
Lipschitz in state; no conservative physical flux is required. -/
theorem trueCellAverage_quasilinearSignedSlope_error_le
    (f f' : ℝ → ℝ) (coefficient : ℝ → ℝ) (K M A center width : ℝ)
    (hK : 0 ≤ K) (hM : 0 ≤ M) (hA : 0 ≤ A) (hw : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x-f' y| ≤ K*|x-y|)
    (hfLip : ∀ x y, |f x-f y| ≤ M*|x-y|)
    (haLip : ∀ u v, |coefficient u-coefficient v| ≤ A*|u-v|) :
    let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
    let speed := coefficient (avg center)
    |max speed 0 * ((avg center-avg (center-width))/width) +
      min speed 0 * ((avg (center+width)-avg center)/width) -
      coefficient (f center) * f' center| ≤
      |speed| *((3*K/2)*width) + A*(M*(width/2))*|f' center| := by
  let avg := fun c => oneDimensionalCellAverage f (c-width/2) (c+width/2)
  let speed := coefficient (avg center)
  have hb := trueCellAverage_signedSlope_error_le f f' K center width speed hK hw hf hLip
  have hcont : Continuous f := continuous_iff_continuousAt.mpr (fun x => (hf x).continuousAt)
  have hmean := oneDimensionalCellAverage_sub_center_le_of_lipschitz
    f M center width hM hw hcont hfLip
  have ha := (haLip (avg center) (f center)).trans
    (mul_le_mul_of_nonneg_left hmean hA)
  have hprod : |(speed-coefficient (f center))*f' center| ≤
      A*(M*(width/2))*|f' center| := by
    rw [abs_mul]
    exact mul_le_mul_of_nonneg_right ha (abs_nonneg _)
  dsimp only at hb ⊢
  change |max speed 0*((avg center-avg (center-width))/width)+
    min speed 0*((avg (center+width)-avg center)/width)-
    coefficient (f center)*f' center| ≤ _
  have htri := abs_add_le
    (max speed 0*((avg center-avg (center-width))/width)+
      min speed 0*((avg (center+width)-avg center)/width)-speed*f' center)
    ((speed-coefficient (f center))*f' center)
  have heq : max speed 0*((avg center-avg (center-width))/width)+
      min speed 0*((avg (center+width)-avg center)/width)-speed*f' center+
      (speed-coefficient (f center))*f' center =
      max speed 0*((avg center-avg (center-width))/width)+
      min speed 0*((avg (center+width)-avg center)/width)-
      coefficient (f center)*f' center := by ring
  rw [heq] at htri
  exact htri.trans (add_le_add hb hprod)

end NumStability
