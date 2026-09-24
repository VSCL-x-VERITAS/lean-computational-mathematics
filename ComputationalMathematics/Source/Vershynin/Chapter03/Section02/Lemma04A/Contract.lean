import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Lemma04A.Signature

/-! Source-facing contract for the first assertion of Lemma 3.2.4. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Lemma 3.2.4, first assertion, printed pages 47–48: the expected squared
Euclidean norm of an isotropic random vector in `ℝⁿ` equals `n`. -/
theorem hdp_03_lem_3_2_4a :
    hdp_03_lem_3_2_4a__contract_type := by
  intro n Ω _ μ _ X hLp hX
  exact NumStability.HDP.Vector.Isotropy.integral_vecNorm2Sq_eq_card hLp hX

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen first assertion of Lemma 3.2.4. -/
theorem hdp_03_lem_3_2_4a__contract :
    hdp_03_lem_3_2_4a__contract_type :=
  hdp_03_lem_3_2_4a

end NumStability.HDP.Contract
