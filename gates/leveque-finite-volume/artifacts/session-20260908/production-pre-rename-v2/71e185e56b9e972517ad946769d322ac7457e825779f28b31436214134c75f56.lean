/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Positivity

/-!
# Classification of a two-variable second-order principal part

The mixed coefficient is the full coefficient of the mixed derivative.
Hyperbolicity means a positive quadratic discriminant.
-/

namespace NumStability

/-- Coefficients of a homogeneous two-variable second-order principal part:
`timeTime * p_tt + timeSpace * p_tx + spaceSpace * p_xx`. -/
structure SecondOrderPrincipalPart where
  timeTime : ℝ
  timeSpace : ℝ
  spaceSpace : ℝ

/-- Positive discriminant is the hyperbolic case of the two-variable
second-order principal-part classification. -/
def SecondOrderPrincipalPart.IsHyperbolic
    (part : SecondOrderPrincipalPart) : Prop :=
  0 < discrim part.timeTime part.timeSpace part.spaceSpace

/-- The principal part of `p_tt - c² p_xx = 0`. -/
def wavePrincipalPart (c : ℝ) : SecondOrderPrincipalPart :=
  ⟨1, 0, -(c ^ 2)⟩

/-- A positive-speed wave principal part has positive discriminant. -/
theorem wavePrincipalPart_isHyperbolic (c : ℝ) (hc : 0 < c) :
    (wavePrincipalPart c).IsHyperbolic := by
  change 0 < (0 : ℝ) ^ 2 - 4 * 1 * -(c ^ 2)
  simp only [zero_pow (by decide : (2 : ℕ) ≠ 0), mul_one, mul_neg, zero_sub, neg_neg]
  positivity

end NumStability
