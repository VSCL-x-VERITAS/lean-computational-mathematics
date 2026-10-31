import Mathlib.Tactic

/-!
# A finite-alphabet length bound

This arithmetic estimate can be used with a radius-four Hamming-ball count at
length thirty. It does not choose an alphabet or construct a code.
-/

namespace NumStability.HDP.Coding

/-- The scalar polynomial from the first five terms of a length-thirty
Hamming-ball count fits below the available eighteenth power for every
alphabet size at least two. -/
theorem thirtyLengthAlphabetPolynomialBound (q : ℕ) (hq : 2 ≤ q) :
    1 + 30 * (q - 1) + 435 * (q - 1) ^ 2 +
      4060 * (q - 1) ^ 3 + 27405 * (q - 1) ^ 4 ≤ q ^ 18 := by
  let t := q - 2
  have hq' : q = t + 2 := by dsimp [t]; omega
  rw [hq']
  have hsub : (t + 2) - 1 = t + 1 := by omega
  rw [hsub]
  nlinarith only [show 0 ≤ t ^ 18 from Nat.zero_le _,
    show 0 ≤ t ^ 17 from Nat.zero_le _,
    show 0 ≤ t ^ 16 from Nat.zero_le _,
    show 0 ≤ t ^ 15 from Nat.zero_le _,
    show 0 ≤ t ^ 14 from Nat.zero_le _,
    show 0 ≤ t ^ 13 from Nat.zero_le _,
    show 0 ≤ t ^ 12 from Nat.zero_le _,
    show 0 ≤ t ^ 11 from Nat.zero_le _,
    show 0 ≤ t ^ 10 from Nat.zero_le _,
    show 0 ≤ t ^ 9 from Nat.zero_le _,
    show 0 ≤ t ^ 8 from Nat.zero_le _,
    show 0 ≤ t ^ 7 from Nat.zero_le _,
    show 0 ≤ t ^ 6 from Nat.zero_le _,
    show 0 ≤ t ^ 5 from Nat.zero_le _,
    show 0 ≤ t ^ 4 from Nat.zero_le _,
    show 0 ≤ t ^ 3 from Nat.zero_le _,
    show 0 ≤ t ^ 2 from Nat.zero_le _,
    Nat.zero_le t]

/-- The same estimate after including all `q ^ 12` possible messages. -/
theorem thirtyLengthAlphabetPolynomialBound_mul (q : ℕ) (hq : 2 ≤ q) :
    (1 + 30 * (q - 1) + 435 * (q - 1) ^ 2 +
      4060 * (q - 1) ^ 3 + 27405 * (q - 1) ^ 4) * q ^ 12 ≤ q ^ 30 := by
  calc
    _ ≤ q ^ 18 * q ^ 12 := Nat.mul_le_mul_right _
      (thirtyLengthAlphabetPolynomialBound q hq)
    _ = q ^ 30 := by rw [← pow_add]

end NumStability.HDP.Coding
