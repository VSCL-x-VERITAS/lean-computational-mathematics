/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RealEigenbasisDiagonalization

/-!
# Hyperbolicity and real diagonalization in LeVeque Chapter 3

Equation (3.2), printed page 47, raw PDF page 69. The source recalls the
hyperbolicity condition from Chapter 2 and writes the coefficient matrix in
its ordered real eigenbasis. The diagonalization calculation is reused from
the Chapter 2 formalization.
-/

namespace NumStability

/-- A constant real matrix is hyperbolic exactly when it has a complete real
eigenbasis, whose column matrix gives the representation in (3.2). -/
theorem leveque03_hyperbolicMatrix_diagonalization
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (coefficient : Matrix ι ι ℝ) :
    IsRealHyperbolicMatrix coefficient ↔
      ∃ (eigenvalues : ι → ℝ)
          (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
        (∀ p, coefficient.mulVec (eigenbasis p) =
          eigenvalues p • eigenbasis p) ∧
        (let R := (Pi.basisFun ℝ ι).toMatrix eigenbasis
         coefficient = R * Matrix.diagonal eigenvalues * R⁻¹) := by
  constructor
  · rintro ⟨eigenvalues, eigenbasis, heigen⟩
    refine ⟨eigenvalues, eigenbasis, heigen, ?_⟩
    exact (Leveque02Tracer.realEigenbasisDiagonalization
      coefficient eigenvalues eigenbasis heigen).2
  · rintro ⟨eigenvalues, eigenbasis, heigen, _⟩
    exact ⟨eigenvalues, eigenbasis, heigen⟩

end NumStability
