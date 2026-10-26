/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Lp.lpSpace
import Mathlib.Analysis.Normed.Module.Convex
import Mathlib.Tactic.Ring

/-!
# Reindexing summable and bounded sequences

An equivalence of indices acts isometrically on `ℓᵖ` sequences for `1 ≤ p`,
including `p = ∞`. This applies to translations of infinite uniform grids and
permutations of finite grids, with arbitrary real normed-space values.
Convex averaging with a reindexed copy gives a contractive linear operator.
-/

namespace NumStability

noncomputable section

private theorem lp_reindex_mem {ι κ E : Type*} [NormedAddCommGroup E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ κ) (u : lp (fun _ : κ => E) p) :
    Memℓp (fun i => u (e i)) p := by
  by_cases hp : p = ⊤
  · subst p
    obtain ⟨bound, hbound⟩ := (lp.memℓp u).bddAbove
    apply memℓp_infty
    refine ⟨bound, ?_⟩
    rintro value ⟨i, rfl⟩
    exact hbound ⟨e i, rfl⟩
  · have hpos : 0 < p.toReal := ENNReal.toReal_pos_iff.mpr
      ⟨lt_of_lt_of_le zero_lt_one (Fact.out : 1 ≤ p), lt_top_iff_ne_top.mpr hp⟩
    apply memℓp_gen
    exact (e.summable_iff (f := fun j => ‖u j‖ ^ p.toReal)).mpr
      ((lp.memℓp u).summable hpos)

/-- Pull back an `ℓᵖ` sequence along an equivalence without changing its norm. -/
def lpReindex {ι κ E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ κ) :
    lp (fun _ : κ => E) p ≃ₗᵢ[ℝ] lp (fun _ : ι => E) p := by
  let pull (u : lp (fun _ : κ => E) p) : lp (fun _ : ι => E) p :=
    ⟨fun i => u (e i), lp_reindex_mem e u⟩
  let push (u : lp (fun _ : ι => E) p) : lp (fun _ : κ => E) p :=
    ⟨fun j => u (e.symm j), lp_reindex_mem e.symm u⟩
  let equiv : lp (fun _ : κ => E) p ≃ₗ[ℝ] lp (fun _ : ι => E) p :=
    { toFun := pull
      invFun := push
      left_inv := fun u => by ext j; simp [pull, push]
      right_inv := fun u => by ext i; simp [pull, push]
      map_add' := fun u v => by ext i; rfl
      map_smul' := fun c u => by ext i; rfl }
  refine { equiv with norm_map' := ?_ }
  intro u
  by_cases hp : p = ⊤
  · subst p
    rw [lp.norm_eq_ciSup, lp.norm_eq_ciSup]
    exact e.iSup_comp (g := fun j => ‖u j‖)
  · have hpos : 0 < p.toReal := ENNReal.toReal_pos_iff.mpr
      ⟨lt_of_lt_of_le zero_lt_one (Fact.out : 1 ≤ p), lt_top_iff_ne_top.mpr hp⟩
    rw [lp.norm_eq_tsum_rpow hpos, lp.norm_eq_tsum_rpow hpos]
    congr 1
    exact e.tsum_eq (fun j => ‖u j‖ ^ p.toReal)

@[simp] theorem lpReindex_apply {ι κ E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ κ) (u : lp (fun _ : κ => E) p) (i : ι) :
    lpReindex e u i = u (e i) := rfl

/-- Average a sequence with a reindexed copy by a scalar weight. -/
def lpReindexAverage {ι E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ ι) (weight : ℝ) :
    lp (fun _ : ι => E) p →L[ℝ] lp (fun _ : ι => E) p :=
  (1 - weight) • ContinuousLinearMap.id ℝ _ +
    weight • (lpReindex e).toContinuousLinearEquiv.toContinuousLinearMap

@[simp] theorem lpReindexAverage_apply {ι E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ ι) (weight : ℝ)
    (u : lp (fun _ : ι => E) p) :
    lpReindexAverage e weight u = (1 - weight) • u + weight • lpReindex e u := rfl

/-- Convex averaging does not increase the sequence norm. -/
theorem lpReindexAverage_norm_le {ι E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ ι) {weight : ℝ}
    (hzero : 0 ≤ weight) (hone : weight ≤ 1) (u : lp (fun _ : ι => E) p) :
    ‖lpReindexAverage e weight u‖ ≤ ‖u‖ := by
  calc
    ‖lpReindexAverage e weight u‖ ≤ (1 - weight) * ‖u‖ + weight * ‖lpReindex e u‖ := by
      simpa only [lpReindexAverage_apply, smul_eq_mul] using
        convexOn_univ_norm.2 (Set.mem_univ u) (Set.mem_univ (lpReindex e u))
          (sub_nonneg.mpr hone) hzero (sub_add_cancel 1 weight)
    _ = ‖u‖ := by rw [(lpReindex e).norm_map]; ring

/-- The averaging operator does not amplify perturbations. -/
theorem lpReindexAverage_norm_sub_le {ι E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {p : ENNReal} [Fact (1 ≤ p)] (e : ι ≃ ι) {weight : ℝ}
    (hzero : 0 ≤ weight) (hone : weight ≤ 1) (u v : lp (fun _ : ι => E) p) :
    ‖lpReindexAverage e weight u - lpReindexAverage e weight v‖ ≤ ‖u - v‖ := by
  rw [← map_sub]
  exact lpReindexAverage_norm_le e hzero hone (u - v)

end
end NumStability
