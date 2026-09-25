/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianSpecificVolumeEvolutionTarget

/-!
# Proof-free target for LeVeque equation (2.105)

The prior interval identity (2.104) holds for fixed bounds inside an open
interval of attained physical labels. Differentiation under the integral and
continuity of both spatial fields then give its pointwise integrand equality.
-/

open MeasureTheory
open scoped Topology

namespace NumStability.Leveque02Tracer

/-- On an open interval of physical mass labels, the all-interval form of
(2.104) yields the local Lagrangian mass equation `Vₜ - U_ξ = 0`. -/
def lagrangianMassDifferentialTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity eulerianDensity : ℝ → ℝ → ℝ)
    (lowerLabel upperLabel time label : ℝ),
    label ∈ Set.Ioo lowerLabel upperLabel →
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      η ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      0 < eulerianDensity (particlePosition η time) time) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      HasDerivAt
        (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ)
        (deriv (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ) time)
        time) →
    (∀ η ∈ Set.Ioo lowerLabel upperLabel,
      HasDerivAt
        (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time)
        (deriv (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time)
          η) η) →
    ContinuousAt
      (fun η => deriv
        (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ) time)
      label →
    StronglyMeasurableAtFilter
      (fun η => deriv
        (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ) time)
      (𝓝 label) volume →
    ContinuousAt
      (fun η => deriv
        (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time) η)
      label →
    StronglyMeasurableAtFilter
      (fun η => deriv
        (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time) η)
      (𝓝 label) volume →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        ∀ᶠ τ in 𝓝 time,
          IntervalIntegrable
            (fun η => lagrangianSpecificVolume eulerianDensity particlePosition η τ)
            volume a b) →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        HasDerivAt
          (fun τ => ∫ η in a..b,
            lagrangianSpecificVolume eulerianDensity particlePosition η τ)
          (∫ η in a..b,
            deriv (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition η τ)
              time)
          time) →
    (∀ a ∈ Set.Ioo lowerLabel upperLabel,
      ∀ b ∈ Set.Ioo lowerLabel upperLabel,
        deriv
          (fun τ => ∫ η in a..b,
            lagrangianSpecificVolume eulerianDensity particlePosition η τ) time =
          ∫ η in a..b,
            deriv (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time)
              η) →
    deriv (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ) time -
      deriv (fun ζ => lagrangianParticleVelocity eulerianVelocity particlePosition ζ time)
        label = 0

end NumStability.Leveque02Tracer
