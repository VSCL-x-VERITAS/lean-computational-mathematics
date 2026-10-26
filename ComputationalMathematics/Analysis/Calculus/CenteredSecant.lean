/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# A centered secant estimate

The first-order Taylor remainders at symmetric endpoints control the
error of a centered difference quotient under a Lipschitz derivative.
-/

namespace NumStability

/-- A centered secant differs from the derivative at its midpoint by
at most a linear width term when the derivative is Lipschitz. -/
theorem centeredSecant_deriv_error_le_of_lipschitzDeriv
    (f f' : ℝ → ℝ) (K center width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hLip : ∀ x y, |f' x - f' y| ≤ K * |x - y|) :
    |(f (center + width / 2) - f (center - width / 2)) / width -
      f' center| ≤ K * width / 2 := by
  have hp := firstOrderTaylorError_le_of_lipschitzDeriv
    f f' K center (center + width / 2) hK hf hLip
  have hm := firstOrderTaylorError_le_of_lipschitzDeriv
    f f' K center (center - width / 2) hK hf hLip
  have hp' : |f (center + width / 2) -
      (f center + f' center * (width / 2))| ≤
      K * (width / 2) ^ 2 := by
    simpa [show center + width / 2 - center = width / 2 by ring] using hp
  have hm' : |f (center - width / 2) -
      (f center - f' center * (width / 2))| ≤
      K * (width / 2) ^ 2 := by
    convert hm using 1 <;> ring
  have htri :
      |(f (center + width / 2) - (f center + f' center * (width / 2))) -
        (f (center - width / 2) - (f center - f' center * (width / 2)))| ≤
      |f (center + width / 2) - (f center + f' center * (width / 2))| +
        |f (center - width / 2) - (f center - f' center * (width / 2))| := by
    simpa only [sub_eq_add_neg, abs_neg] using
      abs_add_le
        (f (center + width / 2) - (f center + f' center * (width / 2)))
        (-(f (center - width / 2) - (f center - f' center * (width / 2))))
  have hnum : |f (center + width / 2) - f (center - width / 2) -
      width * f' center| ≤ K * width ^ 2 / 2 := by
    convert htri.trans (add_le_add hp' hm') using 1 <;> ring
  have hquot : (f (center + width / 2) - f (center - width / 2)) /
      width - f' center =
      (f (center + width / 2) - f (center - width / 2) -
        width * f' center) / width := by
    field_simp [hwidth.ne']
  rw [hquot, abs_div, abs_of_pos hwidth]
  calc
    |f (center + width / 2) - f (center - width / 2) -
        width * f' center| / width ≤
        (K * width ^ 2 / 2) / width :=
          div_le_div_of_nonneg_right hnum hwidth.le
    _ = K * width / 2 := by field_simp [hwidth.ne']

/-- Quadratic endpoint evaluation errors add only a linear term to a
centered secant error after division by the mesh width. -/
theorem centeredSecant_error_of_endpointErrors
    (f f' : ℝ → ℝ) (leftValue rightValue center width K E : ℝ)
    (hwidth : 0 < width)
    (hleft : |leftValue - f (center - width / 2)| ≤ E * width ^ 2)
    (hright : |rightValue - f (center + width / 2)| ≤ E * width ^ 2)
    (hsecant : |(f (center + width / 2) - f (center - width / 2)) /
      width - f' center| ≤ K * width / 2) :
    |(rightValue - leftValue) / width - f' center| ≤
      (2 * E + K / 2) * width := by
  have hnum : |(rightValue - leftValue) -
      (f (center + width / 2) - f (center - width / 2))| ≤
      2 * E * width ^ 2 := by
    have htri :
        |(rightValue - f (center + width / 2)) -
          (leftValue - f (center - width / 2))| ≤
        |rightValue - f (center + width / 2)| +
          |leftValue - f (center - width / 2)| := by
      simpa only [sub_eq_add_neg, abs_neg] using
        (abs_add_le (rightValue - f (center + width / 2))
          (-(leftValue - f (center - width / 2))))
    convert htri.trans (add_le_add hright hleft) using 1 <;> ring
  have hquot :
      |(rightValue - leftValue) / width -
        (f (center + width / 2) - f (center - width / 2)) / width| ≤
      2 * E * width := by
    have hid : (rightValue - leftValue) / width -
        (f (center + width / 2) - f (center - width / 2)) / width =
        ((rightValue - leftValue) -
          (f (center + width / 2) - f (center - width / 2))) / width := by ring
    rw [hid, abs_div, abs_of_pos hwidth]
    calc
      _ ≤ (2 * E * width ^ 2) / width :=
        div_le_div_of_nonneg_right hnum hwidth.le
      _ = 2 * E * width := by field_simp [hwidth.ne']
  have htri :
      |(rightValue - leftValue) / width - f' center| ≤
        |(rightValue - leftValue) / width -
          (f (center + width / 2) - f (center - width / 2)) / width| +
        |(f (center + width / 2) - f (center - width / 2)) /
          width - f' center| := by
    convert abs_add_le
      ((rightValue - leftValue) / width -
        (f (center + width / 2) - f (center - width / 2)) / width)
      ((f (center + width / 2) - f (center - width / 2)) /
        width - f' center) using 1 <;> ring
  calc
    _ ≤ _ := htri
    _ ≤ 2 * E * width + K * width / 2 := add_le_add hquot hsecant
    _ = (2 * E + K / 2) * width := by ring

end NumStability
