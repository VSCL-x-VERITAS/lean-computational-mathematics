/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianSpecificVolumeIntegralTarget

/-!
# Proof-free target for LeVeque equation (2.104)

The specific-volume interval identity is assumed on a time neighborhood, as
required before differentiating it. The spatial derivative of Lagrangian
velocity and the endpoint particle derivatives are classical derivatives.
-/

open MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- At fixed mass-label bounds, the time derivative of total specific volume
is the endpoint Lagrangian-velocity difference and the integral of its actual
spatial derivative. -/
def lagrangianSpecificVolumeEvolutionTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity eulerianDensity : ℝ → ℝ → ℝ)
    (leftLabel rightLabel time : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      label ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
    (∀ᶠ τ in 𝓝 time,
      ∀ label ∈ Set.uIcc leftLabel rightLabel,
        0 < eulerianDensity (particlePosition label τ) τ) →
    (∀ᶠ τ in 𝓝 time,
      IntervalIntegrable
        (fun label => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
        volume leftLabel rightLabel) →
    (fun τ => ∫ label in leftLabel..rightLabel,
      lagrangianSpecificVolume eulerianDensity particlePosition label τ) =ᶠ[𝓝 time]
      (fun τ => particlePosition rightLabel τ - particlePosition leftLabel τ) →
    HasDerivAt (fun τ => particlePosition leftLabel τ)
      (lagrangianParticleVelocity eulerianVelocity particlePosition leftLabel time) time →
    HasDerivAt (fun τ => particlePosition rightLabel τ)
      (lagrangianParticleVelocity eulerianVelocity particlePosition rightLabel time) time →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      HasDerivAt (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
        (deriv (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
          label) label) →
    IntervalIntegrable
      (fun label => deriv
        (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time) label)
      volume leftLabel rightLabel →
      HasDerivAt
          (fun τ => ∫ label in leftLabel..rightLabel,
            lagrangianSpecificVolume eulerianDensity particlePosition label τ)
          (lagrangianParticleVelocity eulerianVelocity particlePosition rightLabel time -
            lagrangianParticleVelocity eulerianVelocity particlePosition leftLabel time)
          time ∧
        deriv
            (fun τ => ∫ label in leftLabel..rightLabel,
              lagrangianSpecificVolume eulerianDensity particlePosition label τ) time =
          lagrangianParticleVelocity eulerianVelocity particlePosition rightLabel time -
            lagrangianParticleVelocity eulerianVelocity particlePosition leftLabel time ∧
        lagrangianParticleVelocity eulerianVelocity particlePosition rightLabel time -
            lagrangianParticleVelocity eulerianVelocity particlePosition leftLabel time =
          ∫ label in leftLabel..rightLabel,
            deriv (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
              label

end NumStability.Leveque02Tracer
