/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.GaussianHeatFlowIntegrals
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdmissibleDomainNecessity

/-!
# Whole-line influence for Gaussian heat flow

Every open neighborhood contains a smooth compactly supported perturbation
whose Gaussian evolution is positive at every positive-time observation.
The admissible initial-data class is the full bounded continuous class.
-/

namespace NumStability

open Filter MeasureTheory Set
open scoped Topology ContDiff

theorem exists_gaussianHeatFlow_localized_profile
    (diffusion observation time location radius : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) (hradius : 0 < radius) :
    ∃ profile : BoundedContinuousFunction ℝ ℝ,
      ContDiff ℝ ∞ (profile : ℝ → ℝ) ∧
      HasCompactSupport (profile : ℝ → ℝ) ∧
      (∀ z : ℝ, 0 ≤ profile z ∧ profile z ≤ 1) ∧
      profile location = 1 ∧
      tsupport (profile : ℝ → ℝ) ⊆ Metric.ball location radius ∧
      gaussianHeatFlow diffusion (fun _ : ℝ => 0) observation time = 0 ∧
      0 < gaussianHeatFlow diffusion profile observation time := by
  obtain ⟨f, hsupport, hcompact, hsmooth, hbounds, hcenter⟩ :=
    exists_contDiff_tsupport_subset (n := (⊤ : ℕ∞)) (Metric.ball_mem_nhds location hradius)
  have hpointwise : ∀ z : ℝ, 0 ≤ f z ∧ f z ≤ 1 := by
    intro z
    exact hbounds ⟨z, rfl⟩
  have hnorm : ∀ z : ℝ, ‖f z‖ ≤ 1 := by
    intro z
    rw [Real.norm_of_nonneg (hpointwise z).1]
    exact (hpointwise z).2
  let profile : BoundedContinuousFunction ℝ ℝ :=
    BoundedContinuousFunction.ofNormedAddCommGroup f hsmooth.continuous 1 hnorm
  refine ⟨profile, hsmooth, hcompact, hpointwise, hcenter, hsupport,
    gaussianHeatFlow_zero diffusion observation time, ?_⟩
  apply gaussianHeatFlow_pos diffusion observation time location profile hdiffusion htime
    (fun z => (hpointwise z).1)
  change 0 < f location
  rw [hcenter]
  norm_num

theorem gaussianHeatFlow_essentialPointOnClass
    (diffusion observation time location : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    IsEssentialPointOnClass IsBoundedContinuousHeatData
      (fun initial : ℝ → ℝ => gaussianHeatFlow diffusion initial observation time) location := by
  intro radius hradius
  obtain ⟨profile, _, _, _, _, hsupport, hzero, hpositive⟩ :=
    exists_gaussianHeatFlow_localized_profile diffusion observation time location radius
      hdiffusion htime hradius
  refine ⟨(fun _ : ℝ => 0), (profile : ℝ → ℝ), ⟨0, rfl⟩, ⟨profile, rfl⟩, ?_, ?_⟩
  · intro z hz
    have hout : z ∉ tsupport (profile : ℝ → ℝ) := fun h => hz (hsupport h)
    exact (image_eq_zero_of_notMem_tsupport hout).symm
  · change gaussianHeatFlow diffusion (fun _ : ℝ => 0) observation time ≠
      gaussianHeatFlow diffusion profile observation time
    rw [hzero]
    exact ne_of_lt hpositive

theorem gaussianHeatFlow_essentialSet_eq_univ
    (diffusion observation time : ℝ)
    (hdiffusion : 0 < diffusion) (htime : 0 < time) :
    {location : ℝ | IsEssentialPointOnClass IsBoundedContinuousHeatData
      (fun initial : ℝ → ℝ => gaussianHeatFlow diffusion initial observation time) location} =
      Set.univ := by
  apply Set.eq_univ_of_forall
  intro location
  exact gaussianHeatFlow_essentialPointOnClass diffusion observation time location hdiffusion htime

end NumStability
