/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.RepeatedBlockDiagonalization
import ComputationalMathematics.Source.Bhatia.Chapter01.BlockPositiveTarget

/-!
# Bhatia's fixed unitary for repeated blocks

Source correspondence for Matrix Analysis (1997), Lemma I.3.2, printed page 10.
The prescribed normalized sum-and-difference unitary is fixed before the
arbitrary operator and conjugates its four repeated blocks to twice that
operator direct-summed with zero. Dimension zero is included.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- The printed fixed unitary implements the exact displayed equivalence. -/
theorem repeatedBlockUnitaryEquivalence : Targets.repeatedBlockUnitaryEquivalence.{u} := by
  intro H _ _ _
  exact NumStability.repeated_block_unitary_diagonalization (E := H)

end NumStability.Bhatia.Chapter01
