import ComputationalMathematics.HDP.Vector.Covariance
import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.CovarianceExpansion.Signature

/-! Source-facing contract for the covariance expansion in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: covariance is the second-moment matrix minus
the outer product of the mean vector with itself. -/
theorem hdp_03_body_3_2_covariance_expansion :
    hdp_03_body_3_2_covariance_expansion__contract_type := by
  intro n Ω _ μ _ X hX
  exact NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_secondMoment_sub_outer X hX

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 covariance-expansion signature. -/
theorem hdp_03_body_3_2_covariance_expansion__contract :
    hdp_03_body_3_2_covariance_expansion__contract_type :=
  hdp_03_body_3_2_covariance_expansion

end NumStability.HDP.Contract
