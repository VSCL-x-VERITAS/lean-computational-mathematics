import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417CorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417WitnessProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyParents.Equation417.Target

/-!
# Equation (4.17): witness and complete corrected counterpart

Assemble the separately named child results in the target's declared order.
-/

namespace NumStability.HDP.Contract.DiscrepancyParents

/-- The counterexample and all three components of the corrected counterpart. -/
theorem equation417WholeParent_proved : equation417WholeParent :=
  ⟨DiscrepancyChildren.equation417_witness_child_proved,
    DiscrepancyChildren.equation417_correction_child_proved,
    DiscrepancyChildren.signal_norm_correction_child_proved,
    DiscrepancyChildren.spectral_gap_correction_child_proved⟩

end NumStability.HDP.Contract.DiscrepancyParents
