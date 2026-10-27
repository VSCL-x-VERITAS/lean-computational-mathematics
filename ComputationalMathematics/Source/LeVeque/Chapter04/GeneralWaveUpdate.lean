/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GeneralFluctuationFlux
import ComputationalMathematics.Source.LeVeque.Chapter04.WaveFluctuations
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# LeVeque Chapter 4, equation (4.41): general signed-wave update

The local Riemann waves split the physical-flux jump at each face. The
Godunov face flux takes the left physical flux plus the incoming
negative-speed waves. Conservation then yields the signed-wave update.
This statement applies to any flux law with such Riemann wave data.
-/

namespace NumStability

/-- Signed wave fluctuations reconstruct the speed-weighted flux jump. -/
theorem leveque04_signedWaveFluctuations_sum
    {m : ℕ} (speed : Fin m → ℝ)
    (wave : Fin m → (Fin m → ℝ)) :
    leveque04_negativeFluctuation speed wave +
      leveque04_positiveFluctuation speed wave =
        ∑ p, speed p • wave p := by
  simp only [leveque04_negativeFluctuation,
    leveque04_positiveFluctuation, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p _
  rw [← add_smul]
  congr 1
  simp only [leveque04_negativeVelocity,
    leveque04_positiveVelocity]
  exact (min_add_max (speed p) 0).trans (add_zero _)

/-- Equation (4.41): when each Riemann wave fan resolves the physical-flux
jump, the selected Godunov face flux gives the sum of right-going waves
from the left and left-going waves from the right. -/
theorem leveque04_equation41
    {m : ℕ} (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (old : ℤ → (Fin m → ℝ))
    (waveSpeed : ℤ → Fin m → ℝ)
    (wave : ℤ → Fin m → (Fin m → ℝ))
    (hriemann : ∀ j, flux (old j) - flux (old (j - 1)) =
      ∑ p, waveSpeed j p • wave j p)
    (scale : ℝ) (i : ℤ) :
    conservativeFluxDifferenceUpdateInt scale old
        (fun j => leveque04_generalFluctuationFlux
          (fun k => flux (old k))
          (fun k => leveque04_negativeFluctuation (waveSpeed k) (wave k)) j) i =
      old i - scale •
        ((∑ p, leveque04_positiveVelocity (waveSpeed i p) • wave i p) +
          (∑ p, leveque04_negativeVelocity (waveSpeed (i + 1) p) •
            wave (i + 1) p)) := by
  let physical : ℤ → (Fin m → ℝ) := fun j => flux (old j)
  let leftGoing : ℤ → (Fin m → ℝ) := fun j =>
    leveque04_negativeFluctuation (waveSpeed j) (wave j)
  let rightGoing : ℤ → (Fin m → ℝ) := fun j =>
    leveque04_positiveFluctuation (waveSpeed j) (wave j)
  have hsplit : FluxDifferenceSplitting.IsSplit
      physical leftGoing rightGoing := by
    intro j
    exact (hriemann j).trans
      (leveque04_signedWaveFluctuations_sum (waveSpeed j) (wave j)).symm
  have hface (j : ℤ) :
      leveque04_generalFluctuationFlux physical leftGoing j =
        FluxDifferenceSplitting.faceFlux physical rightGoing j := by
    exact (FluxDifferenceSplitting.faceFlux_eq_left
      physical leftGoing rightGoing hsplit j).symm
  have hdiff := FluxDifferenceSplitting.faceFlux_difference
    physical leftGoing rightGoing hsplit i
  have hdiff' :
      leveque04_generalFluctuationFlux physical leftGoing (i + 1) -
        leveque04_generalFluctuationFlux physical leftGoing i =
          rightGoing i + leftGoing (i + 1) := by
    rw [hface (i + 1), hface i]
    exact hdiff
  simpa only [conservativeFluxDifferenceUpdateInt, rightGoing, leftGoing,
    leveque04_positiveFluctuation, leveque04_negativeFluctuation] using
    congrArg (fun change : Fin m → ℝ => old i - scale • change) hdiff'

end NumStability
