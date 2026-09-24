import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Exercise06.Signature

/-! Exercise 3.7.6: an arbitrary globally convergent real power series is
realized as a cross-inner-product kernel by splitting coefficient magnitudes
and signs between two Hilbert-space feature maps. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_ex_3_7_6 : hdp_03_ex_3_7_6__contract_type := by
  intro n f a hseries u v
  exact ⟨NumStability.HDP.Tensor.signedPowerSeriesFeature_inner f a hseries u v,
    NumStability.HDP.Tensor.absolute_signed_powerSeriesFeature_norm_sq f a hseries u⟩

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_7_6__contract : hdp_03_ex_3_7_6__contract_type :=
  hdp_03_ex_3_7_6

end NumStability.HDP.Contract
