/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.LinearAlgebra.Finsupp.LinearCombination

/-!
# Orthonormal families with the same prefix spans

Two finite ordered orthonormal families determine the same flag of prefix
spans precisely up to a scalar of norm one at each index. The classification
below needs no ambient dimension or spanning hypothesis.
-/

set_option autoImplicit false
open scoped BigOperators

namespace NumStability

variable {𝕜 H : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]

/-- Equal prefix spans of finite orthonormal families force their vectors
to differ only by independent unit scalar phases, including the empty case. -/
theorem exists_unit_phases_of_orthonormal_prefix_spans {n : ℕ} (q r : Fin n → H)
    (hq : Orthonormal 𝕜 q) (hr : Orthonormal 𝕜 r)
    (hspan : ∀ k, Submodule.span 𝕜 (q '' Set.Iic k) =
      Submodule.span 𝕜 (r '' Set.Iic k)) :
    ∃ c : Fin n → 𝕜, (∀ i, ‖c i‖ = 1) ∧ ∀ i, q i = c i • r i := by
  classical
  have orth_span (v : Fin n → H) (hv : Orthonormal 𝕜 v) (j : Fin n)
      (s : Set (Fin n)) (hj : ∀ k ∈ s, j ≠ k) (x : H)
      (hx : x ∈ Submodule.span 𝕜 (v '' s)) : inner 𝕜 (v j) x = 0 := by
    induction hx using Submodule.span_induction with
    | mem x hx =>
      obtain ⟨k, hk, rfl⟩ := hx
      exact hv.inner_eq_zero (hj k hk)
    | zero => exact inner_zero_right _
    | add x y _ _ hx hy => simp only [inner_add_right, hx, hy, add_zero]
    | smul a x _ hx => rw [inner_smul_right, hx, mul_zero]
  have hdiag (i : Fin n) : q i = inner 𝕜 (r i) (q i) • r i := by
    have hqi : q i ∈ Submodule.span 𝕜 (r '' Set.Iic i) := by
      rw [← hspan i]
      exact Submodule.subset_span ⟨i, Set.mem_Iic.mpr le_rfl, rfl⟩
    have hfull : q i ∈ Submodule.span 𝕜 (Set.range r) := by
      apply Submodule.span_mono (s := r '' Set.Iic i) (t := Set.range r) ?_ hqi
      rintro _ ⟨j, _, rfl⟩
      exact ⟨j, rfl⟩
    obtain ⟨a, ha⟩ := (Submodule.mem_span_range_iff_exists_fun 𝕜).mp hfull
    have coeff (j : Fin n) : a j = inner 𝕜 (r j) (q i) := by
      rw [← ha, hr.inner_right_fintype]
    have offdiag (j : Fin n) (hji : j ≠ i) : a j = 0 := by
      rw [coeff j]
      rcases lt_or_gt_of_ne hji with hlt | hgt
      · have hrj : r j ∈ Submodule.span 𝕜 (q '' Set.Iic j) := by
          rw [hspan j]
          exact Submodule.subset_span ⟨j, Set.mem_Iic.mpr le_rfl, rfl⟩
        rw [inner_eq_zero_symm]
        exact orth_span q hq i (Set.Iic j)
          (fun k hk => ne_of_gt (lt_of_le_of_lt hk hlt)) (r j) hrj
      · exact orth_span r hr j (Set.Iic i)
          (fun k hk => ne_of_gt (lt_of_le_of_lt hk hgt)) (q i) hqi
    have hsum : (∑ j, a j • r j) = a i • r i := by
      apply Finset.sum_eq_single_of_mem i (Finset.mem_univ i)
      intro j _ hji
      rw [offdiag j hji, zero_smul]
    exact ha.symm.trans (hsum.trans (by rw [coeff i]))
  refine ⟨fun i => inner 𝕜 (r i) (q i), ?_, hdiag⟩
  intro i
  have hn := congrArg norm (hdiag i)
  simpa only [hq.norm_eq_one i, norm_smul, hr.norm_eq_one i, mul_one] using hn.symm

end NumStability
