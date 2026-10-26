/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.LocalCharacteristics

/-!
# Local characteristics including closed time endpoints

Joint continuity on the physical closed time domain and C1 regularity
and the actual advection PDE only inside it propagate the field
through the endpoints. The resolved nonconservative transport theorem
requires derivatives only in the interior of the selected segment.
No extension of the supplied field outside physical time is assumed.
-/

namespace NumStability
open Set LocalLinearAdvection

theorem local_linearAdvection_characteristic_eq_on_closedTime
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (q : ℝ → ℝ → E) (spaceRegion : Set ℝ)
    (beginTime endTime speed x start finish : ℝ)
    (hstart : start ≤ finish) (hbegin : beginTime ≤ start) (hend : finish ≤ endTime)
    (hspace : IsOpen spaceRegion)
    (hcontinuous : ContinuousOn (Function.uncurry q) (spaceRegion ×ˢ Icc beginTime endTime))
    (hsmooth : ContDiffOn ℝ 1 (Function.uncurry q) (spaceRegion ×ˢ Ioo beginTime endTime))
    (hpde : ∀ y ∈ spaceRegion, ∀ τ ∈ Ioo beginTime endTime,
      IsLinearAdvectionSolutionAt q speed y τ)
    (hpath : ∀ τ ∈ Icc start finish,
      (x-speed*(finish-τ),τ) ∈ spaceRegion ×ˢ Icc beginTime endTime) :
    q x finish = q (x-speed*(finish-start)) start := by
  let curve := fun τ => x-speed*finish+speed*τ
  have hcurve (τ : ℝ) : curve τ = x-speed*(finish-τ) := by dsimp [curve];ring
  have hinside (τ : ℝ) (hτ : τ ∈ Icc start finish) :
      (curve τ,τ) ∈ spaceRegion ×ˢ Icc beginTime endTime := by
    simpa only [hcurve] using hpath τ hτ
  have hc : ContinuousOn (fun τ => q (curve τ) τ) (Icc start finish) :=
    hcontinuous.comp
      ((continuous_const.add (continuous_const.mul continuous_id)).prodMk continuous_id).continuousOn
      hinside
  have h := nonconservativeTransport_characteristic_eq
    (q := q) (velocity := fun _ => speed) (curve := curve)
    (F := fun τ => fderiv ℝ (Function.uncurry q) (curve τ,τ))
    (qt := fun τ => qt q (curve τ) τ) (qx := fun τ => qx q (curve τ) τ)
    hstart hinside hc (fun τ hτ => ?_)
  · simpa [hcurve] using h
  · have hi := hinside τ (Ioo_subset_Icc_self hτ)
    have ht : τ ∈ Ioo beginTime endTime := by
      constructor <;> linarith [hτ.1,hτ.2]
    have hd := (hsmooth.differentiableOn_one _ ⟨hi.1,ht⟩).differentiableAt
      ((hspace.prod isOpen_Ioo).mem_nhds ⟨hi.1,ht⟩)
    have hqt := partial_time hd
    have hqx := partial_space hd
    rcases hpde _ hi.1 _ ht with ⟨a,b,ha,hb,hzero⟩
    have hpde' : qt q (curve τ) τ + speed • qx q (curve τ) τ = 0 := by
      rw [hqt.unique ha,hqx.unique hb]
      exact hzero
    have hderiv : HasDerivAt curve speed τ := by
      simpa only [mul_one,zero_add] using
        (hasDerivAt_const τ (x-speed*finish)).add ((hasDerivAt_id τ).const_mul speed)
    exact ⟨hspace.uniqueDiffOn _ hi.1,
      uniqueDiffWithinAt_of_mem_nhds (Icc_mem_nhds ht.1 ht.2),
      hd.hasFDerivAt.hasFDerivWithinAt,hqt.hasDerivWithinAt,hqx.hasDerivWithinAt,hderiv,hpde'⟩

end NumStability
