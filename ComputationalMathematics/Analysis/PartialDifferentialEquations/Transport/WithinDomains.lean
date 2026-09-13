/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Linear advection on relative domains

Compatible spatial and temporal slices of a translated profile have derivative
witnesses satisfying the advection equation. Derivatives are taken within the
specified sets. No uniqueness of derivative values on arbitrary sets is asserted.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Selected partial derivative witnesses satisfy advection on relative slices. -/
def IsLinearAdvectionSolutionWithinAt (q : ℝ → ℝ → E) (speed x t : ℝ)
    (spaceDomain timeDomain : Set ℝ) : Prop :=
  ∃ qt qx : E,
    HasDerivWithinAt (fun τ => q x τ) qt timeDomain t ∧
    HasDerivWithinAt (fun ξ => q ξ t) qx spaceDomain x ∧
    qt + speed • qx = 0

/-- A profile derivative gives advection witnesses on compatible relative domains. -/
theorem travelingWave_isLinearAdvectionSolutionWithinAt
    {profile : ℝ → E} {profileDerivative : E} (speed x t : ℝ)
    (spaceDomain timeDomain profileDomain : Set ℝ)
    (hspace : Set.MapsTo (fun ξ => ξ - speed * t) spaceDomain profileDomain)
    (htime : Set.MapsTo (fun τ => x - speed * τ) timeDomain profileDomain)
    (hprofile : HasDerivWithinAt profile profileDerivative profileDomain (x - speed * t)) :
    IsLinearAdvectionSolutionWithinAt (travelingWave profile speed) speed x t
      spaceDomain timeDomain := by
  refine ⟨(-speed) • profileDerivative, profileDerivative, ?_, ?_, ?_⟩
  · have ht : HasDerivAt (fun τ : ℝ => x - speed * τ) (-speed) t := by
      simpa using (hasDerivAt_const t x).sub ((hasDerivAt_id t).const_mul speed)
    simpa only [travelingWave, Function.comp_def] using
      hprofile.scomp t ht.hasDerivWithinAt htime
  · have hx : HasDerivAt (fun ξ : ℝ => ξ - speed * t) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * t)
    simpa only [travelingWave, Function.comp_def, one_smul] using
      hprofile.scomp x hx.hasDerivWithinAt hspace
  · simp

end NumStability
