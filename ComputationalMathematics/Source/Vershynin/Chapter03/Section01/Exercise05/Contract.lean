import ComputationalMathematics.HDP.Vector.NormVariance
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Exercise05.Signature

/-! Source-facing contract for Exercise 3.1.5. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.1.5, printed page 44: the variance of the Euclidean norm is
bounded by `C K⁴` for one universal positive constant `C`. -/
theorem hdp_03_hex_h3_d1_d5 : hdp_03_hex_h3_d1_d5__contract_type := by
  rcases NumStability.HDP.Vector.NormVariance.varianceEuclideanNorm_le with
    ⟨C, hC, hBound⟩
  exact ⟨C, lt_of_lt_of_le zero_lt_one hC, hBound⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Exercise 3.1.5 signature. -/
theorem hdp_03_hex_h3_d1_d5__contract :
    hdp_03_hex_h3_d1_d5__contract_type :=
  hdp_03_hex_h3_d1_d5

end NumStability.HDP.Contract
