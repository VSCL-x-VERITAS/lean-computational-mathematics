import ComputationalMathematics.HDP.Vector.CovarianceEstimation
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Spectral clustering of finite point samples

The deterministic algorithmic layer used for the Gaussian-mixture application:
form the sample covariance, choose a unit vector maximizing its Rayleigh
quotient, and divide sample points according to projection sign.
-/

noncomputable section

open Matrix Set

namespace NumStability.HDP.Vector.SpectralClustering

/-- A unit vector attaining the largest Rayleigh quotient of a real square
matrix. For symmetric matrices this is exactly a unit top eigenvector. -/
def IsTopRayleighVector {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (v : Fin n → ℝ) : Prop :=
  ‖v‖ = 1 ∧ ∀ w : Fin n → ℝ, ‖w‖ = 1 →
    dotProduct w (A.mulVec w) ≤ dotProduct v (A.mulVec v)

/-- Points whose projection onto `v` is strictly positive. -/
def positiveCluster {m n : ℕ} (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) :
    Set (Fin m) := {i | 0 < dotProduct v (X i)}

/-- Points whose projection onto `v` is nonpositive. -/
def nonpositiveCluster {m n : ℕ} (v : Fin n → ℝ) (X : Fin m → Fin n → ℝ) :
    Set (Fin m) := {i | dotProduct v (X i) ≤ 0}

/-- Sign thresholding always partitions the sample indices into two disjoint
clusters. -/
theorem signClusters_partition {m n : ℕ} (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) :
    positiveCluster v X ∪ nonpositiveCluster v X = Set.univ ∧
      Disjoint (positiveCluster v X) (nonpositiveCluster v X) := by
  constructor
  · ext i
    simp only [positiveCluster, nonpositiveCluster, Set.mem_union, Set.mem_setOf_eq,
      Set.mem_univ, iff_true]
    exact lt_or_ge 0 (dotProduct v (X i))
  · rw [Set.disjoint_left]
    intro i hi hj
    change 0 < dotProduct v (X i) at hi
    change dotProduct v (X i) ≤ 0 at hj
    exact (not_le_of_gt hi) hj

/-- The sample covariance used in the spectral clustering algorithm. -/
def clusteringSampleCovariance {m n : ℕ} (X : Fin m → Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  NumStability.HDP.Vector.Covariance.sampleCovariance X

end NumStability.HDP.Vector.SpectralClustering
