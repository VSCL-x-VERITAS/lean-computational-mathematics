import ComputationalMathematics.HDP.Vector.GaussianMixtureProjectionEnergy

/-! Ordinary finite projection-margin counts and their deterministic transfer. -/
noncomputable section
open Matrix
open scoped BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- Indices where the actual projection of a fixed error direction consumes a margin. -/
def projectionMarginIndices {m n : ℕ} (X : Fin m → Fin n → ℝ)
    (d : Fin n → ℝ) (τ : ℝ) : Set (Fin m) :=
  {i | τ ≤ |dotProduct d (X i)|}

/-- The finite margin count is bounded by the actual squared projections. -/
theorem ncard_projectionMargin_mul_margin_sq_le {m n : ℕ}
    (X : Fin m → Fin n → ℝ) (d : Fin n → ℝ) (τ : ℝ) (hτ : 0 ≤ τ) :
    (Set.ncard (projectionMarginIndices X d τ) : ℝ) * τ ^ 2 ≤
      ∑ i, dotProduct d (X i) ^ 2 := by
  classical
  let U := projectionMarginIndices X d τ
  have hpoint : ∀ i ∈ U.toFinset, τ ^ 2 ≤ dotProduct d (X i) ^ 2 := by
    intro i hi
    have hiU : i ∈ projectionMarginIndices X d τ := by simpa [U] using hi
    change τ ≤ |dotProduct d (X i)| at hiU
    nlinarith [sq_abs (dotProduct d (X i))]
  have hsum := Finset.card_nsmul_le_sum U.toFinset
    (fun i ↦ dotProduct d (X i) ^ 2) (τ ^ 2) hpoint
  calc
    (Set.ncard (projectionMarginIndices X d τ) : ℝ) * τ ^ 2 ≤
        ∑ i ∈ U.toFinset, dotProduct d (X i) ^ 2 := by
      simpa [U, Set.ncard_eq_toFinset_card', nsmul_eq_mul] using hsum
    _ ≤ ∑ i : Fin m, dotProduct d (X i) ^ 2 := by
      exact Finset.sum_le_sum_of_subset_of_nonneg
        (by intro i _; simp) (by intro i _ _; positivity)

/-- Half-budget control from the fixed-direction covariance energy bound. -/
theorem ncard_projectionMargin_le_half_budget_of_sampleSecondMoment_deviation
    {m n : ℕ} (hm : 0 < m) (X : Fin m → Fin n → ℝ)
    (mean d : Fin n → ℝ) (τ ε : ℝ) (hτ : 0 < τ)
    (hbudget :
      (1 + NumStability.vecNorm2 mean ^ 2 +
        NumStability.realMatrixOperatorNorm
          (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean)) *
        NumStability.vecNorm2 d ^ 2 ≤ ε / 2 * τ ^ 2) :
    (Set.ncard (projectionMarginIndices X d τ) : ℝ) ≤ ε * m / 2 := by
  have hcard := ncard_projectionMargin_mul_margin_sq_le X d τ hτ.le
  have henergy := sum_dotProduct_sq_le_of_sampleSecondMoment_deviation hm X mean d
  have hscaled := mul_le_mul_of_nonneg_left hbudget (Nat.cast_nonneg m)
  have hτsq := sq_pos_of_pos hτ
  nlinarith

/-- Only an ideal margin error or an actual projection perturbation can change a sign. -/
theorem misclassifiedIndices_subset_idealMarginErrors_union_projectionMargin
    {m n : ℕ} (labels : Fin m → ℝ) (u v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) (s τ : ℝ)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1) :
    misclassifiedIndices labels (s • v) X ⊆
      idealMarginErrors labels u X τ ∪ projectionMarginIndices X (u - s • v) τ := by
  intro i hi
  by_contra hnot
  rw [Set.mem_union, not_or] at hnot
  have hideal : τ < labels i * dotProduct u (X i) := lt_of_not_ge hnot.1
  have herr : |dotProduct (u - s • v) (X i)| < τ := lt_of_not_ge hnot.2
  rw [sub_dotProduct] at herr
  have hbounds := abs_lt.mp herr
  change labels i * dotProduct (s • v) (X i) ≤ 0 at hi
  rcases hlabels i with h | h <;> rw [h] at hi hideal <;>
    norm_num at hi hideal hbounds <;> linarith

/-- Deterministic classification transfer using the actual error direction, without a trace. -/
theorem makesAtMostErrorsUpToSign_of_margin_and_projection_energy
    {m n : ℕ} (hm : 0 < m) (labels : Fin m → ℝ)
    (u v : Fin n → ℝ) (X : Fin m → Fin n → ℝ)
    (s τ ε : ℝ) (hs : s = -1 ∨ s = 1)
    (hlabels : ∀ i, labels i = -1 ∨ labels i = 1) (hτ : 0 < τ)
    (hideal : (Set.ncard (idealMarginErrors labels u X τ) : ℝ) ≤ ε * m / 2)
    (hbudget :
      (1 + NumStability.vecNorm2 u ^ 2 +
        NumStability.realMatrixOperatorNorm
          (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment u)) *
        NumStability.vecNorm2 (u - s • v) ^ 2 ≤ ε / 2 * τ ^ 2) :
    MakesAtMostErrorsUpToSign labels v X (ε * m) := by
  refine ⟨s, hs, ?_⟩
  have hprojection := ncard_projectionMargin_le_half_budget_of_sampleSecondMoment_deviation
    hm X u (u - s • v) τ ε hτ hbudget
  have hcard : Set.ncard (misclassifiedIndices labels (s • v) X) ≤
      Set.ncard (idealMarginErrors labels u X τ) +
        Set.ncard (projectionMarginIndices X (u - s • v) τ) :=
    (Set.ncard_le_ncard (misclassifiedIndices_subset_idealMarginErrors_union_projectionMargin
      labels u v X s τ hlabels)).trans (Set.ncard_union_le _ _)
  have hcardR : (Set.ncard (misclassifiedIndices labels (s • v) X) : ℝ) ≤
      (Set.ncard (idealMarginErrors labels u X τ) : ℝ) +
        (Set.ncard (projectionMarginIndices X (u - s • v) τ) : ℝ) := by exact_mod_cast hcard
  linarith

end NumStability.HDP.Vector.GaussianMixture
