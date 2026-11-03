/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Inverse
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.BoundedVariation
import Mathlib.Topology.Order.LeftRightNhds
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic

/-!
# Derivatives on real fibers and affine contact sets

A real fiber has at most countably many points isolated on its right. At every
other point the function repeatedly takes its fiber value in punctured
neighborhoods, so its total derivative is zero. Applied to a Lipschitz function
minus an affine function, this identifies derivatives almost everywhere on the
set where the functions agree; the agreement set need not be open.
-/

noncomputable section
open Set Filter MeasureTheory
open scoped Topology NNReal

namespace NumStability

theorem deriv_eq_zero_ae_on_fiber (f : ℝ → ℝ) (c : ℝ) :
    ∀ᵐ x : ℝ, f x = c → deriv f x = 0 := by
  let S : Set ℝ := {x | f x = c}
  have hcount : {x ∈ S | 𝓝[S ∩ Ioi x] x = ⊥}.Countable :=
    countable_setOf_isolated_right_within
  filter_upwards [hcount.ae_notMem volume] with x hx
  intro hfx
  have hne : 𝓝[S ∩ Ioi x] x ≠ ⊥ := fun hbot => hx ⟨hfx, hbot⟩
  haveI : NeBot (𝓝[S ∩ Ioi x] x) := Filter.neBot_iff.mpr hne
  have hsub : S ∩ Ioi x ⊆ S \ {x} := by
    intro y hy
    exact ⟨hy.1, (ne_of_gt hy.2)⟩
  have hacc : AccPt x (𝓟 S) := accPt_principal_iff_nhdsWithin.mpr
    (Filter.neBot_of_le (nhdsWithin_mono x hsub))
  exact deriv_zero_of_frequently_const (accPt_iff_frequently_nhdsNE.mp hacc)

theorem lipschitz_deriv_eq_slope_ae_of_eq_affine (f : ℝ → ℝ) {C : ℝ≥0}
    (hf : LipschitzWith C f) (a q : ℝ) :
    ∀ᵐ t : ℝ, f t = a + q * t → deriv f t = q := by
  filter_upwards [deriv_eq_zero_ae_on_fiber (fun t => f t - (a + q * t)) 0,
    hf.ae_differentiableAt_real] with t hzero hdiff
  intro heq
  have hz := hzero (by rw [heq]; exact sub_self _)
  have hlin : HasDerivAt (fun s : ℝ => a + q * s) q t := by
    simpa only [id_eq, mul_one] using (((hasDerivAt_id t).const_mul q).const_add a)
  have hd : HasDerivAt (fun s => f s - (a + q * s)) (deriv f t - q) t :=
    hdiff.hasDerivAt.sub hlin
  rw [hd.deriv] at hz
  linarith

end NumStability
