import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Exercise05C.Signature

/-! Exercise 3.7.5(c): a globally convergent power series with nonnegative
coefficients is realized by the Hilbert sum of its scaled tensor powers. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_7_5c : hdp_03_ex_3_7_5c__contract_type := by
  intro n f a ha hseries u v
  exact NumStability.HDP.Tensor.powerSeriesFeature_inner f a ha hseries u v

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_7_5c__contract : hdp_03_ex_3_7_5c__contract_type :=
  hdp_03_ex_3_7_5c

end NumStability.HDP.Contract
