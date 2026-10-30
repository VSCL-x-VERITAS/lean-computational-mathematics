import ComputationalMathematics.Source.Vershynin.Chapter04.ExpectedAdjacencyLiteralObstruction.Contract

/-!
# Concrete four-vertex expected-adjacency obstruction

The admissible p=1,q=0 instance has actual expected diagonal zero and printed inclusive diagonal one. This concrete negative witness forwards the existing expectation, diagonal and literal-obstruction certificates. It does not replace the separately named correction or assert an author-intended repair.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Graph.StochasticBlock

/-- At the admissible endpoint p=1,q=0, the actual expected diagonal is zero
and the printed inclusive diagonal is one. This is a negative witness, not a
source-positive expected-adjacency theorem or a proposed author repair. -/
theorem hdp_04_expected_adjacency_n4_concrete_literal_obstruction :
    let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
    let i : Vertex 2 := (0, 0)
    θ.q < θ.p ∧
      (∫ ω, stochasticBlockAdjacency ω i i ∂graphMeasure 2 θ) = 0 ∧
      expectedAdjacency 2 θ.p θ.q i i = 1 ∧
      ¬ (∀ a b : Vertex 2,
        (∫ ω, stochasticBlockAdjacency ω a b ∂graphMeasure 2 θ) =
          expectedAdjacency 2 θ.p θ.q a b) := by
  let θ : Parameters := { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
  let i : Vertex 2 := (0, 0)
  have hpq : θ.q < θ.p := by norm_num [θ]
  have hactual := (hdp_04_expected_adjacency_n4_corrected θ hpq).1 i i
  have hdiagonal := hdp_04_expected_adjacency_n4_counterexample θ hpq i
  exact ⟨hpq, hactual.trans hdiagonal.1,
    by simpa [θ] using hdiagonal.2.1,
    hdp_04_expected_adjacency_n4_literal_identification_obstruction θ hpq⟩

end NumStability.HDP.Contract
