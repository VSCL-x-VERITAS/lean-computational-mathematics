import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise05B.Signature

/-! Source-facing contract for Exercise 3.3.5(b). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.3.5(b), printed page 51: standard-Gaussian linear
marginals preserve Euclidean distance as scalar `L²` distance. -/
theorem hdp_03_ex_3_3_5b : hdp_03_ex_3_3_5b__contract_type := by
  intro n Ω _ μ _ X u v hX
  exact NumStability.HDP.Vector.Gaussian.scalarL2Distance_linearMarginal_of_isStandardNormal
    hX u v

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_5b__contract : hdp_03_ex_3_3_5b__contract_type :=
  hdp_03_ex_3_3_5b

end NumStability.HDP.Contract
