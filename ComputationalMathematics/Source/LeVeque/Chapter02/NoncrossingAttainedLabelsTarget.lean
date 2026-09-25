/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjective

/-!
# LeVeque Chapter 2: NoncrossingAttainedLabelsTarget

Target for noncrossing attained mass labels.
-/

open MeasureTheory
namespace NumStability.Leveque02Tracer

/-- Equation (2.103), restricted to labels attained from initial positions. -/
def IntervalIdentity (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianDensity : ℝ → ℝ → ℝ) (time : ℝ) : Prop :=
  ∀ a ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation),
    ∀ b ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation),
      (∫ η in a..b,
        lagrangianSpecificVolume eulerianDensity particlePosition η time) =
          particlePosition b time - particlePosition a time

/-- The mass-coordinate Jacobian on attained labels. -/
def MassCoordinateJacobian (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianDensity : ℝ → ℝ → ℝ) (time : ℝ) : Prop :=
  ∀ η ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation),
    HasDerivAt (fun ζ => particlePosition ζ time)
      (lagrangianSpecificVolume eulerianDensity particlePosition η time) η

/-- A repaired source target: on an open interval of attained mass labels, the
integral and Jacobian forms are equivalent under continuous specific volume;
either form prevents any two ordered particle labels from crossing. -/
def noncrossingAttainedLabelsTarget : Prop :=
  ∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
    (particlePosition eulerianVelocity eulerianDensity : ℝ → ℝ → ℝ)
    (timeDomain : Set ℝ),
    timeDomain.Nonempty → 0 ∈ timeDomain →
    (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
    (∀ x : ℝ, 0 < initialDensity x) →
    (∀ x : ℝ,
      particlePosition (lagrangianMassLabel initialDensity referenceLocation x) 0 = x) →
    (∀ t ∈ timeDomain,
      ∀ η ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation),
        HasDerivAt (fun τ => particlePosition η τ)
          (lagrangianParticleVelocity eulerianVelocity particlePosition η t) t) →
    (∀ t ∈ timeDomain,
      ∀ η ∈ Set.range (lagrangianMassLabel initialDensity referenceLocation),
        0 < eulerianDensity (particlePosition η t) t) →
    ∀ t ∈ timeDomain,
      ContinuousOn (fun η =>
        lagrangianSpecificVolume eulerianDensity particlePosition η t)
        (Set.range (lagrangianMassLabel initialDensity referenceLocation)) →
      (IntervalIdentity initialDensity referenceLocation particlePosition eulerianDensity t ↔
        MassCoordinateJacobian initialDensity referenceLocation particlePosition eulerianDensity t) ∧
      (IntervalIdentity initialDensity referenceLocation particlePosition eulerianDensity t →
        StrictMonoOn (fun η => particlePosition η t)
          (Set.range (lagrangianMassLabel initialDensity referenceLocation)))

end NumStability.Leveque02Tracer
