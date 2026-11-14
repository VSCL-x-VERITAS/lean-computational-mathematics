/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.SymmetricTensorMultiplicity
import ComputationalMathematics.Analysis.Matrix.PermanentSortedTuples

/-!
# Orthonormality of symmetric tensors with sorted labels

Symmetric products of an orthonormal family with distinct monotone label
tuples have zero cross inner product. The additional multiplicity-factorial
normalization makes the family of sorted-label tensors orthonormal.

All tensors live in the actual `PiTensorProduct` quotient, with its four
explicit product Hilbert structures. This leaf proves orthonormality only;
no spanning, basis or dimension assertion is made.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators

namespace PiTensorProduct

variable {k : ℕ} {α H : Type*} [Fintype α] [DecidableEq α] [PartialOrder α]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

private local instance sortedProductNormedAddCommGroup :
    NormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productNormedAddCommGroup
private local instance sortedProductSeminormedAddCommGroup :
    SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productSeminormedAddCommGroup
private local instance sortedProductInnerProductSpace :
    InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productInnerProductSpace
private local instance sortedProductNormedSpace :
    NormedSpace ℂ (PiTensorProduct ℂ (fun _ : Fin k => H)) :=
  productNormedSpace

omit [Fintype α] in
/-- Distinct monotone label tuples from an orthonormal family give orthogonal
normalized unsigned permutation sums, including tuples with repeated labels. -/
theorem inner_normalized_sum_permuted_tprod_eq_zero_of_monotone_ne
    (v : α → H) (hv : Orthonormal ℂ v) (f g : Fin k → α)
    (hf : Monotone f) (hg : Monotone g) (hfg : f ≠ g) :
    inner ℂ
      ((((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ σ : Equiv.Perm (Fin k), tprod ℂ (fun i => v (f (σ i))))
      ((((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ τ : Equiv.Perm (Fin k), tprod ℂ (fun i => v (g (τ i)))) = 0 := by
  have h := inner_normalized_sum_permuted_tprod_eq_permanent
    (fun i => v (f i)) (fun i => v (g i))
  simp only [Fintype.card_fin] at h
  rw [h]
  simp_rw [orthonormal_iff_ite.mp hv]
  exact Matrix.permanent_ite_eq_zero_of_monotone_ne f g hf hg hfg

/-- The multiplicity-normalized symmetric products of an orthonormal family,
indexed by all monotone tuples, form an orthonormal family in the actual tensor
product. This statement does not assert that they span any subspace. -/
theorem orthonormal_multiplicity_normalized_sum_permuted_tprod
    (v : α → H) (hv : Orthonormal ℂ v) :
    Orthonormal ℂ (fun f : {f : Fin k → α // Monotone f} =>
      (((Real.sqrt (((∏ a : α, Nat.factorial (Fintype.card {i // f.1 i = a})) : ℕ) : ℝ))⁻¹ : ℝ) : ℂ) •
        ((((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ) •
          ∑ σ : Equiv.Perm (Fin k), tprod ℂ (fun i => v (f.1 (σ i))))) := by
  constructor
  · intro f
    simpa only [Fintype.card_fin] using
      norm_multiplicity_normalized_sum_permuted_tprod_eq_one v hv f.1
  · intro f g hfg
    have hne : f.1 ≠ g.1 := fun h => hfg (Subtype.ext h)
    rw [inner_smul_left, inner_smul_right,
      inner_normalized_sum_permuted_tprod_eq_zero_of_monotone_ne
        v hv f.1 g.1 f.2 g.2 hne]
    simp

end PiTensorProduct
