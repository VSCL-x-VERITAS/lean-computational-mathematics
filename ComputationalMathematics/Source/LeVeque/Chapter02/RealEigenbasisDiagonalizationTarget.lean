/-
SPDX-License-Identifier: MIT
-/

import Mathlib.LinearAlgebra.Matrix.Basis
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity

/-!
# Target for diagonalization by a complete real eigenbasis
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.72): with the same ordered real eigenpairs in the columns of
`R` and on the diagonal of `Λ`, the complete eigenbasis diagonalizes `A` in
both directions. -/
def realEigenbasisDiagonalizationTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι] [DecidableEq ι]
      (coefficient : Matrix ι ι ℝ)
      (eigenvalues : ι → ℝ)
      (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
    (∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p) →
      let R := (Pi.basisFun ℝ ι).toMatrix eigenbasis
      let Λ := Matrix.diagonal eigenvalues
      R⁻¹ * coefficient * R = Λ ∧
        coefficient = R * Λ * R⁻¹

end NumStability.Leveque02Tracer
