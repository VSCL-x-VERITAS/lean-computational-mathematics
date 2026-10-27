/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedInteriorDerivativeBudgets

/-!
# Spatial derivatives through closed physical time endpoints

Closed physical C2 regularity derives the actual derivative of every spatial
slice in the spatial interior, including the initial and final physical
times. The physical within derivative supplies this value. Its continuity
then gives continuity of the actual scalar spatial derivative on the closed
time rectangle, without differentiability of a nonphysical time extension.
-/

namespace NumStability
open Set

theorem contDiffOn_two_closedRectangle_spatial_hasDerivAt
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (L R start finish x t : ℝ)
    (hx : x ∈ Ioo L R) (ht : t ∈ Icc start finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc start finish)) :
    HasDerivAt (fun ξ => q ξ t)
      (fderivWithin ℝ (Function.uncurry q) (Icc L R ×ˢ Icc start finish) (x,t) (1,0)) x := by
  have hd := (hq.of_le (m := 1) (by norm_num)).differentiableOn_one
    (x,t) ⟨Ioo_subset_Icc_self hx,ht⟩
  have hcurve : HasDerivWithinAt (fun ξ : ℝ => (ξ,t)) (1,0) (Ioo L R) x :=
    ((hasDerivAt_id x).prodMk (hasDerivAt_const x t)).hasDerivWithinAt
  have hmaps : MapsTo (fun ξ : ℝ => (ξ,t)) (Ioo L R) (Icc L R ×ˢ Icc start finish) :=
    fun ξ hξ => ⟨Ioo_subset_Icc_self hξ,ht⟩
  have h := hd.hasFDerivWithinAt.comp_hasDerivWithinAt x hcurve
    hmaps
  exact h.hasDerivAt (isOpen_Ioo.mem_nhds hx)

theorem contDiffOn_two_closedRectangle_spatial_derivative_continuousOn
    (q : ℝ → ℝ → ℝ) (L R start finish : ℝ)
    (hLR : L < R) (htime : start < finish)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc start finish)) :
    ContinuousOn (fun p : ℝ × ℝ => deriv (fun ξ => q ξ p.2) p.1)
      (Ioo L R ×ˢ Icc start finish) := by
  let box := Icc L R ×ˢ Icc start finish
  have hD := hq.fderivWithin
    ((uniqueDiffOn_Icc hLR).prod (uniqueDiffOn_Icc htime)) (m := 1) (by norm_num)
  have hc : ContinuousOn
      (fun p => fderivWithin ℝ (Function.uncurry q) box p (1,0)) box :=
    hD.continuousOn.clm_apply continuousOn_const
  apply (hc.mono (prod_mono Ioo_subset_Icc_self (Subset.refl _))).congr
  intro p hp
  exact (contDiffOn_two_closedRectangle_spatial_hasDerivAt q L R start finish
    p.1 p.2 hp.1 hp.2 hq).deriv

end NumStability
