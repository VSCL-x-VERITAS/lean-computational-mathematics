/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IntegralMassBalanceCumulative
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel

/-!
# Proof-free target for the Lagrangian momentum interval balance

The pressure field is expressed in the mass label. A cumulative material
momentum balance with pressure-only endpoint forces is the physical premise;
the target obtains the printed instantaneous derivative.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The time derivative of total momentum between fixed particle labels is
left pressure minus right pressure. -/
def lagrangianMomentumIntervalTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity lagrangianPressure : ℝ → ℝ → ℝ)
    (leftLabel rightLabel time : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      label ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
    IsCumulativeSectionConservation
      (lagrangianParticleVelocity eulerianVelocity particlePosition)
      (lagrangianPressure leftLabel) (lagrangianPressure rightLabel)
      leftLabel rightLabel time →
    HasDerivAt
      (fun τ => ∫ label in leftLabel..rightLabel,
        lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
      (lagrangianPressure leftLabel time - lagrangianPressure rightLabel time) time ∧
    deriv
      (fun τ => ∫ label in leftLabel..rightLabel,
        lagrangianParticleVelocity eulerianVelocity particlePosition label τ) time =
      lagrangianPressure leftLabel time - lagrangianPressure rightLabel time

end NumStability.Leveque02Tracer
