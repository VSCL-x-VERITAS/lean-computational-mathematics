import ComputationalMathematics.HDP.Coding.GilbertVarshamov
import ComputationalMathematics.HDP.Coding.PackingConverse
import ComputationalMathematics.HDP.Coding.Rate
import Mathlib.Algebra.Order.Floor.Semiring

/-!
# Positive-message binary codes

This module characterizes the feasible block lengths for correcting a closed
Hamming radius with a positive number of message bits. It also chooses an exact
positive integral message length with a one-sided lower bound relative to the
logarithmic boundary, including when that boundary is small or negative.
The constructions reuse the existing decoder for separated codewords.
-/

noncomputable section
open NumStability.HDP.Coding

namespace NumStability.HDP.Coding

/-- A single message bit repeated across every available coordinate. -/
def oneBitEncode (n : ℕ) (x : BinaryWord 1) : BinaryWord n := fun _ => x 0

/-- Every strict feasible radius admits a positive-message code, by reusing
    the existing decoder for separated codewords. -/
noncomputable def oneBitCode {n r : ℕ} (h2r : 2 * r < n) : ErrorCorrectingCode 1 n r := by
  classical
  apply errorCorrectingCodeOfSeparated (oneBitEncode n)
  intro x y hxy
  have hzero : x 0 ≠ y 0 := by
    intro h
    apply hxy
    funext i
    have hi : i = (0 : Fin 1) := Subsingleton.elim _ _
    simpa only [hi] using h
  simpa [oneBitEncode, hammingDist, hzero] using h2r

/-- The exact positive integer message length `max 1 (Nat.floor B)`, with
    `B - 1 < k`, for every strict feasible radius. The boundary `B` may be
    small or negative. -/
theorem exists_rounded_positive_code
    (n r : ℕ) (hr : 0 < r) (h2r : 2 * r < n) :
    ∃ k : ℕ, 0 < k ∧
      k = max 1 (Nat.floor ((n : ℝ) - 2 * (r : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ))))) ∧
      Nonempty (ErrorCorrectingCode k n r) ∧
      1 - rateLoss (2 * errorFraction r n) - 1 / (n : ℝ) < codingRate k n := by
  let B : ℝ := (n : ℝ) - 2 * (r : ℝ) *
    Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ)))
  have hn : 0 < n := lt_of_le_of_lt (Nat.zero_le _) h2r
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hrate (k : ℕ) (hk : B - 1 < (k : ℝ)) :
      1 - rateLoss (2 * errorFraction r n) - 1 / (n : ℝ) < codingRate k n := by
    have hb := lengthBoundary_div_eq_one_sub_rateLoss_two_errorFraction n r hn hr
    change B / (n : ℝ) = 1 - rateLoss (2 * errorFraction r n) at hb
    rw [← hb]
    unfold codingRate
    rw [← sub_div]
    exact div_lt_div_of_pos_right hk hnR
  by_cases hB : 1 ≤ B
  · have hk : 1 ≤ Nat.floor B := (Nat.one_le_floor_iff B).mpr hB
    have hle : ((Nat.floor B : ℕ) : ℝ) ≤ B := Nat.floor_le (by linarith)
    have hlength : ((Nat.floor B : ℕ) : ℝ) + 2 * (r : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ))) ≤ (n : ℝ) := by
      dsimp [B] at hle
      linarith
    refine ⟨Nat.floor B, by omega, ?_,
      ⟨errorCorrectingCodeOfLengthLogBound hr h2r.le hlength⟩, ?_⟩
    · exact (max_eq_right hk).symm
    · apply hrate
      have hround := Nat.lt_floor_add_one B
      linarith
  · have hBlt : B < 1 := lt_of_not_ge hB
    have hfloor : Nat.floor B = 0 := Nat.floor_eq_zero.mpr hBlt
    refine ⟨1, by omega, ?_, ⟨oneBitCode h2r⟩, ?_⟩
    · change 1 = max 1 (Nat.floor B)
      rw [hfloor]
      rfl
    · apply hrate
      norm_num
      linarith

end NumStability.HDP.Coding

noncomputable section
open NumStability.HDP.Coding
namespace NumStability.HDP.Coding

theorem strict_radius_of_positive_message_code {k n r : ℕ}
    (hk : 0 < k) (C : ErrorCorrectingCode k n r) : 2 * r < n := by
  have hne : (0 : BinaryWord k) ≠ (1 : BinaryWord k) := by
    intro h
    have hi := congrFun h ⟨0, hk⟩
    norm_num at hi
  have hsep := C.two_mul_lt_hammingDist_encode hne
  have hbound := hammingDist_le_card_fintype
    (x := C.encode 0) (y := C.encode 1)
  simpa only [Fintype.card_fin] using hsep.trans_le hbound

theorem exists_positive_message_code_iff (n r : ℕ) :
    (∃ k : ℕ, 0 < k ∧ Nonempty (ErrorCorrectingCode k n r)) ↔ 2 * r < n := by
  constructor
  · rintro ⟨k, hk, ⟨C⟩⟩
    exact strict_radius_of_positive_message_code hk C
  · intro h
    exact ⟨1, by norm_num, ⟨NumStability.HDP.Coding.oneBitCode h⟩⟩
end NumStability.HDP.Coding
