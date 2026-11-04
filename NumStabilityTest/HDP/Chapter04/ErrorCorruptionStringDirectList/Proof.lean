import NumStabilityTest.HDP.Chapter04.ErrorCorruptionStringDirectList.Target
import ComputationalMathematics.Source.Vershynin.Chapter04.ErrorCorruptionString.DirectListExample

/-! Native verification bridge from the canonical source proof to its frozen target. -/

namespace NumStability.HDP.Verification

theorem errorCorruptionStringAtMostTwoExample :
    SourceTargets.StringDirectListDraft.errorCorruptionStringAtMostTwoExample :=
  StringCorruption.errorCorruptionStringAtMostTwoExample

end NumStability.HDP.Verification
