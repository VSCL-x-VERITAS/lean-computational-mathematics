import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Definition02.Signature

/-! Definition 3.6.2: the adjacency matrix of a finite simple graph. -/

namespace NumStability.HDP.Contract

theorem hdp_03_def_3_6_2 : hdp_03_def_3_6_2__contract_type := by
  intro n G _
  exact ⟨G.isSymm_adjMatrix, fun i j ↦ G.adjMatrix_apply (α := ℝ) i j⟩

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_6_2__contract : hdp_03_def_3_6_2__contract_type :=
  hdp_03_def_3_6_2

end NumStability.HDP.Contract
