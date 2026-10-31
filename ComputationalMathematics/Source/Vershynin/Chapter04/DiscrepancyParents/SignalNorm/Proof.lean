import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417CorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormWitnessProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyParents.SignalNorm.Target

/-!
# Signal norm: witness and complete corrected counterpart

Assemble the separately named child results in the target's declared order.
-/

namespace NumStability.HDP.Contract.DiscrepancyParents

/-- The norm counterexample and all components of the corrected counterpart. -/
theorem signalNormWholeParent_proved : signalNormWholeParent :=
  ⟨DiscrepancyChildren.signal_norm_witness_child_proved,
    DiscrepancyChildren.equation417_correction_child_proved,
    DiscrepancyChildren.signal_norm_correction_child_proved,
    DiscrepancyChildren.spectral_gap_correction_child_proved⟩

end NumStability.HDP.Contract.DiscrepancyParents
