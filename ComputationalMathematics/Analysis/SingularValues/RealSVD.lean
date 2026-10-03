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

/-- Coordinate spelling of all eight conditions in a real rectangular SVD.
The rank-width witness supplies the indices in the reconstruction; the two
orthonormality conditions use ordinary coordinate dot products. -/
def RealMatrixSVDExplicitFields {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (r : ℕ) (s : Fin n → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin n)) : Prop :=
  ∃ hwidth : r ≤ n,
    r = A.rank ∧
    (∀ i, 0 ≤ s i) ∧
    (∀ i j, i.val ≤ j.val → s j ≤ s i) ∧
    (∀ i, r ≤ i.val → s i = 0) ∧
    (∀ k l, (∑ a, u k a * u l a) = if k = l then 1 else 0) ∧
    (∀ k l, (∑ a, v k a * v l a) = if k = l then 1 else 0) ∧
    (∀ a b, A a b = ∑ k : Fin r,
      s (Fin.castLE hwidth k) * u k a * v k b)

/-- The coordinate conditions are necessary and sufficient for the existing
SVD certificate, with no additional rank or matrix-shape restriction. -/
theorem isRealMatrixSVD_iff_explicit_fields {m n r : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)} :
    IsRealMatrixSVD A r s u v ↔ RealMatrixSVDExplicitFields A r s u v := by
  have horth {d : ℕ} (w : Fin r → EuclideanSpace ℝ (Fin d)) :
      Orthonormal ℝ w ↔
        ∀ k l, (∑ a, w k a * w l a) = if k = l then 1 else 0 := by
    simp [orthonormal_iff_ite, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply, mul_comm]
  constructor
  · intro h
    exact ⟨h.rank_le_width, h.rank_eq, h.singularValues_nonnegative,
      fun i j hij ↦ h.singularValues_antitone hij,
      h.singularValues_zero_of_rank_le,
      (horth u).mp h.leftSingularVectors_orthonormal,
      (horth v).mp h.rightSingularVectors_orthonormal, h.reconstruction⟩
  · rintro ⟨hwidth, hrank, hnonneg, horder, hzero, hu, hv, hrec⟩
    exact ⟨hrank, hwidth, hnonneg, fun i j hij ↦ horder i j hij,
      hzero, (horth u).mpr hu, (horth v).mpr hv, hrec⟩

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
