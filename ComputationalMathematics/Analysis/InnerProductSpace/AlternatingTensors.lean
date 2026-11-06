/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.PiTensorProduct
import Mathlib.LinearAlgebra.Alternating.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt

/-!
# Norms of alternating tensors

For an orthonormal family, the pure tensors indexed by permutations are
orthonormal in the product Hilbert structure. Consequently the existing
`MultilinearMap.alternatization` of `PiTensorProduct.tprod` has norm
`sqrt (Nat.factorial (Fintype.card ι))`. Multiplication by the inverse square root gives
norm one. The finite index type may be empty; no dimension or arity lower
bound is assumed.

All tensor norm and inner-product structures are the explicitly named
product Hilbert structures, selected only locally in this module.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

noncomputable section

open scoped BigOperators ComplexConjugate

namespace PiTensorProduct

variable {ι H : Type*} [Fintype ι] [DecidableEq ι] [NormedAddCommGroup H]
  [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]

local instance : NormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedAddCommGroup
local instance : SeminormedAddCommGroup (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productSeminormedAddCommGroup
local instance : InnerProductSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productInnerProductSpace
local instance : NormedSpace ℂ (PiTensorProduct ℂ (fun _ : ι => H)) :=
  productNormedSpace

omit [DecidableEq ι] in
/-- Distinct permutations of an orthonormal family give orthonormal pure
tensors in the actual product Hilbert tensor quotient. -/
theorem orthonormal_permuted_tprod {x : ι → H} (hx : Orthonormal ℂ x) :
    Orthonormal ℂ (fun σ : Equiv.Perm ι => tprod ℂ (fun i => x (σ i))) := by
  classical
  apply orthonormal_iff_ite.mpr
  intro σ τ
  rw [inner_tprod]
  simp_rw [orthonormal_iff_ite.mp hx]
  by_cases h : σ = τ
  · subst τ
    simp
  · rw [if_neg h]
    obtain ⟨i, hi⟩ := DFunLike.ne_iff.mp h
    exact Finset.prod_eq_zero (Finset.mem_univ i) (if_neg hi)

/-- The self inner product of the unnormalized algebraic alternatization
is the number of permutations. This reuses Mathlib's alternatization and
weighted orthonormal-sum identity. -/
theorem inner_alternatization_tprod_self {x : ι → H} (hx : Orthonormal ℂ x) :
    inner ℂ (MultilinearMap.alternatization (tprod ℂ) x)
      (MultilinearMap.alternatization (tprod ℂ) x) = (Nat.factorial (Fintype.card ι) : ℂ) := by
  have hexpand : MultilinearMap.alternatization (tprod ℂ) x =
      ∑ σ : Equiv.Perm ι, (((Equiv.Perm.sign σ : ℤ) : ℂ) •
        tprod ℂ (fun i => x (σ i))) := by
    rw [MultilinearMap.alternatization_apply]
    apply Finset.sum_congr rfl
    intro σ _
    rcases Int.units_eq_one_or (Equiv.Perm.sign σ) with h | h <;>
      simp [h, Units.smul_def]
  rw [hexpand]
  have hinner := (orthonormal_permuted_tprod hx).inner_sum
    (fun σ => ((Equiv.Perm.sign σ : ℤ) : ℂ))
    (fun σ => ((Equiv.Perm.sign σ : ℤ) : ℂ)) Finset.univ
  rw [hinner]
  have hsign (σ : Equiv.Perm ι) :
      conj ((Equiv.Perm.sign σ : ℤ) : ℂ) * ((Equiv.Perm.sign σ : ℤ) : ℂ) = 1 := by
    rcases Int.units_eq_one_or (Equiv.Perm.sign σ) with h | h <;> simp [h]
  simp only [hsign]
  simp [Fintype.card_perm]

/-- The norm of the existing alternatization of the tensor multilinear
map, for any finite orthonormal family. -/
theorem norm_alternatization_tprod {x : ι → H} (hx : Orthonormal ℂ x) :
    ‖MultilinearMap.alternatization (tprod ℂ) x‖ =
      Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ) := by
  rw [@norm_eq_sqrt_re_inner ℂ, inner_alternatization_tprod_self hx]
  simp

/-- Inverse-square-root-factorial normalization makes the alternatization
of an orthonormal family a unit tensor. This includes the internal empty
family, whose pure tensor is the scalar unit. -/
theorem norm_normalized_alternatization_tprod {x : ι → H} (hx : Orthonormal ℂ x) :
    ‖(((Real.sqrt (Nat.factorial (Fintype.card ι) : ℝ))⁻¹ : ℝ) : ℂ) •
        MultilinearMap.alternatization (tprod ℂ) x‖ = 1 := by
  have hpos : (0 : ℝ) < Nat.factorial (Fintype.card ι) := by
    exact_mod_cast Nat.factorial_pos (Fintype.card ι)
  rw [norm_smul, norm_alternatization_tprod hx]
  simp [Real.sqrt_ne_zero'.mpr hpos, abs_of_nonneg (Real.sqrt_nonneg _)]

end PiTensorProduct
