/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Characteristic derivatives on relative domains

A joint derivative and the advection equation determine the actual derivative
along a compatible characteristic. Unique differentiability of the coordinate
slices identifies the partial derivative witnesses with the joint derivative.
The characteristic-time set itself need not have unique derivatives.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A differentiable advection field has zero derivative along a compatible characteristic. -/
theorem linearAdvection_hasDerivWithinAt_characteristic
    {q : ℝ → ℝ → E} {F : (ℝ × ℝ) →L[ℝ] E} {speed origin t : ℝ}
    {spaceDomain timeDomain characteristicTimes : Set ℝ}
    (htime : t ∈ characteristicTimes)
    (hcurveDomain : Set.MapsTo (fun τ => (origin + speed * τ, τ)) characteristicTimes
      (Set.prod spaceDomain timeDomain))
    (hspaceUnique : UniqueDiffWithinAt ℝ spaceDomain (origin + speed * t))
    (htimeUnique : UniqueDiffWithinAt ℝ timeDomain t)
    (hF : HasFDerivWithinAt (Function.uncurry q) F (Set.prod spaceDomain timeDomain)
      (origin + speed * t, t))
    (hpde : IsLinearAdvectionSolutionWithinAt q speed (origin + speed * t) t
      spaceDomain timeDomain) :
    HasDerivWithinAt (fun τ => q (origin + speed * τ) τ) 0 characteristicTimes t := by
  have hpoint := hcurveDomain htime
  rcases hpde with ⟨qt, qx, ht, hx, hzero⟩
  have hx' : HasDerivWithinAt (fun ξ => q ξ t) (F (1, 0))
      spaceDomain (origin + speed * t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivWithinAt (f := fun ξ : ℝ => (ξ, t)) (origin + speed * t)
        (((hasDerivAt_id (origin + speed * t)).prodMk
          (hasDerivAt_const _ t)).hasDerivWithinAt)
        (fun _ hξ => ⟨hξ, hpoint.2⟩)
  have ht' : HasDerivWithinAt (fun τ => q (origin + speed * t) τ) (F (0, 1))
      timeDomain t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivWithinAt (f := fun τ : ℝ => (origin + speed * t, τ)) t
        (((hasDerivAt_const t (origin + speed * t)).prodMk
          (hasDerivAt_id t)).hasDerivWithinAt)
        (fun _ hτ => ⟨hpoint.1, hτ⟩)
  have hpair : (speed, (1 : ℝ)) = speed • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (speed, 1) = 0 := by
    rw [hpair, map_add, map_smul, hspaceUnique.eq_deriv _ hx' hx,
      htimeUnique.eq_deriv _ ht' ht]
    simpa only [add_comm] using hzero
  have hcurve : HasDerivAt (fun τ : ℝ => (origin + speed * τ, τ)) (speed, 1) t := by
    convert ((hasDerivAt_const t origin).add ((hasDerivAt_id t).const_mul speed)).prodMk
      (hasDerivAt_id t) using 1
    simp
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivWithinAt (f := fun τ : ℝ => (origin + speed * τ, τ)) t
      hcurve.hasDerivWithinAt hcurveDomain

end NumStability
