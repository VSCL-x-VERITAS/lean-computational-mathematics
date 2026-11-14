/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.AbsoluteValuePositiveRootTarget

/-!
# Absolute value in Bhatia, Chapter I

Bhatia, *Matrix Analysis* (1997), Section I.2, printed page 5 (PDF page 17):
the Gram operator is positive, and its unique positive square root is denoted
by |A|. The prescribed root is positive, squares to the Gram operator, and
is unique among positive roots, including on a zero-dimensional space.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- The prescribed operator absolute value is the unique positive Gram root. -/
theorem absoluteValuePositiveRoot : Targets.absoluteValuePositiveRootChoice.{u} := by
  intro H _ _ _ A
  exact ⟨LinearMap.isPositive_adjoint_comp_self A,
    NumStability.positiveSquareRoot_isPositive _ _,
    NumStability.positiveSquareRoot_comp_self _ _,
    fun B hB hsq => NumStability.positiveSquareRoot_unique _ _ B hB hsq⟩

end NumStability.Bhatia.Chapter01
