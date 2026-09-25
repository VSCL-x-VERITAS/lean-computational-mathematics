/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicPowerSlopeTarget

/-!
# Correctly qualified power-law pressure slope

The real-power derivative is positive at positive densities when both physical
parameters are positive. Its restriction there is the existing isentropic
pressure law. No slope claim is made for arbitrary real parameters.
-/

namespace NumStability.Leveque02Tracer

/-- Under positive parameters, the isentropic law satisfies (2.37). -/
theorem isentropicPowerSlope : isentropicPowerSlopeTarget := by
  intro coefficient exponent hcoefficient hexponent
  constructor
  · intro density
    rfl
  · intro density hdensity
    refine ⟨coefficient * (exponent * density ^ (exponent - 1)), ?_, ?_⟩
    · exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt hdensity))).const_mul coefficient
    · exact mul_pos hcoefficient
        (mul_pos hexponent (Real.rpow_pos_of_pos hdensity _))

end NumStability.Leveque02Tracer
