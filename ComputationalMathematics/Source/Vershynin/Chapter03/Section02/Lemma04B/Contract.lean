import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Lemma04B.Signature

/-! Source-facing contract for the second assertion of Lemma 3.2.4. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Lemma 3.2.4, second assertion, printed pages 47–48: two independent
isotropic random vectors in `ℝⁿ` have expected squared inner product `n`. -/
theorem hdp_03_lem_3_2_4b :
    hdp_03_lem_3_2_4b__contract_type := by
  intro n Ω _ μ _ X Y hXLp hYLp hXiso hYiso hIndep
  exact NumStability.HDP.Vector.Isotropy.integral_inner_sq_eq_card
    hXLp hYLp hXiso hYiso hIndep

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen second assertion of Lemma 3.2.4. -/
theorem hdp_03_lem_3_2_4b__contract :
    hdp_03_lem_3_2_4b__contract_type :=
  hdp_03_lem_3_2_4b

end NumStability.HDP.Contract
