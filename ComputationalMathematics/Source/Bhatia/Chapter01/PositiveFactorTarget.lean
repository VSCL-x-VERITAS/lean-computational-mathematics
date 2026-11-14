/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Block

/-!
# Bhatia Exercise I.2.2: positive factorizations

The factors are square matrices in a fixed orthonormal basis of the original
complex Hilbert space. Diagonal normalization includes reality and nonnegativity.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Equivalence of all four conditions, including each reverse implication. -/
def positiveFactorEquivalence : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ) (E : OrthonormalBasis (Fin n) ℂ H)
      (A : H →ₗ[ℂ] H),
    let M := LinearMap.toMatrix E.toBasis E.toBasis A
    let gram := fun B : Matrix (Fin n) (Fin n) ℂ => M = B.conjTranspose * B
    let upper := fun T : Matrix (Fin n) (Fin n) ℂ =>
      Matrix.BlockTriangular T (fun i : Fin n => i) ∧ gram T
    let normalized := fun T : Matrix (Fin n) (Fin n) ℂ =>
      Matrix.BlockTriangular T (fun i : Fin n => i) ∧
      (∀ i : Fin n, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ)) ∧ gram T
    (A.IsPositive ↔ ∃ B, gram B) ∧
    ((∃ B, gram B) ↔ ∃ T, upper T) ∧
    ((∃ T, upper T) ↔ ∃ T, normalized T)

/-- Uniqueness is restricted to the normalized upper triangular factors of a
positive definite operator; existence is the separate equivalence proposition. -/
def positiveFactorUniqueness : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (n : ℕ) (E : OrthonormalBasis (Fin n) ℂ H)
      (A : H →ₗ[ℂ] H),
    (A.IsSymmetric ∧ ∀ x : H, x ≠ 0 → 0 < (inner ℂ x (A x)).re) →
    let M := LinearMap.toMatrix E.toBasis E.toBasis A
    let normalized := fun T : Matrix (Fin n) (Fin n) ℂ =>
      Matrix.BlockTriangular T (fun i : Fin n => i) ∧
      (∀ i : Fin n, ∃ d : ℝ, 0 ≤ d ∧ T i i = (d : ℂ)) ∧
      M = T.conjTranspose * T
    ∀ T S : Matrix (Fin n) (Fin n) ℂ,
      normalized T → normalized S → T = S

end NumStability.Bhatia.Chapter01.Targets
