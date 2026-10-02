import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.Rank

/-!
# Real rectangular singular-value decompositions

A lightweight certificate for a real rectangular singular-value decomposition.
The certificate keeps the matrix rank, the ordered zero-extended singular-value
sequence, orthonormal left and right singular families, and the rank-one
reconstruction in one reusable proposition.
-/

namespace NumStability

open scoped BigOperators

/-- Certificate for a real `m × n` singular-value decomposition.

The singular values are indexed across all `n` source coordinates, arranged in
non-increasing order, and required to vanish from the rank onward. The singular
vector families are indexed only by the rank, so no arbitrary zero-singular-
value vectors are introduced. -/
structure IsRealMatrixSVD {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (r : ℕ) (s : Fin n → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin n)) : Prop where
  rank_eq : r = A.rank
  rank_le_width : r ≤ n
  singularValues_nonnegative : ∀ i, 0 ≤ s i
  singularValues_antitone : Antitone s
  singularValues_zero_of_rank_le : ∀ i, r ≤ i.1 → s i = 0
  leftSingularVectors_orthonormal : Orthonormal ℝ u
  rightSingularVectors_orthonormal : Orthonormal ℝ v
  reconstruction : ∀ i j,
    A i j = ∑ k : Fin r,
      s (Fin.castLE rank_le_width k) * u k i * v k j

/-- A real rectangular SVD certificate together with the left- and right-Gram
eigenvector equations.  The corresponding Gram eigenvalue is the square of the
nonnegative singular value, so this packages the usual square-root relation
without choosing a second eigenvalue indexing convention. -/
structure IsRealMatrixSVDWithGramEigenrelations {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (r : ℕ) (s : Fin n → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin n)) : Prop
    extends IsRealMatrixSVD A r s u v where
  leftGram_eigenvector : ∀ a i,
    (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * u a l) =
      (s (Fin.castLE rank_le_width a)) ^ 2 * u a i
  rightGram_eigenvector : ∀ a j,
    (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * v a l) =
      (s (Fin.castLE rank_le_width a)) ^ 2 * v a j

end NumStability
