import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Pi

/-!
# Community zero-sum dimension

The coordinate-sum map for two nonempty finite communities is surjective.
Its kernel has dimension `2 * k - 2`, including zero when `k = 1`.
The carrier agrees definitionally with the stochastic-block vertex carrier.
-/

noncomputable section

namespace NumStability.HDP.Graph

/-- The two sums of the coordinates inside each fixed community. -/
def communitySumMap (k : ℕ) :
    ((Fin 2 × Fin k) → ℝ) →ₗ[ℝ] (Fin 2 → ℝ) :=
  LinearMap.pi fun c : Fin 2 =>
    ∑ a : Fin k,
      (LinearMap.proj (c, a) :
        ((Fin 2 × Fin k) → ℝ) →ₗ[ℝ] ℝ)

@[simp]
theorem communitySumMap_apply (k : ℕ)
    (x : (Fin 2 × Fin k) → ℝ) (c : Fin 2) :
    communitySumMap k x c = ∑ a : Fin k, x (c, a) := by
  simp only [communitySumMap, LinearMap.pi_apply, LinearMap.sum_apply,
    LinearMap.proj_apply]

/-- Functions whose coordinate sums vanish separately in both communities. -/
def communityZeroSumSubspace (k : ℕ) :
    Submodule ℝ ((Fin 2 × Fin k) → ℝ) :=
  LinearMap.ker (communitySumMap k)

@[simp]
theorem mem_communityZeroSumSubspace (k : ℕ)
    (x : (Fin 2 × Fin k) → ℝ) :
    x ∈ communityZeroSumSubspace k ↔
      ∀ c : Fin 2, ∑ a : Fin k, x (c, a) = 0 := by
  change communitySumMap k x = 0 ↔
    ∀ c : Fin 2, ∑ a : Fin k, x (c, a) = 0
  simp only [funext_iff, communitySumMap_apply, Pi.zero_apply]

/-- Every pair of community sums is realized when each community is nonempty. -/
theorem communitySumMap_surjective {k : ℕ} (hk : 0 < k) :
    Function.Surjective (communitySumMap k) := by
  intro y
  let a0 : Fin k := ⟨0, hk⟩
  exact ⟨fun i : Fin 2 × Fin k => if i.2 = a0 then y i.1 else 0, by
    funext c
    rw [communitySumMap_apply]
    change (∑ a : Fin k, if a = a0 then y c else 0) = y c
    simp⟩

/-- The zero-sum complement has dimension `2 * k - 2`, including zero
dimension when `k = 1`. No probability or spectral assumptions are needed. -/
theorem finrank_communityZeroSumSubspace {k : ℕ} (hk : 0 < k) :
    Module.finrank ℝ (communityZeroSumSubspace k) = 2 * k - 2 := by
  have hrange : LinearMap.range (communitySumMap k) = ⊤ :=
    LinearMap.range_eq_top_of_surjective (communitySumMap k)
      (communitySumMap_surjective hk)
  have hdim := LinearMap.finrank_range_add_finrank_ker (communitySumMap k)
  rw [hrange, finrank_top] at hdim
  have hdim' :
      2 + Module.finrank ℝ (communityZeroSumSubspace k) = 2 * k := by
    simpa only [Module.finrank_fintype_fun_eq_card,
      Fintype.card_prod, Fintype.card_fin, communityZeroSumSubspace] using hdim
  exact Nat.eq_sub_of_add_eq' hdim'

end NumStability.HDP.Graph
