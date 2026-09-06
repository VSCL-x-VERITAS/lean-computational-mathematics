import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Remark09.Exact.Signature
import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Proposition01.Contract
import ComputationalMathematics.HDP.Scalar.MGFLocalTaylor
import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Stable Chapter 2 source contract for Remark 2.7.9. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Remark 2.7.9: the local quadratic MGF approximation, its standard-normal
special case, the cited class characterizations, and the `Exp(1)` obstruction. -/
theorem hdp_02_hrem_h2_d7_d9_exact :
    hdp_02_hrem_h2_d7_d9_exact__contract_type := by
  refine ⟨?_, NumStability.HDP.Scalar.SubGaussian.standardNormalMGF,
    hdp_02_hprop_h2_d5_d2, hdp_02_hprop_h2_d7_d1_exact⟩
  refine ⟨?_, NumStability.HDP.exp_sq_half_local_taylor, ?_⟩
  · intro Ω _ μ _ X hX hBound _ _
    exact NumStability.HDP.bounded_mgf_local_taylor μ X hX hBound
  · intro lam hlam
    exact NumStability.HDP.Scalar.SubExponential.remark279_exp_mgf_not_integrable hlam

theorem hdp_02_hrem_h2_d7_d9__contract :
    hdp_02_hrem_h2_d7_d9_exact__contract_type :=
  hdp_02_hrem_h2_d7_d9_exact

end NumStability.HDP.Contract
