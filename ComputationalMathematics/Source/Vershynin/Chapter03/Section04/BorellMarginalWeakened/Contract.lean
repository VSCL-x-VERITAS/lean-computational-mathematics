import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.BorellMarginalWeakened.Signature

/-!
# Weakened Borell marginal result

This theorem records the bounded-support consequence currently available in
the library.  It does not claim the universal constant from Borell's lemma.
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Every unit marginal of an isotropic convex-body law has finite exact `ψ₁`
gauge.  The bound supplied by this theorem may depend on the body and the
direction. -/
theorem hdp_03_body_3_4_borell_marginal_weakened :
    hdp_03_body_3_4_borell_marginal_weakened__contract_type := by
  intro n K hK _hIso u _hu
  exact
    NumStability.HDP.Convex.linearMarginal_psiOneGauge_lt_top_of_isConvexBody
      hK u

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_4_borell_marginal_weakened__contract :
    hdp_03_body_3_4_borell_marginal_weakened__contract_type :=
  hdp_03_body_3_4_borell_marginal_weakened

end NumStability.HDP.Contract
