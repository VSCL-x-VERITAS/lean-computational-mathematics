import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise05.Signature

/-! Exercise 3.5.5: equivalence of the unit-vector and Gram-matrix SDPs. -/

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_5_5 : hdp_03_ex_3_5_5__contract_type := by
  intro n _ A _
  constructor
  · intro X
    exact ⟨NumStability.HDP.Optimization.unitVectorGram_isCorrelationMatrix X,
      NumStability.HDP.Optimization.semidefiniteQuadraticValue_unitVectorGram A X⟩
  · intro M hM
    obtain ⟨X, hX⟩ :=
      NumStability.HDP.Optimization.exists_unitVectorFamily_gram_eq hM
    refine ⟨X, hX, ?_⟩
    rw [← hX]
    exact NumStability.HDP.Optimization.semidefiniteQuadraticValue_unitVectorGram A X

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_5_5__contract : hdp_03_ex_3_5_5__contract_type :=
  hdp_03_ex_3_5_5

end NumStability.HDP.Contract
