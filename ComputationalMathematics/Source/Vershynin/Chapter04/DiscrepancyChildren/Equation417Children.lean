import ComputationalMathematics.HDP.Graph.FinStochasticBlock
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM

/-! Analyst-derived child specifications; not printed author statements.
Each declaration is a proof-free Prop for independent source/target review. -/

noncomputable section

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04Equation417WitnessChildTarget : Prop :=
  (∃ θ : StochasticBlock.Parameters,
      θ.p = 1 ∧ θ.q = 0 ∧
      let community : Fin 2 → Fin 2 := id
      let P := FinStochasticBlock.measure community θ
      let B : Matrix (Fin 2) (Fin 2) ℝ :=
        fun i j => if community i = community j then (θ.p : ℝ) else θ.q
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      (∀ i j : Fin 2,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      M = 0 ∧ B = 1 ∧ M ≠ B ∧ M.rank ≠ 2 ∧
      M.mulVec (fun _ : Fin 2 => (1 : ℝ)) ≠
        (1 : ℝ) • (fun _ : Fin 2 => (1 : ℝ)))

/-- Distinct child of the printed Chapter 4 parent; requires independent audit. -/
def HDP04Equation417CorrectionChildTarget : Prop :=
  (∀ (k : ℕ) (hk : 0 < k) (θ : StochasticBlock.Parameters)
        (community : Fin (2 * k) → Fin 2),
      (∀ b : Fin 2, Fintype.card {i : Fin (2 * k) // community i = b} = k) →
      θ.q < θ.p →
      let n : ℕ := 2 * k
      let P := FinStochasticBlock.measure community θ
      let B : Matrix (Fin n) (Fin n) ℝ :=
        fun i j => if community i = community j then (θ.p : ℝ) else θ.q
      let M := FinStochasticBlock.expectedAdjacency community θ.p θ.q
      let ones : Fin n → ℝ := fun _ => 1
      let signal : Fin n → ℝ := fun i => if community i = 0 then 1 else -1
      (∀ i j : Fin n,
        ∫ ω, (FinStochasticBlock.adjacency ω) i j ∂P = M i j) ∧
      (∀ i j : Fin n,
        M i j = B i j - (if i = j then (θ.p : ℝ) else 0)) ∧
      M ≠ B ∧ B.rank = 2 ∧
      B.mulVec ones = ((k : ℝ) * ((θ.p : ℝ) + θ.q)) • ones ∧
      B.mulVec signal = ((k : ℝ) * ((θ.p : ℝ) - θ.q)) • signal ∧
      M.mulVec ones = ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) • ones ∧
      M.mulVec signal = ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) • signal ∧
      (∀ x : Fin n → ℝ,
        (∀ b : Fin 2,
          (∑ i : Fin n, if community i = b then x i else 0) = 0) →
        B.mulVec x = 0 ∧ M.mulVec x = (-(θ.p : ℝ)) • x) ∧
      Module.finrank ℝ (LinearMap.ker B.mulVecLin) = n - 2 ∧
      Module.finrank ℝ (Module.End.eigenspace M.mulVecLin (-(θ.p : ℝ))) = n - 2 ∧
      (∀ r : ℝ, Module.End.HasEigenvalue M.mulVecLin r ↔
        r = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∨
        r = (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∨
        (r = -(θ.p : ℝ) ∧ 1 < k)) ∧
      (∃ hB : B.IsHermitian,
        NumStability.hermitianOrderedEigenvalue hB (⟨0, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) + θ.q) ∧
        NumStability.hermitianOrderedEigenvalue hB (⟨1, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) - θ.q) ∧
        (∀ j : Fin n, 2 ≤ j.val →
          NumStability.hermitianOrderedEigenvalue hB j = 0)) ∧
      (∃ hM : M.IsHermitian,
        NumStability.hermitianOrderedEigenvalue hM (⟨0, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
        NumStability.hermitianOrderedEigenvalue hM (⟨1, by dsimp [n]; omega⟩ : Fin n) =
          (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∧
        (∀ j : Fin n, 2 ≤ j.val →
          NumStability.hermitianOrderedEigenvalue hM j = -(θ.p : ℝ))))

end NumStability.HDP.Contract.DiscrepancyChildren
