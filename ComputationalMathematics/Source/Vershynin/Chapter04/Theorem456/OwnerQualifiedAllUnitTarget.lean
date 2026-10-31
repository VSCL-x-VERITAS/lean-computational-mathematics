import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMClassificationSuccess

/-!
# Theorem 4.5.6: owner-qualified loopless all-unit target

This file states the complete corrected source-facing proposition. It contains no
proof or source-admission decision. The law, ordered eigenspace, classifier, and
error event are explicit so that their definitions can be inspected during the
independent statement review.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- The owner-qualified complete Theorem 4.5.6 for the actual loopless balanced
stochastic block model. `k` ranges over positive half-sizes through `hn`, so
`n = 2*k ≥ 2`; `community` ranges over every balanced labeling of the vertices.
The bound holds on one event for every unit vector in the algebraically ordered
second eigenspace, including multiplicities. The Boolean choice swaps the two
output labels while leaving the strict-positive/otherwise threshold unchanged. -/
def hdp_04_theorem_4_5_6_owner_qualified_all_unit : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k)
      (θ : NumStability.HDP.Graph.StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2,
        Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      θ.q < θ.p →
      let n : ℕ := 2 * k
      let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      0 < μ →
      let P := NumStability.HDP.Graph.FinStochasticBlock.measure community θ
      1 - 4 * Real.exp (-(n : ℝ)) ≤
        P.real {ω : NumStability.HDP.Graph.FinStochasticBlock.UpperPair n → Bool |
          ∀ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 →
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω).toEuclideanLin v =
              NumStability.hermitianOrderedEigenvalue
                (NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian ω)
                ⟨1, hn⟩ • v →
            ∃ swapped : Bool,
              ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                (if swapped then
                  NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                 else community) v).card : ℝ) ≤ C / μ ^ 2}

end NumStability.HDP.Contract
