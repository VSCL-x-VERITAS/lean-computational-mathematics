/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Order
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.PosDef

/-!
# Bhatia Chapter I: the Cholesky decomposition name

The naming sentence on printed page 5 (PDF17) follows the positive-definite
uniqueness assertion. Its mathematical data are an upper factor with embedded
real nonnegative diagonal and the equation A = TᴴT.
-/

set_option autoImplicit false
open scoped ComplexOrder

namespace NumStability.Bhatia.Chapter01.Targets

/-- The normalized upper-factor relation in the source's primary
positive-definite context. Existence and uniqueness are separate source rows. -/
def choleskyPrimaryRelation {n : ℕ} (A T : Matrix (Fin n) (Fin n) ℂ) : Prop :=
  A.PosDef ∧
    Matrix.BlockTriangular T (fun i : Fin n => i) ∧
    (∀ i, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ)) ∧
    A = T.conjTranspose * T

/-- The full mathematical data of the Cholesky naming relation. The
diagonal condition is real nonnegativity, rather than a condition on real parts. -/
def choleskyNaming : Prop :=
  ∀ (n : ℕ) (A T : Matrix (Fin n) (Fin n) ℂ), A.PosDef →
    (choleskyPrimaryRelation A T ↔
      Matrix.BlockTriangular T (fun i : Fin n => i) ∧
      (∀ i, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ)) ∧
      A = T.conjTranspose * T)

end NumStability.Bhatia.Chapter01.Targets
