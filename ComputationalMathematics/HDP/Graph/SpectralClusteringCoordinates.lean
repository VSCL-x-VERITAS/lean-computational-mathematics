import ComputationalMathematics.HDP.Graph.SpectralClustering

/-!
# Coordinate certificate for the selected second eigenvector

The existing complete decreasing orthonormal eigenbasis is expressed through
ordinary real coordinates. Reconstruction and the matrix-vector equations
expose completeness and matrix action, while slot 1 counts multiplicity.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Graph.SpectralClustering

/-- Ordinary coordinate identities for a complete decreasing eigendecomposition
whose second slot is the existing selected vector. -/
theorem secondEigenvector_coordinateOrderedCertificate {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) (hn : 1 < n) :
    ∃ (eigenvalue : Fin n → ℝ) (b : Fin n → Fin n → ℝ),
      (∀ i j, i.val ≤ j.val → eigenvalue j ≤ eigenvalue i) ∧
      (∀ i j, (∑ k, b i k * b j k) = if i = j then 1 else 0) ∧
      (∀ x : Fin n → ℝ, ∀ j, (∑ i, (∑ k, b i k * x k) * b i j) = x j) ∧
      (∀ i j, (∑ k, A j k * b i k) = eigenvalue i * b i j) ∧
      (∀ j, secondEigenvector A hA hn j = b ⟨1, hn⟩ j) := by
  rcases secondEigenvector_completeOrderedCertificate A hA hn with
    ⟨eigenvalue, B, hanti, heigen, hselected⟩
  let b : Fin n → Fin n → ℝ := fun i ↦ WithLp.ofLp (B i)
  refine ⟨eigenvalue, b, ?_, ?_, ?_, ?_, ?_⟩
  · intro i j hij
    exact hanti hij
  · intro i j
    have h := (orthonormal_iff_ite.mp B.orthonormal) i j
    simpa [b, PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using h
  · intro x j
    have h := congrArg (fun y : EuclideanSpace ℝ (Fin n) ↦ y j)
      (B.sum_repr' (WithLp.toLp 2 x))
    simpa [b, PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, mul_comm] using h
  · intro i j
    have h := congrArg (fun y : EuclideanSpace ℝ (Fin n) ↦ y j) (heigen i)
    simpa [b, Matrix.toLpLin_apply, Matrix.mulVec, dotProduct] using h
  · intro j
    exact congrArg (fun y : EuclideanSpace ℝ (Fin n) ↦ y j) hselected

end NumStability.HDP.Graph.SpectralClustering
