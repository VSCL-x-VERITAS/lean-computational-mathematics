import ComputationalMathematics.Algorithms.LinearSystems.LeastSquares.Existence
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.LeastSquaresExistence

/-! # Existence of finite real least-squares minimizers -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem leastSquaresMinimizerExists : Targets.leastSquaresMinimizerExists := by
  intro m n A b
  exact ⟨leastSquaresMinimizer A b,
    leastSquaresMinimizer_isLeastSquaresMinimizer A b,
    leastSquaresMinimizer_residual_norm_le A b⟩

end NumStability.Source.DrineasMahoney.RandNLA2016
