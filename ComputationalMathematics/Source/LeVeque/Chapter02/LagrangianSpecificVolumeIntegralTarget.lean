/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Proof-free target for LeVeque equation (2.103)

The Lagrangian mass-coordinate Jacobian `X_ξ=V` is a visible physical
premise. The specific-volume definition alone does not imply it.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- The integral of specific volume over an attained mass-label interval is
the physical separation of the two particles at the observed time. -/
def lagrangianSpecificVolumeIntegralTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianDensity : ℝ → ℝ → ℝ)
    (leftLabel rightLabel time : ℝ),
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      label ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      0 < eulerianDensity (particlePosition label time) time) →
    (∀ label ∈ Set.uIcc leftLabel rightLabel,
      HasDerivAt (fun η => particlePosition η time)
        (lagrangianSpecificVolume eulerianDensity particlePosition label time) label) →
    IntervalIntegrable
      (fun label => lagrangianSpecificVolume eulerianDensity particlePosition label time)
      volume leftLabel rightLabel →
      (∫ label in leftLabel..rightLabel,
          lagrangianSpecificVolume eulerianDensity particlePosition label time) =
        particlePosition rightLabel time - particlePosition leftLabel time

end NumStability.Leveque02Tracer
