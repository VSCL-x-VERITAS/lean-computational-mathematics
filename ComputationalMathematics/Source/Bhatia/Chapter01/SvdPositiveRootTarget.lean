/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.Algebra.Star.Unitary

/-!
# Full singular value decomposition from the positive absolute value

Bhatia, Matrix Analysis, Section I.2, printed pages 5–6 (PDF pages 17–18),
with the finite complex Hilbert setting and orthonormal coordinate conventions
from printed pages 1–4 (PDF pages 13–16).

The prescribed singular values are the full decreasing eigenvalue tuple of
the positive square root of the actual Gram operator. Both singular frames
are complete orthonormal bases, and their reference-coordinate matrices are
unitary. The matrix identity retains every singular value, including all zero
slots and multiplicities. No invertibility or positive-dimension assumption
is imposed, and no singular frame or transport identity is supplied as a premise.
-/

set_option autoImplicit false
open scoped Matrix
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Every finite-dimensional complex endomorphism has full left and right
unitary singular frames for its prescribed ordered singular-value tuple. -/
noncomputable def fullOrthonormalSingularValueDecompositionPositiveRoot : Prop := by
  classical
  exact ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n := Module.finrank ℂ H
    let G := (LinearMap.adjoint A).comp A
    let P := NumStability.positiveSquareRoot G
      (LinearMap.isPositive_adjoint_comp_self A)
    let hs : P.IsPositive := NumStability.positiveSquareRoot_isPositive G
      (LinearMap.isPositive_adjoint_comp_self A)
    let s : Fin n → ℝ := hs.isSymmetric.eigenvalues rfl
    let e := stdOrthonormalBasis ℂ H
    let M := LinearMap.toMatrix e.toBasis e.toBasis A
    ∃ q w : OrthonormalBasis (Fin n) ℂ H,
      let W := LinearMap.toMatrix w.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      let Q := LinearMap.toMatrix q.toBasis e.toBasis (LinearMap.id : H →ₗ[ℂ] H)
      W ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
      Q ∈ unitary (Matrix (Fin n) (Fin n) ℂ) ∧
      Wᴴ * M * Q = Matrix.diagonal (fun i => (s i : ℂ))

end NumStability.Bhatia.Chapter01.Targets
