/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RealEigenbasisDiagonalizationTarget

/-!
# Diagonalization by a complete real eigenbasis
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.72): the ordered eigenvector columns conjugate the coefficient
matrix to the diagonal matrix of their paired eigenvalues. -/
theorem realEigenbasisDiagonalization :
    realEigenbasisDiagonalizationTarget := by
  intro ι _ _ coefficient eigenvalues eigenbasis heigen
  let R : Matrix ι ι ℝ := (Pi.basisFun ℝ ι).toMatrix eigenbasis
  let S : Matrix ι ι ℝ := eigenbasis.toMatrix (Pi.basisFun ℝ ι)
  let Λ : Matrix ι ι ℝ := Matrix.diagonal eigenvalues
  have hSR : S * R = 1 := by
    simp [S, R]
  have hRS : R * S = 1 := by
    simp [S, R]
  have hInv : R⁻¹ = S := Matrix.inv_eq_left_inv hSR
  have hAR : coefficient * R = R * Λ := by
    ext i p
    have hp := congrFun (heigen p) i
    calc
      (coefficient * R) i p =
          (coefficient.mulVec (eigenbasis p)) i := by
        simp [Matrix.mul_apply, Matrix.mulVec, dotProduct,
          R, Module.Basis.toMatrix_apply]
      _ = eigenvalues p * eigenbasis p i := by
        simpa [Pi.smul_apply, smul_eq_mul] using hp
      _ = (R * Λ) i p := by
        simp [R, Λ, Module.Basis.toMatrix_apply, mul_comm]
  change R⁻¹ * coefficient * R = Λ ∧
    coefficient = R * Λ * R⁻¹
  constructor
  · rw [hInv]
    calc
      S * coefficient * R = S * (coefficient * R) := by rw [Matrix.mul_assoc]
      _ = S * (R * Λ) := by rw [hAR]
      _ = Λ := by rw [← Matrix.mul_assoc, hSR, Matrix.one_mul]
  · rw [hInv]
    calc
      coefficient = coefficient * (R * S) := by rw [hRS, Matrix.mul_one]
      _ = (coefficient * R) * S := by rw [Matrix.mul_assoc]
      _ = (R * Λ) * S := by rw [hAR]

end NumStability.Leveque02Tracer
