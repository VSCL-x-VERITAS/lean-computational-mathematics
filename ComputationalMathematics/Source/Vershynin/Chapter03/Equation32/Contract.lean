import ComputationalMathematics.Source.Vershynin.Chapter03.Equation32.Signature

/-! Display (3.32): a real Hilbert-space feature map represents its kernel by
pairwise inner products. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_32 : hdp_03_eq_3_32__contract_type := by
  intro X H _ _ _ K Φ
  exact NumStability.HDP.Kernel.isRealFeatureMap_iff K Φ

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_32__contract : hdp_03_eq_3_32__contract_type :=
  hdp_03_eq_3_32

end NumStability.HDP.Contract
