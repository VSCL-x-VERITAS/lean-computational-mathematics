/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TracerMassModel

/-!
# Volumetric and linear tracer density in LeVeque Chapter 2

The paragraph preceding (2.1), printed page 15 (PDF page 37), defines linear
tracer density by multiplying volumetric tracer density by pipe area.
-/

namespace NumStability.Leveque02Tracer

/-- The density conversion on nonnegative physical input data. -/
def densityDefinitionTarget : Prop :=
  ∀ (volumetricDensity : ℝ → ℝ → ℝ) (area : ℝ → ℝ) (x t : ℝ),
    0 ≤ volumetricDensity x t → 0 ≤ area x →
      linearDensity volumetricDensity area x t = volumetricDensity x t * area x

end NumStability.Leveque02Tracer
