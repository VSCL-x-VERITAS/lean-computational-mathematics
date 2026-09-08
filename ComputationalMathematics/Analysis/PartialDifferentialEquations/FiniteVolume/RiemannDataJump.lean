/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import ComputationalMathematics.Topology.Order.Jump

/-!
# Jumps of Riemann data

Distinct constant-side data has a jump at zero. The origin value remains free.
-/

namespace NumStability

/-- The existing one-sided Riemann limits give a jump when the states differ. -/
theorem IsRiemannData.hasJumpAt {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {left right : E}
    (h : IsRiemannData data left right) (hne : left ≠ right) :
    HasJumpAt data 0 left right :=
  ⟨h.tendsto_left, h.tendsto_right, hne⟩

end NumStability
