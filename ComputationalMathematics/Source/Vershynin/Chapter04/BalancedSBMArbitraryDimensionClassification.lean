import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMNonzeroClassification
import ComputationalMathematics.HDP.Graph.BalancedCommunityEquivalence
import Mathlib.Tactic.FinCases

/-!
# Balanced-model classification in arbitrary total dimension

Equal binary-community sizes determine the half-size through the existing
balanced index equivalence. Rewriting by this cardinality identity transports
the common nonzero-eigenvector guarantee without changing its constant or law.
No book-source correspondence is asserted.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery

open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- The common nonzero-vector classification tail for equal binary fibers,
with total dimension supplied directly. -/
theorem exists_equal_fiber_nonzero_binary_classification_tail :
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
        4 * Real.exp (-(n : ℝ)) := by
  obtain ⟨C, hC, htail⟩ := exists_all_balanced_nonzero_binary_classification_tail
  refine ⟨C, hC, ?_⟩
  intro n hn θ community hbalanced hq hpq
  have hex : ∃ k : ℕ, n = 2 * k ∧
      ∀ b : Fin 2, Fintype.card {i : Fin n // community i = b} = k := by
    let k := Fintype.card {i : Fin n // community i = 0}
    have hcards : ∀ b : Fin 2, Fintype.card {i : Fin n // community i = b} = k := by
      intro b
      fin_cases b
      · rfl
      · exact hbalanced.symm
    obtain ⟨e, _⟩ := exists_balancedCommunityIndexEquiv hcards
    refine ⟨k, ?_, hcards⟩
    simpa only [Fintype.card_fin] using Fintype.card_congr e
  obtain ⟨k, rfl, hcards⟩ := hex
  exact htail k hn θ community hcards hq hpq

end NumStability.HDP.Contract.BalancedFinSBMRecovery
