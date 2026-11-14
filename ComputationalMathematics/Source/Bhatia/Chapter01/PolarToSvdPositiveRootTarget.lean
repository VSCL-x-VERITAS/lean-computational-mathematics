/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Algebra.Star.Unitary

/-!
# A concrete realization of SVD from supplied polar factors

Bhatia, *Matrix Analysis*, Exercise I.2.4(iii), printed page 6 (PDF page 18),
with the singular values and positive absolute value from printed page 5
(PDF page 17).

This is a concrete realization of the method exercise. Its input is an actual
unitary-times-positive factorization of the given operator. The right basis
diagonalizes that positive factor, and the left basis is its image under the
supplied unitary. The prescribed diagonal uses the full ordered eigenvalue tuple
of the unique positive Gram root, including all zero entries and multiplicities.
These basis relations specify the realization; the source does not display
these formulas. Finite complex spaces of dimension zero remain included.
-/

set_option autoImplicit false
open scoped Matrix
universe u
namespace NumStability.Bhatia.Chapter01.Targets

/-- A pointwise realization of SVD from every supplied actual polar
factorization, retaining its positive eigenbasis and w_i=U(q_i). -/
noncomputable def orderedSingularDecompositionFromPolarPositiveRoot : Prop := by
  classical
  exact ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A U P : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let G := (LinearMap.adjoint A).comp A
    let absOp := NumStability.positiveSquareRoot G
      (LinearMap.isPositive_adjoint_comp_self A)
    let hs : absOp.IsPositive := NumStability.positiveSquareRoot_isPositive G
      (LinearMap.isPositive_adjoint_comp_self A)
    let s : Fin n → ℝ := hs.isSymmetric.eigenvalues rfl
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    U ∈ unitary (H →ₗ[ℂ] H) → P.IsPositive → A = U.comp P →
    ∃ q w : OrthonormalBasis (Fin n) ℂ H,
      (∀ i, P (q i) = (s i : ℂ) • q i) ∧
      (∀ i, w i = U (q i)) ∧
      (let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
       let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
       W ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
       Q ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
       Wᴴ * M * Q = Matrix.diagonal (fun i => (s i : ℂ)))

end NumStability.Bhatia.Chapter01.Targets
