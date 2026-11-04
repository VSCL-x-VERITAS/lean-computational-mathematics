import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMAllUnitClassification
import Mathlib.Analysis.Normed.Module.Normalize

namespace NumStability.HDP.Verification

open MeasureTheory ProbabilityTheory
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

def BalancedSBMNonzeroClosedTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
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
