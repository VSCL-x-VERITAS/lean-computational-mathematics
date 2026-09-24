import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Lemma02.Signature

/-! Lemma 3.4.2: independent centered sub-Gaussian coordinates. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Independent mean-zero sub-Gaussian coordinates form a sub-Gaussian vector,
whose vector `ψ₂` norm is controlled by the largest coordinate norm. -/
theorem hdp_03_lem_3_4_2 : hdp_03_lem_3_4_2__contract_type :=
  NumStability.HDP.Vector.SubGaussian.independentCenteredCoordinates_vectorSubGaussian

set_option linter.style.nameCheck false in
theorem hdp_03_lem_3_4_2__contract : hdp_03_lem_3_4_2__contract_type :=
  hdp_03_lem_3_4_2

end NumStability.HDP.Contract
