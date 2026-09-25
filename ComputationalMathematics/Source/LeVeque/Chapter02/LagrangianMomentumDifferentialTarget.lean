/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMomentumIntervalTarget

/-!
# Proof-free target for LeVeque equation (2.106)

The pressure-only momentum balance is required on every fixed subinterval of
an open physical label range, with enough regularity to differentiate its
momentum integral in time and localize in the right label.
-/

open Filter MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- The all-interval Lagrangian momentum balance yields the local law
`Uₜ + p_ξ = 0` at an interior physical mass label. -/
def lagrangianMomentumDifferentialTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity lagrangianPressure : ℝ → ℝ → ℝ)
    (lowerLabel upperLabel time label : ℝ),
    label ∈ Set.Ioo lowerLabel upperLabel →
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      η ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      HasDerivAt
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ)
        (deriv
          (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ) time)
        time) →
    ContinuousAt
      (fun η => deriv
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ) time)
      label →
    StronglyMeasurableAtFilter
      (fun η => deriv
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ) time)
      (𝓝 label) volume →
    HasDerivAt (fun ζ => lagrangianPressure ζ time)
      (deriv (fun ζ => lagrangianPressure ζ time) label) label →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        ∀ᶠ τ in 𝓝 time,
          IntervalIntegrable
            (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η τ)
            volume a b) →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        HasDerivAt
          (fun τ => ∫ η in a..b,
            lagrangianParticleVelocity eulerianVelocity particlePosition η τ)
          (∫ η in a..b,
            deriv (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition η τ)
              time)
          time) →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        HasDerivAt
          (fun τ => ∫ η in a..b,
            lagrangianParticleVelocity eulerianVelocity particlePosition η τ)
          (lagrangianPressure a time - lagrangianPressure b time)
          time) →
    deriv
        (fun τ => lagrangianParticleVelocity eulerianVelocity particlePosition label τ)
        time +
      deriv (fun ζ => lagrangianPressure ζ time) label = 0

end NumStability.Leveque02Tracer
