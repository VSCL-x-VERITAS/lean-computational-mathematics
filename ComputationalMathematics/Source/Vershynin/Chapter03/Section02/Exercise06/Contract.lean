import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Exercise06.Signature

/-! Source-facing contract for Exercise 3.2.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Exercise 3.2.6, printed page 49: independent centered isotropic vectors
have expected squared distance `2n`. -/
theorem hdp_03_ex_3_2_6 : hdp_03_ex_3_2_6__contract_type := by
  intro n Ω _ μ _ X Y hXLp hYLp hXmean hYmean hXiso hYiso hIndep
  exact NumStability.HDP.Vector.Isotropy.integral_vecNorm2Sq_sub_eq_two_mul_card
    hXLp hYLp hXmean hYmean hXiso hYiso hIndep

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.2.6 signature. -/
theorem hdp_03_ex_3_2_6__contract : hdp_03_ex_3_2_6__contract_type :=
  hdp_03_ex_3_2_6

end NumStability.HDP.Contract
