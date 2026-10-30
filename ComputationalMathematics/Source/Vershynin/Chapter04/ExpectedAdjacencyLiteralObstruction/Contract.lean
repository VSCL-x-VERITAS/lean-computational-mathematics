import ComputationalMathematics.Source.Vershynin.Chapter04.SBMLooplessCorrections.Contract

/-!
# Literal expected-adjacency obstructions

These two negative statements compare the actual entrywise expectation of
the loopless graph model with the printed inclusive block formula. They reuse
the existing complete expectation and diagonal certificates. The general
decomposition, corrected expectation, rank and spectral statements remain
separate mathematical assertions.
-/

namespace NumStability.HDP.Contract

open MeasureTheory
open NumStability.HDP.Graph.StochasticBlock

/-- The actual entrywise expectation cannot be the inclusive p-diagonal block
matrix for any nonempty balanced instance in the strict probability regime. -/
theorem hdp_04_expected_adjacency_literal_identification_obstruction
    {k : ℕ} (hk : 0 < k) (θ : Parameters) (hpq : θ.q < θ.p) :
    ¬ (∀ i j : Vertex k,
      (∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure k θ) =
        expectedAdjacency k θ.p θ.q i j) := by
  intro hprinted
  let i : Vertex k := (0, ⟨0, hk⟩)
  have hactual :=
    (hdp_04_expected_adjacency_decomposition_corrected hk θ hpq).1 i i
  have hdiagonal :=
    hdp_04_expected_adjacency_decomposition_counterexample hk θ hpq i
  exact hdiagonal.2.2 (hactual.symm.trans (hprinted i i))

/-- Four-vertex specialization of the literal expectation obstruction. -/
theorem hdp_04_expected_adjacency_n4_literal_identification_obstruction
    (θ : Parameters) (hpq : θ.q < θ.p) :
    ¬ (∀ i j : Vertex 2,
      (∫ ω, stochasticBlockAdjacency ω i j ∂graphMeasure 2 θ) =
        expectedAdjacency 2 θ.p θ.q i j) := by
  exact hdp_04_expected_adjacency_literal_identification_obstruction
    (by decide) θ hpq

end NumStability.HDP.Contract
