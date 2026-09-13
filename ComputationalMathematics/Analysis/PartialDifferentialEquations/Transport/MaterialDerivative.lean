/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Material derivatives on physical domains

The derivative of a field along a particle curve is its time partial plus
particle velocity times its space partial. Actual coordinate derivatives are
identified through uniqueness on their physical domains.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- The material derivative is the actual derivative of a field along a particle curve. -/
theorem materialDerivative_hasDerivWithinAt
    {q : ℝ → ℝ → E} {velocity curve : ℝ → ℝ} {F : (ℝ × ℝ) →L[ℝ] E}
    {qt qx : E} {t : ℝ} {spaceDomain timeDomain characteristicTimes : Set ℝ}
    (htime : t ∈ characteristicTimes)
    (hcurveDomain : Set.MapsTo (fun τ => (curve τ, τ)) characteristicTimes
      (Set.prod spaceDomain timeDomain))
    (hspaceUnique : UniqueDiffWithinAt ℝ spaceDomain (curve t))
    (htimeUnique : UniqueDiffWithinAt ℝ timeDomain t)
    (hF : HasFDerivWithinAt (Function.uncurry q) F (Set.prod spaceDomain timeDomain)
      (curve t, t))
    (ht : HasDerivWithinAt (fun τ => q (curve t) τ) qt timeDomain t)
    (hx : HasDerivWithinAt (fun x => q x t) qx spaceDomain (curve t))
    (hcurve : HasDerivWithinAt curve (velocity (curve t)) characteristicTimes t) :
    HasDerivWithinAt (fun τ => q (curve τ) τ)
      (qt + velocity (curve t) • qx) characteristicTimes t := by
  have hpoint := hcurveDomain htime
  have hx' : HasDerivWithinAt (fun x => q x t) (F (1, 0)) spaceDomain (curve t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivWithinAt (f := fun x : ℝ => (x, t)) (curve t)
        (((hasDerivAt_id (curve t)).prodMk (hasDerivAt_const _ t)).hasDerivWithinAt)
        (fun _ hx => ⟨hx, hpoint.2⟩)
  have ht' : HasDerivWithinAt (fun τ => q (curve t) τ) (F (0, 1)) timeDomain t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivWithinAt (f := fun τ : ℝ => (curve t, τ)) t
        (((hasDerivAt_const t (curve t)).prodMk (hasDerivAt_id t)).hasDerivWithinAt)
        (fun _ hτ => ⟨hpoint.1, hτ⟩)
  have hpair : (velocity (curve t), (1 : ℝ)) =
      velocity (curve t) • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (velocity (curve t), 1) = qt + velocity (curve t) • qx := by
    rw [hpair, map_add, map_smul, hspaceUnique.eq_deriv _ hx' hx,
      htimeUnique.eq_deriv _ ht' ht, add_comm]
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivWithinAt (f := fun τ : ℝ => (curve τ, τ)) t
      (hcurve.prodMk (hasDerivAt_id t).hasDerivWithinAt) hcurveDomain

end NumStability
