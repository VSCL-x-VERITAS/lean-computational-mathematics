/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.LinearAlgebra.Alternating.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.FieldSimp

/-!
# Gram determinants of alternating tensors

The product Hilbert inner product of a tensor alternatization with a pure
tensor is the determinant of the matrix of pairwise inner products.
Alternating both inputs introduces the factorial of the number of factors;
inverse-square-root-factorial normalization cancels that factor.

Both vector families are arbitrary. The finite index type may be empty and
the vector space may have dimension zero. The existing tensor quotient and
`MultilinearMap.alternatization` are used throughout, with the product Hilbert
structures selected only locally.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators ComplexConjugate

namespace PiTensorProduct

variable {ι H : Type*} [Fintype ι] [DecidableEq ι] [NormedAddCommGroup H]
  [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

private local instance gramProductNormedAddCommGroup : NormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedAddCommGroup
private local instance gramProductSeminormedAddCommGroup : SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productSeminormedAddCommGroup
private local instance gramProductInnerProductSpace : InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productInnerProductSpace
private local instance gramProductNormedSpace : NormedSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedSpace

omit [FiniteDimensional ℂ H] in
private theorem alternatization_tprod_sum (x : ι → H) :
    MultilinearMap.alternatization (tprod ℂ) x =
      ∑ σ : Equiv.Perm ι, (((Equiv.Perm.sign σ : ℤ) : ℂ) •
        tprod ℂ (fun i => x (σ i))) := by
  rw [MultilinearMap.alternatization_apply]
  apply Finset.sum_congr rfl
  intro σ _
  rcases Int.units_eq_one_or (Equiv.Perm.sign σ) with h | h <;>
    simp [h, Units.smul_def]

/-- Alternating the first tensor family gives the determinant of its
pairings with an arbitrary pure tensor. -/
theorem inner_alternatization_tprod_eq_det (x y : ι → H) :
    inner ℂ (MultilinearMap.alternatization (tprod ℂ) x) (tprod ℂ y) =
      Matrix.det (fun i j => inner ℂ (x i) (y j)) := by
  rw [alternatization_tprod_sum, sum_inner, Matrix.det_apply']
  apply Finset.sum_congr rfl
  intro σ _
  rw [inner_smul_left, inner_tprod]
  rcases Int.units_eq_one_or (Equiv.Perm.sign σ) with h | h <;> simp [h]

/-- The inner product of two unnormalized tensor alternatizations is the
factorial of the number of factors times the cross-Gram determinant. -/
theorem inner_alternatization_tprod_eq_factorial_det (x y : ι → H) :
    inner ℂ (MultilinearMap.alternatization (tprod ℂ) x)
      (MultilinearMap.alternatization (tprod ℂ) y) =
        (Nat.factorial (Fintype.card ι) : ℂ) *
          Matrix.det (fun i j => inner ℂ (x i) (y j)) := by
  rw [alternatization_tprod_sum y, inner_sum]
  calc
    _ = ∑ τ : Equiv.Perm ι, ((Equiv.Perm.sign τ : ℤ) : ℂ) *
        (((Equiv.Perm.sign τ : ℤ) : ℂ) *
          Matrix.det (fun i j => inner ℂ (x i) (y j))) := by
      apply Finset.sum_congr rfl
      intro τ _
      rw [inner_smul_right, inner_alternatization_tprod_eq_det]
      congr 1
      simpa only [Matrix.submatrix_apply, id_eq] using
        Matrix.det_permute' τ (fun i j => inner ℂ (x i) (y j))
    _ = ∑ _τ : Equiv.Perm ι, Matrix.det (fun i j => inner ℂ (x i) (y j)) := by
      apply Finset.sum_congr rfl
      intro τ _
      rcases Int.units_eq_one_or (Equiv.Perm.sign τ) with h | h <;> simp [h]
    _ = _ := by simp [Fintype.card_perm, nsmul_eq_mul]

/-- The cross-Gram determinant is the inner product of the actual normalized
antisymmetrized tensors, for arbitrary vector families. -/
theorem inner_normalized_alternatization_tprod_eq_det (x y : ι → H) :
    inner ℂ
      ((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        MultilinearMap.alternatization (tprod ℂ) x)
      ((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        MultilinearMap.alternatization (tprod ℂ) y) =
      Matrix.det (fun i j => inner ℂ (x i) (y j)) := by
  let m : ℕ := Nat.factorial (Fintype.card ι)
  let r : ℝ := Real.sqrt (m : ℝ)
  have hm : (0 : ℝ) < m := by
    exact_mod_cast Nat.factorial_pos (Fintype.card ι)
  have hr : r ≠ 0 := Real.sqrt_ne_zero'.mpr hm
  have hsq : r ^ 2 = (m : ℝ) := Real.sq_sqrt (Nat.cast_nonneg m)
  have hcoeff : conj ((r⁻¹ : ℝ) : ℂ) * ((r⁻¹ : ℝ) : ℂ) * (m : ℂ) = 1 := by
    rw [Complex.conj_ofReal]
    norm_cast
    rw [← hsq]
    field_simp [hr]
  change inner ℂ
    (((r⁻¹ : ℝ) : ℂ) • MultilinearMap.alternatization (tprod ℂ) x)
    (((r⁻¹ : ℝ) : ℂ) • MultilinearMap.alternatization (tprod ℂ) y) = _
  rw [inner_smul_left, inner_smul_right, inner_alternatization_tprod_eq_factorial_det]
  rw [← mul_assoc, ← mul_assoc, hcoeff, one_mul]

end PiTensorProduct
