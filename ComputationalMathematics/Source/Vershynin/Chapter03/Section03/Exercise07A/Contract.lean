import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise07A.Signature

/-! Exercise 3.3.7(a): standard-Gaussian radius and direction are independent. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- The Euclidean norm of a positive-dimensional standard Gaussian vector is
independent of its radially normalized direction. -/
theorem hdp_03_ex_3_3_7a : hdp_03_ex_3_3_7a__contract_type := by
  intro d Omega _ mu X hX
  exact
    NumStability.HDP.Vector.Gaussian.indepFun_radius_direction_of_isStandardNormal
      d hX

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_7a__contract : hdp_03_ex_3_3_7a__contract_type :=
  hdp_03_ex_3_3_7a

end NumStability.HDP.Contract
