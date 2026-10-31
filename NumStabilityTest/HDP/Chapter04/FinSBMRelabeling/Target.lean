import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import Mathlib.MeasureTheory.Constructions.Pi

/-! Ordinary law transport for supplied community-preserving vertex equivalences.
No source convention or eigenvector choice is specified here. -/

namespace NumStability.HDP.Verification

open MeasureTheory
open NumStability.HDP.Graph

def FinSBMRelabelingClosedTarget : Prop :=
  ∀ (n m : ℕ) (c : Fin n → Fin 2) (d : Fin m → Fin 2)
    (e : Fin n ≃ Fin m),
    (∀ i, d (e i) = c i) →
    ∀ θ : StochasticBlock.Parameters,
      ∃ T : (FinStochasticBlock.UpperPair n → Bool) ≃ᵐ
          (FinStochasticBlock.UpperPair m → Bool),
        (FinStochasticBlock.measure c θ).map T = FinStochasticBlock.measure d θ ∧
        (∀ ω, Matrix.reindex e e (FinStochasticBlock.adjacency ω) =
          FinStochasticBlock.adjacency (T ω)) ∧
        (∀ p q : ℝ, Matrix.reindex e e (FinStochasticBlock.expectedAdjacency c p q) =
          FinStochasticBlock.expectedAdjacency d p q)

end NumStability.HDP.Verification
