import ComputationalMathematics.HDP.Matrix.SubGaussianNormThreshold

/-!
# Vershynin Chapter 4, Equation (4.16)
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.16): the threshold selected after the net union
bound is `C K (√n + √m + t)`. -/
theorem hdp_04_equation_4_16 (C K : ℝ) (n m : ℕ) (t : ℝ) :
    NumStability.HDP.Matrix.subGaussianNormThreshold C K n m t =
      C * K * (Real.sqrt n + Real.sqrt m + t) := by
  rfl

end NumStability.HDP.Contract
