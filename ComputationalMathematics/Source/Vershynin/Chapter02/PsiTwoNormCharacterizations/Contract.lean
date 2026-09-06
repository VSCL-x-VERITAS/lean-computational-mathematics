import ComputationalMathematics.Source.Vershynin.Chapter02.PsiTwoNormCharacterizations.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 contract module for the gauge-facing ψ₂
    characterization theorem. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hthm_hpsi2_hnorm_hcharacterizations__contract
    : hdp_02_hthm_hpsi2_hnorm_hcharacterizations__contract_type := by
  intro Ω inst Ωμ instμ X hCenter
  exact NumStability.HDP.Contract.hdp_02_hthm_hpsi2_hnorm_hcharacterizations hCenter

end NumStability.HDP.Contract
