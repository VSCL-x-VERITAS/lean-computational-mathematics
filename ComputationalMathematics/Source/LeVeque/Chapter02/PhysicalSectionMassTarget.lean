/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassUnitsTarget

/-!
# Physical domain for LeVeque Chapter 2, equation (2.1)

The source identifies the integral of tracer mass per unit length with total
mass in an ordered section of pipe at a fixed time. This target makes the
nonnegative density and finite-integral conditions of that physical reading
explicit, while taking the one-dimensional density directly as the input.
-/

namespace NumStability.Leveque02Tracer

/-- The mass formula (2.1) on an ordered segment with a nonnegative,
integrable linear tracer density. -/
def physicalSectionMassTarget : Prop :=
  ∀ (q : ℝ → ℝ → LinearMassDensity) (x₁ x₂ t : ℝ),
    x₁ < x₂ →
    (∀ x ∈ Set.Icc x₁ x₂, 0 ≤ linearMassDensityValue (q x t)) →
    IntervalIntegrable (fun x ↦ linearMassDensityValue (q x t))
      MeasureTheory.volume x₁ x₂ →
    sectionMassFromLinearDensity q x₁ x₂ t =
      TracerMass.ofReal (∫ x in x₁..x₂, linearMassDensityValue (q x t))

end NumStability.Leveque02Tracer
