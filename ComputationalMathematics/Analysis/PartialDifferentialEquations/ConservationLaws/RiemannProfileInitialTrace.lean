/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainInitialTrace

/-!
# Initial traces from affine exterior states

Away from its initial interface, a profile with constant exterior states
outside affine fronts approaches its initial value as positive time tends
to zero. No separate continuity assumption on the profile is needed.
-/

open Filter
open scoped Topology
namespace NumStability

theorem riemannProfile_tendsto_initial_of_affine_fronts
    {E : Type*} [TopologicalSpace E] (field : ℝ → ℝ → E) (leftState rightState : E)
    (center leftSpeed rightSpeed horizon x : ℝ) (hhorizon : 0 < horizon) (hx : x ≠ center)
    (hleft : ∀ time ∈ Set.Icc 0 horizon,
      x < center + leftSpeed * time → field x time = leftState)
    (hright : ∀ time ∈ Set.Icc 0 horizon,
      center + rightSpeed * time < x → field x time = rightState) :
    Tendsto (field x) (𝓝[>] (0 : ℝ)) (𝓝 (field x 0)) := by
  have hid : Tendsto (fun time : ℝ => time) (𝓝[>] (0 : ℝ)) (𝓝 (0 : ℝ)) :=
    tendsto_id.mono_left nhdsWithin_le_nhds
  have htime : ∀ᶠ time in 𝓝[>] (0 : ℝ), time ∈ Set.Icc 0 horizon := Icc_mem_nhdsGT hhorizon
  rcases lt_or_gt_of_ne hx with hxl | hxr
  · have hfront : Tendsto (fun time : ℝ => center + leftSpeed * time)
        (𝓝[>] (0 : ℝ)) (𝓝 center) := by
      simpa using tendsto_const_nhds.add (tendsto_const_nhds.mul hid)
    have hnear := hfront.eventually (eventually_gt_nhds hxl)
    have hzero := hleft 0 ⟨le_refl _, hhorizon.le⟩ (by simpa using hxl)
    rw [hzero]
    apply tendsto_const_nhds.congr'
    filter_upwards [htime, hnear] with time ht hc
    exact (hleft time ht hc).symm
  · have hfront : Tendsto (fun time : ℝ => center + rightSpeed * time)
        (𝓝[>] (0 : ℝ)) (𝓝 center) := by
      simpa using tendsto_const_nhds.add (tendsto_const_nhds.mul hid)
    have hnear := hfront.eventually (eventually_lt_nhds hxr)
    have hzero := hright 0 ⟨le_refl _, hhorizon.le⟩ (by simpa using hxr)
    rw [hzero]
    apply tendsto_const_nhds.congr'
    filter_upwards [htime, hnear] with time ht hc
    exact (hright time ht hc).symm

end NumStability