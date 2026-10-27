/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.Reindex
import Mathlib.Analysis.Normed.Group.InfiniteSum
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Topology.Algebra.InfiniteSum.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# Bounded scalar pairings on ℓ¹

The weighted infinite sum defines a continuous linear functional for any
index type and real coefficient family bounded by one.
-/

namespace NumStability

noncomputable section

variable {ι : Type*}

/-- The coordinate norms of an ℓ¹ sequence sum to its norm. -/
theorem lp_one_hasSum_norm (u : lp (fun _ : ι => ℝ) 1) :
    HasSum (fun i => ‖u i‖) ‖u‖ := by
  simpa using lp.hasSum_norm (p := 1) (by norm_num) u

/-- Coefficients bounded by one preserve absolute summability. -/
theorem lp_one_weighted_summable (coeff : ι → ℝ)
    (hc : ∀ i, ‖coeff i‖ ≤ 1) (u : lp (fun _ : ι => ℝ) 1) :
    Summable (fun i => coeff i * u i) := by
  apply (lp_one_hasSum_norm u).summable.of_norm_bounded
  intro i
  rw [norm_mul]
  exact mul_le_of_le_one_left (norm_nonneg _) (hc i)

/-- Pairing with coefficients bounded by one is norm decreasing. -/
theorem lp_one_weighted_tsum_norm_le (coeff : ι → ℝ)
    (hc : ∀ i, ‖coeff i‖ ≤ 1) (u : lp (fun _ : ι => ℝ) 1) :
    ‖∑' i, coeff i * u i‖ ≤ ‖u‖ := by
  have h := lp_one_weighted_summable coeff hc u
  have hn := lp_one_hasSum_norm u
  calc
    ‖∑' i, coeff i * u i‖ ≤ ∑' i, ‖coeff i * u i‖ := norm_tsum_le_tsum_norm h.norm
    _ ≤ ∑' i, ‖u i‖ := by
      refine h.norm.tsum_le_tsum ?_ hn.summable
      intro i
      rw [norm_mul]
      exact mul_le_of_le_one_left (norm_nonneg _) (hc i)
    _ = ‖u‖ := hn.tsum_eq

/-- Pair an ℓ¹ sequence with a fixed bounded scalar coefficient family. -/
def lpOnePairing (coeff : ι → ℝ) (hc : ∀ i, ‖coeff i‖ ≤ 1) :
    lp (fun _ : ι => ℝ) 1 →L[ℝ] ℝ :=
  LinearMap.mkContinuous
    { toFun := fun u => ∑' i, coeff i * u i
      map_add' := by
        intro u v
        simp only [lp.coeFn_add, Pi.add_apply, mul_add]
        exact (lp_one_weighted_summable coeff hc u).tsum_add
          (lp_one_weighted_summable coeff hc v)
      map_smul' := by
        intro a u
        simp only [lp.coeFn_smul, Pi.smul_apply, smul_eq_mul, RingHom.id_apply]
        rw [← tsum_mul_left]
        congr 1
        funext i
        ring }
    1 (by intro u; simpa using lp_one_weighted_tsum_norm_le coeff hc u)


/-- The continuous pairing is the weighted infinite sum. -/
@[simp] theorem lpOnePairing_apply (coeff : ι → ℝ)
    (hc : ∀ i, ‖coeff i‖ ≤ 1) (u : lp (fun _ : ι => ℝ) 1) :
    lpOnePairing coeff hc u = ∑' i, coeff i * u i := rfl

/-- An eigenrelation on the coefficients intertwines reindexing and the pairing. -/
theorem lpOnePairing_reindex (coeff : ι → ℝ)
    (hc : ∀ i, ‖coeff i‖ ≤ 1) (e : ι ≃ ι) (eigenvalue : ℝ)
    (heigen : ∀ i, coeff (e.symm i) = eigenvalue * coeff i)
    (u : lp (fun _ : ι => ℝ) 1) :
    lpOnePairing coeff hc (lpReindex e u) =
      eigenvalue * lpOnePairing coeff hc u := by
  simp only [lpOnePairing_apply, lpReindex_apply]
  calc
    (∑' i, coeff i * u (e i)) = ∑' i, coeff (e.symm i) * u i := by
      simpa only [Equiv.symm_apply_apply] using
        e.tsum_eq (fun i => coeff (e.symm i) * u i)
    _ = ∑' i, eigenvalue * (coeff i * u i) := by
      apply tsum_congr
      intro i
      rw [heigen i]
      ring
    _ = eigenvalue * ∑' i, coeff i * u i := tsum_mul_left

end
end NumStability
