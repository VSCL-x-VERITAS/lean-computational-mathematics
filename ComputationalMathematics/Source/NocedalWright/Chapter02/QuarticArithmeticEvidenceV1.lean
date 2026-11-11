import Mathlib.Data.Nat.Basic

/-!
Arithmetic evidence used by the Chapter 2 degenerate quartic example.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Checked exponent reduction for the first derivative of the quartic. -/
theorem quarticFourSubOne : (4 : ℕ) - 1 = 3 := rfl

/-- Checked exponent reduction for the derivative of the cubic term. -/
theorem quarticThreeSubOne : (3 : ℕ) - 1 = 2 := rfl

end ComputationalMathematics.Source.NocedalWright.Chapter02
