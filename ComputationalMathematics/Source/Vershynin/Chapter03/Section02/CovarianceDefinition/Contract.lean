import ComputationalMathematics.HDP.Vector.Covariance
import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.CovarianceDefinition.Signature

/-! Source-facing contract for the covariance-matrix definition in Section 3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: covariance is the expected centered outer
product, equivalently the second-moment matrix minus the outer product of means. -/
theorem hdp_03_body_3_2_covariance_def :
    hdp_03_body_3_2_covariance_def__contract_type := by
  intro n Ω _ μ _ X hX
  constructor
  · exact NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_centeredOuter μ X
  · exact
      NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_secondMoment_sub_outer X hX

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 covariance-definition signature. -/
theorem hdp_03_body_3_2_covariance_def__contract :
    hdp_03_body_3_2_covariance_def__contract_type :=
  hdp_03_body_3_2_covariance_def

end NumStability.HDP.Contract
