import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417Children

/-! The loopless two-vertex law with p = 1 and q = 0 has zero expected
adjacency, while the displayed block matrix is the identity. -/

noncomputable section

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- Explicit two-vertex obstruction to the printed expectation and rank-two claims. -/
theorem equation417_witness_child_proved : HDP04Equation417WitnessChildTarget := by
  let θ : StochasticBlock.Parameters :=
    { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
  refine ⟨θ, rfl, rfl, ?_⟩
  dsimp only
  have hM : FinStochasticBlock.expectedAdjacency (id : Fin 2 → Fin 2) θ.p θ.q = 0 := by
    ext i j
    by_cases hij : i = j <;>
      simp [FinStochasticBlock.expectedAdjacency, θ, hij]
  have hB : (fun i j : Fin 2 => if id i = id j then (θ.p : ℝ) else θ.q) =
      (1 : Matrix (Fin 2) (Fin 2) ℝ) := by
    ext i j
    simp [θ, Matrix.one_apply]
  refine ⟨FinStochasticBlock.adjacency_expectation id θ, hM, hB, ?_, ?_, ?_⟩
  · rw [hM, hB]
    exact zero_ne_one
  · rw [hM, Matrix.rank_zero]
    norm_num
  · rw [hM, Matrix.zero_mulVec, one_smul]
    intro h
    have := congrFun h (0 : Fin 2)
    norm_num at this

end NumStability.HDP.Contract.DiscrepancyChildren
