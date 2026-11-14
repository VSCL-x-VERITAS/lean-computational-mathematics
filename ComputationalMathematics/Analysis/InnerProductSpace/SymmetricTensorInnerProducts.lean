/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct
import Mathlib.LinearAlgebra.Matrix.Permanent
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Tactic.FieldSimp

/-!
# Symmetric tensor inner products

The unsigned sum of the pure tensors obtained by permuting a finite family
pairs with a pure tensor by the permanent of their cross-inner-product matrix.
Pairing two such sums introduces a factorial, which is cancelled by normalizing
both sums by the inverse square root of that factorial.

The sums live in the actual `PiTensorProduct` quotient with the explicitly
selected product Hilbert structures. All input families are arbitrary; there
is no orthonormality, rank, positive-dimension or nonempty-index assumption.
No new permanent or symmetric tensor carrier is defined.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators ComplexConjugate

namespace PiTensorProduct

variable {ι H : Type*} [Fintype ι] [DecidableEq ι]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

private local instance symmetricProductNormedAddCommGroup : NormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedAddCommGroup
private local instance symmetricProductSeminormedAddCommGroup : SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productSeminormedAddCommGroup
private local instance symmetricProductInnerProductSpace : InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productInnerProductSpace
private local instance symmetricProductNormedSpace : NormedSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedSpace

/-- Pairing an unsigned permutation sum with a pure tensor is the permanent
of the matrix with the left family's vectors in its first inner-product slot. -/
theorem inner_sum_permuted_tprod_tprod_eq_permanent (x y : ι → H) :
    inner ℂ (∑ σ : Equiv.Perm ι, tprod ℂ (fun i => x (σ i))) (tprod ℂ y) =
      Matrix.permanent (fun i j => inner ℂ (x i) (y j)) := by
  simp only [sum_inner, inner_tprod, Matrix.permanent]

/-- The cross inner product of two unsigned permutation sums is a factorial
times the permanent. Repeated and linearly dependent input vectors are allowed. -/
theorem inner_sum_permuted_tprod_eq_factorial_permanent (x y : ι → H) :
    inner ℂ (∑ σ : Equiv.Perm ι, tprod ℂ (fun i => x (σ i)))
      (∑ τ : Equiv.Perm ι, tprod ℂ (fun i => y (τ i))) =
        (Nat.factorial (Fintype.card ι) : ℂ) *
          Matrix.permanent (fun i j => inner ℂ (x i) (y j)) := by
  rw [inner_sum]
  simp_rw [inner_sum_permuted_tprod_tprod_eq_permanent]
  have hperm (τ : Equiv.Perm ι) :
      Matrix.permanent (fun i j => inner ℂ (x i) (y (τ j))) =
        Matrix.permanent (fun i j => inner ℂ (x i) (y j)) :=
    Matrix.permanent_permute_rows τ (fun i j => inner ℂ (x i) (y j))
  simp_rw [hperm]
  simp [Fintype.card_perm]

/-- Inverse-square-root-factorial normalization of both unsigned permutation
sums gives their exact permanent cross-inner-product identity. -/
theorem inner_normalized_sum_permuted_tprod_eq_permanent (x y : ι → H) :
    inner ℂ
      ((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ σ : Equiv.Perm ι, tprod ℂ (fun i => x (σ i)))
      ((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ τ : Equiv.Perm ι, tprod ℂ (fun i => y (τ i))) =
      Matrix.permanent (fun i j => inner ℂ (x i) (y j)) := by
  have hpos : (0 : ℝ) < Nat.factorial (Fintype.card ι) := by
    exact_mod_cast Nat.factorial_pos (Fintype.card ι)
  have hne : ((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ)) : ℂ) ≠ 0 := by
    exact_mod_cast (Real.sqrt_ne_zero'.mpr hpos)
  have hsq : ((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ) : ℂ)) ^ 2 =
      (Nat.factorial (Fintype.card ι) : ℂ) := by
    exact_mod_cast Real.sq_sqrt (le_of_lt hpos)
  rw [inner_smul_left, inner_smul_right,
    inner_sum_permuted_tprod_eq_factorial_permanent]
  simp only [Complex.ofReal_inv, map_inv₀, Complex.conj_ofReal]
  rw [← hsq]
  field_simp [hne]

end PiTensorProduct
