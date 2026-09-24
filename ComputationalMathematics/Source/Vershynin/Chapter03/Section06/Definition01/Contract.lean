import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Definition01.Signature

/-! Definition 3.6.1: the maximum cut of a finite simple graph. -/

namespace NumStability.HDP.Contract

theorem hdp_03_def_3_6_1 : hdp_03_def_3_6_1__contract_type := by
  intro V _ _ G _
  obtain ⟨S, hS⟩ := NumStability.HDP.Graph.exists_cutSize_eq_maxCut G
  exact ⟨fun _ _ h ↦ G.symm h, fun v ↦ G.irrefl,
    fun u v ↦ by rw [SimpleGraph.mem_edgeFinset, SimpleGraph.mem_edgeSet], S, hS,
    NumStability.HDP.Graph.cutSize_le_maxCut G⟩

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_6_1__contract : hdp_03_def_3_6_1__contract_type :=
  hdp_03_def_3_6_1

end NumStability.HDP.Contract
