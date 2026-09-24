import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Lemma10B.Signature

/-! Source-facing contract for Lemma 3.3.10(b). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Lemma 3.3.10(b), printed page 54: if an isotropic random vector takes the
distinct values `x i` with positive probabilities `p i`, then the indexed
vectors `sqrt (p i) • x i` form a tight frame with bound one. -/
theorem hdp_03_lem_3_3_10b : hdp_03_lem_3_3_10b__contract_type := by
  intro N n Ω _ μ X p hp x _hpPos _hx hIso hLaw
  exact
    NumStability.HDP.Vector.FrameIsotropy.isTightFrame_sqrtWeights_of_hasFiniteWeightedVectorLaw
      p hp x hIso hLaw

set_option linter.style.nameCheck false in
theorem hdp_03_lem_3_3_10b__contract : hdp_03_lem_3_3_10b__contract_type :=
  hdp_03_lem_3_3_10b

end NumStability.HDP.Contract
