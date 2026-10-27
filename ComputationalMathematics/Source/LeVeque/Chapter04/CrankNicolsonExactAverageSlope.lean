/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonApproxForwardResidual

/-!
# Smooth exact-average slope budgets for approximate-face diffusion

The neighboring exact cell-average slope is close to the profile
derivative at the shared face. Uniform derivative bounds then supply
the size and adjacent-variation budgets used by the approximate-face
Crank–Nicolson residual transfer.
-/

namespace NumStability

/-- A smooth exact cell-average face slope is bounded by the profile's
derivative bound plus its quadratic consistency defect. -/
theorem leveque04_exactAverage_faceSlope_bound
    (f f' f'' : ℝ → ℝ) (K B face width maxWidth : ℝ)
    (hK : 0 ≤ K)
    (hwidth : 0 < width) (hmax : width ≤ maxWidth)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hderiv : ∀ x, |f' x| ≤ B) :
    |(oneDimensionalCellAverage f face (face + width) -
        oneDimensionalCellAverage f (face - width) face) / width| ≤
      B + K * maxWidth ^ 2 / 2 := by
  let slope := (oneDimensionalCellAverage f face (face + width) -
    oneDimensionalCellAverage f (face - width) face) / width
  have herr : |slope - f' face| ≤ K * width ^ 2 / 2 := by
    exact oneDimensionalCellAverage_centeredSlope_error_le
      f f' f'' K face width hK hwidth hf hf' hLip
  have hsq : width ^ 2 ≤ maxWidth ^ 2 := by nlinarith
  have hdefect : K * width ^ 2 / 2 ≤ K * maxWidth ^ 2 / 2 := by
    exact div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hsq hK) (by norm_num)
  have htri : |slope| ≤ |slope - f' face| + |f' face| := by
    convert abs_add_le (slope - f' face) (f' face) using 1; ring
  calc
    _ ≤ |slope - f' face| + |f' face| := htri
    _ ≤ K * width ^ 2 / 2 + B := add_le_add herr (hderiv face)
    _ ≤ B + K * maxWidth ^ 2 / 2 := by linarith [hdefect]

/-- On a smooth exact-average grid, neighboring face slopes vary by
at most a constant times the cell width. -/
theorem leveque04_exactAverage_adjacentFaceSlope_bound
    (f f' f'' : ℝ → ℝ) (K B2 face width maxWidth : ℝ)
    (hK : 0 ≤ K)
    (hwidth : 0 < width) (hmax : width ≤ maxWidth)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hderivLip : ∀ x y, |f' x - f' y| ≤ B2 * |x - y|) :
    |(oneDimensionalCellAverage f (face + width) (face + 2 * width) -
        oneDimensionalCellAverage f face (face + width)) / width -
      (oneDimensionalCellAverage f face (face + width) -
        oneDimensionalCellAverage f (face - width) face) / width| ≤
      (B2 + K * maxWidth) * width := by
  let right := (oneDimensionalCellAverage f (face + width)
    (face + 2 * width) -
    oneDimensionalCellAverage f face (face + width)) / width
  let left := (oneDimensionalCellAverage f face (face + width) -
    oneDimensionalCellAverage f (face - width) face) / width
  have hright : |right - f' (face + width)| ≤ K * width ^ 2 / 2 := by
    have h := oneDimensionalCellAverage_centeredSlope_error_le
      f f' f'' K (face + width) width hK hwidth hf hf' hLip
    have hcoord : face + width + width = face + 2 * width := by ring
    simpa only [hcoord, add_sub_cancel_right, right] using h
  have hleft : |left - f' face| ≤ K * width ^ 2 / 2 := by
    exact oneDimensionalCellAverage_centeredSlope_error_le
      f f' f'' K face width hK hwidth hf hf' hLip
  have hderiv : |f' (face + width) - f' face| ≤ B2 * width := by
    simpa [abs_of_pos hwidth] using hderivLip (face + width) face
  have htri : |right - left| ≤
      |right - f' (face + width)| +
        |f' (face + width) - f' face| +
          |left - f' face| := by
    have heq : right - left =
        (right - f' (face + width)) +
          (f' (face + width) - f' face) +
            (f' face - left) := by ring
    rw [heq]
    calc
      _ ≤ |right - f' (face + width)| +
            |f' (face + width) - f' face| +
              |f' face - left| := by
              exact (abs_add_le _ _).trans
                (add_le_add (abs_add_le _ _) (le_refl _))
      _ = _ := by rw [abs_sub_comm (f' face) left]
  have hsq : width ^ 2 ≤ maxWidth * width := by nlinarith
  have hlast : K * width ^ 2 ≤ K * maxWidth * width := by
    nlinarith [mul_le_mul_of_nonneg_left hsq hK]
  calc
    _ ≤ |right - f' (face + width)| +
          |f' (face + width) - f' face| +
            |left - f' face| := htri
    _ ≤ K * width ^ 2 / 2 + B2 * width +
          K * width ^ 2 / 2 :=
            add_le_add (add_le_add hright hderiv) hleft
    _ ≤ (B2 + K * maxWidth) * width := by nlinarith [hlast]

end NumStability
