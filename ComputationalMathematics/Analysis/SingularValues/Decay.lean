import ComputationalMathematics.Analysis.SingularValues.Basic

/-!
# Singular-value decay bounds

Pointwise bounds for ordered singular values derived from global Schatten
norm information.
-/

namespace NumStability

open scoped BigOperators

/-- One-based singular-value decay controlled by the Frobenius norm:
the singular value with zero-based index `i` is at most
`||A||_F / sqrt (i + 1)`. -/
theorem complexMatrixSingularValue_le_frobenius_div_sqrt_succ {m n : ℕ}
    (A : CMatrix m n) (i : Fin n) :
    complexMatrixSingularValue A i ≤
      complexMatrixFrobenius A / Real.sqrt (i.1 + 1 : ℕ) := by
  have hcard_pos : 0 < ((i.1 + 1 : ℕ) : ℝ) := by positivity
  have hsqrt_pos : 0 < Real.sqrt ((i.1 + 1 : ℕ) : ℝ) :=
    Real.sqrt_pos.2 hcard_pos
  apply (le_div_iff₀ hsqrt_pos).2
  apply (sq_le_sq₀
    (mul_nonneg (complexMatrixSingularValue_nonneg A i) (Real.sqrt_nonneg _))
    (complexMatrixFrobenius_nonneg A)).1
  rw [mul_pow, Real.sq_sqrt (le_of_lt hcard_pos),
    complexMatrixFrobenius_sq,
    complexMatrixFrobeniusSq_eq_sum_singularValue_sq]
  calc
    complexMatrixSingularValue A i ^ 2 * ((i.1 + 1 : ℕ) : ℝ) =
        ∑ j ∈ Finset.Iic i, complexMatrixSingularValue A i ^ 2 := by
          simp [Fin.card_Iic, nsmul_eq_mul, mul_comm]
    _ ≤ ∑ j ∈ Finset.Iic i, complexMatrixSingularValue A j ^ 2 := by
          apply Finset.sum_le_sum
          intro j hj
          exact (sq_le_sq₀ (complexMatrixSingularValue_nonneg A i)
            (complexMatrixSingularValue_nonneg A j)).2
            (complexMatrixSingularValue_antitone A (Finset.mem_Iic.mp hj))
    _ ≤ ∑ j : Fin n, complexMatrixSingularValue A j ^ 2 := by
          exact Finset.sum_le_univ_sum_of_nonneg
            (fun j => sq_nonneg (complexMatrixSingularValue A j))

end NumStability
