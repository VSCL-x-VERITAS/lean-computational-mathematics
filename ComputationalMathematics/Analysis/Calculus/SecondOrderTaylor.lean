/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.CenteredSlopeError
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# A second-order Taylor bound from Lipschitz second derivative

Applying the first-order bound to a function's derivative and the
mean-value inequality to the quadratic remainder yields a cubic error.
The coefficient is intentionally simple rather than optimal.
-/

namespace NumStability
open Set

/-- A globally Lipschitz second derivative bounds the quadratic
Taylor remainder cubically at every center and target point. -/
theorem secondOrderTaylorError_le_of_lipschitzSecondDeriv
    (f f' f'' : ℝ → ℝ) (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y, HasDerivAt f (f' y) y)
    (hf' : ∀ y, HasDerivAt f' (f'' y) y)
    (hLip : ∀ y z, |f'' y - f'' z| ≤ K * |y - z|) :
    |f x - (f center + f' center * (x - center) +
      f'' center * (x - center) ^ 2 / 2)| ≤ K * |x - center| ^ 3 := by
  have h := norm_secondOrderTaylorError_le_of_local_second_deriv_variation
    f f' f'' K center x hK
    (fun y _ => hf y)
    (fun y _ => hf' y)
    (fun y _ => by
      rw [Real.norm_eq_abs]
      exact hLip y center)
  simpa [Real.norm_eq_abs, smul_eq_mul, div_eq_mul_inv,
    mul_comm, mul_left_comm, mul_assoc] using h

/-- A centered difference approximates the derivative to quadratic order when the second derivative is Lipschitz. -/
theorem centeredDifference_deriv_error_le_of_lipschitzSecondDeriv
    (f f' f'' : ℝ → ℝ) (K center width : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|) :
    |(f (center + width / 2) - f (center - width / 2)) / width -
      f' center| ≤ K * width ^ 2 / 4 := by
  have h := local_vector_centeredSlope_error
    f f' f'' K center (width / 2) hK (half_pos hwidth)
    (fun y _ => hf y)
    (fun y _ => hf' y)
    (fun y _ => by
      rw [Real.norm_eq_abs]
      exact hLip y center)
  convert h using 1 <;> norm_num <;> field_simp <;> ring

end NumStability
