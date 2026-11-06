/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.GramSchmidtOrtho
import Mathlib.Tactic.Ring

/-!
# Normalized Gram–Schmidt projections and coefficients

The normalized one-dimensional projection formula also holds for the zero
vector. It identifies the projection recurrence with the recurrence in terms
of normalized predecessors and gives the diagonal Gram–Schmidt coefficient.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 E : Type*} [RCLike 𝕜] [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]

/-- Normalizing a spanning vector does not change its projection formula,
including when the spanning vector is zero. -/
theorem starProjection_singleton_normalized (v w : E) :
    (𝕜 ∙ v).starProjection w =
      inner 𝕜 ((‖v‖ : 𝕜)⁻¹ • v) w • ((‖v‖ : 𝕜)⁻¹ • v) := by
  rw [Submodule.starProjection_singleton]
  simp only [inner_smul_left, RCLike.conj_inv, RCLike.conj_ofReal,
    smul_smul, RCLike.ofReal_pow, div_eq_mul_inv]
  congr 1
  ring

variable {ι : Type*} [LinearOrder ι] [LocallyFiniteOrderBot ι] [WellFoundedLT ι]

/-- The projection recurrence is exactly the residual obtained using the
normalized predecessors, including any predecessors that vanish. -/
theorem gramSchmidt_eq_normalized_residual (f : ι → E) (j : ι) :
    InnerProductSpace.gramSchmidt 𝕜 f j =
      f j - ∑ i ∈ Finset.Iio j,
        inner 𝕜 (InnerProductSpace.gramSchmidtNormed 𝕜 f i) (f j) •
          InnerProductSpace.gramSchmidtNormed 𝕜 f i := by
  rw [InnerProductSpace.gramSchmidt_def]
  simp_rw [starProjection_singleton_normalized]
  rfl

/-- The unnormalized residual has the same inner product with its input as
with itself. No independence assumption is needed. -/
theorem inner_gramSchmidt_input (f : ι → E) (j : ι) :
    inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j) (f j) =
      (‖InnerProductSpace.gramSchmidt 𝕜 f j‖ : 𝕜) ^ 2 := by
  calc
    inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j) (f j) =
        inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j)
          (InnerProductSpace.gramSchmidt 𝕜 f j +
            ∑ i ∈ Finset.Iio j,
              (inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f i) (f j) /
                (‖InnerProductSpace.gramSchmidt 𝕜 f i‖ : 𝕜) ^ 2) •
                  InnerProductSpace.gramSchmidt 𝕜 f i) :=
      congrArg (inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j))
        (InnerProductSpace.gramSchmidt_def'' 𝕜 f j)
    _ = inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j)
        (InnerProductSpace.gramSchmidt 𝕜 f j) := by
      simp only [inner_add_right, inner_sum, inner_smul_right]
      apply add_eq_left.mpr
      apply Finset.sum_eq_zero
      intro i hi
      rw [InnerProductSpace.gramSchmidt_orthogonal 𝕜 f
        (ne_of_gt (Finset.mem_Iio.mp hi)), mul_zero]
    _ = _ := inner_self_eq_norm_sq_to_K _

/-- The normalized Gram–Schmidt coefficient of its own input is the real
norm of the unnormalized residual, embedded in the scalar field. -/
theorem inner_gramSchmidtNormed_input (f : ι → E) (j : ι) :
    inner 𝕜 (InnerProductSpace.gramSchmidtNormed 𝕜 f j) (f j) =
      (‖InnerProductSpace.gramSchmidt 𝕜 f j‖ : 𝕜) := by
  rw [InnerProductSpace.gramSchmidtNormed, inner_smul_left,
    RCLike.conj_inv, RCLike.conj_ofReal, inner_gramSchmidt_input]
  by_cases h : (‖InnerProductSpace.gramSchmidt 𝕜 f j‖ : 𝕜) = 0
  · simp [h]
  · rw [pow_two, ← mul_assoc, inv_mul_cancel₀ h, one_mul]

/-- Norm normalization vanishes exactly when its unnormalized residual does. -/
theorem gramSchmidtNormed_eq_zero_iff (f : ι → E) (j : ι) :
    InnerProductSpace.gramSchmidtNormed 𝕜 f j = 0 ↔
      InnerProductSpace.gramSchmidt 𝕜 f j = 0 := by
  simp [InnerProductSpace.gramSchmidtNormed]

/-- An arbitrary input has zero Gram–Schmidt residual precisely when it is
in the span of its strict predecessors. Earlier zero outputs are allowed. -/
theorem gramSchmidt_eq_zero_iff_mem_span_predecessors (f : ι → E) (j : ι) :
    InnerProductSpace.gramSchmidt 𝕜 f j = 0 ↔
      f j ∈ Submodule.span 𝕜 (f '' Set.Iio j) := by
  constructor
  · intro h
    rw [← InnerProductSpace.span_gramSchmidt_Iio 𝕜 f j]
    rw [InnerProductSpace.gramSchmidt_def'' 𝕜 f j, h, zero_add]
    apply Submodule.sum_mem
    intro i hi
    apply Submodule.smul_mem
    exact Submodule.subset_span ⟨i, Finset.mem_Iio.mp hi, rfl⟩
  · intro h
    rw [← InnerProductSpace.span_gramSchmidt_Iio 𝕜 f j] at h
    have hspan (x : E)
        (hx : x ∈ Submodule.span 𝕜
          (InnerProductSpace.gramSchmidt 𝕜 f '' Set.Iio j)) :
        inner 𝕜 (InnerProductSpace.gramSchmidt 𝕜 f j) x = 0 := by
      induction hx using Submodule.span_induction with
      | mem x hx =>
        obtain ⟨i, hi, rfl⟩ := hx
        exact InnerProductSpace.gramSchmidt_orthogonal 𝕜 f (ne_of_gt hi)
      | zero => exact inner_zero_right _
      | add x y _ _ hx hy => simp only [inner_add_right, hx, hy, add_zero]
      | smul a x _ hx => rw [inner_smul_right, hx, mul_zero]
    apply (inner_self_eq_zero (𝕜 := 𝕜)).mp
    rw [inner_self_eq_norm_sq_to_K, ← inner_gramSchmidt_input f j]
    exact hspan (f j) h

/-- The normalized process takes its zero branch exactly at dependence on
the original strict predecessors, without any independence assumption. -/
theorem gramSchmidtNormed_eq_zero_iff_mem_span_predecessors (f : ι → E) (j : ι) :
    InnerProductSpace.gramSchmidtNormed 𝕜 f j = 0 ↔
      f j ∈ Submodule.span 𝕜 (f '' Set.Iio j) := by
  rw [gramSchmidtNormed_eq_zero_iff, gramSchmidt_eq_zero_iff_mem_span_predecessors]

end NumStability
