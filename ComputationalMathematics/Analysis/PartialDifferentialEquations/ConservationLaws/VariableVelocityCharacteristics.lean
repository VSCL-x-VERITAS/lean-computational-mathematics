/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# Conservative transport along variable-velocity characteristics

Actual partial and curve derivatives determine the field's material rate.
Physical coordinate domains have unique derivatives; the characteristic is
required to remain in those domains.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- A conservative field changes along a particle at minus velocity divergence times its value. -/
theorem conservativeTransport_hasDerivWithinAt_characteristic
    {q : ℝ → ℝ → E} {velocity curve : ℝ → ℝ}
    {F : (ℝ × ℝ) →L[ℝ] E} {velocityDerivative t : ℝ}
    {spaceDomain timeDomain characteristicTimes : Set ℝ}
    (htime : t ∈ characteristicTimes)
    (hcurveDomain : Set.MapsTo (fun τ => (curve τ, τ)) characteristicTimes
      (Set.prod spaceDomain timeDomain))
    (hspaceUnique : UniqueDiffWithinAt ℝ spaceDomain (curve t))
    (htimeUnique : UniqueDiffWithinAt ℝ timeDomain t)
    (hF : HasFDerivWithinAt (Function.uncurry q) F (Set.prod spaceDomain timeDomain)
      (curve t, t))
    (hvelocity : HasDerivWithinAt velocity velocityDerivative spaceDomain (curve t))
    (hcurve : HasDerivWithinAt curve (velocity (curve t)) characteristicTimes t)
    (hpde : ∃ timeDerivative fluxDerivative : E,
      HasDerivWithinAt (fun τ => q (curve t) τ) timeDerivative timeDomain t ∧
      HasDerivWithinAt (fun x => velocity x • q x t) fluxDerivative spaceDomain (curve t) ∧
      timeDerivative + fluxDerivative = 0) :
    HasDerivWithinAt (fun τ => q (curve τ) τ)
      (-(velocityDerivative • q (curve t) t)) characteristicTimes t := by
  have hpoint := hcurveDomain htime
  rcases hpde with ⟨qt, fluxDerivative, ht, hflux, hzero⟩
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
  have hflux' : HasDerivWithinAt (fun x => velocity x • q x t)
      (velocity (curve t) • F (1, 0) + velocityDerivative • q (curve t) t)
      spaceDomain (curve t) := hvelocity.smul hx'
  have hresidual : F (0, 1) +
      (velocity (curve t) • F (1, 0) + velocityDerivative • q (curve t) t) = 0 := by
    rw [hspaceUnique.eq_deriv _ hflux' hflux, htimeUnique.eq_deriv _ ht' ht]
    exact hzero
  have hpair : (velocity (curve t), (1 : ℝ)) =
      velocity (curve t) • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (velocity (curve t), 1) = -(velocityDerivative • q (curve t) t) := by
    rw [hpair, map_add, map_smul]
    apply eq_neg_of_add_eq_zero_left
    simpa only [add_assoc, add_left_comm, add_comm] using hresidual
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivWithinAt (f := fun τ : ℝ => (curve τ, τ)) t
      (hcurve.prodMk (hasDerivAt_id t).hasDerivWithinAt) hcurveDomain

end NumStability
