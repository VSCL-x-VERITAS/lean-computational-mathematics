import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczFunction.Signature
import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions

/-! Stable Chapter 2 contract module for the Orlicz-function definition. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hdef_horlicz_hfunction_exact :
    hdp_02_hdef_horlicz_hfunction__contract_type :=
  NumStability.HDP.Scalar.SubExponential.exists_orliczFunction_toFun_iff

theorem hdp_02_hdef_horlicz_hfunction__contract :
    hdp_02_hdef_horlicz_hfunction__contract_type := by
  exact hdp_02_hdef_horlicz_hfunction_exact

end NumStability.HDP.Contract
