import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianAllUnitCorrectionProofs
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianWitnessProofs
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyParents.Theorem475.Target

/-!
# Theorem 4.7.5: witness and all-unit corrected counterpart

Combine the counterexample with the separately specified positive replacement.
-/

namespace NumStability.HDP.Contract.DiscrepancyParents

/-- The theorem's counterexample and its all-unit correction under stronger conditions. -/
theorem theorem475WholeParent_proved : theorem475WholeParent :=
  ⟨DiscrepancyChildren.theorem475_witness_child_proved,
    DiscrepancyChildren.GaussianAllUnit.theorem475_allUnitCorrection_child_proved⟩

end NumStability.HDP.Contract.DiscrepancyParents
