import Mathlib.InformationTheory.Hamming

/-!
Unsealed, uncompiled successor proposal for the fixed displayed message pair.
Direct character lists preserve the two ordinary spaces, case and order.
Both raw and ordinary-space-filtered conventions remain explicit.
The four conjuncts propose same-length reception within budget two.
No assertion about arbitrary messages, k, r, encoding or decoding is made.
Source scope, object correspondence and native elaboration still require review.
-/

set_option autoImplicit false

namespace NumStability.HDP.SourceTargets.StringDirectListDraft

/-- All displayed message characters, including both ordinary spaces. -/
def rawSent : List Char :=
  ['f', 'i', 'l', 'l', ' ', 't', 'h', 'e', ' ', 'g', 'l', 'a', 's', 's']

/-- All displayed received characters, including both ordinary spaces. -/
def rawReceived : List Char :=
  ['b', 'i', 'l', 'l', ' ', 't', 'h', 'e', ' ', 'c', 'l', 'a', 's', 's']

/-- The alternate convention deletes only ordinary spaces from the sent list. -/
def lettersSent : List Char :=
  rawSent.filter (fun c => c != ' ')

/-- The same alternate convention applied to the received list. -/
def lettersReceived : List Char :=
  rawReceived.filter (fun c => c != ' ')

/-- Proposed fixed-example admissibility in each explicitly retained convention. -/
def errorCorruptionStringAtMostTwoExample : Prop :=
  rawSent.length = rawReceived.length ∧
  hammingDist
    (fun i : Fin rawSent.length => rawSent.get i)
    (fun i : Fin rawSent.length => rawReceived.get i) ≤ 2 ∧
  lettersSent.length = lettersReceived.length ∧
  hammingDist
    (fun i : Fin lettersSent.length => lettersSent.get i)
    (fun i : Fin lettersSent.length => lettersReceived.get i) ≤ 2

end NumStability.HDP.SourceTargets.StringDirectListDraft
