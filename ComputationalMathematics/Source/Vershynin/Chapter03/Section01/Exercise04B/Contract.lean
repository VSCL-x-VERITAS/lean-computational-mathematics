import ComputationalMathematics.HDP.Vector.NormExpectation
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Exercise04B.Signature

/-! Source-facing contract for Exercise 3.1.4(b). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.1.4(b), printed page 43: for a dimension-uniform coordinate
`ψ₂` scale, the expectation error can be replaced by a quantity vanishing as
`n → ∞`; the wrapper records the explicit `C K⁴ / √n` rate. -/
theorem hdp_03_hex_h3_d1_d4b : hdp_03_hex_h3_d1_d4b__contract_type := by
  rcases
      NumStability.HDP.Vector.NormConcentration.expectationEuclideanNorm_sqrt_sub_le_div_sqrt with
    ⟨C, hC, hBound⟩
  exact ⟨C, lt_of_lt_of_le zero_lt_one hC, hBound⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.1.4(b) signature. -/
theorem hdp_03_hex_h3_d1_d4b__contract :
    hdp_03_hex_h3_d1_d4b__contract_type :=
  hdp_03_hex_h3_d1_d4b

end NumStability.HDP.Contract
