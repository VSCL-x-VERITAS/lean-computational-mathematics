/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Decomposition
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Block

/-!
# Orthonormalizing a common triangular basis

Gram–Schmidt preserves every initial basis span. Thus a family that is upper
triangular in one ordered basis is upper triangular in one orthonormal basis.
The family may be empty or infinitely indexed; the carrier may have dimension
zero. No commutation or normality premise is needed for this transfer.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 H I : Type*} [RCLike 𝕜]
variable [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
variable [FiniteDimensional 𝕜 H]

/-- A common upper-triangular basis can be replaced by a common orthonormal
upper-triangular basis, without changing the family or its indexing type. -/
theorem exists_common_upperTriangular_orthonormalBasis_of_basis
    {n : ℕ} (b : Module.Basis (Fin n) 𝕜 H) (A : I → H →ₗ[𝕜] H)
    (hA : ∀ a : I, (LinearMap.toMatrix b b (A a)).BlockTriangular id) :
    ∃ E : OrthonormalBasis (Fin n) 𝕜 H,
      ∀ a : I, (LinearMap.toMatrix E.toBasis E.toBasis (A a)).BlockTriangular id := by
  classical
  have hdim : Module.finrank 𝕜 H = Fintype.card (Fin n) := Module.finrank_eq_card_basis b
  let E : OrthonormalBasis (Fin n) 𝕜 H :=
    InnerProductSpace.gramSchmidtOrthonormalBasis hdim b
  have hn : ∀ i, InnerProductSpace.gramSchmidtNormed 𝕜 b i ≠ 0 :=
    (gramSchmidtNormed_ne_zero_iff_linearIndependent hdim b).mpr b.linearIndependent
  have hE : (E : Fin n → H) = InnerProductSpace.gramSchmidtNormed 𝕜 b := by
    funext i
    exact InnerProductSpace.gramSchmidtOrthonormalBasis_apply hdim (hn i)
  have hspan (j : Fin n) :
      Submodule.span 𝕜 (E '' Set.Iic j) = Submodule.span 𝕜 (b '' Set.Iic j) := by
    rw [hE, InnerProductSpace.span_gramSchmidtNormed,
      InnerProductSpace.span_gramSchmidt_Iic]
  have hmem (a : I) (j k : Fin n) (hkj : k ≤ j) :
      A a (b k) ∈ Submodule.span 𝕜 (b '' Set.Iic j) := by
    apply b.mem_span_image.mpr
    intro i hi
    by_contra hij
    have hki : k < i := lt_of_le_of_lt hkj (lt_of_not_ge hij)
    have hz : b.repr (A a (b k)) i = 0 := by
      simpa only [LinearMap.toMatrix_apply] using hA a (i := i) (j := k) hki
    exact (Finsupp.mem_support_iff.mp hi) hz
  have hinvariant (a : I) (j : Fin n) :
      Submodule.span 𝕜 (b '' Set.Iic j) ≤
        (Submodule.span 𝕜 (b '' Set.Iic j)).comap (A a) := by
    apply Submodule.span_le.mpr
    rintro _ ⟨k, hk, rfl⟩
    exact hmem a j k hk
  refine ⟨E, ?_⟩
  intro a i j hji
  have hj : E j ∈ Submodule.span 𝕜 (b '' Set.Iic j) := by
    rw [← hspan]
    exact Submodule.subset_span ⟨j, Set.mem_Iic.mpr le_rfl, rfl⟩
  have haj : A a (E j) ∈ Submodule.span 𝕜 (E '' Set.Iic j) := by
    rw [hspan]
    exact hinvariant a j hj
  have hsupp := E.toBasis.repr_support_subset_of_mem_span (Set.Iic j) haj
  rw [LinearMap.toMatrix_apply]
  change E.toBasis.repr (A a (E j)) i = 0
  by_contra hi
  exact (not_le_of_gt hji) (hsupp (Finsupp.mem_support_iff.mpr hi))

end NumStability
