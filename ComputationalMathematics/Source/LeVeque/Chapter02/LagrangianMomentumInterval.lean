/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMomentumIntervalTarget

/-!
# Lagrangian momentum between fixed mass labels
-/

namespace NumStability.Leveque02Tracer

/-- The existing cumulative section-conservation theorem applies to
Lagrangian velocity with pressure acting at the two fixed label endpoints. -/
theorem lagrangianMomentumInterval : lagrangianMomentumIntervalTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity
    lagrangianPressure leftLabel rightLabel time _ _ _ _ hbalance
  have hsection := integralMassBalance_fromCumulative
    (lagrangianParticleVelocity eulerianVelocity particlePosition)
    (lagrangianPressure leftLabel) (lagrangianPressure rightLabel)
    leftLabel rightLabel time hbalance
  exact ⟨hsection.2.2, hsection.2.2.deriv⟩

end NumStability.Leveque02Tracer
