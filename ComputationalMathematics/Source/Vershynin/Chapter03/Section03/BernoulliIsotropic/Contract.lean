import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.BernoulliIsotropic.Signature

/-! Source-facing contract for symmetric Bernoulli isotropy in Section 3.3.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.1, printed page 49: the symmetric Bernoulli distribution is isotropic. -/
theorem hdp_03_body_3_3_bernoulli_isotropic :
    hdp_03_body_3_3_bernoulli_isotropic__contract_type := by
  intro n Ω _ μ _ X hX
  exact NumStability.HDP.Vector.Bernoulli.isIsotropic_of_isSymmetricBernoulli hX

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.1 isotropy signature. -/
theorem hdp_03_body_3_3_bernoulli_isotropic__contract :
    hdp_03_body_3_3_bernoulli_isotropic__contract_type :=
  hdp_03_body_3_3_bernoulli_isotropic

end NumStability.HDP.Contract
