/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Complex.Basic
import Mathlib.Topology.Instances.Matrix

/-!
# Bhatia Chapter I: the matrix exponential

Exercise I.2.8, printed page 8. The exponential series of every complex square
matrix converges; its sum is the library exponential `NormedSpace.exp`. Each
exponential is invertible with inverse `exp (-A)`, every invertible matrix is an
exponential, and every unitary matrix is the exponential of a skew-Hermitian
matrix. The ambient topology is the library's topology on
`Matrix (Fin n) (Fin n) ℂ`, the product topology of the entries; the
exponential is named with that topological-ring instance explicitly, so no
operator-norm instance is involved.
-/

set_option autoImplicit false

open Filter Topology

namespace NumStability.Bhatia.Chapter01.Targets

/-- For every complex square matrix `A`, the partial sums
`I + A + A²/2! + ⋯ + A^(N-1)/(N-1)!` converge, and the limit is `exp A`. -/
def matrixExpSeriesConverges : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    Tendsto (fun N : ℕ => ∑ k ∈ Finset.range N, ((k.factorial : ℂ)⁻¹) • A ^ k) atTop
      (𝓝 (@NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing A))

/-- Every matrix exponential is invertible, and its inverse is `exp (-A)`. -/
def matrixExpInverse : Prop :=
  ∀ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    IsUnit (@NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing A) ∧
      (@NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing A)⁻¹ =
        @NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing (-A)

/-- Every invertible complex square matrix is the exponential of some matrix. -/
def invertibleMatrixIsExp : Prop :=
  ∀ (n : ℕ) (M : Matrix (Fin n) (Fin n) ℂ),
    IsUnit M → ∃ A : Matrix (Fin n) (Fin n) ℂ,
      @NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing A = M

/-- Every unitary matrix (`U Uᴴ = 1` and `Uᴴ U = 1`) is the exponential of a
skew-Hermitian matrix (`Aᴴ = -A`). -/
def unitaryMatrixIsExpSkewHermitian : Prop :=
  ∀ (n : ℕ) (U : Matrix (Fin n) (Fin n) ℂ),
    U * U.conjTranspose = 1 ∧ U.conjTranspose * U = 1 →
      ∃ A : Matrix (Fin n) (Fin n) ℂ, A.conjTranspose = -A ∧
        @NormedSpace.exp (Matrix (Fin n) (Fin n) ℂ) _ _ Matrix.topologicalRing A = U

end NumStability.Bhatia.Chapter01.Targets
