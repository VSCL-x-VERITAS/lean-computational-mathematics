/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearFluxSplitting
import ComputationalMathematics.Source.LeVeque.Chapter04.SpectralFluctuations

/-!
# LeVeque Chapter 4: linear Godunov interface flux

Equations (4.49), (4.50), and (4.56) express the same linear interface
flux using negative waves, positive waves, and split coefficient matrices.
-/

namespace NumStability

/-- The left-state representation of a linear interface flux. -/
noncomputable def leveque04_linearGodunovFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) : Fin m → ℝ :=
  coefficient.mulVec left +
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec
      (right - left)

/-- Equation (4.49): physical flux of the left cell plus all
negative-speed Riemann waves. -/
theorem leveque04_equation49
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (left right : Fin m → ℝ) :
    leveque04_linearGodunovFlux coefficient eigenbasis waveSpeed left right =
      coefficient.mulVec left +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  rw [leveque04_linearGodunovFlux, leveque04_equation48]
  rfl

/-- Equation (4.50): the same interface flux from the right state,
subtracting all positive-speed Riemann waves. -/
theorem leveque04_equation50
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (left right : Fin m → ℝ) :
    leveque04_linearGodunovFlux coefficient eigenbasis waveSpeed left right =
      coefficient.mulVec right -
        ∑ p, leveque04_positiveVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis left right p := by
  rw [leveque04_linearGodunovFlux]
  have hsum := leveque04_equation46 coefficient eigenbasis waveSpeed hdiag
  rw [LinearFluxSplitting.left_eq_right coefficient
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed)
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed) hsum]
  rw [leveque04_equation47]
  rfl

/-- Equation (4.56): positive coefficient part acts on the left
cell state and negative part on the right cell state. -/
theorem leveque04_equation56
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (left right : Fin m → ℝ) :
    leveque04_linearGodunovFlux coefficient eigenbasis waveSpeed left right =
      (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec left +
        (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec right := by
  rw [leveque04_linearGodunovFlux]
  exact LinearFluxSplitting.left_eq_split coefficient
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed)
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed)
    (leveque04_equation46 coefficient eigenbasis waveSpeed hdiag) left right

/-- The split Godunov flux is consistent on an equal-state face. -/
theorem leveque04_linearGodunovFlux_consistent
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (state : Fin m → ℝ) :
    leveque04_linearGodunovFlux coefficient eigenbasis waveSpeed state state =
      coefficient.mulVec state := by
  rw [leveque04_equation56 coefficient eigenbasis waveSpeed hdiag]
  exact LinearFluxSplitting.split_consistent coefficient
    (leveque04_positiveCoefficientPart eigenbasis waveSpeed)
    (leveque04_negativeCoefficientPart eigenbasis waveSpeed)
    (leveque04_equation46 coefficient eigenbasis waveSpeed hdiag) state

/-- The right-state formula (4.50) for a numerical flux already identified
by the Riemann-wave formula (4.49). This isolates the algebraic rewrite
from the separate Riemann-interface trace assertion. -/
theorem leveque04_equation50_from49
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
    numericalFlux = coefficient.mulVec right -
      ∑ p, leveque04_positiveVelocity (waveSpeed p) •
        leveque03_riemannWave eigenbasis left right p := by
  rw [h49, ← leveque04_equation49 coefficient eigenbasis waveSpeed left right]
  exact leveque04_equation50 coefficient eigenbasis waveSpeed hdiag left right

/-- The split-matrix formula (4.56), conditional on the Riemann-wave
representation of the selected numerical interface flux. -/
theorem leveque04_equation56_from49
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
      (leveque04_positiveCoefficientPart eigenbasis waveSpeed).mulVec left +
        (leveque04_negativeCoefficientPart eigenbasis waveSpeed).mulVec right := by
  rw [h49, ← leveque04_equation49 coefficient eigenbasis waveSpeed left right]
  exact leveque04_equation56 coefficient eigenbasis waveSpeed hdiag left right

/-- Equal left and right states make the conditional flux formula
agree with the physical linear flux. -/
theorem leveque04_linearFlux_consistent_from49
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (state numericalFlux : Fin m → ℝ)
    (h49 : numericalFlux = coefficient.mulVec state +
      ∑ p, leveque04_negativeVelocity (waveSpeed p) •
        leveque03_riemannWave eigenbasis state state p) :
    numericalFlux = coefficient.mulVec state := by
  rw [h49, ← leveque04_equation49 coefficient eigenbasis waveSpeed state state]
  exact leveque04_linearGodunovFlux_consistent coefficient
    eigenbasis waveSpeed hdiag state

end NumStability
