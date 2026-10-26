/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AbsoluteSpectralMatrix
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovFlux
import Mathlib.Tactic.Module

/-!
# LeVeque Chapter 4: centered Roe flux

For a linear system the split interface flux can be written as a centered
physical flux minus an absolute-spectral jump correction.
-/

namespace NumStability

/-- The split linear flux equals a centered physical flux minus the
absolute-matrix correction. -/
theorem leveque04_splitFlux_eq_centered
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (left right : Fin m → ℝ) :
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec left +
      (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec right =
        (1 / 2 : ℝ) •
          (coefficient.mulVec left + coefficient.mulVec right) -
        (1 / 2 : ℝ) •
          (leveque04_absoluteCoefficient eigenbasis waveSpeed).mulVec
            (right - left) := by
  let positive := leveque04_positiveCoefficientPart eigenbasis waveSpeed
  let negative := leveque04_negativeCoefficientPart eigenbasis waveSpeed
  let absolute := leveque04_absoluteCoefficient eigenbasis waveSpeed
  have hsum : positive + negative = coefficient :=
    leveque04_equation46 coefficient eigenbasis waveSpeed hdiag
  have hdiff : positive - negative = absolute :=
    leveque04_positive_sub_negative_eq_absolute eigenbasis waveSpeed
  have hleft : coefficient.mulVec left =
      positive.mulVec left + negative.mulVec left := by
    rw [← Matrix.add_mulVec, hsum]
  have hright : coefficient.mulVec right =
      positive.mulVec right + negative.mulVec right := by
    rw [← Matrix.add_mulVec, hsum]
  have habsolute : absolute.mulVec (right - left) =
      positive.mulVec right - positive.mulVec left -
        negative.mulVec right + negative.mulVec left := by
    rw [← hdiff, Matrix.sub_mulVec, Matrix.mulVec_sub,
      Matrix.mulVec_sub]
    abel
  rw [hleft, hright, habsolute]
  module

/-- Equation (4.61), conditional on the linear Riemann-wave interface
flux formula (4.49). -/
theorem leveque04_equation61_from49
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (left right numericalFlux : Fin m → ℝ)
    (h49 : numericalFlux = coefficient.mulVec left +
      ∑ p, leveque04_negativeVelocity (waveSpeed p) •
        leveque03_riemannWave eigenbasis left right p) :
    numericalFlux =
      (1 / 2 : ℝ) •
        (coefficient.mulVec left + coefficient.mulVec right) -
      (1 / 2 : ℝ) •
        (leveque04_absoluteCoefficient eigenbasis waveSpeed).mulVec
          (right - left) := by
  rw [leveque04_equation56_from49 coefficient eigenbasis waveSpeed
    hdiag left right numericalFlux h49]
  exact leveque04_splitFlux_eq_centered coefficient eigenbasis
    waveSpeed hdiag left right

/-- The absolute spectral action on a Riemann jump is the sum of its
waves weighted by the difference between positive and negative speeds. -/
theorem leveque04_absoluteWaveAction
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    (leveque04_absoluteCoefficient eigenbasis waveSpeed).mulVec (right - left) =
      ∑ p, (leveque04_positiveVelocity (waveSpeed p) -
        leveque04_negativeVelocity (waveSpeed p)) •
          leveque03_riemannWave eigenbasis left right p := by
  have h := leveque04_spectralWaveAction eigenbasis
    (fun p => |waveSpeed p|) left right
  change (leveque04_absoluteCoefficient eigenbasis waveSpeed).mulVec
      (right - left) =
    ∑ p, |waveSpeed p| •
      leveque03_riemannWave eigenbasis left right p at h
  rw [h]
  apply Finset.sum_congr rfl
  intro p _
  have hs : leveque04_positiveVelocity (waveSpeed p) -
      leveque04_negativeVelocity (waveSpeed p) = |waveSpeed p| := by
    simpa only [leveque04_positiveVelocity,
      leveque04_negativeVelocity, zero_sub, abs_neg] using
      max_sub_min_eq_abs (waveSpeed p) 0
  rw [hs]

/-- Equation (4.59), the average of the two linear flux descriptions
with their signed-wave difference. -/
theorem leveque04_equation59_from49
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (left right numericalFlux : Fin m → ℝ)
    (h49 : numericalFlux = coefficient.mulVec left +
      ∑ p, leveque04_negativeVelocity (waveSpeed p) •
        leveque03_riemannWave eigenbasis left right p) :
    numericalFlux = (1 / 2 : ℝ) •
      ((coefficient.mulVec left + coefficient.mulVec right) -
        ∑ p, (leveque04_positiveVelocity (waveSpeed p) -
          leveque04_negativeVelocity (waveSpeed p)) •
            leveque03_riemannWave eigenbasis left right p) := by
  rw [smul_sub]
  rw [← leveque04_absoluteWaveAction eigenbasis waveSpeed left right]
  exact leveque04_equation61_from49 coefficient eigenbasis
    waveSpeed hdiag left right numericalFlux h49

end NumStability
