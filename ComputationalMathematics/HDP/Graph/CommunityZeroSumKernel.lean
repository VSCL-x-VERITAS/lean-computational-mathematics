import ComputationalMathematics.HDP.Graph.StochasticBlock
import ComputationalMathematics.HDP.Graph.CommunityZeroSumDimension
import Mathlib.LinearAlgebra.Eigenspace.Basic

/-!
# Community zero-sum kernel of the balanced block expectation

For nonempty communities and `0 ≤ q < p`, the rank-two expected-adjacency
matrix has kernel exactly equal to the vectors whose coordinates sum to zero
separately in both communities.
-/

noncomputable section

open Matrix

namespace NumStability.HDP.Graph.StochasticBlock

theorem expectedAdjacency_mulVec_eq_zero_of_community_sums
    (k : ℕ) (p q : ℝ) (x : Vertex k → ℝ)
    (hx : ∀ c : Fin 2, ∑ a : Fin k, x (c, a) = 0) :
    (expectedAdjacency k p q).mulVec x = 0 := by
  funext i
  simp only [Matrix.mulVec, dotProduct, expectedAdjacency]
  rw [Fintype.sum_prod_type, Fin.sum_univ_two]
  have hi : i.1 = 0 ∨ i.1 = 1 := by
    rcases Nat.le_one_iff_eq_zero_or_eq_one.mp
        (Nat.le_of_lt_succ i.1.isLt) with h | h
    · exact Or.inl (Fin.ext h)
    · exact Or.inr (Fin.ext h)
  rcases hi with hi | hi
  · simp only [hi, Fin.isValue, if_pos]
    rw [← Finset.mul_sum, ← Finset.mul_sum, hx 0, hx 1]
    simp
  · simp only [hi, Fin.isValue, if_pos]
    rw [← Finset.mul_sum, ← Finset.mul_sum, hx 0, hx 1]
    simp

theorem finrank_expectedAdjacency_kernel {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    Module.finrank ℝ (LinearMap.ker (expectedAdjacency k p q).mulVecLin) =
      2 * k - 2 := by
  have hrank :
      Module.finrank ℝ (LinearMap.range (expectedAdjacency k p q).mulVecLin) = 2 := by
    simpa only [Matrix.rank] using
      (expectedAdjacency_rank_eq_two (k := k) hk (p := p) (q := q) hq hpq)
  have htotal : Module.finrank ℝ (Vertex k → ℝ) = 2 * k := by
    simp only [Vertex, Module.finrank_fintype_fun_eq_card,
      Fintype.card_prod, Fintype.card_fin]
  have hdim := LinearMap.finrank_range_add_finrank_ker
    (expectedAdjacency k p q).mulVecLin
  rw [hrank, htotal] at hdim
  exact Nat.eq_sub_of_add_eq' hdim

theorem expectedAdjacency_kernel_eq_communityZeroSumSubspace
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    LinearMap.ker (expectedAdjacency k p q).mulVecLin =
      communityZeroSumSubspace k := by
  have hle : communityZeroSumSubspace k ≤
      LinearMap.ker (expectedAdjacency k p q).mulVecLin := by
    intro x hx
    change (expectedAdjacency k p q).mulVec x = 0
    exact expectedAdjacency_mulVec_eq_zero_of_community_sums k p q x
      ((mem_communityZeroSumSubspace k x).mp hx)
  apply (Submodule.eq_of_le_of_finrank_eq hle ?_).symm
  rw [finrank_communityZeroSumSubspace hk,
    finrank_expectedAdjacency_kernel hk hq hpq]

/-- After subtracting the within-community diagonal, the `-p` eigenvector
equation holds exactly on the community zero-sum subspace. -/
theorem expectedAdjacency_sub_diagonal_eigenvector_iff_zero_sum
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p)
    (x : Vertex k → ℝ) :
    ((expectedAdjacency k p q - p • 1).mulVec x = (-p) • x) ↔
      x ∈ communityZeroSumSubspace k := by
  have hmembership :
      (expectedAdjacency k p q).mulVec x = 0 ↔
        x ∈ communityZeroSumSubspace k := by
    rw [← expectedAdjacency_kernel_eq_communityZeroSumSubspace hk hq hpq]
    change (expectedAdjacency k p q).mulVec x = 0 ↔
      (expectedAdjacency k p q).mulVec x = 0
    rfl
  rw [← hmembership, Matrix.sub_mulVec, Matrix.smul_mulVec,
    Matrix.one_mulVec]
  constructor
  · intro h
    calc
      (expectedAdjacency k p q).mulVec x =
          ((expectedAdjacency k p q).mulVec x - p • x) + p • x := by abel
      _ = (-p) • x + p • x := by rw [h]
      _ = 0 := by simp [neg_smul]
  · intro h
    simp [h, neg_smul]

/-- The residual `-p` eigenspace is exactly the community zero-sum subspace. -/
theorem expectedAdjacency_sub_diagonal_eigenspace_eq_zero_sum
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    Module.End.eigenspace (expectedAdjacency k p q - p • 1).mulVecLin (-p) =
      communityZeroSumSubspace k := by
  ext x
  simpa only [Module.End.mem_eigenspace_iff, Matrix.mulVecLin_apply] using
    (expectedAdjacency_sub_diagonal_eigenvector_iff_zero_sum hk hq hpq x)

/-- The geometric multiplicity of the residual eigenvalue is `2*k-2`.
For singleton communities this is zero, so the residual eigenvalue is absent. -/
theorem finrank_expectedAdjacency_sub_diagonal_eigenspace
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    Module.finrank ℝ
      (Module.End.eigenspace (expectedAdjacency k p q - p • 1).mulVecLin (-p)) =
      2 * k - 2 := by
  rw [expectedAdjacency_sub_diagonal_eigenspace_eq_zero_sum hk hq hpq]
  exact finrank_communityZeroSumSubspace hk

/-- The residual value `-p` is an eigenvalue exactly when each community has
at least two vertices. Singleton communities have no residual direction. -/
theorem expectedAdjacency_sub_diagonal_has_residual_eigenvalue_iff
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    Module.End.HasEigenvalue (expectedAdjacency k p q - p • 1).mulVecLin (-p) ↔
      1 < k := by
  rw [Module.End.hasEigenvalue_iff,
    expectedAdjacency_sub_diagonal_eigenspace_eq_zero_sum hk hq hpq]
  constructor
  · intro hne
    obtain ⟨x, hx, hxne⟩ :=
      (Submodule.ne_bot_iff (communityZeroSumSubspace k)).mp hne
    have hpos : 0 < Module.finrank ℝ (communityZeroSumSubspace k) :=
      Module.finrank_pos_iff_exists_ne_zero.mpr
        ⟨⟨x, hx⟩, by simpa using hxne⟩
    rw [finrank_communityZeroSumSubspace hk] at hpos
    omega
  · intro hk2 hbot
    have hdim := finrank_communityZeroSumSubspace hk
    rw [hbot, finrank_bot] at hdim
    omega

end NumStability.HDP.Graph.StochasticBlock
