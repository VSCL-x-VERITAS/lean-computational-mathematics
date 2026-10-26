/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.SignedSpectralMatrices

/-!
# LeVeque Chapter 4, equation (4.60): absolute spectral matrix

The absolute-value matrix of a diagonalizable linear system has the
absolute characteristic speeds on its diagonal. It equals the difference
between the positive and negative spectral parts.
-/

namespace NumStability

/-- The diagonal matrix of absolute characteristic speeds. -/
noncomputable def leveque04_absoluteEigenvalueDiagonal
    {m : ℕ} (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  Matrix.diagonal (fun p => |waveSpeed p|)

/-- The absolute-value matrix formed in the eigenvector basis. -/
noncomputable def leveque04_absoluteCoefficient
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) : Matrix (Fin m) (Fin m) ℝ :=
  let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
  R * leveque04_absoluteEigenvalueDiagonal waveSpeed * R⁻¹

/-- Equation (4.60): |A| is R|Λ|R⁻¹, with |Λ| diagonal in
the absolute characteristic speeds. -/
theorem leveque04_equation60
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    leveque04_absoluteEigenvalueDiagonal waveSpeed =
        Matrix.diagonal (fun p => |waveSpeed p|) ∧
      leveque04_absoluteCoefficient eigenbasis waveSpeed =
        R * Matrix.diagonal (fun p => |waveSpeed p|) * R⁻¹ :=
  ⟨rfl, rfl⟩

/-- The absolute spectral matrix is the positive coefficient part minus
the negative coefficient part. -/
theorem leveque04_positive_sub_negative_eq_absolute
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) :
    leveque04_positiveCoefficientPart eigenbasis waveSpeed -
      leveque04_negativeCoefficientPart eigenbasis waveSpeed =
        leveque04_absoluteCoefficient eigenbasis waveSpeed := by
  simp only [leveque04_positiveCoefficientPart,
    leveque04_negativeCoefficientPart,
    leveque04_absoluteCoefficient]
  rw [← sub_mul, ← mul_sub]
  have hdiag :
      leveque04_positiveEigenvalueDiagonal waveSpeed -
        leveque04_negativeEigenvalueDiagonal waveSpeed =
          leveque04_absoluteEigenvalueDiagonal waveSpeed := by
    unfold leveque04_positiveEigenvalueDiagonal
      leveque04_negativeEigenvalueDiagonal
      leveque04_absoluteEigenvalueDiagonal
    rw [Matrix.diagonal_sub]
    congr 1
    funext p
    simpa only [leveque04_positiveVelocity,
      leveque04_negativeVelocity, zero_sub, abs_neg] using
      max_sub_min_eq_abs (waveSpeed p) 0
  rw [hdiag]

end NumStability
