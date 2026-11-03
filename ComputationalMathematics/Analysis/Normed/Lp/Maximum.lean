/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Lp.lpSpace
import Mathlib.Data.Finset.Max
import Mathlib.Tactic.Linarith

/-!
# Attainment of a nonzero square-summable sequence's largest coordinate

Every positive superlevel is finite. A finite maximum above one nonzero
coordinate is therefore a global maximum, without a finite index set.
-/

namespace NumStability

/-- A nonzero square-summable sequence attains a positive global coordinate norm. -/
theorem l2_exists_norm_max_of_ne_zero {ι E : Type*} [NormedAddCommGroup E]
    (u : lp (fun _ : ι => E) 2) (hu : u ≠ 0) :
    ∃ i : ι, 0 < ‖u i‖ ∧ ∀ j : ι, ‖u j‖ ≤ ‖u i‖ := by
  classical
  obtain ⟨i₀, hi₀⟩ : ∃ i : ι, u i ≠ 0 := by
    by_contra! hzero
    apply hu
    ext i
    exact hzero i
  have hpos : 0 < ‖u i₀‖ := norm_pos_iff.mpr hi₀
  have hs : Summable (fun i => ‖u i‖ ^ (2 : ℕ)) := by
    simpa using (lp.memℓp u).summable (by norm_num : 0 < (2 : ENNReal).toReal)
  have hfinite : Set.Finite {i : ι | ‖u i₀‖ ^ 2 ≤ ‖u i‖ ^ 2} := by
    simpa using hs.tendsto_cofinite_zero.eventually_lt_const (sq_pos_of_pos hpos)
  have hi₀mem : i₀ ∈ hfinite.toFinset := by simp
  obtain ⟨i, hi, hmax⟩ := hfinite.toFinset.exists_max_image (fun j => ‖u j‖) ⟨i₀, hi₀mem⟩
  have hbase : ‖u i₀‖ ≤ ‖u i‖ := hmax i₀ hi₀mem
  refine ⟨i, hpos.trans_le hbase, ?_⟩
  intro j
  by_cases hj : j ∈ hfinite.toFinset
  · exact hmax j hj
  · have hlt : ‖u j‖ ^ 2 < ‖u i₀‖ ^ 2 := by
      simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq, not_le] using hj
    have hn := norm_nonneg (u j)
    nlinarith

end NumStability
