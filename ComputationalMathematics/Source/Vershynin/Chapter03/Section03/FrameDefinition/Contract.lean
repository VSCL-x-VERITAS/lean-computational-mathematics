import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.FrameDefinition.Signature

/-! Definition 3.3.8: finite frames and tight frames. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- A finite real family is a frame exactly when it admits positive approximate
Parseval bounds, and it is tight with bound `A` exactly when the two bounds
coincide at the positive value `A`. -/
theorem hdp_03_def_3_3_8 : hdp_03_def_3_3_8__contract_type := by
  intro N n u
  constructor
  · rfl
  · intro A
    rfl

set_option linter.style.nameCheck false in
theorem hdp_03_def_3_3_8__contract : hdp_03_def_3_3_8__contract_type :=
  hdp_03_def_3_3_8

end NumStability.HDP.Contract
