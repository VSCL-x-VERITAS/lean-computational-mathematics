/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionPhysicalStabilityTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionLpNecessity

/-!
# Quadratic refinement necessity for physical diffusion samples

The source-facing theorem proves the exact reviewed qualified target. A
positive continuity patch and actual locally uniform samples supply an
eventual positive face; actual unit-probe bounds in every standard norm then
force quadratic time-step refinement. Arbitrary finite ghost functions need
only satisfy the stated all-pairs stability premise, and an interior overlap
with the physical positive patch remains necessary for the finite argument.
-/

open Filter
open scoped Topology

namespace NumStability

/-- The selected physical interpretation of the explicit diffusion refinement
restriction, with the disclosed norm, sampling and finite-overlap qualifications. -/
theorem leveque04_explicitDiffusionPhysicalStability :
    leveque04_explicitDiffusionPhysicalStability_target := by
  constructor
  · intro p _ β horizon bound timeStep width origin diffusivity
      hβ hpositive hT hbound hw ht href htime hs hstable
    obtain ⟨x, hx⟩ := hpositive
    obtain ⟨c, hc, hsample⟩ := hs.wholeLine_positive (hβ.continuousAt) hx hw href
    refine ⟨bound / c, div_nonneg hbound hc.le, ?_⟩
    apply eventually_atTop.mp
    filter_upwards [hsample, hstable, htime.eventually_lt_const hT] with j hj hsj htj
    exact explicitDiffusion_quadratic_bound_of_face_bound (ht j).le (hw j) hc hj
      (explicitDiffusionLp_face_bound p (hw j) htj.le hsj _)
  · intro p _ β horizon bound timeStep width origin cells diffusivity leftGhost rightGhost
      hβ hpositive hT hbound hw ht href htime hs hstable
    obtain ⟨x, R, hx, hR, hcover⟩ := hpositive
    obtain ⟨c, hc, hsample⟩ :=
      hs.finite_interior_positive (hβ.continuousAt) hx hR hw href hcover
    refine ⟨bound / c, div_nonneg hbound hc.le, ?_⟩
    apply eventually_atTop.mp
    filter_upwards [hsample, hstable, htime.eventually_lt_const hT] with j hj hsj htj
    obtain ⟨i, hi0, hi1, hci⟩ := hj
    exact explicitDiffusion_quadratic_bound_of_face_bound (ht j).le (hw j) hc hci
      (explicitDiffusionFiniteLp_face_bound p (hw j) htj.le hsj i hi0 hi1)

end NumStability
