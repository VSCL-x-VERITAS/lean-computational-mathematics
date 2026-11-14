/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.Combinatorics.MonotoneTuples
import ComputationalMathematics.Analysis.InnerProductSpace.SymmetricTensorOrthonormality
import ComputationalMathematics.Analysis.InnerProductSpace.SymmetricTensorSpan
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# An orthonormal basis of the actual symmetric tensor span

A finite orthonormal basis of the factor space gives an orthonormal basis
of the span of its normalized symmetric tensors. The basis is indexed by
nondecreasing label tuples and includes the second multiplicity-factorial
normalization. Its cardinality gives the binomial dimension of that span.

The ambient space is the actual `PiTensorProduct` quotient with the explicit
product Hilbert structures. No abstract symmetric-power carrier is substituted.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators

namespace PiTensorProduct

variable {k : ℕ} {α H : Type*} [Fintype α] [LinearOrder α]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

private local instance basisProductNormedAddCommGroup :
    NormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productNormedAddCommGroup
private local instance basisProductSeminormedAddCommGroup :
    SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productSeminormedAddCommGroup
private local instance basisProductInnerProductSpace :
    InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productInnerProductSpace
private local instance basisProductNormedSpace :
    NormedSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productNormedSpace

private def symmetricBasisVector (b : OrthonormalBasis α ℂ H)
    (f : {f : Fin k → α // Monotone f}) : PiTensorProduct ℂ (fun _ : Fin k => H) :=
  (((Real.sqrt (((∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a})) : ℕ) : ℝ))⁻¹ : ℝ) : ℂ) •
    normalizedSymmetricTensor (Fin k) H (fun i => b (f.1 i))

private theorem symmetricBasisVector_orthonormal (b : OrthonormalBasis α ℂ H) :
    Orthonormal ℂ (symmetricBasisVector (k := k) b) := by
  unfold symmetricBasisVector
  simpa only [normalizedSymmetricTensor_apply, Fintype.card_fin] using
    orthonormal_multiplicity_normalized_sum_permuted_tprod
      (k := k) (α := α) (H := H) b b.orthonormal

omit [FiniteDimensional ℂ H] in
private theorem symmetricBasisVector_mem (b : OrthonormalBasis α ℂ H)
    (f : {f : Fin k → α // Monotone f}) :
    symmetricBasisVector b f ∈
      Submodule.span ℂ (Set.range (normalizedSymmetricTensor (Fin k) H)) := by
  exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨fun i => b (f.1 i), rfl⟩)

omit [FiniteDimensional ℂ H] in
private theorem span_symmetricBasisVector (b : OrthonormalBasis α ℂ H) :
    Submodule.span ℂ (Set.range (symmetricBasisVector (k := k) b)) =
      Submodule.span ℂ (Set.range (normalizedSymmetricTensor (Fin k) H)) := by
  classical
  let w := fun f : {f : Fin k → α // Monotone f} =>
    normalizedSymmetricTensor (Fin k) H (fun i => b (f.1 i))
  let c := fun f : {f : Fin k → α // Monotone f} =>
    (((Real.sqrt (((∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a})) : ℕ) : ℝ))⁻¹ : ℝ) : ℂ)
  have hc (f : {f : Fin k → α // Monotone f}) : c f ≠ 0 := by
    have hm : 0 < ∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a}) :=
      Finset.prod_pos (fun a _ => Nat.factorial_pos _)
    have hmR : (0 : ℝ) <
        ((∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a})) : ℕ) := by
      exact_mod_cast hm
    dsimp only [c]
    exact_mod_cast inv_ne_zero (Real.sqrt_ne_zero'.mpr hmR)
  have hs : Submodule.span ℂ (Set.range (symmetricBasisVector (k := k) b)) =
      Submodule.span ℂ (Set.range w) := by
    apply le_antisymm
    · apply Submodule.span_le.mpr
      rintro _ ⟨f, rfl⟩
      exact Submodule.smul_mem _ (c f) (Submodule.subset_span ⟨f, rfl⟩)
    · apply Submodule.span_le.mpr
      rintro _ ⟨f, rfl⟩
      have hu := Submodule.smul_mem
        (Submodule.span ℂ (Set.range (symmetricBasisVector (k := k) b)))
        (c f)⁻¹ (Submodule.subset_span (Set.mem_range_self f))
      change (c f)⁻¹ • (c f • w f) ∈ _ at hu
      simpa only [smul_smul, inv_mul_cancel₀ (hc f), one_smul] using hu
  have hw : Submodule.span ℂ (Set.range w) =
      Submodule.span ℂ (Set.range (normalizedSymmetricTensor (Fin k) H)) := by
    simpa only [w, OrthonormalBasis.coe_toBasis] using
      (span_normalizedSymmetricTensor_eq_span_monotone_basis (k := k) b.toBasis).symm
  exact hs.trans hw

/-- The multiplicity-normalized symmetric products of the given orthonormal
basis, indexed by all nondecreasing tuples, are an orthonormal basis of the
actual symmetric tensor span. -/
noncomputable def symmetricTensorOrthonormalBasis (b : OrthonormalBasis α ℂ H) (k : ℕ) :
    OrthonormalBasis {f : Fin k → α // Monotone f} ℂ
      (Submodule.span ℂ (Set.range (normalizedSymmetricTensor (Fin k) H))) := by
  classical
  let V := Submodule.span ℂ (Set.range (normalizedSymmetricTensor (Fin k) H))
  have hm : ∀ f, symmetricBasisVector (k := k) b f ∈ V :=
    symmetricBasisVector_mem b
  have hon := (symmetricBasisVector_orthonormal (k := k) b).codRestrict V hm
  have hsp : Submodule.span ℂ
      (Set.range (fun f => (⟨symmetricBasisVector b f, hm f⟩ : V))) = ⊤ :=
    (Submodule.span_range_subtype_eq_top_iff V hm).2 (span_symmetricBasisVector b)
  exact OrthonormalBasis.mk hon hsp.ge

/-- The constructed basis vector has exactly the inverse-square-root
multiplicity coefficient multiplying the actual normalized symmetric product. -/
@[simp] theorem symmetricTensorOrthonormalBasis_apply
    (b : OrthonormalBasis α ℂ H) (k : ℕ) (f : {f : Fin k → α // Monotone f}) :
    (symmetricTensorOrthonormalBasis b k f : PiTensorProduct ℂ (fun _ : Fin k => H)) =
      (((Real.sqrt (((∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a})) : ℕ) : ℝ))⁻¹ : ℝ) : ℂ) •
        normalizedSymmetricTensor (Fin k) H (fun i => b (f.1 i)) := by
  simp [symmetricTensorOrthonormalBasis, symmetricBasisVector, OrthonormalBasis.coe_mk]

/-- The actual symmetric span has the binomial dimension given by the number
of nondecreasing label tuples. -/
theorem finrank_span_normalizedSymmetricTensor (b : OrthonormalBasis α ℂ H) (k : ℕ) :
    Module.finrank ℂ (Submodule.span ℂ
      (Set.range (normalizedSymmetricTensor (Fin k) H))) =
      (Fintype.card α + k - 1).choose k := by
  rw [Module.finrank_eq_card_basis (symmetricTensorOrthonormalBasis b k).toBasis]
  exact Tuple.card_monotone_tuples α k

end PiTensorProduct
