import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417Children
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormChildren
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapChildren

/-! Whole-parent discrepancy counterpart.
The ordered conjunction retains the formal counterexample and every separately
named analyst correction. It does not assert the false printed claim. -/

namespace NumStability.HDP.Contract.DiscrepancyParents

def equation417WholeParent : Prop :=
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04Equation417WitnessChildTarget ∧
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04Equation417CorrectionChildTarget ∧
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04SBMSignalNormCorrectionChildTarget ∧
    NumStability.HDP.Contract.DiscrepancyChildren.HDP04SBMSpectralGapCorrectionChildTarget

end NumStability.HDP.Contract.DiscrepancyParents
