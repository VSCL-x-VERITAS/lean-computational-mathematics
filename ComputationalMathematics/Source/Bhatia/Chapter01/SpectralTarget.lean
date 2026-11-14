/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.IsDiag
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.UnitaryGroup

/-!
# Bhatia Chapter I: normal Schur forms and spectral diagonalization

Transparent statement contract for the paragraph on printed page 5 (PDF17).
The diagonal list retains algebraic multiplicities through its characteristic
polynomial. No ordering or distinctness of eigenvalues is imposed.
-/

set_option autoImplicit false
noncomputable section
open scoped BigOperators Matrix
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Every Schur form of a normal operator is diagonal, and an actual
orthonormal eigenbasis realizes a full unitary diagonalization. -/
def spectralSchurAndMultiplicityContract : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    IsStarNormal A →
    ∀ E : OrthonormalBasis (Fin (Module.finrank ℂ H)) ℂ H,
      let n := Module.finrank ℂ H
      let M := LinearMap.toMatrix E.toBasis E.toBasis A
      IsStarNormal M ∧
      (∀ (Q : Matrix.unitaryGroup (Fin n) ℂ) (T : Matrix (Fin n) (Fin n) ℂ),
        Matrix.BlockTriangular T (fun i : Fin n => i) →
        M = (Q : Matrix (Fin n) (Fin n) ℂ) * T *
          (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ → T.IsDiag) ∧
      (∃ (Q : Matrix.unitaryGroup (Fin n) ℂ) (eigenvalues : Fin n → ℂ)
          (b : OrthonormalBasis (Fin n) ℂ H),
        (Q : Matrix (Fin n) (Fin n) ℂ) =
          LinearMap.toMatrix b.toBasis E.toBasis (LinearMap.id : H →ₗ[ℂ] H) ∧
        (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ * M *
          (Q : Matrix (Fin n) (Fin n) ℂ) = Matrix.diagonal eigenvalues ∧
        M = (Q : Matrix (Fin n) (Fin n) ℂ) * Matrix.diagonal eigenvalues *
          (Q : Matrix (Fin n) (Fin n) ℂ)ᴴ ∧
        (∀ i, A (b i) = eigenvalues i • b i) ∧
        M.charpoly = ∏ i : Fin n, (Polynomial.X - Polynomial.C (eigenvalues i)))

end NumStability.Bhatia.Chapter01.Targets
