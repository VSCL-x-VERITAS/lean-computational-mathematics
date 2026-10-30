import Mathlib.InformationTheory.Hamming

/-!
Proof-free draft for the literal example on HDP printed pages 85–86.
The displayed spaces are preserved and cannot account for either mismatch.
This target is unsealed and carries no source-faithfulness acceptance.
-/

namespace NumStability.HDP.SourceTargets

/-- The supplied messages have equal lengths and differ at exactly two letters. -/
def errorCorruptionStringExample : Prop :=
  "fill the glass".toList.length = 14 ∧
  "bill the class".toList.length = 14 ∧
  hammingDist
    (fun i : Fin 14 => "fill the glass".toList.getD i.val ' ')
    (fun i : Fin 14 => "bill the class".toList.getD i.val ' ') = 2 ∧
  ("fill the glass".toList.filter (fun c => c != ' ')).length = 12 ∧
  ("bill the class".toList.filter (fun c => c != ' ')).length = 12 ∧
  hammingDist
    (fun i : Fin 12 => ("fill the glass".toList.filter (fun c => c != ' ')).getD i.val ' ')
    (fun i : Fin 12 => ("bill the class".toList.filter (fun c => c != ' ')).getD i.val ' ') = 2

end NumStability.HDP.SourceTargets
