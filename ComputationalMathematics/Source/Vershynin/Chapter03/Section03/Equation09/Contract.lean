import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation09.Signature
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise09.Contract

/-! Source-facing contract for Equation (3.9). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.9), printed page 53: the outer products of a positive-size tight
frame with bound `A` sum to `A` times the identity matrix. -/
theorem hdp_03_eq_3_9 : hdp_03_eq_3_9__contract_type := by
  intro N n u A hFrame
  exact (hdp_03_ex_3_3_9 u A hFrame.1).mp hFrame

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_9__contract : hdp_03_eq_3_9__contract_type :=
  hdp_03_eq_3_9

end NumStability.HDP.Contract
