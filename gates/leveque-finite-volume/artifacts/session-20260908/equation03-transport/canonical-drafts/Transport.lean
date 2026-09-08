/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal

/-!
# Transport along linear advection characteristics

Arbitrary profiles are invariant along characteristics. Classical solvability
on the whole plane is equivalent to differentiability of the initial profile.
-/

namespace NumStability

/-- Translation along a characteristic preserves every profile, without regularity. -/
theorem travelingWave_characteristic_translate {E : Type*} (profile : ℝ → E)
    (speed x t h : ℝ) :
    travelingWave profile speed (x + speed * h) (t + h) =
      travelingWave profile speed x t := by
  unfold travelingWave
  congr 1
  ring

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The restriction to each characteristic is constant, even for nonsmooth profiles. -/
theorem travelingWave_hasDerivAt_characteristic (profile : ℝ → E)
    (speed x t : ℝ) :
    HasDerivAt (fun τ => travelingWave profile speed (x + speed * τ) τ) 0 t := by
  simpa only [travelingWave_at_translated_point] using hasDerivAt_const t (profile x)

/-- Classical solvability on the whole plane requires precisely differentiability
of the profile, because the spatial section at time zero is the profile itself. -/
theorem travelingWave_isLinearAdvectionSolution_iff (profile : ℝ → E) (speed : ℝ) :
    IsLinearAdvectionSolution (travelingWave profile speed) speed ↔
      Differentiable ℝ profile := by
  constructor
  · intro h x
    obtain ⟨qt, qx, _, hx, _⟩ := h x 0
    simpa only [travelingWave_zero] using hx.differentiableAt
  · exact travelingWave_isLinearAdvectionSolution speed

end NumStability
