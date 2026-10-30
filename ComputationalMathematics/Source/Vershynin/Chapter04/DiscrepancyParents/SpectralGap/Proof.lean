import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417CorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SignalNormCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapCorrectionProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.SpectralGapWitnessProof
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyParents.SpectralGap.Target

/-!
# Spectral gap: witness and complete corrected counterpart

Assemble the separately named child results in the target's declared order.
-/

namespace NumStability.HDP.Contract.DiscrepancyParents

/-- The indexed-gap counterexample and the complete corrected spectral statements. -/
theorem spectralGapWholeParent_proved : spectralGapWholeParent :=
  ⟨DiscrepancyChildren.spectral_gap_witness_child_proved,
    DiscrepancyChildren.equation417_correction_child_proved,
    DiscrepancyChildren.signal_norm_correction_child_proved,
    DiscrepancyChildren.spectral_gap_correction_child_proved⟩

end NumStability.HDP.Contract.DiscrepancyParents
