import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Actual-expectation signal-norm obstruction

A separately named negative witness for the exact printed signal-norm equality. It forwards the existing actual-expectation and loopless norm certificates. The asymptotic comparison and author-intended repair are not inferred.
-/

noncomputable section

open Matrix MeasureTheory
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Contract

open NumStability.HDP.Graph.StochasticBlock

/-- The same ordinary expectation has operator norm zero, whereas the exact
printed scalar `((p+q)/2)n` equals one. The asymptotic claim is not selected. -/
theorem hdp_04_sbm_actual_expectation_norm_obstruction :
    let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
    let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
      ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
    θ.q < θ.p ∧ ‖D‖ = 0 ∧
      ((((θ.p : ℝ) + θ.q) / 2) * ((2 * 1 : ℕ) : ℝ)) = 1 ∧
      ‖D‖ ≠ ((((θ.p : ℝ) + θ.q) / 2) * ((2 * 1 : ℕ) : ℝ)) := by
  let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
  let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
    ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
  have hpq : θ.q < θ.p := by norm_num [θ]
  have hident : D = looplessExpectedAdjacency 1 θ.p θ.q := by
    ext i j
    exact (hdp_04_expected_adjacency_decomposition_corrected (k := 1)
      (by decide) θ hpq).1 i j
  have hnorm : ‖D‖ = 0 := by
    rw [hident]
    simpa [θ] using hdp_04_sbm_signal_norm_counterexample.1
  change θ.q < θ.p ∧ ‖D‖ = 0 ∧ _
  refine ⟨hpq, hnorm, ?_, ?_⟩
  · norm_num [θ]
  · rw [hnorm]
    norm_num [θ]

end NumStability.HDP.Contract
