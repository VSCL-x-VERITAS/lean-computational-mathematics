import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-! Analyst-derived child specifications; not printed author statements.
Each declaration is a proof-free Prop for independent source/target review. -/

noncomputable section

open Matrix MeasureTheory
open scoped Matrix.Norms.L2Operator
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04SBMSignalNormWitnessChildTarget : Prop :=
  (∃ θ : StochasticBlock.Parameters,
      θ.p = 1 ∧ θ.q = 0 ∧
      let community : Fin 2 → Fin 2 := id
      let P := FinStochasticBlock.measure community θ
      let B : Matrix (Fin 2) (Fin 2) ℝ :=
        fun i j => if community i = community j then (θ.p : ℝ) else θ.q
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      (∀ i j : Fin 2,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      ‖M‖ = 0 ∧ ‖B‖ = 1 ∧ ‖M‖ ≠ ‖B‖ ∧
      (∃ i j : Fin 2, community i ≠ community j ∧
        |(if community i = 0 then (1 : ℝ) else -1)| =
          |(if community j = 0 then (1 : ℝ) else -1)|)) ∧
    (∀ c : ℝ, 0 < c → ∀ K : ℕ,
      ∃ k : ℕ, K ≤ k ∧ 2 ≤ k ∧
        ∃ θ : StochasticBlock.Parameters,
          θ.q < θ.p ∧
          let community := NumStability.HDP.Contract.BalancedFinSBM.community k
          let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
          ‖M‖ < c * ((2 * k : ℕ) : ℝ))

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04SBMSignalNormCorrectionChildTarget : Prop :=
  (∀ (k : ℕ) (_hk : 0 < k) (θ : StochasticBlock.Parameters)
        (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let B : Matrix (Fin n) (Fin n) ℝ :=
        fun i j => if community i = community j then (θ.p : ℝ) else θ.q
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
      (∀ i j : Fin n,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      (∀ (ω : FinStochasticBlock.UpperPair n → Bool) (i j : Fin n),
        FinStochasticBlock.adjacency ω i j =
          M i j + (FinStochasticBlock.adjacency ω i j - M i j)) ∧
      (∀ i j : Fin n,
        ∫ ω, (FinStochasticBlock.adjacency ω i j - M i j) ∂P = 0) ∧
      ‖B‖ = (k : ℝ) * ((θ.p : ℝ) + θ.q) ∧
      ‖M‖ = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
      ‖M‖ / (n : ℝ) =
        ((θ.p : ℝ) + θ.q) / 2 - (θ.p : ℝ) / (n : ℝ) ∧
      (∀ i : Fin n,
        |signal i| = 1 ∧ (0 < signal i ↔ community i = 0)) ∧
      (∃ i j : Fin n,
        community i ≠ community j ∧ |signal i| = |signal j|) ∧
      (∀ i : Fin n,
        (community i = 0 ↔ 0 < signal i) ∧
        (community i = 1 ↔ signal i < 0))) ∧
    (∀ θ : StochasticBlock.Parameters,
      θ.q < θ.p →
      ∃ c C : ℝ, 0 < c ∧ 0 < C ∧
        ∀ (k : ℕ) (_hk : 2 ≤ k) (community : Fin (2 * k) → Fin 2),
          (∀ b : Fin 2,
            Fintype.card {i : Fin (2 * k) // community i = b} = k) →
          let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
          c * ((2 * k : ℕ) : ℝ) ≤ ‖M‖ ∧
            ‖M‖ ≤ C * ((2 * k : ℕ) : ℝ))

end NumStability.HDP.Contract.DiscrepancyChildren
