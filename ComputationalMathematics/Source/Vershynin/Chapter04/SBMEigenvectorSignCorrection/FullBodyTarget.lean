import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.HDP.Graph.SpectralClustering
import ComputationalMathematics.HDP.Vector.BinarySignBound

/-!
# Full corrected p95–96 eigenvector-sign target

This proof-free target places the normalized eigenvector estimate, its scaled
squared-error consequence, sign count, and genuine output-label swap on one
event for every unit second ordered eigenvector of the observed adjacency.
The same sample-and-vector-dependent sign witnesses all four assertions.
-/

noncomputable section

open MeasureTheory
open NumStability.HDP.Graph
open NumStability.HDP.Vector.SignRecovery

namespace NumStability.HDP.Contract

/-- Owner-qualified complete quantitative eigenvector-sign statement for the
actual finite loopless SBM, including the printed p95 estimate and p96 body. -/
def HDP04SBMEigenvectorSignCorrectionFullBodyTarget : Prop :=
  ∃ C : ℝ, 0 < C ∧
    ∀ (k : ℕ) (hn : 1 < 2 * k) (θ : StochasticBlock.Parameters)
      (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      0 < θ.q → θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      let μgap : ℝ := min (((θ.p : ℝ) - (θ.q : ℝ)) / 2) (θ.q : ℝ)
      let μfinal : ℝ := min (θ.q : ℝ) ((θ.p : ℝ) - (θ.q : ℝ))
      let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
      0 < μgap ∧ 0 < μfinal ∧ μgap ≤ μfinal ∧ μfinal ≤ 2 * μgap ∧
      (∀ i j : Fin n,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      (∃ u : EuclideanSpace ℝ (Fin n),
        SpectralClustering.IsSecondOrderedEigenvector M hn u ∧
        (∀ i : Fin n, (Real.sqrt (n : ℝ) • u) i = signal i) ∧
        P.real {ω |
        ∀ v : EuclideanSpace ℝ (Fin n),
          SpectralClustering.IsSecondOrderedEigenvector
            (FinStochasticBlock.adjacency ω) hn v →
          ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
            ‖u - s • v‖ ≤ Real.sqrt C / (μgap * Real.sqrt (n : ℝ)) ∧
            (∑ i : Fin n,
              (signal i - (s • (Real.sqrt (n : ℝ) • v)) i) ^ 2) ≤
              C / μgap ^ 2 ∧
            (((signDisagreements signal
              (s • (Real.sqrt (n : ℝ) • v))).card : ℝ) ≤
                C / μgap ^ 2) ∧
            ∃ swapped : Bool,
              s = (if swapped then -1 else 1) ∧
              (((binaryThresholdMisclassifications
                (if swapped then swapBinaryCommunity community else community)
                (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ C / μgap ^ 2) ∧
              (((binaryThresholdMisclassifications
                (if swapped then swapBinaryCommunity community else community)
                (Real.sqrt (n : ℝ) • v)).card : ℝ) ≤ 4 * C / μfinal ^ 2)} ≥
          1 - 4 * Real.exp (-(n : ℝ)))

end NumStability.HDP.Contract
