/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation04ConservativeUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.IntegerLocalNumericalFlux

/-!
# LeVeque Chapter 4, equations (4.6) and (4.7)

An interface flux is computed from the two adjacent cell averages. Substituting
that choice into the conservative update produces the three-point formula.
-/

namespace NumStability

/-- Equation (4.6): one shared interface flux depends only on its adjacent
cell averages. -/
theorem leveque04_equation06 {m : ℕ}
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (cellAverage : ℤ → (Fin m → ℝ)) (i : ℤ) :
    leveque04_localInterfaceFlux numericalFlux cellAverage i =
      numericalFlux (cellAverage (i - 1)) (cellAverage i) := rfl

/-- Equation (4.7): the local numerical-flux choice yields the conservative
three-point update, with right flux minus left flux. -/
theorem leveque04_equation07 {m : ℕ}
    (timeStep cellWidth : ℝ)
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (cellAverage : ℤ → (Fin m → ℝ)) (i : ℤ) :
    leveque04_finiteVolumeUpdate timeStep cellWidth cellAverage
        (leveque04_localInterfaceFlux numericalFlux cellAverage) i =
      cellAverage i - (timeStep / cellWidth) •
        (numericalFlux (cellAverage i) (cellAverage (i + 1)) -
          numericalFlux (cellAverage (i - 1)) (cellAverage i)) := by
  simp [leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    leveque04_localInterfaceFlux]

end NumStability
