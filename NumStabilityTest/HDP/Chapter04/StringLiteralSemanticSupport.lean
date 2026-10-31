import Init

/-! Imported-definition support for a prospective evidence revision.
These facts identify literal payloads and the ordinary space character.
They do not assert message lengths, Hamming distances, source correspondence,
or the whole previously frozen target. -/

namespace NumStability.HDP.SemanticSupport

theorem fill_the_glass_toList :
    ("fill the glass" : String).toList =
      ['f', 'i', 'l', 'l', ' ', 't', 'h', 'e', ' ', 'g', 'l', 'a', 's', 's'] := by
  decide

theorem bill_the_class_toList :
    ("bill the class" : String).toList =
      ['b', 'i', 'l', 'l', ' ', 't', 'h', 'e', ' ', 'c', 'l', 'a', 's', 's'] := by
  decide

theorem ordinary_space_toNat : (' ' : Char).toNat = 32 := by
  decide

theorem ordinary_space_ofNat : Char.ofNat 32 = (' ' : Char) := by
  decide

theorem ordinary_space_code_valid : Nat.isValidChar 32 := by
  decide

end NumStability.HDP.SemanticSupport
