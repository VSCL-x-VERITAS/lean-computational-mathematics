/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumDensityTarget

/-!
# Momentum density and section momentum

The source-facing theorem exposes the pointwise momentum density and its
fixed-time spatial integral. The interval hypotheses delimit the physical
interpretation; both equalities follow from the audited definitions.
-/

namespace NumStability.Leveque02Tracer

/-- Momentum per unit length is density times signed velocity, and section
momentum is the spatial integral of that density. -/
theorem momentumDensity : momentumDensityTarget := by
  constructor
  · intro density velocity x t
    rfl
  · intro density velocity a b t _ _
    rfl

end NumStability.Leveque02Tracer
