/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.SectionMassUnitsModel

/-!
# Proof-free unit-aware target for LeVeque equation (2.1)
-/

namespace NumStability.Leveque02Tracer

/-- The unit-aware fixed-time section-mass interpretation of equation (2.1). -/
def sectionMassFromLinearDensityTarget : Prop :=
  ∀ (q : ℝ → ℝ → LinearMassDensity) (x₁ x₂ t : ℝ),
    x₁ < x₂ →
    IntervalIntegrable (fun x ↦ linearMassDensityValue (q x t))
      MeasureTheory.volume x₁ x₂ →
    sectionMassFromLinearDensity q x₁ x₂ t =
      TracerMass.ofReal (∫ x in x₁..x₂, linearMassDensityValue (q x t))

end NumStability.Leveque02Tracer
