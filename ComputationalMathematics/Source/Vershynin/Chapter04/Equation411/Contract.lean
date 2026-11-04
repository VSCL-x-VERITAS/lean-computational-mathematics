import ComputationalMathematics.HDP.Coding.ErrorCorrection

/-!
# Vershynin Chapter 4, Equation (4.11)
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.11): `2r+1` copies of a `k`-letter message use
`(2r+1)k` letters. -/
theorem hdp_04_equation_4_11 (r k : ℕ) :
    Fintype.card (Fin (2 * r + 1) × Fin k) = (2 * r + 1) * k := by
  simp

end NumStability.HDP.Contract
