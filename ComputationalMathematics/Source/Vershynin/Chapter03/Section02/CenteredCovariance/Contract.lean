import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.CenteredCovariance.Signature

/-! Source-facing contract for the centered covariance identity in Section 3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2, printed page 45: for a zero-mean random vector, covariance and
second-moment matrices coincide. -/
theorem hdp_03_body_3_2_centered_covariance :
    hdp_03_body_3_2_centered_covariance__contract_type := by
  intro n Ω _ μ _ X hX hMean
  exact
    NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_secondMomentMatrix X hX hMean

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2 centered-covariance signature. -/
theorem hdp_03_body_3_2_centered_covariance__contract :
    hdp_03_body_3_2_centered_covariance__contract_type :=
  hdp_03_body_3_2_centered_covariance

end NumStability.HDP.Contract
