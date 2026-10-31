import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise429.NumericalTarget

/-!
# Exercise 4.2.9: proof of the selected numerical comparison

This proof reuses the general metric-space comparison. The source-facing
interpretation of the extended covering numbers remains under review.
-/

namespace NumStability.HDP.Contract

/-- Mathematical proof of the selected numerical target. -/
theorem exercise429NumericalTarget_proved : exercise429NumericalTarget := by
  intro T _ K ε _
  exact NumStability.HDP.Metric.externalCoveringNumber_comparison K ε

end NumStability.HDP.Contract
