import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMAllUnitClassification

namespace NumStability.HDP.Verification

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Graph
open NumStability.HDP.Contract
open NumStability.HDP.Vector.SignRecovery

def CanonicalSBMBoundedDiagonalClosedTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters),
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let community := BalancedFinSBM.community k
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
          ∃ v : EuclideanSpace ℝ (Fin n),
            SpectralClustering.IsSecondOrderedEigenvector
              (FinStochasticBlock.adjacency ω + Matrix.diagonal d) hn v ∧
            ∀ swapped : Bool,
              C / μ ^ 2 <
                ((binaryThresholdMisclassifications
                  (if swapped then swapBinaryCommunity community else community)
                  (Real.sqrt n • v)).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ))

end NumStability.HDP.Verification
