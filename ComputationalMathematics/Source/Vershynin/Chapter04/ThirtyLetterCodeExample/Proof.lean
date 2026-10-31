import ComputationalMathematics.Source.Vershynin.Chapter04.ThirtyLetterCodeExample.Target

/-!
# Proof of the qualified thirty-letter example

The uniform 26-symbol code supplies the fixed witness required by the audited
phrase-specific target.
-/

namespace NumStability.HDP.SourceTargets

/-- A thirty-letter codeword corrects every corruption of the displayed phrase
at Hamming radius two, under the selected 26-letter interpretation. -/
theorem thirtyLetterQualifiedProof : thirtyLetterQualifiedTarget := by
  refine ⟨NumStability.HDP.Coding.alphabet26Code12To30Correcting2, ?_⟩
  intro y hy
  exact NumStability.HDP.Coding.alphabet26Code12To30Correcting2.corrects
    fillTheGlass26 y hy

end NumStability.HDP.SourceTargets
