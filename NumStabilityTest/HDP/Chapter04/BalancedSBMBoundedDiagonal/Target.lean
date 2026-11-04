import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBMBoundedDiagonalClassification
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMArbitraryDimensionClassification

namespace NumStability.HDP.Verification

open MeasureTheory ProbabilityTheory

def BalancedSBMBoundedDiagonalClosedTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (n : ℕ) (hn : 1 < n)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
      (community : Fin n → Fin 2),
      Fintype.card {i : Fin n // community i = 0} =
        Fintype.card {i : Fin n // community i = 1} →
      0 < θ.q → θ.q < θ.p →
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ d : Fin n → ℝ, (∀ i, 0 ≤ d i ∧ d i ≤ 1) ∧
          ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω +
              Matrix.diagonal d).toEuclideanLin v =
              NumStability.hermitianOrderedEigenvalue
                ((NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian ω).add
                  (Matrix.isHermitian_diagonal d)) ⟨1, hn⟩ • v ∧
            ∀ swapped : Bool,
              C / μ ^ 2 <
                ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                  (if swapped then
                    NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                   else community) v).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ))

end NumStability.HDP.Verification
