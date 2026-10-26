/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifferenceSplitting
import Mathlib.Algebra.Group.Pi.Basic

/-!
# LeVeque Chapter 4: general flux-difference splitting

Equations (4.52) and (4.53) give the two descriptions of one numerical
interface flux. Their equality yields (4.54); the same split supplies the
two forms of (4.55) and conservation of finite-block updates.
-/

namespace NumStability

/-- Equation (4.54), derived from the two representations (4.52) and
(4.53) of the same numerical flux. -/
theorem leveque04_equation54_general
    {m : ℕ} (physical leftGoing rightGoing numericalFlux : ℤ → (Fin m → ℝ))
    (h52 : ∀ i, numericalFlux i = physical (i - 1) + leftGoing i)
    (h53 : ∀ i, numericalFlux i = physical i - rightGoing i) :
    FluxDifferenceSplitting.IsSplit physical leftGoing rightGoing :=
  FluxDifferenceSplitting.isSplit_of_faceFlux_forms
    physical leftGoing rightGoing numericalFlux h52 h53

/-- Equation (4.55): the face flux has identical left-state and
right-state descriptions whenever (4.54) holds. -/
theorem leveque04_equation55_general
    {m : ℕ} (physical leftGoing rightGoing : ℤ → (Fin m → ℝ))
    (hsplit : FluxDifferenceSplitting.IsSplit physical leftGoing rightGoing)
    (i : ℤ) :
    FluxDifferenceSplitting.faceFlux physical rightGoing i =
        physical i - rightGoing i ∧
      FluxDifferenceSplitting.faceFlux physical rightGoing i =
        physical (i - 1) + leftGoing i :=
  ⟨rfl, FluxDifferenceSplitting.faceFlux_eq_left
    physical leftGoing rightGoing hsplit i⟩

/-- Conservation claim following (4.54): summing a finite block of
wave-form updates cancels every interior interface flux. -/
theorem leveque04_fluxSplittingConservation
    {m : ℕ} (scale : ℝ) (old : ℕ → (Fin m → ℝ))
    (physical leftGoing rightGoing : ℤ → (Fin m → ℝ))
    (hsplit : FluxDifferenceSplitting.IsSplit physical leftGoing rightGoing)
    (cellCount : ℕ) :
    Finset.sum (Finset.range cellCount)
      (fun i => old i - scale •
        (rightGoing (i : ℤ) + leftGoing ((i : ℤ) + 1))) =
      Finset.sum (Finset.range cellCount) old -
        scale • (FluxDifferenceSplitting.faceFlux physical rightGoing
          (cellCount : ℤ) -
          FluxDifferenceSplitting.faceFlux physical rightGoing 0) :=
  FluxDifferenceSplitting.sum_waveUpdates scale old
    physical leftGoing rightGoing hsplit cellCount

end NumStability
