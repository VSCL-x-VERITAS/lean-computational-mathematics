/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# LeVeque Chapter 2, Equation (2.1)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 2,
printed page 15 (PDF page 37), introduces the mass in a pipe segment as the
spatial integral of the tracer density at a fixed time. The density is measured
as mass per unit length, after multiplication by cross-sectional area when
starting from volumetric density.

This module records that definition. It does not assert conservation in time
or characterize physical mass through abstract properties of an integral.

The definition uses Mathlib's oriented interval integral. Its physical reading
uses ordered endpoints and an integrable, nonnegative density. Reversed
endpoints give a signed quantity; Mathlib's totalized value on a nonintegrable
density is not a physical mass. The identity below only unfolds the definition.
-/

namespace NumStability

/-- The oriented spatial integral in LeVeque (2.1), at a fixed time. -/
noncomputable def leveque02Equation01SectionMass
    (q : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ) : ℝ :=
  ∫ x in x₁..x₂, q x t

/-- The defining formula (2.1); this is a notation correspondence. -/
theorem leveque02_equation01_eq_intervalIntegral
    (q : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ) :
    leveque02Equation01SectionMass q x₁ x₂ t = ∫ x in x₁..x₂, q x t := rfl

end NumStability
