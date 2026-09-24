import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Definition04.Signature

/-! Definition 3.5.4: finite semidefinite programs with equality constraints. -/

namespace NumStability.HDP.Contract

theorem hdp_03_def_3_5_4 : hdp_03_def_3_5_4__contract_type := by
  intro n m A B b
  refine ⟨⟨A, B, b⟩, rfl, rfl, rfl, ?_, ?_, ?_⟩
  · intro X
    rfl
  · intro X
    rfl
  · intro X
    rfl

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_5_4__contract : hdp_03_def_3_5_4__contract_type :=
  hdp_03_def_3_5_4

end NumStability.HDP.Contract
