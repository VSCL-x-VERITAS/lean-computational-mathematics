import ComputationalMathematics.Source.Vershynin.Chapter02.Section09.Theorem02.Signature

/-! Stable source wrapper for Vershynin, Theorem 2.9.2. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hthm_h2_d9_d2_exact :
    hdp_02_hthm_h2_d9_d2__contract_type := by
  intro ι Ω _ _ μ _ X K hK hX hInt hBound hIndep t ht
  constructor
  · intro hVariance
    exact
      NumStability.HDP.Scalar.IndependentSums.Bennett.bennettTail_eq_zero_of_variance_eq_zero
        hK hX hBound hVariance ht
  · intro _
    exact NumStability.HDP.Scalar.IndependentSums.Bennett.bennettTail
      hK hX hInt hBound hIndep ht.le

theorem hdp_02_hthm_h2_d9_d2__contract :
    hdp_02_hthm_h2_d9_d2__contract_type :=
  hdp_02_hthm_h2_d9_d2_exact

end NumStability.HDP.Contract
