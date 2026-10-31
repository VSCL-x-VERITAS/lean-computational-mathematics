import Mathlib.InformationTheory.Hamming

/-! The displayed Chapter 4 corruption example under both retained space conventions. -/

namespace NumStability.HDP.StringCorruption

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

theorem errorCorruptionStringAtMostTwoExample :
  rawSent.length = rawReceived.length ∧
  hammingDist
    (fun i : Fin rawSent.length => rawSent.get i)
    (fun i : Fin rawSent.length => rawReceived.get i) ≤ 2 ∧
  lettersSent.length = lettersReceived.length ∧
  hammingDist
    (fun i : Fin lettersSent.length => lettersSent.get i)
    (fun i : Fin lettersSent.length => lettersReceived.get i) ≤ 2 := by
  decide

end NumStability.HDP.StringCorruption
