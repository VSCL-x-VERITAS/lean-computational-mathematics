/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.5, printed page 19 / PDF page 31.
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Defs
import ComputationalMathematics.Source.Bhatia.Chapter01.IncreasingIndicesTarget

/-!
# Bhatia Chapter I: submatrices with increasing row and column indices

The source notation A[I|J] retains rows I and columns J in their increasing
order. Fin indices are zero based: I r corresponds to the source index
(I r).val + 1. Both tuples belong to the existing source Q encoding.
Only positive degree is exposed; every ambient size n is retained.

This file states the submatrix definition only. The exterior-operator entry
and determinant identity belong to the separate compound-minors row.
The later nondecreasing-index notation permits repeated rows and columns;
that extension is separate, although generic Matrix.submatrix already
retains repeated indices without deduplication.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- The source k-by-k submatrix, with I indexing rows and J columns. -/
def increasingSubmatrix {n k : ℕ} (_hk : 0 < k)
    (A : Matrix (Fin n) (Fin n) ℂ)
    (I J : increasingIndexSet n k) : Matrix (Fin k) (Fin k) ℂ :=
  Matrix.submatrix A I.val J.val

/-- Complete ordered entry characterization of the source definition. -/
def submatrixDefinitionTarget : Prop :=
  ∀ (n k : ℕ) (hk : 0 < k) (A : Matrix (Fin n) (Fin n) ℂ)
    (I J : increasingIndexSet n k) (r s : Fin k),
    increasingSubmatrix hk A I J r s = A (I.val r) (J.val s)

end NumStability.Bhatia.Chapter01.Targets
