import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMNonzeroClassification

namespace NumStability.HDP.Verification

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

def BalancedSBMArbitraryDimensionClosedTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (n : ℕ) (hn : 1 < n) (θ : StochasticBlock.Parameters)
      (community : Fin n → Fin 2),
      Fintype.card {i : Fin n // community i = 0} =
        Fintype.card {i : Fin n // community i = 1} →
      0 < θ.q → θ.q < θ.p →
      let P := FinStochasticBlock.measure community θ
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      P.real {ω |
        ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
          (FinStochasticBlock.adjacency ω).toEuclideanLin v =
            NumStability.hermitianOrderedEigenvalue
              (FinStochasticBlock.adjacency_hermitian ω) ⟨1, hn⟩ • v ∧
          ∀ swapped : Bool,
            C / μ ^ 2 <
              ((binaryThresholdMisclassifications
                (if swapped then swapBinaryCommunity community else community)
                v).card : ℝ)} ≤
        4 * Real.exp (-(n : ℝ))

end NumStability.HDP.Verification
