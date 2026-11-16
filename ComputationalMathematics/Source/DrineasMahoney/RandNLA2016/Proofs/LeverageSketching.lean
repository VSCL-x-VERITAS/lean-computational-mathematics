import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeverageSketching

/-! # Equivalence of squared and unsquared residual minimization -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem leastSquaresResidualMinimum : Targets.leastSquaresResidualMinimum := by
  intro m n A b xOpt
  constructor
  · intro h x
    exact Real.sqrt_le_sqrt (h x)
  · intro h x
    have hx := (sq_le_sq₀ (vecNorm2_nonneg (lsResidual A b xOpt))
      (vecNorm2_nonneg (lsResidual A b x))).mpr (h x)
    simpa only [vecNorm2_sq] using hx

end NumStability.Source.DrineasMahoney.RandNLA2016
