import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise07.Signature

/-! Exercise 3.5.7: the bipartite unit-vector optimization is exactly its
factor-half block correlation-matrix SDP. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

theorem hdp_03_hex_h3_d5_d7 : hdp_03_hex_h3_d5_d7__contract_type := by
  intro m n A
  constructor
  · intro k X Y hX hY
    refine ⟨bipartiteUnitGram X Y,
      bipartiteUnitGram_isCorrelationMatrixOn X Y hX hY, rfl, ?_⟩
    exact bipartiteSemidefiniteValue_unitGram A X Y
  · intro M hM
    obtain ⟨X, Y, hX, hY, hgram⟩ :=
      exists_bipartite_unit_families_gram_eq hM
    refine ⟨X, Y, hX, hY, hgram, ?_⟩
    rw [← hgram]
    exact bipartiteSemidefiniteValue_unitGram A X Y

set_option linter.style.nameCheck false in
theorem hdp_03_hex_h3_d5_d7__contract : hdp_03_hex_h3_d5_d7__contract_type :=
  hdp_03_hex_h3_d5_d7

end NumStability.HDP.Contract
