/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjective
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel

/-!
# Proof-free target for the Lagrangian particle map and fields

Only labels attained from initial positions are used. Initial compatibility
and the trajectory differential equation are visible premises; no flow
existence or all-time invertibility is inferred from the label definition.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- For a physical particle trajectory, Lagrangian velocity is Eulerian
velocity at its position, the position derivative is that velocity, and
specific volume is reciprocal Eulerian density at the same position. -/
def lagrangianParticleMapTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity eulerianDensity : ℝ → ℝ → ℝ)
    (label time : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    label ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    0 < eulerianDensity (particlePosition label time) time →
    HasDerivAt (fun τ => particlePosition label τ)
      (eulerianVelocity (particlePosition label time) time) time →
      lagrangianMassLabel initialDensity referenceLocation
          (particlePosition label 0) = label ∧
        lagrangianParticleVelocity eulerianVelocity particlePosition label time =
          eulerianVelocity (particlePosition label time) time ∧
        deriv (fun τ => particlePosition label τ) time =
          lagrangianParticleVelocity eulerianVelocity particlePosition label time ∧
        lagrangianSpecificVolume eulerianDensity particlePosition label time =
          1 / eulerianDensity (particlePosition label time) time

end NumStability.Leveque02Tracer
