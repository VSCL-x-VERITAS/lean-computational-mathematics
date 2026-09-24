import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise09.Signature

/-! Exercise 3.3.9: the rank-one matrix identity for tight frames. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- A finite family is a tight frame with positive bound `A` if and only if its
rank-one outer products sum to `A` times the identity matrix. -/
theorem hdp_03_ex_3_3_9 : hdp_03_ex_3_3_9__contract_type := by
  intro N n u A hA
  exact NumStability.HDP.Vector.Frame.isTightFrame_iff_sum_vecMulVec u hA

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_9__contract : hdp_03_ex_3_3_9__contract_type :=
  hdp_03_ex_3_3_9

end NumStability.HDP.Contract
