/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelInjectiveTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianParticleMapModel

/-! Eulerian sites and Lagrangian particle labels have distinct coordinate roles. -/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- A fixed spatial observation site. -/
structure EulerianSite where
  /-- Spatial coordinate of the fixed observation site. -/
  coordinate : ℝ

/-- A mass coordinate labeling a moving particle. -/
structure ParticleLabel where
  /-- Mass coordinate associated with the particle label. -/
  mass : ℝ

/-- Label the particle initially at a physical Eulerian site by its initial mass. -/
noncomputable def labelOfInitialSite (initialDensity : ℝ → ℝ)
    (referenceLocation : ℝ) (site : EulerianSite) : ParticleLabel :=
  ⟨lagrangianMassLabel initialDensity referenceLocation site.coordinate⟩

/-- The physical Eulerian site occupied by a labeled particle at a given time.
The map is supplied, rather than inferred to exist. -/
def particleSite (particlePosition : ℝ → ℝ → ℝ)
    (label : ParticleLabel) (time : ℝ) : EulerianSite :=
  ⟨particlePosition label.mass time⟩

/-- Eulerian velocity at one fixed spatial site. -/
def eulerianVelocityAt (velocity : ℝ → ℝ → ℝ)
    (site : EulerianSite) (time : ℝ) : ℝ :=
  velocity site.coordinate time

/-- Lagrangian velocity follows the supplied particle-position map. -/
noncomputable def particleVelocityAt (velocity particlePosition : ℝ → ℝ → ℝ)
    (label : ParticleLabel) (time : ℝ) : ℝ :=
  lagrangianParticleVelocity velocity particlePosition label.mass time

/-- A supplied material flow whose trajectories satisfy the defining
Lagrangian motion equation. This does not assert existence for every velocity. -/
structure LagrangianParticleFlow where
  /-- Position of a particle label at a given time. -/
  position : ℝ → ℝ → ℝ
  /-- Velocity of a particle label at a given time. -/
  velocity : ℝ → ℝ → ℝ
  motion : ∀ (label : ParticleLabel) (time : ℝ),
    HasDerivAt (fun τ => position label.mass τ)
      (velocity (position label.mass time) time) time

/-- Proof-free coordinate target for the opening of Section 2.13. A fixed
Eulerian site is evaluated directly, while a Lagrangian label is first sent
through its supplied position map. This pullback identity needs no density
hypothesis. Positive initial density separately makes mass labels unique.
Initial compatibility and the trajectory equation are premises where used;
global existence of a flow is not asserted. -/
def eulerianLagrangianCoordinatesTarget : Prop :=
  (∀ (flow : LagrangianParticleFlow)
      (fixedSite : EulerianSite) (label : ParticleLabel) (time : ℝ),
      eulerianVelocityAt flow.velocity fixedSite time =
        flow.velocity fixedSite.coordinate time ∧
      particleVelocityAt flow.velocity flow.position label time =
        eulerianVelocityAt flow.velocity (particleSite flow.position label time) time ∧
      deriv (fun τ => flow.position label.mass τ) time =
        particleVelocityAt flow.velocity flow.position label time) ∧
  (∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
      (initialSite : EulerianSite),
      (∀ a b : ℝ, IntervalIntegrable initialDensity volume a b) →
      (∀ x : ℝ, 0 < initialDensity x) →
      Function.Injective (lagrangianMassLabel initialDensity referenceLocation) ∧
        (labelOfInitialSite initialDensity referenceLocation initialSite).mass =
          lagrangianMassLabel initialDensity referenceLocation initialSite.coordinate) ∧
  (∀ (initialDensity : ℝ → ℝ) (referenceLocation : ℝ)
      (particlePosition : ℝ → ℝ → ℝ) (initialSite : EulerianSite),
      let label := labelOfInitialSite initialDensity referenceLocation initialSite
      particlePosition label.mass 0 = initialSite.coordinate →
        particleSite particlePosition label 0 = initialSite)

end NumStability.Leveque02Tracer
