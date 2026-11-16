import ComputationalMathematics.Analysis.SingularValues.ZeroPaddedCoordinates

/-! # Full right-coordinate real SVD certificates

The full square right basis retains the null singular directions. On those
directions the left coordinate is zero. Positive singular directions have unit
left columns. This represents rectangular SVDs uniformly, including `m < n`.
-/
namespace NumStability
open scoped BigOperators

structure IsRealFullRightSVD {m n : ℕ}
    (A U : Matrix (Fin m) (Fin n) ℝ) (sigma : Fin n → ℝ)
    (V : Matrix (Fin n) (Fin n) ℝ) : Prop where
  singularValues_nonneg : ∀ a, 0 ≤ sigma a
  singularValues_antitone : Antitone sigma
  representation : ∀ i j, A i j = ∑ a, U i a * sigma a * V j a
  right_orthonormal : ∀ a b, (∑ i, V i a * V i b) = if a = b then 1 else 0
  left_cross : ∀ a b, a ≠ b → (∑ i, U i a * U i b) = 0
  left_diag : ∀ a, (∑ i, U i a * U i a) = if sigma a = 0 then 0 else 1

namespace IsRealFullRightSVD

theorem left_subfamily_contraction {m n p : ℕ}
    {A U : Matrix (Fin m) (Fin n) ℝ} {sigma : Fin n → ℝ}
    {V : Matrix (Fin n) (Fin n) ℝ} (h : IsRealFullRightSVD A U sigma V)
    (e : Fin p ↪ Fin n) : rectOpNorm2Le (fun i a => U i (e a)) 1 := by
  apply rectOpNorm2Le_one_of_orthogonal_columns
  · intro a b hab
    exact h.left_cross _ _ (e.injective.ne hab)
  · intro a
    rw [h.left_diag]
    split_ifs <;> norm_num

theorem right_subfamily_contraction {m n p : ℕ}
    {A U : Matrix (Fin m) (Fin n) ℝ} {sigma : Fin n → ℝ}
    {V : Matrix (Fin n) (Fin n) ℝ} (h : IsRealFullRightSVD A U sigma V)
    (e : Fin p ↪ Fin n) : rectOpNorm2Le (fun i a => V i (e a)) 1 := by
  apply rectOpNorm2Le_one_of_orthogonal_columns
  · intro a b hab
    simpa [e.injective.ne hab] using h.right_orthonormal (e a) (e b)
  · intro a
    simp [h.right_orthonormal]

end IsRealFullRightSVD
end NumStability
