/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.RCLike.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Hadamard
import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.LinearAlgebra.Matrix.PosDef

/-! Source targets for Bhatia, Matrix Analysis (1997), Problem I.6.13,
printed page 23 (PDF page 35). Pair indices denote the lexicographically
labelled tensor basis, with the same diagonal-pair injection for both axes.
Every norm is the continuous-operator norm on EuclideanSpace ℂ (Fin n).
Positivity uses the Hermitian, nonnegative quadratic-form convention of I.2. -/

set_option autoImplicit false

open scoped ComplexOrder

namespace NumStability.Bhatia.Chapter01.Targets

/-- The Schur product is the principal restriction of the Kronecker product
along the diagonal-pair injection, for every finite square complex size. -/
def schurProductPrincipalSubmatrix : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    Function.Injective (fun i : Fin n => (i, i)) ∧
      Matrix.submatrix (Matrix.kronecker A B)
        (fun i : Fin n => (i, i)) (fun i : Fin n => (i, i)) =
        Matrix.hadamard A B

/-- The Euclidean Hilbert operator norm of the Schur product is bounded by
the product of the two Euclidean Hilbert operator norms, with constant 1. -/
def schurProductOperatorNorm : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    ‖Matrix.toEuclideanCLM (n := Fin n) (𝕜 := ℂ) (Matrix.hadamard A B)‖ ≤
      ‖Matrix.toEuclideanCLM (n := Fin n) (𝕜 := ℂ) A‖ *
        ‖Matrix.toEuclideanCLM (n := Fin n) (𝕜 := ℂ) B‖

/-- The Schur product of two positive semidefinite square complex matrices
is positive semidefinite, including the empty size and singular factors. -/
def schurProductPositiveSemidefinite : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    Matrix.PosSemidef A → Matrix.PosSemidef B →
      Matrix.PosSemidef (Matrix.hadamard A B)

end NumStability.Bhatia.Chapter01.Targets
