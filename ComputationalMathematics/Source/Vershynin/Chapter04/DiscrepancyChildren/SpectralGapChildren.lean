import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-! Analyst-derived child specifications; not printed author statements.
Each declaration is a proof-free Prop for independent source/target review. -/

noncomputable section

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04SBMSpectralGapWitnessChildTarget : Prop :=
  (∃ θ : StochasticBlock.Parameters,
      θ.p = 1 ∧ (θ.q : ℝ) = 3 / 4 ∧
      let community : Fin 2 → Fin 2 := id
      let P := FinStochasticBlock.measure community θ
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      (∀ i j : Fin 2,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      ∃ hM : M.IsHermitian,
        NumStability.hermitianOrderedEigenvalue hM (0 : Fin 2) = 3 / 4 ∧
        NumStability.hermitianOrderedEigenvalue hM (1 : Fin 2) = -(3 / 4 : ℝ) ∧
        (∀ j : Fin 2, j ≠ (1 : Fin 2) →
          |NumStability.hermitianOrderedEigenvalue hM (1 : Fin 2) -
            NumStability.hermitianOrderedEigenvalue hM j| = 3 / 2) ∧
        min (((θ.p : ℝ) - θ.q) / 2) (θ.q : ℝ) * (2 : ℝ) = 1 / 4 ∧
        (∀ j : Fin 2, j ≠ (1 : Fin 2) →
          |NumStability.hermitianOrderedEigenvalue hM (1 : Fin 2) -
            NumStability.hermitianOrderedEigenvalue hM j| ≠
              min (((θ.p : ℝ) - θ.q) / 2) (θ.q : ℝ) * (2 : ℝ)))

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04SBMSpectralGapCorrectionChildTarget : Prop :=
  (∀ (k : ℕ) (hk : 0 < k) (θ : StochasticBlock.Parameters)
        (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let B : Matrix (Fin n) (Fin n) ℝ :=
        fun i j => if community i = community j then (θ.p : ℝ) else θ.q
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      let μgap : ℝ := min (((θ.p : ℝ) - θ.q) / 2) (θ.q : ℝ)
      (∀ i j : Fin n,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      (∃ hB : B.IsHermitian, ∃ hM : M.IsHermitian,
        (∀ j : Fin n,
          NumStability.hermitianOrderedEigenvalue hM j =
            NumStability.hermitianOrderedEigenvalue hB j - θ.p) ∧
        NumStability.hermitianOrderedEigenvalue hM (⟨0, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
        NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∧
        (∀ j : Fin n, 2 ≤ j.val →
          NumStability.hermitianOrderedEigenvalue hM j = -(θ.p : ℝ)) ∧
        (∀ j : Fin n, j ≠ (⟨1, by dsimp [n]; omega⟩ : Fin n) →
          μgap * (n : ℝ) ≤
            |NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) -
              NumStability.hermitianOrderedEigenvalue hM j|) ∧
        (2 ≤ k → ∃ j : Fin n, j ≠ (⟨1, by dsimp [n]; omega⟩ : Fin n) ∧
          |NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) -
            NumStability.hermitianOrderedEigenvalue hM j| =
              μgap * (n : ℝ)) ∧
        (k = 1 → ∀ j : Fin n, j ≠ (⟨1, by dsimp [n]; omega⟩ : Fin n) →
          |NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) -
            NumStability.hermitianOrderedEigenvalue hM j| =
              2 * (θ.q : ℝ)) ∧
        (θ.q = 0 → ∃ j : Fin n, j ≠ (⟨1, by dsimp [n]; omega⟩ : Fin n) ∧
          |NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) -
            NumStability.hermitianOrderedEigenvalue hM j| = 0) ∧
        (0 < θ.q → ∀ j : Fin n, j ≠ (⟨1, by dsimp [n]; omega⟩ : Fin n) →
          0 < |NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) -
            NumStability.hermitianOrderedEigenvalue hM j|)))

end NumStability.HDP.Contract.DiscrepancyChildren
