/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Normalization
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Phases
import ComputationalMathematics.Analysis.InnerProductSpace.Orthonormal.PrefixSpans

/-!
# Unit phase families of normalized Gram–Schmidt outputs

For an independent finite input, independent unit scalar phases preserve
orthonormality, every inclusive prefix span, and the nonzero projection
residuals. Conversely, every orthonormal family with those prefix spans is
obtained by such phases of the normalized Gram–Schmidt outputs.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]

/-- Independent unit phases of normalized Gram–Schmidt outputs preserve
the prefix spans and residuals, with phase normalization of every residual. -/
theorem gramSchmidt_unit_phase_family {n : ℕ} (X : Fin n → H)
    (hX : LinearIndependent 𝕜 X) (c : Fin n → 𝕜) (hc : ∀ i, ‖c i‖ = 1) :
    let Q := fun i => c i • InnerProductSpace.gramSchmidtNormed 𝕜 X i
    let residual := fun k => X k - ∑ i ∈ Finset.Iio k, inner 𝕜 (Q i) (X k) • Q i
    Orthonormal 𝕜 Q ∧
      (∀ k, Submodule.span 𝕜 (Q '' Set.Iic k) = Submodule.span 𝕜 (X '' Set.Iic k)) ∧
      ∀ k, residual k ≠ 0 ∧ Q k = c k • ((‖residual k‖ : 𝕜)⁻¹ • residual k) := by
  dsimp only
  refine ⟨orthonormal_smul_of_norm_eq_one _ c
    (InnerProductSpace.gramSchmidtNormed_orthonormal hX) hc, ?_, ?_⟩
  · intro k
    rw [span_image_smul_of_norm_eq_one _ c hc,
      InnerProductSpace.span_gramSchmidtNormed X,
      InnerProductSpace.span_gramSchmidt_Iic 𝕜 X]
  · intro k
    have hres :
        X k - ∑ i ∈ Finset.Iio k,
          inner 𝕜 (c i • InnerProductSpace.gramSchmidtNormed 𝕜 X i) (X k) •
            (c i • InnerProductSpace.gramSchmidtNormed 𝕜 X i) =
          InnerProductSpace.gramSchmidt 𝕜 X k := by
      calc
        _ = X k - ∑ i ∈ Finset.Iio k,
            inner 𝕜 (InnerProductSpace.gramSchmidtNormed 𝕜 X i) (X k) •
              InnerProductSpace.gramSchmidtNormed 𝕜 X i := by
          congr 1
          apply Finset.sum_congr rfl
          intro i _
          exact inner_smul_phase_projection (c i) (hc i) _ _
        _ = _ := (gramSchmidt_eq_normalized_residual X k).symm
    rw [hres]
    exact ⟨InnerProductSpace.gramSchmidt_ne_zero k hX, rfl⟩

/-- Every orthonormal family with the input's inclusive prefix spans is a
unit phase family of its normalized Gram–Schmidt outputs. -/
theorem exists_unit_phases_eq_gramSchmidtNormed {n : ℕ} (X q : Fin n → H)
    (hX : LinearIndependent 𝕜 X) (hq : Orthonormal 𝕜 q)
    (hspan : ∀ k, Submodule.span 𝕜 (q '' Set.Iic k) =
      Submodule.span 𝕜 (X '' Set.Iic k)) :
    ∃ c : Fin n → 𝕜, (∀ i, ‖c i‖ = 1) ∧
      ∀ i, q i = c i • InnerProductSpace.gramSchmidtNormed 𝕜 X i := by
  apply exists_unit_phases_of_orthonormal_prefix_spans q
    (InnerProductSpace.gramSchmidtNormed 𝕜 X) hq
    (InnerProductSpace.gramSchmidtNormed_orthonormal hX)
  intro k
  rw [InnerProductSpace.span_gramSchmidtNormed X,
    InnerProductSpace.span_gramSchmidt_Iic 𝕜 X]
  exact hspan k

end NumStability
