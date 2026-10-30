import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMArbitraryDimensionClassification
import Mathlib.MeasureTheory.Measure.Real

namespace NumStability.HDP.Verification

open MeasureTheory ProbabilityTheory

def BalancedSBMSuccessClosedTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (n : ℕ) (hn : 1 < n)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
      (community : Fin n → Fin 2),
      Fintype.card {i : Fin n // community i = 0} =
        Fintype.card {i : Fin n // community i = 1} →
      0 < θ.q → θ.q < θ.p →
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      1 - 4 * Real.exp (-(n : ℝ)) ≤
        P.real {ω |
          ∀ v : EuclideanSpace ℝ (Fin n), v ≠ 0 →
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω).toEuclideanLin v =
              NumStability.hermitianOrderedEigenvalue
                (NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian ω)
                ⟨1, hn⟩ • v →
            ∃ swapped : Bool,
              ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                (if swapped then
                  NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                 else community) v).card : ℝ) ≤ C / μ ^ 2}

end NumStability.HDP.Verification
