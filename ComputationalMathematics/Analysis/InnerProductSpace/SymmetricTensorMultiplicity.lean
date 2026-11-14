/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.SymmetricTensorInnerProducts
import ComputationalMathematics.Analysis.Matrix.PermanentMultiplicity
import Mathlib.Analysis.InnerProductSpace.Orthonormal

/-!
# Multiplicity norms of symmetric tensors

A normalized unsigned permutation sum of an orthonormal family, with labels
allowed to repeat, has squared norm equal to the product of the factorials
of the label multiplicities. An additional inverse-square-root of this
product makes the tensor a unit vector.

The tensors live in the actual `PiTensorProduct` quotient with the four named
product Hilbert structures. The statements allow every finite index type,
including the empty type; no ordering, rank or positive-dimension hypothesis
is needed. They assert the norm calculation, not a spanning or basis theorem.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators

namespace PiTensorProduct

variable {ι α H : Type*} [Fintype ι] [DecidableEq ι] [Fintype α] [DecidableEq α]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

private local instance multiplicityProductNormedAddCommGroup :
    NormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedAddCommGroup
private local instance multiplicityProductSeminormedAddCommGroup :
    SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productSeminormedAddCommGroup
private local instance multiplicityProductInnerProductSpace :
    InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productInnerProductSpace
private local instance multiplicityProductNormedSpace :
    NormedSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedSpace

/-- Repetitions in an orthonormal family contribute exactly the factorials
of their multiplicities to the squared symmetric tensor norm. -/
theorem norm_sq_normalized_sum_permuted_tprod_orthonormal
    (v : α → H) (hv : Orthonormal ℂ v) (f : ι → α) :
    ‖((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
      ∑ σ : Equiv.Perm ι, tprod ℂ (fun i => v (f (σ i))))‖ ^ 2 =
      (((∏ a : α, Nat.factorial (Fintype.card {i // f i = a})) : ℕ) : ℝ) := by
  rw [norm_sq_eq_re_inner (𝕜 := ℂ),
    inner_normalized_sum_permuted_tprod_eq_permanent
      (fun i => v (f i)) (fun i => v (f i))]
  simp_rw [orthonormal_iff_ite.mp hv]
  rw [Matrix.permanent_ite_eq_prod_factorial_card_fiber]
  exact Complex.natCast_re _

/-- The inverse square root of the fiber-factorial product is the additional
normalization that makes a repeated-orthonormal-family symmetric tensor unit. -/
theorem norm_multiplicity_normalized_sum_permuted_tprod_eq_one
    (v : α → H) (hv : Orthonormal ℂ v) (f : ι → α) :
    ‖(((Real.sqrt (((∏ a : α, Nat.factorial (Fintype.card {i // f i = a})) : ℕ) : ℝ))⁻¹ : ℝ) : ℂ) •
      ((((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        ∑ σ : Equiv.Perm ι, tprod ℂ (fun i => v (f (σ i))))‖ = 1 := by
  let z : PiTensorProduct ℂ (fun _ : ι => H) :=
    (((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
      ∑ σ : Equiv.Perm ι, tprod ℂ (fun i => v (f (σ i)))
  let m : ℕ := ∏ a : α, Nat.factorial (Fintype.card {i // f i = a})
  have hm : 0 < m := Finset.prod_pos (fun a _ => Nat.factorial_pos _)
  have hmR : (0 : ℝ) < m := by exact_mod_cast hm
  have hsq : ‖z‖ ^ 2 = (m : ℝ) :=
    norm_sq_normalized_sum_permuted_tprod_orthonormal v hv f
  have hn : ‖z‖ = Real.sqrt (m : ℝ) := by
    rw [← Real.sqrt_sq (norm_nonneg z), hsq]
  change ‖(((Real.sqrt (m : ℝ))⁻¹ : ℝ) : ℂ) • z‖ = 1
  rw [norm_smul, Complex.norm_real, Real.norm_eq_abs, abs_inv,
    abs_of_nonneg (Real.sqrt_nonneg _), hn,
    inv_mul_cancel₀ (Real.sqrt_ne_zero'.mpr hmR)]

end PiTensorProduct
