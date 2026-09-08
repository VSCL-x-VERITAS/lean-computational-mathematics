/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.Characteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.TravelingWaveCharacterization

/-!
# LeVeque Chapter 1, equation (1.3): translated-profile solutions

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, equation
(1.3), printed page 1 (raw PDF page 23), with the classical/integral distinction
in Section 1.1.2, printed pages 4–5 (raw PDF pages 26–27).

Transport preserves every profile and its initial trace. The classical PDE
conclusion explicitly requires differentiability; the time-integrated rectangle
conclusion explicitly requires interval integrability. The derivative along
a characteristic is not asserted to be a pair of classical partial derivatives.
-/

open MeasureTheory

namespace NumStability

/-- The translated profile has its stated initial trace, transports its full shape,
and satisfies the classical or rectangle conservation law on the respective
explicit regularity domains. Characteristic transport itself is unconditional. -/
theorem leveque01_equation03_transportSolution (profile : ℝ → ℝ) (speed : ℝ) :
    (∀ x, travelingWave profile speed x 0 = profile x) ∧
    (∀ x t, travelingWave profile speed (x + speed * t) t = profile x) ∧
    (∀ x t, HasDerivAt
      (fun τ => travelingWave profile speed (x + speed * τ) τ) 0 t) ∧
    (Differentiable ℝ profile →
      IsLinearAdvectionSolution (travelingWave profile speed) speed) ∧
    ((∀ a b, IntervalIntegrable profile volume a b) →
      IsRectangleConservationLawSolution (travelingWave profile speed)
        (fun state => speed * state)) := by
  refine ⟨travelingWave_zero profile speed,
    travelingWave_at_translated_point profile speed,
    travelingWave_hasDerivAt_characteristic profile speed,
    travelingWave_isLinearAdvectionSolution speed, ?_⟩
  intro h
  exact travelingWave_isRectangleConservationLawSolution profile h speed

end NumStability
