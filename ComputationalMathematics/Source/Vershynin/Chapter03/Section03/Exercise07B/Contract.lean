import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise07B.Signature

/-! Exercise 3.3.7(b): the direction of a standard Gaussian is uniform. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- A positive-dimensional standard Gaussian vector has the canonical uniform
law on the Euclidean unit sphere after radial normalization. -/
theorem hdp_03_ex_3_3_7b : hdp_03_ex_3_3_7b__contract_type := by
  intro d Omega _ mu X hX
  exact
    NumStability.HDP.Vector.Gaussian.hasLaw_gaussianUnitDirection_of_isStandardNormal
      d hX

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_7b__contract : hdp_03_ex_3_3_7b__contract_type :=
  hdp_03_ex_3_3_7b

end NumStability.HDP.Contract
