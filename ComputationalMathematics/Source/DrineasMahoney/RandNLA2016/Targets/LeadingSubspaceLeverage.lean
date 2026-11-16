import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.LeadingSubspace

/-! # Leading-subspace leverage distribution

The footnote-e variant of equation (6) selects the first `k` left singular
vectors of a supplied compatible ordered SVD. Thus the matrix `A` and the
selected leading subspace are linked by reconstruction, rank and orthonormality,
rather than by an unspecified leading-subspace predicate. Choices at a repeated
singular value are fixed by the supplied SVD. An arbitrary orthonormal basis
of that fixed subspace is allowed, specified by equality of actual matrix-vector
image sets. Rank-deficient inputs are allowed.
-/

namespace NumStability.Source.DrineasMahoney.RandNLA2016.Targets

open scoped BigOperators

/-- Equation (6), footnote e: normalized leverage probabilities of one chosen
leading rank-`k` left singular subspace. The denominator is `k`. -/
def leadingSubspaceLeverageDistribution : Prop :=
  ∀ (m n : ℕ) (A : Matrix (Fin m) (Fin n) ℝ),
    0 < m → 0 < n →
    ∀ (k : ℕ) (_hkpos : 0 < k) (hk : k ≤ A.rank)
      (s : Fin n → ℝ)
      (u : Fin A.rank → EuclideanSpace ℝ (Fin m))
      (v : Fin A.rank → EuclideanSpace ℝ (Fin n)),
      IsRealMatrixSVD A A.rank s u v →
      ∀ W : Matrix (Fin m) (Fin k) ℝ,
        HasOrthonormalColumns W →
        Set.range W.mulVec = Set.range (leadingLeftSingularColumns u hk).mulVec →
        rowSqNormProbDen W = (k : ℝ) ∧
        (∀ i, 0 ≤ leverageScoreProb W i) ∧
        (∑ i : Fin m, leverageScoreProb W i) = 1 ∧
        (∀ i, leverageScoreProb W i = (∑ j : Fin k, W i j ^ 2) / (k : ℝ)) ∧
        ∀ i, leverageScoreProb W i = leadingLeftSingularProjector u hk i i / (k : ℝ)

end NumStability.Source.DrineasMahoney.RandNLA2016.Targets
