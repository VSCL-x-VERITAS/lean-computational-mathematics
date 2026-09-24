import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Exercise04A.Signature

/-! Source-facing contract for Exercise 3.1.4(a). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.1.4(a), printed page 43: the expected Euclidean norm is within
`C K²` of `√n` for one universal positive constant `C`. -/
theorem hdp_03_hex_h3_d1_d4a : hdp_03_hex_h3_d1_d4a__contract_type := by
  rcases
      NumStability.HDP.Vector.NormConcentration.expectationEuclideanNorm_abs_sub_sqrt_le with
    ⟨C, hC, hBound⟩
  refine ⟨C, lt_of_lt_of_le zero_lt_one hC, ?_⟩
  intro n _ Ω _ μ _ X hMeas hFinite hSecond hIndep
  have h := hBound X hMeas hFinite hSecond hIndep
  rcases abs_le.mp h with ⟨hLower, hUpper⟩
  constructor <;> linarith

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.1.4(a) signature. -/
theorem hdp_03_hex_h3_d1_d4a__contract :
    hdp_03_hex_h3_d1_d4a__contract_type :=
  hdp_03_hex_h3_d1_d4a

end NumStability.HDP.Contract
