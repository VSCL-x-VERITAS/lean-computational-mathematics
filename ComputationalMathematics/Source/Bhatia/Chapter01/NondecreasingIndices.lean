/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NondecreasingIndicesTarget

/-!
# Nondecreasing multi-indices and their lexicographic order

The source wrapper for Bhatia, Matrix Analysis (1997), I.5, printed pages 16–17.
It proves the exact audited membership and lexicographic definition contract,
retaining every natural dimension, positive degree and repeated entry.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01

/-- The weak-order membership and reused lexicographic relation unfold to their
prescribed defining formulas. -/
theorem nondecreasingIndices_definition : Targets.nondecreasingIndicesDefinition := by
  intro n k _hk
  exact ⟨fun _ => Iff.rfl, fun _ _ => Iff.rfl⟩

end NumStability.Bhatia.Chapter01
