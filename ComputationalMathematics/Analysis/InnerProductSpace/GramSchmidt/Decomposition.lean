/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Normalization
import Mathlib.LinearAlgebra.Dimension.OrzechProperty

/-!
# Normalized Gram–Schmidt decomposition and completion

When the number of inputs equals the dimension, Mathlib completes the nonzero
normalized Gram–Schmidt outputs to an orthonormal basis. Its coefficient rows
vanish at all zero outputs, so the same coefficients reconstruct the input
using the uncompleted family or any replacement that keeps its nonzero entries.
The results include empty index sets and arbitrary dependent inputs.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
variable {ι : Type*} [LinearOrder ι] [LocallyFiniteOrderBot ι] [WellFoundedLT ι]
variable [Fintype ι] [FiniteDimensional 𝕜 H]

/-- Coefficients in the completed basis also reconstruct the input from the
normalized family before its zero entries are completed. -/
theorem gramSchmidtNormed_sum_inner
    (h : Module.finrank 𝕜 H = Fintype.card ι) (f : ι → H) (j : ι) :
    (∑ i, inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis h f i) (f j) •
      InnerProductSpace.gramSchmidtNormed 𝕜 f i) = f j := by
  classical
  calc
    _ = ∑ i, inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis h f i) (f j) •
        InnerProductSpace.gramSchmidtOrthonormalBasis h f i := by
      apply Finset.sum_congr rfl
      intro i _
      by_cases hi : InnerProductSpace.gramSchmidtNormed 𝕜 f i = 0
      · simp only [InnerProductSpace.inner_gramSchmidtOrthonormalBasis_eq_zero h hi j,
          zero_smul]
      · rw [InnerProductSpace.gramSchmidtOrthonormalBasis_apply h hi]
    _ = f j := (InnerProductSpace.gramSchmidtOrthonormalBasis h f).sum_repr' (f j)

/-- Any replacement of the zero normalized outputs preserves reconstruction
with the same coefficients. The replacement need not be orthonormal. -/
theorem gramSchmidt_completion_sum_inner
    (h : Module.finrank 𝕜 H = Fintype.card ι) (f P : ι → H)
    (hP : ∀ i, InnerProductSpace.gramSchmidtNormed 𝕜 f i ≠ 0 →
      P i = InnerProductSpace.gramSchmidtNormed 𝕜 f i) (j : ι) :
    (∑ i, inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis h f i) (f j) • P i) =
      f j := by
  classical
  calc
    _ = ∑ i, inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis h f i) (f j) •
        InnerProductSpace.gramSchmidtNormed 𝕜 f i := by
      apply Finset.sum_congr rfl
      intro i _
      by_cases hi : InnerProductSpace.gramSchmidtNormed 𝕜 f i = 0
      · simp only [InnerProductSpace.inner_gramSchmidtOrthonormalBasis_eq_zero h hi j,
          zero_smul]
      · rw [hP i hi]
    _ = f j := gramSchmidtNormed_sum_inner h f j

/-- For an input family of dimension length, all normalized outputs are
nonzero exactly when the original input family is linearly independent. -/
theorem gramSchmidtNormed_ne_zero_iff_linearIndependent
    (h : Module.finrank 𝕜 H = Fintype.card ι) (f : ι → H) :
    (∀ i, InnerProductSpace.gramSchmidtNormed 𝕜 f i ≠ 0) ↔ LinearIndependent 𝕜 f := by
  classical
  constructor
  · intro hn
    let b := InnerProductSpace.gramSchmidtOrthonormalBasis h f
    have hb : (b : ι → H) = InnerProductSpace.gramSchmidtNormed 𝕜 f := by
      funext i
      exact InnerProductSpace.gramSchmidtOrthonormalBasis_apply h (hn i)
    have hbspan : Submodule.span 𝕜
        (Set.range (InnerProductSpace.gramSchmidtNormed 𝕜 f)) = ⊤ := by
      rw [← hb, ← b.coe_toBasis]
      exact b.toBasis.span_eq
    have hfspan : Submodule.span 𝕜 (Set.range f) = ⊤ := by
      rw [← InnerProductSpace.span_gramSchmidt 𝕜 f,
        ← InnerProductSpace.span_gramSchmidtNormed_range f]
      exact hbspan
    exact linearIndependent_of_top_le_span_of_card_eq_finrank hfspan.ge h.symm
  · intro hf i hi
    exact InnerProductSpace.gramSchmidt_ne_zero i hf
      ((gramSchmidtNormed_eq_zero_iff f i).mp hi)

/-- A dependent family of dimension length has a zero normalized output. -/
theorem gramSchmidtNormed_exists_eq_zero
    (h : Module.finrank 𝕜 H = Fintype.card ι) (f : ι → H)
    (hf : ¬ LinearIndependent 𝕜 f) :
    ∃ i, InnerProductSpace.gramSchmidtNormed 𝕜 f i = 0 := by
  classical
  by_contra! hn
  exact hf ((gramSchmidtNormed_ne_zero_iff_linearIndependent h f).mp hn)

/-- The completed-basis coefficient array is triangular, has zero rows at
the zero normalized outputs, and gives both the uncompleted and completed
factorizations. Every replacement keeping the nonzero outputs preserves it. -/
theorem gramSchmidtNormed_decomposition
    (h : Module.finrank 𝕜 H = Fintype.card ι) (f : ι → H) :
    let Q0 := InnerProductSpace.gramSchmidtNormed 𝕜 f
    let b := InnerProductSpace.gramSchmidtOrthonormalBasis h f
    let R := fun i j => inner 𝕜 (b i) (f j)
    (∀ i j, j < i → R i j = 0) ∧
      (∀ i, Q0 i = 0 → ∀ j, R i j = 0) ∧
      (∀ j, f j = ∑ i, R i j • Q0 i) ∧
      (∀ j, f j = ∑ i, R i j • b i) ∧
      (∀ i, Q0 i ≠ 0 → b i = Q0 i) ∧
      (∀ P : ι → H, (∀ i, Q0 i ≠ 0 → P i = Q0 i) →
        ∀ j, f j = ∑ i, R i j • P i) := by
  dsimp only
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i j hij
    exact InnerProductSpace.gramSchmidtOrthonormalBasis_inv_triangular h f hij
  · intro i hi j
    exact InnerProductSpace.inner_gramSchmidtOrthonormalBasis_eq_zero h hi j
  · intro j
    exact (gramSchmidtNormed_sum_inner h f j).symm
  · intro j
    exact ((InnerProductSpace.gramSchmidtOrthonormalBasis h f).sum_repr' (f j)).symm
  · intro i hi
    exact InnerProductSpace.gramSchmidtOrthonormalBasis_apply h hi
  · intro P hP j
    exact (gramSchmidt_completion_sum_inner h f P hP j).symm

end NumStability
