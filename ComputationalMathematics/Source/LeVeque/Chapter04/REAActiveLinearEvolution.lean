/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannActiveFronts
import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedBilateralEvolution

/-!
# Linear REA assembly with data-dependent active fronts

An inactive characteristic mode imposes no exterior-front constraint. Each
interface can therefore use its own bounds on the speeds of its nonzero
Riemann jumps. The existing bilateral assembly supplies the evolved field.
-/

namespace NumStability

/-- The actual linear Riemann fields assemble on the closed step when the
data-dependent active fronts of adjacent interfaces remain ordered. -/
noncomputable def leveque04_linearREAActiveEvolution
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 ≤ step)
    (hfronts : ∀ j, -bound ≤ leftSpeed j ∧ leftSpeed j ≤ rightSpeed j ∧
      rightSpeed j ≤ bound)
    (hactive : ∀ j p,
      basis.equivFun (states j) p ≠ basis.equivFun (states (j + 1)) p →
        leftSpeed j ≤ speeds p ∧ speeds p ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step) :
    ℝ → ℝ → Fin m → ℝ :=
  leveque04_reaBoundedEvolution states
    (fun j x time => linearRiemannSolution basis speeds
      (states j) (states j) (states (j + 1))
      (x - (origin + (j : ℝ) * width)) time)
    leftSpeed rightSpeed origin width bound step hwidth hbound hstep hfronts hinteraction
    (by
      intro j x time ht hx
      apply linearRiemannSolution_left_of_active_front basis speeds
        (states j) (states (j + 1)) (leftSpeed j) _ time
        (fun p hp => (hactive j p hp).1) ht.1
      linarith)
    (by
      intro j x time ht hx
      apply linearRiemannSolution_right_of_active_front basis speeds
        (states j) (states (j + 1)) (rightSpeed j) _ time
        (fun p hp => (hactive j p hp).2) ht.1
      linarith)

end NumStability
