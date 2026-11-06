/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Unit scalar phases of orthonormal families

Changing each vector by a scalar of norm one preserves its normalized
projection term, orthonormality, and the span of every subfamily. In
particular, projection residuals and prefix spans are unchanged.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E ι : Type*} [RCLike 𝕜] [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]

/-- A unit scalar phase does not change a normalized projection term.
The vector itself may be zero. -/
theorem inner_smul_phase_projection (c : 𝕜) (hc : ‖c‖ = 1) (q x : E) :
    inner 𝕜 (c • q) x • (c • q) = inner 𝕜 q x • q := by
  have hconj : (starRingEnd 𝕜) c * c = 1 := by
    simpa [hc] using RCLike.conj_mul c
  rw [inner_smul_left, smul_smul]
  congr 1
  calc
    ((starRingEnd 𝕜) c * inner 𝕜 q x) * c =
        ((starRingEnd 𝕜) c * c) * inner 𝕜 q x := by ac_rfl
    _ = inner 𝕜 q x := by rw [hconj, one_mul]

/-- Independent unit scalar phases preserve orthonormality. -/
theorem orthonormal_smul_of_norm_eq_one (q : ι → E) (c : ι → 𝕜)
    (hq : Orthonormal 𝕜 q) (hc : ∀ i, ‖c i‖ = 1) :
    Orthonormal 𝕜 (fun i => c i • q i) := by
  constructor
  · intro i
    rw [norm_smul, hc i, hq.norm_eq_one i, one_mul]
  · intro i j hij
    rw [inner_smul_left, inner_smul_right, hq.inner_eq_zero hij, mul_zero, mul_zero]

/-- Independent unit scalar phases preserve the span of every subfamily,
including empty subfamilies and zero vectors. -/
theorem span_image_smul_of_norm_eq_one (q : ι → E) (c : ι → 𝕜)
    (hc : ∀ i, ‖c i‖ = 1) (s : Set ι) :
    Submodule.span 𝕜 ((fun i => c i • q i) '' s) = Submodule.span 𝕜 (q '' s) := by
  apply le_antisymm
  · apply Submodule.span_le.mpr
    rintro _ ⟨i, hi, rfl⟩
    exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨i, hi, rfl⟩)
  · apply Submodule.span_le.mpr
    rintro _ ⟨i, hi, rfl⟩
    have hci : c i ≠ 0 := norm_pos_iff.mp (by rw [hc i]; exact zero_lt_one)
    have hmem := Submodule.smul_mem
      (Submodule.span 𝕜 ((fun i => c i • q i) '' s)) (c i)⁻¹
      (Submodule.subset_span ⟨i, hi, rfl⟩)
    simpa only [smul_smul, inv_mul_cancel₀ hci, one_smul] using hmem

end NumStability
