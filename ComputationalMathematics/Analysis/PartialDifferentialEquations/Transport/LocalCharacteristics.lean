/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.NonconservativeCharacteristics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection

/-!
# Local characteristic propagation for C1 advection fields

The existing nonconservative characteristic equality applies to a
constant signed velocity on any enclosed physical time segment.
Joint C1 regularity derives the actual partial derivatives; the
existing advection PDE witnesses identify their conservation relation.
No global forward domain or C-infinity reference is required.
-/

namespace NumStability
open Set LocalLinearAdvection

theorem local_linearAdvection_characteristic_eq_of_contDiffOn_one
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (spaceRegion timeRegion : Set ℝ)
    (speed x start finish : ℝ) (hstart : start ≤ finish)
    (hspace : IsOpen spaceRegion) (htime : IsOpen timeRegion)
    (hsmooth : ContDiffOn ℝ 1 (Function.uncurry q) (spaceRegion ×ˢ timeRegion))
    (hpde : ∀ y ∈ spaceRegion, ∀ τ ∈ timeRegion, IsLinearAdvectionSolutionAt q speed y τ)
    (hpath : ∀ τ ∈ Icc start finish,
      (x - speed * (finish - τ),τ) ∈ spaceRegion ×ˢ timeRegion) :
    q x finish = q (x - speed * (finish - start)) start := by
  let curve := fun τ => x - speed * finish + speed * τ
  have hcurve (τ : ℝ) : curve τ = x - speed * (finish - τ) := by dsimp [curve];ring
  have hinside (τ : ℝ) (hτ : τ ∈ Icc start finish) :
      (curve τ,τ) ∈ spaceRegion ×ˢ timeRegion := by
    simpa only [hcurve] using hpath τ hτ
  have hc : ContinuousOn (fun τ => q (curve τ) τ) (Icc start finish) :=
    hsmooth.continuousOn.comp
      ((continuous_const.add (continuous_const.mul continuous_id)).prodMk continuous_id).continuousOn
      hinside
  have h := nonconservativeTransport_characteristic_eq
    (q := q) (velocity := fun _ => speed) (curve := curve)
    (F := fun τ => fderiv ℝ (Function.uncurry q) (curve τ,τ))
    (qt := fun τ => qt q (curve τ) τ) (qx := fun τ => qx q (curve τ) τ)
    hstart hinside hc (fun τ hτ => ?_)
  · simpa [hcurve] using h
  · have hi := hinside τ (Ioo_subset_Icc_self hτ)
    have hd := (hsmooth.differentiableOn_one _ hi).differentiableAt
      ((hspace.prod htime).mem_nhds hi)
    have hqt := partial_time hd
    have hqx := partial_space hd
    rcases hpde _ hi.1 _ hi.2 with ⟨a,b,ha,hb,hzero⟩
    have hpde' : qt q (curve τ) τ + speed • qx q (curve τ) τ = 0 := by
      rw [hqt.unique ha,hqx.unique hb]
      exact hzero
    have hderiv : HasDerivAt curve speed τ := by
      simpa only [mul_one,zero_add] using
        (hasDerivAt_const τ (x-speed*finish)).add ((hasDerivAt_id τ).const_mul speed)
    exact ⟨hspace.uniqueDiffOn _ hi.1,htime.uniqueDiffOn _ hi.2,
      hd.hasFDerivAt.hasFDerivWithinAt,hqt.hasDerivWithinAt,hqx.hasDerivWithinAt,hderiv,hpde'⟩

end NumStability
