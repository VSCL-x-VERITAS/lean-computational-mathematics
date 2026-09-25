/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ActualPressureSlopeTarget

/-!
# The positive pressure derivative assumption

Equation (2.37) is a condition on a chosen pressure law. The equivalence below
uses actual derivative existence and uniqueness on positive densities. It does
not claim that every equation of state satisfies the condition.
-/

namespace NumStability.Leveque02Tracer

/-- Positive pressure slope is differentiability with a strictly positive
actual derivative at each positive density. -/
theorem actualPressureSlope : actualPressureSlopeTarget := by
  intro pressureLaw
  constructor
  · intro hpositive density hdensity
    obtain ⟨slope, hslope, hslopePositive⟩ := hpositive density hdensity
    refine ⟨hslope.differentiableAt, ?_⟩
    intro other hother
    simpa only [hslope.unique hother] using hslopePositive
  · intro hactual density hdensity
    obtain ⟨hdifferentiable, hpositive⟩ := hactual density hdensity
    exact ⟨deriv pressureLaw density, hdifferentiable.hasDerivAt,
      hpositive (deriv pressureLaw density) hdifferentiable.hasDerivAt⟩

end NumStability.Leveque02Tracer
