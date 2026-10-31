import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianTheorem475Children
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianExercise476Children

/-!
# Gaussian-mixture recovery counterexamples

Both source rows use the same explicit coordinate-supported family. Its joint
law and probability obstruction apply to every data-only direction rule and
every null-measurable success certificate, including a nonempty spectral class.
-/

namespace NumStability.HDP.Contract.DiscrepancyChildren

/-- The theorem's complete analyst counterexample, with all printed hypotheses. -/
theorem theorem475_witness_child_proved : HDP04Theorem475WitnessChildTarget := by
  intro A c hA hc
  exact NumStability.HDP.Contract.Theorem475Counterexample.eventually_dataOnly_counterexample hA hc

/-- The same family refutes the exercise's final quantitative recovery request. -/
theorem exercise476_witness_child_proved : HDP04Exercise476WitnessChildTarget :=
  theorem475_witness_child_proved

end NumStability.HDP.Contract.DiscrepancyChildren
