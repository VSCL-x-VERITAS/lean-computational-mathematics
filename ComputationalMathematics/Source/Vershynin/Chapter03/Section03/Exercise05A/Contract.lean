import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise05A.Signature

/-! Source-facing contract for Exercise 3.3.5(a). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.3.5(a), printed page 51: for a standard Gaussian vector `X`,
the expectation of `⟨X,u⟩ ⟨X,v⟩` is `⟨u,v⟩`. -/
theorem hdp_03_ex_3_3_5a : hdp_03_ex_3_3_5a__contract_type := by
  intro n Ω _ μ _ X u v hX
  exact NumStability.HDP.Vector.Gaussian.integral_linearMarginal_mul_linearMarginal_of_isStandardNormal hX u v

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_5a__contract : hdp_03_ex_3_3_5a__contract_type :=
  hdp_03_ex_3_3_5a

end NumStability.HDP.Contract
