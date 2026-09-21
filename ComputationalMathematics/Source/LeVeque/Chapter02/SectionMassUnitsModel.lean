/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Equation01

/-!
# Unit-tagged section mass for LeVeque Chapter 2

These transparent wrappers distinguish a one-dimensional mass density from the
mass produced by spatial integration. Their stored values use the real-valued
coordinates of the existing equation (2.1) implementation.
-/

namespace NumStability.Leveque02Tracer

/-- A scalar chemical-tracer density measured as mass per unit pipe length. -/
inductive LinearMassDensity where
  | ofReal (value : ℝ)

/-- A scalar total mass of chemical tracer. -/
inductive TracerMass where
  | ofReal (value : ℝ)

/-- The real coordinate stored by a unit-tagged linear density. -/
def linearMassDensityValue : LinearMassDensity → ℝ
  | .ofReal value => value

/-- Integrate a unit-tagged linear density over a fixed pipe section. -/
noncomputable def sectionMassFromLinearDensity
    (q : ℝ → ℝ → LinearMassDensity) (x₁ x₂ t : ℝ) : TracerMass :=
  .ofReal <| NumStability.leveque02Equation01SectionMass
    (fun x time ↦ linearMassDensityValue (q x time)) x₁ x₂ t

end NumStability.Leveque02Tracer
