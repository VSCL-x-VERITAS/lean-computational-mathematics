import ComputationalMathematics.HDP.Graph.SpectralBinaryClassification
import ComputationalMathematics.HDP.Graph.FinStochasticBlock

/-! Ordinary target for arbitrary balanced binary labels in the specified law. -/

namespace NumStabilityTest.HDP.Chapter04.BalancedSBMAllUnit

def target : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ v : EuclideanSpace ℝ (Fin n),
          NumStability.HDP.Graph.SpectralClustering.IsSecondOrderedEigenvector
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω) hn v ∧
          ∀ swapped : Bool,
            C / μ ^ 2 <
              ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                (if swapped then
                  NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                 else community)
                (Real.sqrt n • v)).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ))

end NumStabilityTest.HDP.Chapter04.BalancedSBMAllUnit
