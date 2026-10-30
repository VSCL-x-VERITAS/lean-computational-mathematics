import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem435.Contract
import ComputationalMathematics.Source.Vershynin.Chapter04.Theorem435.CorrectedTarget

namespace NumStability.HDP.Verification

/-- Expose the retained proof together with its independently audited frozen target. -/
theorem theorem435Corrected : NumStability.HDP.Recovery435.correctedTarget :=
  @NumStability.HDP.Contract.hdp_04_theorem_4_3_5_corrected

end NumStability.HDP.Verification
