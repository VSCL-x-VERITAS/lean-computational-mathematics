import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedSBMArbitraryDimensionClassification
import Mathlib.MeasureTheory.Measure.Real

/-!
# Simultaneous classification success under the actual balanced model

The complement of the existing common bad event gives success for every
nonzero actual second eigenvector at once. The label matching may depend on
the sample and eigenvector. No book-source correspondence is asserted.
-/

noncomputable section
open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract.BalancedFinSBMRecovery
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

/-- The same absolute constant gives simultaneous success for every legitimate
nonzero second eigensolution under the specified actual loopless law. -/
theorem exists_equal_fiber_nonzero_binary_classification_success :
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
                 else community) v).card : ℝ) ≤ C / μ ^ 2} := by
  classical
  obtain ⟨C, hC, htail⟩ := exists_equal_fiber_nonzero_binary_classification_tail
  refine ⟨C, hC, ?_⟩
  intro n hn θ community hbalanced hq hpq
  dsimp only
  let P := FinStochasticBlock.measure community θ
  let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
  let bad : Set (FinStochasticBlock.UpperPair n → Bool) := {ω |
    ∃ v : EuclideanSpace ℝ (Fin n), v ≠ 0 ∧
      (FinStochasticBlock.adjacency ω).toEuclideanLin v =
        NumStability.hermitianOrderedEigenvalue
          (FinStochasticBlock.adjacency_hermitian ω) ⟨1, hn⟩ • v ∧
      ∀ swapped : Bool,
        C / μ ^ 2 <
          ((binaryThresholdMisclassifications
            (if swapped then swapBinaryCommunity community else community) v).card : ℝ)}
  have hbad : P.real bad ≤ 4 * Real.exp (-(n : ℝ)) :=
    htail n hn θ community hbalanced hq hpq
  have hgood : 1 - 4 * Real.exp (-(n : ℝ)) ≤ P.real badᶜ := by
    rw [probReal_compl_eq_one_sub (Set.toFinite bad).measurableSet]
    linarith
  change 1 - 4 * Real.exp (-(n : ℝ)) ≤ P.real {ω | ¬ (ω ∈ bad)} at hgood
  simpa only [bad, Set.mem_setOf_eq, not_exists, not_and, not_forall, not_lt] using hgood

/-- Restrict the simultaneous success event to unit second eigenvectors.
The same constant and probability bound apply, with label matching inside the event. -/
theorem exists_equal_fiber_unit_binary_classification_success :
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
          ∀ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 →
            (NumStability.HDP.Graph.FinStochasticBlock.adjacency ω).toEuclideanLin v =
              NumStability.hermitianOrderedEigenvalue
                (NumStability.HDP.Graph.FinStochasticBlock.adjacency_hermitian ω)
                ⟨1, hn⟩ • v →
            ∃ swapped : Bool,
              ((NumStability.HDP.Vector.SignRecovery.binaryThresholdMisclassifications
                (if swapped then
                  NumStability.HDP.Vector.SignRecovery.swapBinaryCommunity community
                 else community) v).card : ℝ) ≤ C / μ ^ 2} := by
  obtain ⟨C, hC, hsuccess⟩ := exists_equal_fiber_nonzero_binary_classification_success
  refine ⟨C, hC, ?_⟩
  intro n hn θ community hbalanced hq hpq
  dsimp only
  let P := FinStochasticBlock.measure community θ
  let μ : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
  have hsource := hsuccess n hn θ community hbalanced hq hpq
  have hsubset :
      {ω : FinStochasticBlock.UpperPair n → Bool |
        ∀ v : EuclideanSpace ℝ (Fin n), v ≠ 0 →
          (FinStochasticBlock.adjacency ω).toEuclideanLin v =
            NumStability.hermitianOrderedEigenvalue
              (FinStochasticBlock.adjacency_hermitian ω) ⟨1, hn⟩ • v →
          ∃ swapped : Bool,
            ((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity community else community) v).card : ℝ) ≤
                C / μ ^ 2} ⊆
      {ω : FinStochasticBlock.UpperPair n → Bool |
        ∀ v : EuclideanSpace ℝ (Fin n), ‖v‖ = 1 →
          (FinStochasticBlock.adjacency ω).toEuclideanLin v =
            NumStability.hermitianOrderedEigenvalue
              (FinStochasticBlock.adjacency_hermitian ω) ⟨1, hn⟩ • v →
          ∃ swapped : Bool,
            ((binaryThresholdMisclassifications
              (if swapped then swapBinaryCommunity community else community) v).card : ℝ) ≤
                C / μ ^ 2} := by
    intro ω hω v hvunit heig
    apply hω v _ heig
    intro hvzero
    simp [hvzero] at hvunit
  exact hsource.trans (measureReal_mono hsubset)

end NumStability.HDP.Contract.BalancedFinSBMRecovery
