/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveSpeedParts
import ComputationalMathematics.Source.LeVeque.Chapter03.Hyperbolicity

/-!
# LeVeque Chapter 4, equations (4.44)–(4.46): signed spectral matrices

The wave speeds are split by the same max/min operations as (4.40), then
conjugated by the existing right-eigenvector matrix. Their sum recovers the
original coefficient matrix under its Chapter 3 diagonalization.
-/

namespace NumStability

/-- Positive wave-speed diagonal matrix of (4.44). -/
noncomputable def leveque04_positiveEigenvalueDiagonal
    {m : ℕ} (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  Matrix.diagonal (fun p => leveque04_positiveVelocity (waveSpeed p))

/-- Negative wave-speed diagonal matrix of (4.44). -/
noncomputable def leveque04_negativeEigenvalueDiagonal
    {m : ℕ} (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  Matrix.diagonal (fun p => leveque04_negativeVelocity (waveSpeed p))

/-- Equation (4.44): the two signed diagonal matrices contain the
positive and negative eigenvalue parts, respectively. -/
theorem leveque04_equation44
    {m : ℕ} (waveSpeed : Fin m → ℝ) :
    leveque04_positiveEigenvalueDiagonal waveSpeed =
        Matrix.diagonal (fun p => max (waveSpeed p) 0) ∧
      leveque04_negativeEigenvalueDiagonal waveSpeed =
        Matrix.diagonal (fun p => min (waveSpeed p) 0) := ⟨rfl, rfl⟩

/-- The positive-speed part of the coefficient matrix in (4.45). -/
noncomputable def leveque04_positiveCoefficientPart
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  R * leveque04_positiveEigenvalueDiagonal waveSpeed * R⁻¹

/-- The negative-speed part of the coefficient matrix in (4.45). -/
noncomputable def leveque04_negativeCoefficientPart
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  R * leveque04_negativeEigenvalueDiagonal waveSpeed * R⁻¹

/-- Equation (4.45) exposes both spectral conjugations. -/
theorem leveque04_equation45
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    leveque04_positiveCoefficientPart eigenbasis waveSpeed =
        R * leveque04_positiveEigenvalueDiagonal waveSpeed * R⁻¹ ∧
      leveque04_negativeCoefficientPart eigenbasis waveSpeed =
        R * leveque04_negativeEigenvalueDiagonal waveSpeed * R⁻¹ := ⟨rfl, rfl⟩

/-- Positive and negative spectral diagonals add back to the unsplit
eigenvalue diagonal. -/
theorem leveque04_signedEigenvalueDiagonals_sum
    {m : ℕ} (waveSpeed : Fin m → ℝ) :
    leveque04_positiveEigenvalueDiagonal waveSpeed +
      leveque04_negativeEigenvalueDiagonal waveSpeed =
        Matrix.diagonal waveSpeed := by
  unfold leveque04_positiveEigenvalueDiagonal
    leveque04_negativeEigenvalueDiagonal
  rw [Matrix.diagonal_add]
  congr 1
  funext p
  simp only [leveque04_positiveVelocity, leveque04_negativeVelocity]
  exact max_add_min (waveSpeed p) 0 |>.trans (add_zero _)

/-- Equation (4.46): the two signed spectral pieces sum to the original
coefficient matrix when its eigenbasis diagonalization is fixed. -/
theorem leveque04_equation46
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹) :
    leveque04_positiveCoefficientPart eigenbasis waveSpeed +
      leveque04_negativeCoefficientPart eigenbasis waveSpeed = coefficient := by
  simp only [leveque04_positiveCoefficientPart,
    leveque04_negativeCoefficientPart]
  rw [← add_mul, ← mul_add,
    leveque04_signedEigenvalueDiagonals_sum]
  exact hdiag.symm

end NumStability
