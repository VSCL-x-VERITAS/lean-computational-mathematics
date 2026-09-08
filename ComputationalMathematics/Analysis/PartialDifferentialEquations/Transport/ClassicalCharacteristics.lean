/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvectionGlobal
import Mathlib.Analysis.Calculus.Deriv.Prod
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Classical transport along characteristics

For a jointly differentiable field, the advection PDE forces constancy along
each characteristic and determines the field from its initial profile.
The joint differentiability hypothesis is explicit.
-/

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

theorem linearAdvection_hasDerivAt_characteristic
    {q : ℝ → ℝ → E} {speed x t : ℝ}
    (hq : DifferentiableAt ℝ (Function.uncurry q) (x + speed * t, t))
    (hpde : IsLinearAdvectionSolutionAt q speed (x + speed * t) t) :
    HasDerivAt (fun τ => q (x + speed * τ) τ) 0 t := by
  let F := fderiv ℝ (Function.uncurry q) (x + speed * t, t)
  have hF : HasFDerivAt (Function.uncurry q) F (x + speed * t, t) := hq.hasFDerivAt
  rcases hpde with ⟨qt, qx, ht, hx, hzero⟩
  have hx' : HasDerivAt (fun ξ => q ξ t) (F (1, 0)) (x + speed * t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt (x + speed * t)
        ((hasDerivAt_id (x + speed * t)).prodMk (hasDerivAt_const _ t))
  have ht' : HasDerivAt (fun τ => q (x + speed * t) τ) (F (0, 1)) t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt t
        ((hasDerivAt_const t (x + speed * t)).prodMk (hasDerivAt_id t))
  have hpair : (speed, (1 : ℝ)) = speed • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (speed, 1) = 0 := by
    rw [hpair, map_add, map_smul, hx'.unique hx, ht'.unique ht]
    simpa only [add_comm] using hzero
  have hcurve : HasDerivAt (fun τ : ℝ => (x + speed * τ, τ)) (speed, 1) t := by
    convert ((hasDerivAt_const t x).add ((hasDerivAt_id t).const_mul speed)).prodMk
      (hasDerivAt_id t) using 1
    simp
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivAt (f := fun τ : ℝ => (x + speed * τ, τ)) t hcurve

theorem linearAdvection_eq_travelingWave_of_differentiable
    {q : ℝ → ℝ → E} {speed : ℝ}
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : IsLinearAdvectionSolution q speed) :
    q = travelingWave (fun x => q x 0) speed := by
  have hchar (x t : ℝ) : q (x + speed * t) t = q x 0 := by
    have hd (τ : ℝ) : HasDerivAt (fun r => q (x + speed * r) r) 0 τ :=
      linearAdvection_hasDerivAt_characteristic (hq _) (hpde _ _)
    simpa using is_const_of_deriv_eq_zero (fun τ => (hd τ).differentiableAt)
      (fun τ => (hd τ).deriv) t 0
  funext x t
  simpa [travelingWave] using hchar (x - speed * t) t

end NumStability
