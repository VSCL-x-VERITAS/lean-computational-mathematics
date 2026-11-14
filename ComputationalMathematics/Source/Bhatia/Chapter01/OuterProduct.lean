/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OuterProductTarget

/-!
# Scalar and matrix products of complex column vectors

This module proves the source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.1, printed page 2 (PDF page 14): the scalar inner product and the
matrix outer product of two complex column vectors.
-/

namespace NumStability.Bhatia.Chapter01

/-- The scalar and matrix products of two complex column vectors. -/
theorem outerProduct : Targets.outerProduct := by
  intro n u v
  constructor
  · rw [Matrix.conjTranspose_replicateCol]
    exact Matrix.replicateRow_mul_replicateCol_apply (star u) v 0 0
  · rw [Matrix.conjTranspose_replicateCol]
    exact (Matrix.vecMulVec_eq (Fin 1) u (star v)).symm

end NumStability.Bhatia.Chapter01
