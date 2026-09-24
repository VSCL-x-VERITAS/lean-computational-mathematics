import ComputationalMathematics.Source.Vershynin.Chapter03.Section07.Lemma07.Signature

/-! Lemma 3.7.7: normalized signed sine-series features map the Euclidean unit
sphere to a Hilbert unit sphere and satisfy Krivine's arcsine identity. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_lem_3_7_7 : hdp_03_lem_3_7_7__contract_type := by
  intro n u v hu hv
  exact ⟨(NumStability.HDP.Tensor.krivineFeature_norm u hu).1,
    (NumStability.HDP.Tensor.krivineFeature_norm v hv).2,
    NumStability.HDP.Tensor.krivineFeature_arcsin u v hu hv⟩

set_option linter.style.nameCheck false in
theorem hdp_03_lem_3_7_7__contract : hdp_03_lem_3_7_7__contract_type :=
  hdp_03_lem_3_7_7

end NumStability.HDP.Contract
