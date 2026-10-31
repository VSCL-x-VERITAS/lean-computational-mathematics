import ComputationalMathematics.HDP.Coding.QaryHammingVolume

/-!
# Chapter 4 thirty-letter example: qualified target

This proof-free statement uses the owner's explicit 26-lowercase-letter
interpretation of the printed phrase. The fixed code witness corrects every
twelve-letter word; the displayed conclusion concerns the printed phrase.
Independent source-to-target review is still required.
-/

open NumStability.HDP.Coding

namespace NumStability.HDP.SourceTargets

/-- The twelve letters of “fill the glass,” omitting its two spaces, with
`a ↔ 0, …, z ↔ 25`. -/
def fillTheGlass26 : QaryWord 26 12 :=
  ![(5 : Fin 26), 8, 11, 11, 19, 7, 4, 6, 11, 0, 18, 18]

/-- A fixed total 26-letter code witness corrects the displayed phrase at
inclusive Hamming radius two. The structure additionally certifies correction
of every twelve-letter word; that witness requirement is stronger than the
phrase-specific printed conclusion. -/
def thirtyLetterQualifiedTarget : Prop :=
  ∃ c : QaryErrorCorrectingCode 26 12 30 2,
    ∀ y : QaryWord 26 30,
      hammingDist y (c.encode fillTheGlass26) ≤ 2 →
        c.decode y = fillTheGlass26

end NumStability.HDP.SourceTargets
