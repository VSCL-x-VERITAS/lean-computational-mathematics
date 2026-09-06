/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Constant-coefficient linear advection

Source-independent local solution predicates and traveling-wave solutions for
`q_t + a q_x = 0`, for profiles valued in a real normed vector space.
-/

namespace NumStability

/-- A profile translated at constant speed. -/
def travelingWave {E : Type*} (profile : ℝ → E) (speed x t : ℝ) : E :=
  profile (x - speed * t)

/-- The translated profile agrees with the original profile at time zero. -/
@[simp] theorem travelingWave_zero {E : Type*}
    (profile : ℝ → E) (speed x : ℝ) :
    travelingWave profile speed x 0 = profile x := by
  simp [travelingWave]

/-- The value initially at `x` is at `x + speed * t` at time `t`. -/
theorem travelingWave_at_translated_point {E : Type*}
    (profile : ℝ → E) (speed x t : ℝ) :
    travelingWave profile speed (x + speed * t) t = profile x := by
  simp [travelingWave]

section LinearAdvection

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A function satisfies `q_t + speed q_x = 0` at a point. -/
def IsLinearAdvectionSolutionAt
    (q : ℝ → ℝ → E) (speed x t : ℝ) : Prop :=
  ∃ qt qx : E,
    HasDerivAt (fun τ => q x τ) qt t ∧
      HasDerivAt (fun ξ => q ξ t) qx x ∧
        qt + speed • qx = 0

/-- Every differentiable translated profile solves linear advection at the
corresponding point. -/
theorem travelingWave_isLinearAdvectionSolutionAt
    {profile : ℝ → E} {profile' : E} (speed x t : ℝ)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsLinearAdvectionSolutionAt
      (travelingWave profile speed) speed x t := by
  refine ⟨(-speed) • profile', profile', ?_, ?_, ?_⟩
  · have ht : HasDerivAt (fun τ : ℝ => x - speed * τ) (-speed) t := by
      simpa using
        (hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul speed)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp t ht
  · have hx : HasDerivAt (fun ξ : ℝ => ξ - speed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * t)
    simpa [travelingWave, Function.comp_def] using hprofile.scomp x hx
  · simp

end LinearAdvection

end NumStability
