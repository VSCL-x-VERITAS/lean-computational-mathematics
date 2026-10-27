/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannTraceFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifferenceSplitting

/-!
# LeVeque Chapter 4, equation (4.51): linear Godunov update

The two physical-flux descriptions of each linear Riemann face flux turn
the conservative face-flux difference into right- and left-going wave
fluctuations at the two neighboring interfaces.
-/

namespace NumStability

/-- Equation (4.51), with the actual interface-flux representation (4.49)
made an explicit input for every face of the current cell array. -/
theorem leveque04_equation51_from49
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (hdiag : coefficient =
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      R * Matrix.diagonal waveSpeed * R⁻¹)
    (old : ℤ → (Fin m → ℝ)) (faceFlux : ℤ → (Fin m → ℝ))
    (h49 : ∀ i, faceFlux i = coefficient.mulVec (old (i - 1)) +
      leveque04_negativeFluctuation waveSpeed
        (leveque03_riemannWave eigenbasis (old (i - 1)) (old i)))
    (scale : ℝ) (i : ℤ) :
    conservativeFluxDifferenceUpdateInt scale old faceFlux i =
      old i - scale •
        (leveque04_positiveFluctuation waveSpeed
            (leveque03_riemannWave eigenbasis (old (i - 1)) (old i)) +
          leveque04_negativeFluctuation waveSpeed
            (leveque03_riemannWave eigenbasis (old i) (old (i + 1)))) := by
  let physical : ℤ → (Fin m → ℝ) := fun j => coefficient.mulVec (old j)
  let leftGoing : ℤ → (Fin m → ℝ) := fun j =>
    leveque04_negativeFluctuation waveSpeed
      (leveque03_riemannWave eigenbasis (old (j - 1)) (old j))
  let rightGoing : ℤ → (Fin m → ℝ) := fun j =>
    leveque04_positiveFluctuation waveSpeed
      (leveque03_riemannWave eigenbasis (old (j - 1)) (old j))
  have hleft (j : ℤ) : faceFlux j = physical (j - 1) + leftGoing j :=
    h49 j
  have hright (j : ℤ) : faceFlux j = physical j - rightGoing j := by
    have hj := leveque04_equation50_from49 coefficient eigenbasis
      waveSpeed hdiag (old (j - 1)) (old j) (faceFlux j)
    have h49j : faceFlux j = coefficient.mulVec (old (j - 1)) +
        ∑ p, leveque04_negativeVelocity (waveSpeed p) •
          leveque03_riemannWave eigenbasis (old (j - 1)) (old j) p := by
      simpa only [leveque04_negativeFluctuation] using h49 j
    have h := hj h49j
    simpa only [physical, rightGoing,
      leveque04_positiveFluctuation] using h
  have hsplit : FluxDifferenceSplitting.IsSplit
      physical leftGoing rightGoing :=
    FluxDifferenceSplitting.isSplit_of_faceFlux_forms
      physical leftGoing rightGoing faceFlux hleft hright
  have hface (j : ℤ) :
      faceFlux j = FluxDifferenceSplitting.faceFlux physical rightGoing j :=
    hright j
  have hdiff : faceFlux (i + 1) - faceFlux i =
      rightGoing i + leftGoing (i + 1) := by
    rw [hface (i + 1), hface i]
    exact FluxDifferenceSplitting.faceFlux_difference
      physical leftGoing rightGoing hsplit i
  simpa only [conservativeFluxDifferenceUpdateInt,
    rightGoing, leftGoing, add_sub_cancel_right] using
    congrArg (fun change : Fin m → ℝ => old i - scale • change) hdiff

/-- Equation (4.51) for the actual fluxes returned at every cell face
by the certified linear Riemann method. -/
theorem leveque04_equation51_selected
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (old : ℤ → (Fin m → ℝ)) (scale : ℝ) (i : ℤ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => True.intro)
    conservativeFluxDifferenceUpdateInt scale old faceFlux i =
      old i - scale •
        (leveque04_positiveFluctuation waveSpeed
            (leveque03_riemannWave eigenbasis (old (i - 1)) (old i)) +
          leveque04_negativeFluctuation waveSpeed
            (leveque03_riemannWave eigenbasis (old i) (old (i + 1)))) := by
  have hdiag := (Leveque02Tracer.realEigenbasisDiagonalization
    coefficient waveSpeed eigenbasis heigen).2
  apply leveque04_equation51_from49 coefficient eigenbasis
    waveSpeed hdiag old _ ?_ scale i
  intro j
  change (linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen).numericalFluxFromInformation
      ((linearRectangleRiemannInterfaceFluxMethod coefficient
        hcoefficient eigenbasis waveSpeed heigen).extractInformation
        ((linearRectangleRiemannInterfaceFluxMethod coefficient
          hcoefficient eigenbasis waveSpeed heigen).solve
          ⟨old (j - 1), old j⟩ trivial)) = _
  simpa only [leveque04_negativeFluctuation] using
    leveque04_equation49_selected coefficient hcoefficient
      eigenbasis waveSpeed heigen (old (j - 1)) (old j)

end NumStability
