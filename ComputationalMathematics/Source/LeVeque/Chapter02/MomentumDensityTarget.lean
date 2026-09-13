/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumModel

/-!
# Momentum density and section momentum

The source definition identifies the signed momentum density and its section
integral. The ordered section, positive fluid density and integrability make
the integral's physical interpretation explicit.
-/

namespace NumStability.Leveque02Tracer

/-- The local and integrated momentum quantities in Section 2.6. -/
def momentumDensityTarget : Prop :=
  (∀ (density velocity : ℝ → ℝ → ℝ) (x t : ℝ),
    fluidMomentumDensity density velocity x t = density x t * velocity x t) ∧
  (∀ (density velocity : ℝ → ℝ → ℝ) (a b t : ℝ),
    a ≤ b → (∀ x ∈ Set.Icc a b, 0 < density x t) →
    IntervalIntegrable (fun x => density x t * velocity x t) MeasureTheory.volume a b →
    fluidSectionMomentum density velocity a b t =
      ∫ x in a..b, density x t * velocity x t)

end NumStability.Leveque02Tracer
