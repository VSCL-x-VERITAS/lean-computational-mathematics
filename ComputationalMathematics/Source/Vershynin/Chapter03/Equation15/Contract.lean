import ComputationalMathematics.Source.Vershynin.Chapter03.Equation15.Signature
import ComputationalMathematics.HDP.Scalar.GaussianTails

/-! Display (3.15): the squared `L²` norm of the tail truncation of a
standard-normal variable has the printed explicit bound, which is below
`4 / R²`. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.GaussianTails

theorem hdp_03_eq_3_15 : hdp_03_eq_3_15__contract_type := by
  intro R hR
  exact ⟨standardNormal_absTail_secondMoment_le R hR,
    standardNormal_absTail_secondMoment_lt_four_div_sq R hR⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_15__contract : hdp_03_eq_3_15__contract_type :=
  hdp_03_eq_3_15

end NumStability.HDP.Contract
