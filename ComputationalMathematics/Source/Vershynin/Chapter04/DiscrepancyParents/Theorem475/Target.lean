import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianAllUnitCorrections
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.GaussianTheorem475Children

/-! Whole-parent discrepancy counterpart.
The ordered conjunction retains the formal counterexample and every separately
named analyst correction. It does not assert the false printed claim. -/

namespace NumStability.HDP.Contract.DiscrepancyParents

def theorem475WholeParent : Prop :=
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04Theorem475WitnessChildTarget ∧
    NumStability.HDP.Contract.DiscrepancyChildren.GaussianAllUnit.HDP04Theorem475AllUnitCorrectionChildTarget

end NumStability.HDP.Contract.DiscrepancyParents
