import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianAllUnitCorrections
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianExercise476Children

/-! Whole-parent discrepancy counterpart.
The ordered conjunction retains the formal counterexample and every separately
named analyst correction. It does not assert the false printed claim. -/

namespace NumStability.HDP.Contract.DiscrepancyParents

def exercise476WholeParent : Prop :=
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04Exercise476WitnessChildTarget ∧
    NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit.HDP04Exercise476AllUnitCorrectionChildTarget

end NumStability.HDP.Contract.DiscrepancyParents
