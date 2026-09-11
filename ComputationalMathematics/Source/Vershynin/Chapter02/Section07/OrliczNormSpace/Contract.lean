import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.OrliczNormSpace.Signature
import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions

/-! Stable Chapter 2 contract module for the Orlicz norm and space definitions. -/

namespace NumStability.HDP.Contract

theorem hdp_02_hdef_horlicz_hnorm_hspace_exact :
    hdp_02_hdef_horlicz_hnorm_hspace__contract_type :=
  NumStability.HDP.Scalar.SubExponential.orliczGauge_and_member_definitions

theorem hdp_02_hdef_horlicz_hnorm_hspace__contract :
    hdp_02_hdef_horlicz_hnorm_hspace__contract_type := by
  exact hdp_02_hdef_horlicz_hnorm_hspace_exact

end NumStability.HDP.Contract
