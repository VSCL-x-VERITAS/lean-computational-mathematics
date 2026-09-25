/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Particle position, velocity and specific volume in Lagrangian coordinates

The particle-position map is supplied by a flow. The definitions below
evaluate Eulerian velocity and density at that particle's physical location.
-/

namespace NumStability.Leveque02Tracer

/-- Eulerian velocity sampled at the physical position of label `ξ`. -/
noncomputable def lagrangianParticleVelocity
    (eulerianVelocity particlePosition : ℝ → ℝ → ℝ) (label time : ℝ) : ℝ :=
  eulerianVelocity (particlePosition label time) time

/-- Specific volume of the particle with label `ξ`. The physical use of this
definition requires positive Eulerian density at the particle's position. -/
noncomputable def lagrangianSpecificVolume
    (eulerianDensity particlePosition : ℝ → ℝ → ℝ) (label time : ℝ) : ℝ :=
  1 / eulerianDensity (particlePosition label time) time

end NumStability.Leveque02Tracer
