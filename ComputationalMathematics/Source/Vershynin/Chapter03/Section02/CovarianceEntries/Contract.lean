import ComputationalMathematics.HDP.Vector.Covariance
import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.CovarianceEntries.Signature

/-! Source-facing contract for the covariance-entry formula in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: covariance-matrix entries are the
covariances of pairs of coordinates. -/
theorem hdp_03_body_3_2_covariance_entries :
    hdp_03_body_3_2_covariance_entries__contract_type := by
  intro n Ω _ μ _ X _ i j
  exact congrFun
    (congrFun
      (NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_centeredOuter μ X) i) j

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 covariance-entry signature. -/
theorem hdp_03_body_3_2_covariance_entries__contract :
    hdp_03_body_3_2_covariance_entries__contract_type :=
  hdp_03_body_3_2_covariance_entries

end NumStability.HDP.Contract
