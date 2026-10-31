import ComputationalMathematics.HDP.Metric.Euclidean

/-!
# Vershynin Chapter 4, trivial covering range for the Euclidean ball
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, after Equation (4.10): when `ε > 1`, the Euclidean unit ball
is nonempty and its center gives an internal one-ball closed `ε`-cover.
Positive dimension is represented by `Fin (n + 1)`. -/
theorem hdp_04_euclidean_ball_trivial_cover {n : ℕ}
    (ε : ℝ≥0) (hε : 1 < ε) :
    (Metric.closedBall (0 : EuclideanSpace ℝ (Fin (n + 1))) 1).Nonempty ∧
      ∃ c ∈ Metric.closedBall (0 : EuclideanSpace ℝ (Fin (n + 1))) 1,
        ∀ x ∈ Metric.closedBall (0 : EuclideanSpace ℝ (Fin (n + 1))) 1,
          dist x c ≤ (ε : ℝ) := by
  have h0 : (0 : EuclideanSpace ℝ (Fin (n + 1))) ∈ Metric.closedBall 0 1 := by
    simp
  refine ⟨⟨0, h0⟩, 0, h0, ?_⟩
  intro x hx
  exact hx.trans (le_of_lt (by exact_mod_cast hε))

/-- The covering-number formulation follows from the same internal center. -/
theorem hdp_04_euclidean_ball_trivial_coveringNumber {n : ℕ}
    (ε : ℝ≥0) (hε : 1 < ε) :
    Metric.coveringNumber ε
      (Metric.closedBall (0 : EuclideanSpace ℝ (Fin (n + 1))) 1) = 1 :=
  NumStability.HDP.Metric.coveringNumber_unitClosedBall_eq_one ε hε

end NumStability.HDP.Contract
