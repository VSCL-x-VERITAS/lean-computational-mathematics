/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassInterval
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryEndpointMassCounterexampleTarget
import Mathlib.Tactic

/-!
# Counterexample to the stationary-reference mass claim
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- A translating constant-density fluid conserves the mass between particles,
while the mass from the fixed initial reference point changes. -/
theorem stationaryEndpointMassCounterexample :
    stationaryEndpointMassCounterexampleTarget := by
  dsimp [stationaryEndpointMassCounterexampleTarget]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro ξ
    ring
  · intro ξ time
    convert (hasDerivAt_id time).const_add ξ using 1
  · intro x time
    norm_num
  · intro left right time
    simp only [intervalIntegral.integral_const, smul_eq_mul, mul_one]
    ring
  · simp [lagrangianMassLabel]
  · norm_num [lagrangianMassLabel, intervalIntegral.integral_const]
    exact one_add_one_eq_two
  · norm_num [lagrangianMassLabel, intervalIntegral.integral_const]
  · norm_num [lagrangianMassLabel, intervalIntegral.integral_const]

end NumStability.Leveque02Tracer
