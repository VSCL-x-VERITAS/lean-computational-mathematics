/-
SPDX-License-Identifier: MIT
-/

import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.Data.Set.Finite.Basic

/-!
# Fixed-face intersections with moving fronts

A front moving with nonzero constant speed meets a fixed spatial face
at at most one time, so the exceptional times have measure zero.
-/

open MeasureTheory

namespace NumStability

/-- A nonstationary affine front meets any fixed face at a null set of times. -/
theorem affineMovingFront_ae_ne
    (a b x : ℝ) (hb : b ≠ 0) :
    ∀ᵐ τ : ℝ ∂volume, x ≠ a + b * τ := by
  have hinj : Function.Injective (fun τ : ℝ => a + b * τ) := by
    intro τ σ h
    exact (mul_left_cancel₀ hb) (add_left_cancel h)
  have hfinite : Set.Finite {τ : ℝ | x = a + b * τ} := by
    have hpre : Set.Finite ((fun τ : ℝ => a + b * τ) ⁻¹' {x}) :=
      Set.Finite.preimage (fun _ _ _ _ h => hinj h) (Set.finite_singleton x)
    apply hpre.subset
    intro τ hτ
    exact hτ.symm
  have hzero : volume {τ : ℝ | x = a + b * τ} = 0 :=
    hfinite.measure_zero volume
  rw [ae_iff]
  simpa only [not_not] using hzero

/-- At almost every time, a fixed face either misses an affine front
or the front is stationary at that face. -/
theorem affineMovingFront_ae_ne_or_stationary
    (a b x : ℝ) :
    ∀ᵐ τ : ℝ ∂volume,
      x ≠ a + b * τ ∨ (b = 0 ∧ x = a) := by
  by_cases hb : b = 0
  · by_cases hx : x = a
    · exact Filter.Eventually.of_forall (fun _ => Or.inr ⟨hb, hx⟩)
    · exact Filter.Eventually.of_forall (fun τ => Or.inl (by simpa [hb] using hx))
  · filter_upwards [affineMovingFront_ae_ne a b x hb] with τ hτ
    exact Or.inl hτ

end NumStability
