/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.EulerianLagrangianCoordinatesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjective
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: EulerianLagrangianCoordinates

Mass-coordinate relations between Eulerian and particle labels.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

theorem eulerianLagrangianCoordinates : eulerianLagrangianCoordinatesTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro flow fixedSite label time
    refine ⟨rfl, rfl, ?_⟩
    simpa [particleVelocityAt, lagrangianParticleVelocity] using
      (flow.motion label time).deriv
  · intro initialDensity referenceLocation initialSite hintegrable hpositive
    exact ⟨(lagrangianMassLabelInjective initialDensity referenceLocation
      hintegrable hpositive).2, rfl⟩
  · intro initialDensity referenceLocation particlePosition initialSite label hinitial
    cases initialSite with
    | mk coordinate =>
      simp only [particleSite]
      congr 1

/-- The distinction is nonvacuous: a particle can leave a fixed Eulerian site
while its label remains the same. This is a smooth example, not a source claim
about a particular physical flow. -/
theorem movingParticleLeavesFixedSite :
    ∃ (particlePosition velocity : ℝ → ℝ → ℝ)
      (fixedSite : EulerianSite) (label : ParticleLabel),
      (particleSite particlePosition label 0) = fixedSite ∧
      (particleSite particlePosition label 1) ≠ fixedSite ∧
      HasDerivAt (fun τ => particlePosition label.mass τ)
        (particleVelocityAt velocity particlePosition label 1) 1 := by
  refine ⟨(fun mass time => mass + time), (fun _ _ => 1), ⟨0⟩, ⟨0⟩,
    ?_, ?_, ?_⟩
  · change EulerianSite.mk ((0 : ℝ) + 0) = EulerianSite.mk 0
    norm_num
  · intro h
    have hcoordinate := congrArg EulerianSite.coordinate h
    norm_num [particleSite] at hcoordinate
  · simpa [particleVelocityAt, lagrangianParticleVelocity] using
      (hasDerivAt_id (1 : ℝ))

/-- A mass-labeled particle can move through a fixed Eulerian site in a
globally smooth supplied flow, so the strengthened flow premise is inhabited. -/
theorem movingMassLabeledParticleFlow :
    ∃ (flow : LagrangianParticleFlow) (initialDensity : ℝ → ℝ)
      (fixedSite : EulerianSite),
      (∀ x, 0 < initialDensity x) ∧
      particleSite flow.position
        (labelOfInitialSite initialDensity 0 fixedSite) 0 = fixedSite ∧
      particleSite flow.position
        (labelOfInitialSite initialDensity 0 fixedSite) 1 ≠ fixedSite := by
  let flow : LagrangianParticleFlow :=
    ⟨(fun mass time => mass + time), (fun _ _ => 1), by
      intro label time
      simpa using (hasDerivAt_id time).const_add label.mass⟩
  let initialDensity : ℝ → ℝ := fun _ => 1
  let fixedSite : EulerianSite := ⟨0⟩
  refine ⟨flow, initialDensity, fixedSite, ?_, ?_, ?_⟩
  · intro x
    norm_num [initialDensity]
  · simp [flow, initialDensity, fixedSite, particleSite,
      labelOfInitialSite, lagrangianMassLabel]
  · intro h
    have hcoordinate := congrArg EulerianSite.coordinate h
    norm_num [flow, initialDensity, fixedSite, particleSite,
      labelOfInitialSite, lagrangianMassLabel] at hcoordinate

end NumStability.Leveque02Tracer
