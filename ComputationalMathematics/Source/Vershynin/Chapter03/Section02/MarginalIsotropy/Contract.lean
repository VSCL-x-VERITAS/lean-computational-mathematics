import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.MarginalIsotropy.Signature

/-! Source-facing contract for the marginal-variance characterization in Section 3.2.3. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Section 3.2.3, printed page 47: a centered random vector is isotropic if
and only if its one-dimensional marginals have the Euclidean variance profile. -/
theorem hdp_03_body_3_2_marginal_isotropy :
    hdp_03_body_3_2_marginal_isotropy__contract_type := by
  intro n Ω _ μ _ X hLp hMean
  exact NumStability.HDP.Vector.Isotropy.isIsotropic_iff_marginalVariance X hLp hMean

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.2.3 marginal signature. -/
theorem hdp_03_body_3_2_marginal_isotropy__contract :
    hdp_03_body_3_2_marginal_isotropy__contract_type :=
  hdp_03_body_3_2_marginal_isotropy

end NumStability.HDP.Contract
