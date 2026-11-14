/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.SubmatrixTarget

/-!
# Bhatia Chapter I: increasing-index submatrix entries

The source definition on printed page 19 retains the prescribed rows and
columns in increasing order. This wrapper reuses `Matrix.submatrix_apply`.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

/-- Bhatia I.5: increasing-index submatrix entries retain the prescribed order. -/
theorem submatrix_definition : Targets.submatrixDefinitionTarget := by
  intro n k hk A I J r s
  exact Matrix.submatrix_apply A I.val J.val r s

end NumStability.Bhatia.Chapter01
