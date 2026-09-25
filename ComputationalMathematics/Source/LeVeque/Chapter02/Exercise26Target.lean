/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Proof-free target: Exercise 2.6

The moving-endpoint specific-volume identity (2.103) is the mass-preserving
premise. Differentiating its upper label yields `X_ξ=V`; differentiating that
identity in time and `X_t=U` in label makes (2.105) exactly the commutation of
the two mixed derivatives of the particle-position map.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Exercise 2.6: the moving-interval identity gives `X_ξ=V`, and the
Lagrangian mass equation is precisely equality of the mixed partials. -/
def exercise26Target : Prop :=
  ∀ (particlePosition eulerianVelocity eulerianDensity : ℝ → ℝ → ℝ)
    (referenceLabel label time volumeTime velocityLabel
      labelThenTime timeThenLabel : ℝ),
    (∀ τ : ℝ,
      Continuous (fun η =>
        lagrangianSpecificVolume eulerianDensity particlePosition η τ)) →
    (∀ η τ : ℝ, 0 < eulerianDensity (particlePosition η τ) τ) →
    (∀ η τ : ℝ,
      (∫ ζ in referenceLabel..η,
        lagrangianSpecificVolume eulerianDensity particlePosition ζ τ) =
      particlePosition η τ - particlePosition referenceLabel τ) →
    (∀ η τ : ℝ,
      HasDerivAt (fun s => particlePosition η s)
        (lagrangianParticleVelocity eulerianVelocity particlePosition η τ) τ) →
    HasDerivAt
      (fun τ => lagrangianSpecificVolume eulerianDensity particlePosition label τ)
      volumeTime time →
    HasDerivAt
      (fun η => lagrangianParticleVelocity eulerianVelocity particlePosition η time)
      velocityLabel label →
    HasDerivAt
      (fun τ => deriv (fun η => particlePosition η τ) label)
      labelThenTime time →
    HasDerivAt
      (fun η => deriv (fun τ => particlePosition η τ) time)
      timeThenLabel label →
      (∀ η τ : ℝ,
        HasDerivAt (fun ζ => particlePosition ζ τ)
          (lagrangianSpecificVolume eulerianDensity particlePosition η τ) η) ∧
      labelThenTime = volumeTime ∧
      timeThenLabel = velocityLabel ∧
      (volumeTime - velocityLabel = 0 ↔
        labelThenTime = timeThenLabel)

end NumStability.Leveque02Tracer
