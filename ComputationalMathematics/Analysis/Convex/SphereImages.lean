/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Normed.Module.Convex
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Tactic.Linarith

/-!
# Linear images of spheres with a nonzero kernel

A real-linear map with a nonzero kernel has the same image on a sphere centered
at zero as on its closed ball, for every nonnegative radius. Each kernel fiber
through the ball meets the sphere by the intermediate value theorem applied to
its norm along a nonzero kernel direction. Consequently that sphere image is
convex. No finite dimension, completeness or continuity of the map is assumed.
-/

set_option autoImplicit false

namespace NumStability

variable {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
  [AddCommGroup F] [Module ℝ F]

private theorem exists_same_image_norm_eq (f : E →ₗ[ℝ] F)
    (k : E) (hk : k ≠ 0) (hfk : f k = 0) (r : ℝ) (hr : 0 ≤ r)
    (v : E) (hv : ‖v‖ ≤ r) :
    ∃ u : E, ‖u‖ = r ∧ f u = f v := by
  have hkn : 0 < ‖k‖ := norm_pos_iff.mpr hk
  let T : ℝ := (r + ‖v‖) / ‖k‖
  have hT : 0 ≤ T := div_nonneg (add_nonneg hr (norm_nonneg v)) hkn.le
  have hTk : T * ‖k‖ = r + ‖v‖ := div_mul_cancel₀ _ hkn.ne'
  have hnorm : ‖T • k‖ = r + ‖v‖ := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg hT, hTk]
  have hend : r ≤ ‖v + T • k‖ := by
    have htriangle : ‖T • k‖ ≤ ‖v + T • k‖ + ‖v‖ := by
      simpa only [add_sub_cancel_left] using norm_sub_le (v + T • k) v
    rw [hnorm] at htriangle
    linarith
  have hg : Continuous (fun t : ℝ => ‖v + t • k‖) :=
    (continuous_const.add (continuous_id.smul continuous_const)).norm
  have hstart : ‖v + (0 : ℝ) • k‖ ≤ r := by simpa using hv
  obtain ⟨t, _, ht⟩ := intermediate_value_Icc hT hg.continuousOn ⟨hstart, hend⟩
  refine ⟨v + t • k, ht, ?_⟩
  simp only [map_add, map_smul, hfk, smul_zero, add_zero]

/-- A nonzero kernel direction lets every image of a point in a closed ball
be attained on its sphere, including at radius zero. -/
theorem linearMap_image_sphere_eq_image_closedBall (f : E →ₗ[ℝ] F)
    (hker : ∃ k : E, k ≠ 0 ∧ f k = 0) (r : ℝ) (hr : 0 ≤ r) :
    f '' Metric.sphere (0 : E) r = f '' Metric.closedBall (0 : E) r := by
  rcases hker with ⟨k, hk, hfk⟩
  apply Set.Subset.antisymm
  · exact Set.image_mono Metric.sphere_subset_closedBall
  · rintro z ⟨v, hv, rfl⟩
    have hv' : ‖v‖ ≤ r := by simpa only [Metric.mem_closedBall, dist_zero_right] using hv
    obtain ⟨u, hu, hfu⟩ := exists_same_image_norm_eq f k hk hfk r hr v hv'
    exact ⟨u, by simpa only [Metric.mem_sphere, dist_zero_right] using hu, hfu⟩

/-- The image of a sphere under a real-linear map with a nonzero kernel is
convex, even though the sphere itself generally is not. -/
theorem convex_linearMap_image_sphere (f : E →ₗ[ℝ] F)
    (hker : ∃ k : E, k ≠ 0 ∧ f k = 0) (r : ℝ) (hr : 0 ≤ r) :
    Convex ℝ (f '' Metric.sphere (0 : E) r) := by
  rw [linearMap_image_sphere_eq_image_closedBall f hker r hr]
  exact (convex_closedBall (0 : E) r).linear_image f

end NumStability
