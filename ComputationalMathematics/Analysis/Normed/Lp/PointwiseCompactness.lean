/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Topology.Sequences
import Mathlib.Topology.Instances.Real.Lemmas

/-!
# Pointwise compactness of bounded real ℓ² sequences

On a countable index set, the coordinatewise limit of a suitable subsequence of
any norm-bounded ℓ² sequence remains in ℓ² with the same norm bound.
-/

namespace NumStability

open Filter
open scoped Topology

/-- A norm-bounded sequence in real ℓ² on countably many coordinates has a
pointwise convergent subsequence with an ℓ² limit and the same norm bound. -/
theorem l2_exists_pointwise_convergent_subseq {ι : Type*} [Countable ι]
    (F : ℕ → lp (fun _ : ι => ℝ) 2) (B : ℝ) (hF : ∀ k, ‖F k‖ ≤ B) :
    ∃ f : lp (fun _ : ι => ℝ) 2, ‖f‖ ≤ B ∧
      ∃ φ : ℕ → ℕ, StrictMono φ ∧
        ∀ i, Tendsto (fun k => F (φ k) i) atTop (𝓝 (f i)) := by
  let box : Set (ι → ℝ) := {u | ∀ i, u i ∈ Set.Icc (-B) B}
  have hcompact : IsCompact box := isCompact_pi_infinite (fun _ => isCompact_Icc)
  have hmem (k : ℕ) : (fun i => F k i) ∈ box := by
    intro i
    apply abs_le.mp
    exact (show |F k i| ≤ ‖F k‖ by
      simpa only [Real.norm_eq_abs] using
        lp.norm_apply_le_norm (by norm_num : (2 : ENNReal) ≠ 0) (F k) i).trans (hF k)
  obtain ⟨f, _, φ, hφ, hlimit⟩ := hcompact.tendsto_subseq hmem
  have hbounded : Bornology.IsBounded (Set.range (fun k => F (φ k))) := by
    apply isBounded_iff_forall_norm_le.mpr
    refine ⟨B, ?_⟩
    rintro _ ⟨k, rfl⟩
    exact hF (φ k)
  have hpointwise : Tendsto (fun k => fun i => F (φ k) i) atTop (𝓝 f) := hlimit
  have hmemlp : Memℓp f 2 := lp.memℓp_of_tendsto hbounded hpointwise
  let result : lp (fun _ : ι => ℝ) 2 := ⟨f, hmemlp⟩
  refine ⟨result, ?_, φ, hφ, ?_⟩
  · exact lp.norm_le_of_tendsto (Eventually.of_forall (fun k => hF (φ k))) hpointwise
  · exact tendsto_pi_nhds.mp hpointwise

end NumStability
