import ComputationalMathematics.HDP.Graph.SpectralClustering
import Mathlib.Analysis.Normed.Lp.PiLp

/-! Ordinary complete-certificate transport. The second-slot size condition
belongs to the supplied certificate interface, with no source dimension choice. -/

namespace NumStability.HDP.Verification

def SpectralClusteringPermutationClosedTarget : Prop :=
  ∀ (n : ℕ) (hn : 1 < n) (e : Equiv.Perm (Fin n))
    (A : Matrix (Fin n) (Fin n) ℝ) (v : EuclideanSpace ℝ (Fin n)),
    Graph.SpectralClustering.IsSecondOrderedEigenvector A hn v ↔
      Graph.SpectralClustering.IsSecondOrderedEigenvector
        (Matrix.reindex e e A) hn ((LinearIsometryEquiv.piLpCongrLeft 2 ℝ ℝ e) v)

end NumStability.HDP.Verification
