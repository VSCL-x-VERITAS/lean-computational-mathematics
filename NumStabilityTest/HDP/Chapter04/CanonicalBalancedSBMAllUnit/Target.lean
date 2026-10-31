import ComputationalMathematics.HDP.Graph.SpectralBinaryClassification
import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-! Ordinary specified-model target; this carries no book-source acceptance. -/

namespace NumStabilityTest.HDP.Chapter04.CanonicalBalancedSBMAllUnit

def target : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters),
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let community : Fin n → Fin 2 :=
        NumStability.HDP.Contract.BalancedFinSBM.community k
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

end NumStabilityTest.HDP.Chapter04.CanonicalBalancedSBMAllUnit
