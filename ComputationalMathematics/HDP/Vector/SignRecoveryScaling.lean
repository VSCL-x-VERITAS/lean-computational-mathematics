import ComputationalMathematics.HDP.Vector.SignRecovery

/-!
# Positive scaling of threshold classification

Multiplying every score by a positive real number preserves the exact set of
classification errors, including coordinates whose score is zero.
-/

namespace NumStability.HDP.Vector.SignRecovery

/-- Positive scaling preserves the threshold classifier's exact error set. -/
theorem binaryThresholdMisclassifications_pos_smul {n : ℕ}
    (community : Fin n → Fin 2) (v : Fin n → ℝ) (a : ℝ) (ha : 0 < a) :
    binaryThresholdMisclassifications community (a • v) =
      binaryThresholdMisclassifications community v := by
  ext i
  have hp : 0 < a * v i ↔ 0 < v i := mul_pos_iff_of_pos_left ha
  have hn : a * v i ≤ 0 ↔ v i ≤ 0 := by
    simpa only [not_lt] using not_congr hp
  simp only [binaryThresholdMisclassifications, Finset.mem_filter,
    Finset.mem_univ, true_and, Pi.smul_apply, smul_eq_mul]
  split_ifs <;> assumption

end NumStability.HDP.Vector.SignRecovery
