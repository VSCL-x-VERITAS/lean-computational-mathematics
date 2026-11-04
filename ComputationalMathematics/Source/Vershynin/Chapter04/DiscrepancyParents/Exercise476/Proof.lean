import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianAllUnitCorrectionProofs
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianWitnessProofs
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyParents.Exercise476.Target

/-!
# Exercise 4.7.6: witness and five-stage all-unit corrected counterpart

Combine the counterexample with the separately specified corrected proof stages.
-/

namespace NumStability.HDP.Contract.DiscrepancyParents

/-- The exercise's counterexample and its corrected five-stage all-unit statement. -/
theorem exercise476WholeParent_proved : exercise476WholeParent :=
  ⟨DiscrepancyChildren.exercise476_witness_child_proved,
    DiscrepancyChildren.GaussianAllUnit.exercise476_allUnitCorrection_child_proved⟩

end NumStability.HDP.Contract.DiscrepancyParents
