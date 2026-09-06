import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.YoungInequality.Signature

/-! Stable Chapter 2 source contract for the Young inequality in Lemma 2.7.7. -/

namespace NumStability.HDP.Contract

/-- The Young inequality printed in the proof of Lemma 2.7.7. -/
theorem hdp_02_hbody_h2_d7_hyoung_exact :
    ∀ a b : Real, a * b ≤ a ^ 2 / 2 + b ^ 2 / 2 := by
  intro a b
  nlinarith [sq_nonneg (a - b)]

theorem hdp_02_hbody_h2_d7_hyoung__contract :
    hdp_02_hbody_h2_d7_hyoung__contract_type :=
  hdp_02_hbody_h2_d7_hyoung_exact

end NumStability.HDP.Contract
