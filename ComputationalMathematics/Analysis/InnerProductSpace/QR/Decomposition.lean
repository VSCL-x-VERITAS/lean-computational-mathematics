/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Normalization
import ComputationalMathematics.Analysis.InnerProductSpace.QR.Uniqueness
import Mathlib.Logic.ExistsUnique

/-!
# Positively normalized QR decomposition of a finite independent family

Normalized Gram–Schmidt gives the unique orthonormal, upper-triangular
factorization with strictly positive real diagonal. The ambient inner-product
space need not be finite-dimensional, and the empty input family is included.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]

/-- Every finite independent family has a unique orthonormal triangular
factorization normalized by embedded strictly positive real diagonal entries. -/
theorem existsUnique_qr_of_linearIndependent {n : ℕ} (X : Fin n → H)
    (hX : LinearIndependent 𝕜 X) :
    ∃! qr : (Fin n → H) × Matrix (Fin n) (Fin n) 𝕜,
      Orthonormal 𝕜 qr.1 ∧
        (∀ j, X j = ∑ i, qr.2 i j • qr.1 i) ∧
        (∀ i j, j < i → qr.2 i j = 0) ∧
        (∀ j, ∃ d : ℝ, 0 < d ∧ qr.2 j j = (d : 𝕜)) := by
  classical
  let Q := InnerProductSpace.gramSchmidtNormed 𝕜 X
  let R := fun i j => inner 𝕜 (Q i) (X j)
  have hQ : Orthonormal 𝕜 Q := InnerProductSpace.gramSchmidtNormed_orthonormal hX
  have hspan : Submodule.span 𝕜 (Set.range Q) = Submodule.span 𝕜 (Set.range X) := by
    dsimp only [Q]
    rw [InnerProductSpace.span_gramSchmidtNormed_range X,
      InnerProductSpace.span_gramSchmidt 𝕜 X]
  have hR (j : Fin n) : X j = ∑ i, R i j • Q i := by
    have hx : X j ∈ Submodule.span 𝕜 (Set.range Q) := by
      rw [hspan]
      exact Submodule.subset_span ⟨j, rfl⟩
    obtain ⟨c, hc⟩ := (Submodule.mem_span_range_iff_exists_fun 𝕜).mp hx
    have hcoeff (i : Fin n) : c i = R i j :=
      orthonormal_expansion_coefficient hQ hc.symm i
    simpa only [hcoeff] using hc.symm
  have hRt (i j : Fin n) (hij : j < i) : R i j = 0 := by
    dsimp only [R, Q, InnerProductSpace.gramSchmidtNormed]
    rw [inner_smul_left, InnerProductSpace.gramSchmidt_inv_triangular 𝕜 X hij,
      mul_zero]
  have hRd (j : Fin n) : ∃ d : ℝ, 0 < d ∧ R j j = (d : 𝕜) := by
    refine ⟨‖InnerProductSpace.gramSchmidt 𝕜 X j‖,
      norm_pos_iff.mpr (InnerProductSpace.gramSchmidt_ne_zero j hX), ?_⟩
    exact inner_gramSchmidtNormed_input X j
  refine ⟨(Q, R), ⟨hQ, hR, hRt, hRd⟩, ?_⟩
  rintro ⟨P, S⟩ ⟨hP, hS, hSt, hSd⟩
  obtain ⟨hPQ, hSR⟩ := qr_unique_of_pos_diagonal X P Q S R hP hQ hS hR hSt hRt hSd hRd
  exact Prod.ext hPQ hSR

end NumStability
