import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Actual-expectation first-eigenpair obstruction

A separately named negative witness for the exact first printed eigenpair. It forwards the existing actual-expectation and corrected eigenpair certificates. The independently selected loopless full-spectrum correction remains distinct.
-/

noncomputable section

open Matrix MeasureTheory
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Contract

open NumStability.HDP.Graph.StochasticBlock

/-- The actual ordinary expectation fails the printed first eigenpair even
for the source-admissible singleton communities at `p=1,q=0`. -/
theorem hdp_04_equation_4_17_actual_expectation_eigenpair_obstruction :
    let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
    let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
      ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
    θ.q < θ.p ∧ D.mulVec (allOnes 1) = 0 ∧
      D.mulVec (allOnes 1) ≠
        ((((θ.p : ℝ) + θ.q) / 2) * ((2 * 1 : ℕ) : ℝ)) • allOnes 1 := by
  let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
  let D : Matrix (Vertex 1) (Vertex 1) ℝ := fun i j =>
    ∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 1 θ
  have hpq : θ.q < θ.p := by norm_num [θ]
  have hident : D = looplessExpectedAdjacency 1 θ.p θ.q := by
    ext i j
    exact (hdp_04_expected_adjacency_decomposition_corrected (k := 1)
      (by decide) θ hpq).1 i j
  have hzero : D.mulVec (allOnes 1) = 0 := by
    rw [hident]
    simpa [θ] using (hdp_04_equation_4_17_corrected (k := 1) (by decide) θ hpq).1
  change θ.q < θ.p ∧ D.mulVec (allOnes 1) = 0 ∧ _
  refine ⟨hpq, hzero, ?_⟩
  intro hprinted
  rw [hzero] at hprinted
  have hentry := congr_fun hprinted ((0 : Fin 2), (0 : Fin 1))
  norm_num [θ, allOnes] at hentry

end NumStability.HDP.Contract
