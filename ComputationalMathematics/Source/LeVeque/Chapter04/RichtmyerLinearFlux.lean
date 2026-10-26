/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates
import Mathlib.Data.Matrix.Mul
import Mathlib.Tactic.Module
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: Richtmyer flux for a linear system

For a constant matrix flux, applying the flux matrix to the half-time
predictor gives the usual centered flux plus a second-difference
correction. This is the flux identity used by Lax--Wendroff.
-/

namespace NumStability

/-- The linear-system Richtmyer face flux, expanded into the
Lax--Wendroff centered flux and its matrix-squared correction. -/
theorem leveque04_richtmyerLinearFlux
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (timeStep cellWidth : ℝ) (left right : Fin m → ℝ) :
    leveque04_richtmyerFlux timeStep cellWidth
        coefficient.mulVec left right =
      (1 / 2 : ℝ) • (coefficient.mulVec left + coefficient.mulVec right) -
        (timeStep / (2 * cellWidth)) •
          coefficient.mulVec (coefficient.mulVec right -
            coefficient.mulVec left) := by
  simp only [leveque04_richtmyerFlux, leveque04_richtmyerPredictor,
    Matrix.mulVec_sub, Matrix.mulVec_add, Matrix.mulVec_smul]

/-- The conservative Richtmyer update is the standard centered
Lax--Wendroff update for a constant matrix flux. -/
theorem leveque04_richtmyerLinearStep
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (timeStep cellWidth : ℝ) (old : ℤ → (Fin m → ℝ)) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth old
        (leveque04_localInterfaceFlux
          (leveque04_richtmyerFlux timeStep cellWidth coefficient.mulVec)
          old) i =
      old i - (timeStep / (2 * cellWidth)) •
          coefficient.mulVec (old (i + 1) - old (i - 1)) +
        (timeStep ^ 2 / (2 * cellWidth ^ 2)) •
          coefficient.mulVec
            (coefficient.mulVec (old (i + 1) -
              (2 : ℝ) • old i + old (i - 1))) := by
  ext k
  simp only [leveque04_finiteVolumeUpdate,
    conservativeFluxDifferenceUpdateInt, leveque04_localInterfaceFlux,
    leveque04_richtmyerLinearFlux, Matrix.mulVec_sub,
    Matrix.mulVec_add, Matrix.mulVec_smul, Pi.sub_apply,
    Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring_nf

/-- In a real eigenbasis, each characteristic component of the actual
    linear-system Richtmyer update is the scalar Lax–Wendroff stencil. -/
theorem leveque04_richtmyerLinearStep_characteristic
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (timeStep cellWidth : ℝ) (old : ℤ → (Fin m → ℝ))
    (i : ℤ) (p : Fin m) :
    eigenbasis.equivFun
        (leveque04_finiteVolumeUpdate timeStep cellWidth old
          (leveque04_localInterfaceFlux
            (leveque04_richtmyerFlux timeStep cellWidth coefficient.mulVec)
            old) i) p =
      eigenbasis.equivFun (old i) p -
        (waveSpeed p * timeStep / (2 * cellWidth)) *
          (eigenbasis.equivFun (old (i + 1)) p -
            eigenbasis.equivFun (old (i - 1)) p) +
        (waveSpeed p * timeStep / cellWidth) ^ 2 / 2 *
          (eigenbasis.equivFun (old (i + 1)) p -
            2 * eigenbasis.equivFun (old i) p +
            eigenbasis.equivFun (old (i - 1)) p) := by
  rw [leveque04_richtmyerLinearStep]
  simp only [map_add, map_sub, map_smul,
    eigenbasis_coordinates_mulVec coefficient eigenbasis waveSpeed heigen,
    Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

end NumStability
