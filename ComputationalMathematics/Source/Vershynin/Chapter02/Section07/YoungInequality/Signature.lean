import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-! Frozen contract for the Young inequality used in Lemma 2.7.7. -/

namespace NumStability.HDP.Contract

def hdp_02_hbody_h2_d7_hyoung__contract_type : Prop :=
  ∀ a b : Real, a * b ≤ a ^ 2 / 2 + b ^ 2 / 2

end NumStability.HDP.Contract
