import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.SymmetricBernoulli.Signature

/-! Source-facing contract for the symmetric Bernoulli vector definition in Section 3.3.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.1, printed page 49: a symmetric Bernoulli vector has independent
coordinates, each with the symmetric two-point Bernoulli law. -/
theorem hdp_03_body_3_3_symmetric_bernoulli :
    hdp_03_body_3_3_symmetric_bernoulli__contract_type := by
  intro n Ω _ μ _ X
  exact ⟨Iff.rfl,
    NumStability.HDP.Vector.Bernoulli.isSymmetricBernoulli_iff_hasUniformDiscreteCubeLaw⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.1 definition signature. -/
theorem hdp_03_body_3_3_symmetric_bernoulli__contract :
    hdp_03_body_3_3_symmetric_bernoulli__contract_type :=
  hdp_03_body_3_3_symmetric_bernoulli

end NumStability.HDP.Contract
