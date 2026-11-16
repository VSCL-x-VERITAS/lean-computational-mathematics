import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Proofs.EntrySparsification
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.EntrySparsificationAccuracy

/-! # Corrected bounded-accuracy entry-sampling guarantee -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem correctedTruncatedEntryGuaranteeUnitAccuracy :
    Targets.correctedTruncatedEntryGuaranteeUnitAccuracy := by
  intro n s A eps δ hn hs heps _heps1 hδ hδ1 hsample
  constructor
  · intro outcome
    exact truncatedElementwiseSketch_nonzero_card_le (eps / (2 * (n : ℝ))) A outcome
  · exact correctedTruncatedEntryGuarantee n s A eps δ hn hs heps hδ hδ1 hsample

end NumStability.Source.DrineasMahoney.RandNLA2016
