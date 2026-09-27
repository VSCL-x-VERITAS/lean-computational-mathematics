/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution

/-!
# Exercise 3.2: two-family Riemann solver contract

Printed page 62/raw PDF page 84 asks for a script that solves and plots the
Exercise 3.1 problems and further inputs. The executable plotting script is
`experiments/chapter03/exercise32_riemann.py`. This module specifies and
proves the spectral solution's mathematical contract on its real eigenbasis
domain; the script checks that domain numerically and emits SVG profiles.
-/

namespace NumStability

noncomputable def leveque03_exercise32Solution
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (speeds : Fin 2 → ℝ) (left right : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  linearRiemannSolution eigenbasis speeds left left right

theorem leveque03_exercise32Solution_contract
    (coefficient : Matrix (Fin 2) (Fin 2) ℝ)
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (speeds : Fin 2 → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      speeds p • eigenbasis p)
    (left right : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution
        (leveque03_exercise32Solution eigenbasis speeds left right)
        coefficient.mulVec ∧
      (∀ x, leveque03_exercise32Solution eigenbasis speeds left right x 0 =
        riemannData left left right x) := by
  constructor
  · exact linearRiemannSolution_isRectangleSolution coefficient eigenbasis
      speeds heigen left left right
  · intro x
    exact linearRiemannSolution_initial eigenbasis speeds left left right x

end NumStability
