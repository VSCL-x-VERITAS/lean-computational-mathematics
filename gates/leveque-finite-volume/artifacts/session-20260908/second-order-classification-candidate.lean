import Mathlib.Algebra.QuadraticDiscriminant
import Mathlib.Data.Real.Sqrt
import Mathlib.Tactic.Positivity

/-!
Scratch candidate for the second-order classification sentence after LeVeque
(1.7), printed 3/raw 25. These are not production declarations or gate closures.
The mixed coefficient is the full coefficient of p_tx, with no suppressed 2.
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

/-- The positive-material sound speed in (1.7) gives the hyperbolic
second-order principal part asserted immediately after that equation. -/
theorem leveque01_equation07_secondOrderHyperbolic
    (bulkModulus density : ℝ)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    (wavePrincipalPart (Real.sqrt (bulkModulus / density))).IsHyperbolic :=
  wavePrincipalPart_isHyperbolic _ (Real.sqrt_pos.2 (div_pos hbulkModulus hdensity))

#check discrim
#check quadratic_eq_zero_iff
#check Real.sqrt_pos
#print axioms leveque01_equation07_secondOrderHyperbolic

end NumStability
