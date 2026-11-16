import ComputationalMathematics.Analysis.FiniteProbability

/-! Scalar variance for a finite real-valued probability law. -/

namespace NumStability.FiniteProbability

variable {Ω : Type*} [Fintype Ω]

/-- Variance is the expectation of the squared deviation from the mean. -/
noncomputable def varianceReal (P : FiniteProbability Ω) (X : Ω → ℝ) : ℝ :=
  P.expectationReal (fun ω => (X ω - P.expectationReal X) ^ 2)

theorem varianceReal_nonneg (P : FiniteProbability Ω) (X : Ω → ℝ) :
    0 ≤ P.varianceReal X := by
  unfold varianceReal expectationReal
  exact Finset.sum_nonneg (fun ω _ => mul_nonneg (P.prob_nonneg ω) (sq_nonneg _))

theorem varianceReal_eq_expectationReal_sq_sub_mean_sq
    (P : FiniteProbability Ω) (X : Ω → ℝ) :
    P.varianceReal X = P.expectationReal (fun ω => X ω ^ 2) - (P.expectationReal X) ^ 2 := by
  unfold varianceReal
  have h : (fun ω => (X ω - P.expectationReal X) ^ 2) =
      fun ω => X ω ^ 2 - (2 * P.expectationReal X) * X ω + (P.expectationReal X) ^ 2 := by
    funext ω
    ring
  rw [h, expectationReal_add, expectationReal_sub, expectationReal_const_mul,
    expectationReal_const]
  ring

theorem varianceReal_eq_expectationReal_sq_of_mean_zero
    (P : FiniteProbability Ω) (X : Ω → ℝ) (hX : P.expectationReal X = 0) :
    P.varianceReal X = P.expectationReal (fun ω => X ω ^ 2) := by
  simp only [varianceReal, hX, sub_zero]

end NumStability.FiniteProbability
