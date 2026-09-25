/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassDifferential
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMomentumDifferential

/-!
# Proof-free target for LeVeque equation (2.107)

The Lagrangian mass and momentum laws form a closed system when pressure is
a function of specific volume near the chosen physical mass label.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The mass and momentum laws with a local pressure-versus-volume closure
are the two equations of the Lagrangian `p`-system. -/
def lagrangianPSystemTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity eulerianDensity
      lagrangianPressure : ℝ → ℝ → ℝ)
    (pressureLaw : ℝ → ℝ) (label time : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    label ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    0 < eulerianDensity (particlePosition label time) time →
    (∀ v : ℝ, 0 < v → 0 < pressureLaw v) →
    HasDerivAt
      (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
      (deriv (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
        time) time →
    HasDerivAt
      (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
      (deriv (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
        label) label →
    HasDerivAt
      (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
      (deriv (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
        time) time →
    HasDerivAt
      (fun η => lagrangianPressure η time)
      (deriv (fun η => lagrangianPressure η time) label) label →
    (fun η => lagrangianPressure η time) =ᶠ[𝓝 label]
      (fun η => pressureLaw
        (lagrangianSpecificVolume eulerianDensity particlePosition η time)) →
    (deriv
        (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
        time -
      deriv
        (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
        label = 0) →
    (deriv
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
        time +
      deriv (fun η => lagrangianPressure η time) label = 0) →
    HasDerivAt
      (fun η => pressureLaw
        (lagrangianSpecificVolume eulerianDensity particlePosition η time))
      (deriv (fun η => pressureLaw
        (lagrangianSpecificVolume eulerianDensity particlePosition η time)) label) label ∧
    (deriv
        (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
        time -
      deriv
        (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
        label = 0) ∧
    (deriv
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
        time +
      deriv (fun η => pressureLaw
        (lagrangianSpecificVolume eulerianDensity particlePosition η time)) label = 0)

end NumStability.Leveque02Tracer
