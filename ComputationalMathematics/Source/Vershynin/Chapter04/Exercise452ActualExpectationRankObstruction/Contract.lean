import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Actual-expectation rank obstruction

The actual ordinary expectation for two singleton communities has rank zero at p=1,q=0. This negative witness reuses the existing complete expected-entry and rank certificates. The separately named loopless rank classification and spectral corrections remain distinct; no printed positive claim or author repair is asserted.
-/

noncomputable section

namespace NumStability.HDP.Contract

open Matrix MeasureTheory
open NumStability.HDP.Graph.StochasticBlock

/-- With one vertex in each community, `p=1` and `q=0`, the actual matrix of
ordinary expectations has rank zero and fails the printed rank-two claim.
The expected-entry identification and rank witness are existing producers. -/
theorem hdp_04_exercise_4_5_2_actual_expectation_rank_obstruction :
    let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
    let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
      ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
    θ.q < θ.p ∧ D.rank = 0 ∧ D.rank ≠ 2 := by
  let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
  let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
    ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
  have hpq : θ.q < θ.p := by norm_num [θ]
  have hident : D = looplessExpectedAdjacency 1 θ.p θ.q := by
    ext i j
    exact (hdp_04_expected_adjacency_decomposition_corrected (k := 1)
      (by decide) θ hpq).1 i j
  change θ.q < θ.p ∧ D.rank = 0 ∧ D.rank ≠ 2
  rw [hident]
  exact ⟨hpq, hdp_04_exercise_4_5_2_counterexample⟩

end NumStability.HDP.Contract
