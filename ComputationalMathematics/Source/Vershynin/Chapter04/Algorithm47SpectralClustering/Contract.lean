import ComputationalMathematics.HDP.Vector.EuclideanSpectralClustering
import ComputationalMathematics.HDP.Vector.SpectralClustering

/-!
# Vershynin Chapter 4, spectral clustering algorithm for point sets
-/

noncomputable section

open Matrix Set

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.7.1: form the uncentered sample second moment, select
a Euclidean unit eigenvector for its largest eigenvalue, and partition the
input points by projection sign.  The nonpositive side implements the
source's specified tie convention. -/
theorem hdp_04_algorithm_4_7_spectral_clustering {m n : ℕ}
    (hn : 0 < n) (X : Fin m → Fin n → ℝ) :
    let v := NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X
    NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X =
        NumStability.HDP.Vector.Covariance.sampleCovariance X ∧
      ‖v‖ = 1 ∧
      (∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
        NumStability.matrixRayleighForm
            (NumStability.HDP.Vector.Covariance.sampleCovariance X) w ≤
          NumStability.matrixRayleighForm
            (NumStability.HDP.Vector.Covariance.sampleCovariance X) v) ∧
      (NumStability.HDP.Vector.SpectralClustering.positiveCluster v X ∪
          NumStability.HDP.Vector.SpectralClustering.nonpositiveCluster v X = Set.univ) ∧
      Disjoint
        (NumStability.HDP.Vector.SpectralClustering.positiveCluster v X)
        (NumStability.HDP.Vector.SpectralClustering.nonpositiveCluster v X) := by
  dsimp only
  refine ⟨rfl, ?_, ?_, ?_⟩
  · exact NumStability.HDP.Vector.EuclideanSpectralClustering.norm_leadingEigenvector hn X
  · exact
      (NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector_isTopRayleigh
        hn X).2
  · exact NumStability.HDP.Vector.SpectralClustering.signClusters_partition _ X

end NumStability.HDP.Contract
