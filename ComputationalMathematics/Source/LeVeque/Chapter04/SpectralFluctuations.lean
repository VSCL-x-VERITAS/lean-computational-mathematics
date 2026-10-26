/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.SignedSpectralMatrices
import ComputationalMathematics.Source.LeVeque.Chapter04.WaveFluctuations
import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannFigure33

/-!
# LeVeque Chapter 4, equations (4.47)–(4.48): spectral fluctuations

The signed coefficient matrices act on a Riemann jump by scaling each
characteristic wave with the corresponding signed propagation speed.
-/

namespace NumStability

/-- The eigenvector-column matrix assembles coordinates as a finite sum of
scaled eigenvectors. -/
private theorem leveque04_basisMatrix_mulVec_eq_sum
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (coordinates : Fin m → ℝ) :
    ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec coordinates =
      ∑ p, coordinates p • eigenbasis p := by
  have h := Module.Basis.toMatrix_mulVec_repr eigenbasis
    (Pi.basisFun ℝ (Fin m)) (eigenbasis.equivFun.symm coordinates)
  have heq :
      ((Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis).mulVec coordinates =
        eigenbasis.equivFun.symm coordinates := by
    simpa only [← Module.Basis.equivFun_apply,
      LinearEquiv.apply_symm_apply, Pi.basisFun_repr] using h
  rw [heq, eigenbasis.equivFun_symm_apply]

/-- A diagonal speed operator in characteristic coordinates acts on the
Riemann jump by weighting the already defined Chapter 3 waves. -/
theorem leveque04_spectralWaveAction
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speedPart : Fin m → ℝ) (left right : Fin m → ℝ) :
    let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
    (R * Matrix.diagonal speedPart * R⁻¹).mulVec (right - left) =
      ∑ p, speedPart p • leveque03_riemannWave eigenbasis left right p := by
  dsimp only
  rw [← Matrix.mulVec_mulVec, ← Matrix.mulVec_mulVec]
  rw [leveque04_basisMatrix_mulVec_eq_sum]
  apply Finset.sum_congr rfl
  intro p _
  rw [Matrix.mulVec_diagonal]
  have hwave := (leveque03_waveStrength_fromJump eigenbasis left right).2.2 p |>.2
  simp only [leveque03_riemannWave]
  rw [← hwave]
  simp only [leveque03_characteristicVariables, mul_smul]

/-- Equation (4.47): the positive spectral part of the coefficient matrix
applied to a jump equals the right-going fluctuation from that interface. -/
theorem leveque04_equation47
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec (right - left) =
      leveque04_positiveFluctuation waveSpeed
        (leveque03_riemannWave eigenbasis left right) := by
  simpa only [leveque04_positiveCoefficientPart,
    leveque04_positiveEigenvalueDiagonal,
    leveque04_positiveFluctuation] using
    leveque04_spectralWaveAction eigenbasis
      (fun p => leveque04_positiveVelocity (waveSpeed p)) left right

/-- Equation (4.48): the negative spectral part gives the left-going
fluctuation from the same interface. -/
theorem leveque04_equation48
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec (right - left) =
      leveque04_negativeFluctuation waveSpeed
        (leveque03_riemannWave eigenbasis left right) := by
  simpa only [leveque04_negativeCoefficientPart,
    leveque04_negativeEigenvalueDiagonal,
    leveque04_negativeFluctuation] using
    leveque04_spectralWaveAction eigenbasis
      (fun p => leveque04_negativeVelocity (waveSpeed p)) left right

end NumStability
