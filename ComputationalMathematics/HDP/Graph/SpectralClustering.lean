import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer

/-!
# Deterministic graph spectral clustering

For a symmetric adjacency matrix on at least two vertices, choose the ordered
second eigenvector and partition the vertices by the signs of its coordinates.
-/

noncomputable section

open Matrix Set

namespace NumStability.HDP.Graph.SpectralClustering

/-- The normalized eigenvector corresponding to the second largest ordered
eigenvalue of a symmetric adjacency matrix. -/
def secondEigenvector {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : A.IsHermitian) (hn : 1 < n) : EuclideanSpace ℝ (Fin n) :=
  NumStability.hermitianOrderedEigenbasis hA ⟨1, hn⟩

/-- Proof-transparent semantic certificate for a vector in the second slot of
a complete decreasing eigendecomposition.  Quantifying the ordered
eigenvalues together with their orthonormal eigenbasis makes both spectral
coverage and multiplicity explicit, without asking source-facing contracts to
trust an opaque choice of an eigenvalue enumeration. -/
def IsSecondOrderedEigenvector {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hn : 1 < n)
    (v : EuclideanSpace ℝ (Fin n)) : Prop :=
  ∃ (eigenvalue : Fin n → ℝ)
      (eigenbasis : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))),
    Antitone eigenvalue ∧
      (∀ i : Fin n,
        A.toEuclideanLin (eigenbasis i) = eigenvalue i • eigenbasis i) ∧
      v = eigenbasis ⟨1, hn⟩

/-- The selected graph-clustering vector carries the complete decreasing
eigendecomposition certificate used to interpret "second largest" with
multiplicity. -/
theorem secondEigenvector_completeOrderedCertificate {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) (hn : 1 < n) :
    IsSecondOrderedEigenvector A hn (secondEigenvector A hA hn) := by
  refine ⟨NumStability.hermitianOrderedEigenvalue hA,
    NumStability.hermitianOrderedEigenbasis hA,
    NumStability.hermitianOrderedEigenvalue_antitone hA, ?_, rfl⟩
  intro i
  exact NumStability.hermitianOrderedEigenbasis_apply hA i

/-- Vertices whose coefficient in the second eigenvector is positive. -/
def positiveCommunity {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : A.IsHermitian) (hn : 1 < n) : Set (Fin n) :=
  {j | 0 < secondEigenvector A hA hn j}

/-- Vertices whose coefficient in the second eigenvector is nonpositive. -/
def nonpositiveCommunity {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : A.IsHermitian) (hn : 1 < n) : Set (Fin n) :=
  {j | secondEigenvector A hA hn j ≤ 0}

/-- The selected vector is a unit eigenvector at the second ordered
eigenvalue. -/
theorem secondEigenvector_spec {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : A.IsHermitian) (hn : 1 < n) :
    ‖secondEigenvector A hA hn‖ = 1 ∧
      A.toEuclideanLin (secondEigenvector A hA hn) =
        NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ •
          secondEigenvector A hA hn := by
  constructor
  · exact (NumStability.hermitianOrderedEigenbasis hA).norm_eq_one ⟨1, hn⟩
  · exact NumStability.hermitianOrderedEigenbasis_apply hA ⟨1, hn⟩

/-- A transparent certificate that `secondEigenvector` really occupies the
second slot of the decreasing eigenvalue ordering: its eigenvalue is below
the leading value and above every value from the second slot onward. -/
theorem secondEigenvector_isSecondOrdered {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) (hn : 1 < n) :
    ‖secondEigenvector A hA hn‖ = 1 ∧
      A.toEuclideanLin (secondEigenvector A hA hn) =
        NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ •
          secondEigenvector A hA hn ∧
      NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ ≤
        NumStability.hermitianOrderedEigenvalue hA ⟨0, Nat.zero_lt_of_lt hn⟩ ∧
      ∀ j : Fin n, ⟨1, hn⟩ ≤ j →
        NumStability.hermitianOrderedEigenvalue hA j ≤
          NumStability.hermitianOrderedEigenvalue hA ⟨1, hn⟩ := by
  rcases secondEigenvector_spec A hA hn with ⟨hnorm, heigen⟩
  refine ⟨hnorm, heigen, ?_, ?_⟩
  · exact NumStability.hermitianOrderedEigenvalue_antitone hA (by simp)
  · intro j hj
    exact NumStability.hermitianOrderedEigenvalue_antitone hA hj

/-- Sign thresholding of the ordered second eigenvector partitions all
vertices into two disjoint communities. -/
theorem signCommunities_partition {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (hA : A.IsHermitian) (hn : 1 < n) :
    positiveCommunity A hA hn ∪ nonpositiveCommunity A hA hn = Set.univ ∧
      Disjoint (positiveCommunity A hA hn) (nonpositiveCommunity A hA hn) := by
  constructor
  · ext j
    simp only [positiveCommunity, nonpositiveCommunity, Set.mem_union,
      Set.mem_setOf_eq, Set.mem_univ, iff_true]
    exact lt_or_ge 0 (secondEigenvector A hA hn j)
  · rw [Set.disjoint_left]
    intro j hjpos hjnonpos
    change 0 < secondEigenvector A hA hn j at hjpos
    change secondEigenvector A hA hn j ≤ 0 at hjnonpos
    exact (not_le_of_gt hjpos) hjnonpos

end NumStability.HDP.Graph.SpectralClustering
