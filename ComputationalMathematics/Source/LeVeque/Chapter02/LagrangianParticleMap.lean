/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapTarget

/-!
# Lagrangian particle-map identities
-/

namespace NumStability.Leveque02Tracer

/-- On attainable initial mass labels, a compatible particle trajectory has
the printed initial-label, velocity, motion, and specific-volume identities. -/
theorem lagrangianParticleMapIdentities : lagrangianParticleMapTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity
    eulerianDensity label time _ _ hlabel hinitial _ htrajectory
  rcases hlabel with ⟨initialPosition, rfl⟩
  constructor
  · rw [hinitial initialPosition]
  constructor
  · rfl
  constructor
  · simpa [lagrangianParticleVelocity] using htrajectory.deriv
  · rfl

end NumStability.Leveque02Tracer
