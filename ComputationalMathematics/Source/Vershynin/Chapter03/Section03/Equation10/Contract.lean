import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation09.Contract
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation10.Signature

/-! Source-facing contract for Equation (3.10). -/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

/-- Equation (3.10), printed page 53: applying the tight-frame matrix identity
to a vector gives its frame expansion. -/
theorem hdp_03_eq_3_10 : hdp_03_eq_3_10__contract_type := by
  intro N n u A hFrame x
  have hMatrix := congrArg (fun M => Matrix.mulVec M x) (hdp_03_eq_3_9 u A hFrame)
  simpa [Matrix.sum_mulVec, Matrix.vecMulVec_mulVec, Matrix.smul_mulVec,
    Matrix.one_mulVec] using hMatrix

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_10__contract : hdp_03_eq_3_10__contract_type :=
  hdp_03_eq_3_10

end NumStability.HDP.Contract
