import ComputationalMathematics.HDP.Vector.NormFourthMoment
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Exercise06.Signature

/-! Source-facing contract for Exercise 3.1.6. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.1.6, printed page 44: independent coordinates with unit second
moments and fourth moments at most `K⁴` satisfy `Var ‖X‖₂ ≤ C K⁴`. -/
theorem hdp_03_hex_h3_d1_d6 : hdp_03_hex_h3_d1_d6__contract_type := by
  refine ⟨1, zero_lt_one, ?_⟩
  intro n _ Ω _ μ _ X K hMeas hFourthInt hSecond hFourth hIndep
  simpa using
    NumStability.HDP.Vector.NormFourthMoment.varianceEuclideanNorm_le_fourthMoment
      X K hMeas hFourthInt hSecond hFourth hIndep

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.1.6 signature. -/
theorem hdp_03_hex_h3_d1_d6__contract :
    hdp_03_hex_h3_d1_d6__contract_type :=
  hdp_03_hex_h3_d1_d6

end NumStability.HDP.Contract
