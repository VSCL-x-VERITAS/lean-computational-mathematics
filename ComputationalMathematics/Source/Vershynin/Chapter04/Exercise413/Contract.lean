import ComputationalMathematics.Analysis.SingularValues.EckartYoung

/-!
# Vershynin Chapter 4, Exercise 4.1.3

Source contract for the exact operator- and Frobenius-error formulas of the
truncated singular-value decomposition.
-/

namespace NumStability.HDP.Contract

open scoped BigOperators

/-- Vershynin, Chapter 4, Exercise 4.1.3: for the best rank-`k`
approximation obtained by truncating an exact rank-`k+q` SVD, the squared
operator error is the square of the next singular value and the squared
Frobenius error is the sum of the squared omitted singular values. -/
theorem hdp_04_exercise_4_1_3 {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : NumStability.IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    let Ak := NumStability.realSVDHead s u v h.rank_le_width
    NumStability.lowRankResidualOperator A Ak ^ 2 =
        s (Fin.castLE h.rank_le_width
          (Fin.natAdd k (⟨0, hq⟩ : Fin q))) ^ 2 ∧
      NumStability.lowRankResidualFrob A Ak ^ 2 =
        ∑ c : Fin q,
          s (Fin.castLE h.rank_le_width (Fin.natAdd k c)) ^ 2 := by
  let Ak := NumStability.realSVDHead s u v h.rank_le_width
  have hres : (fun i j => A i j - Ak i j) =
      NumStability.realSVDTail s u v h.rank_le_width :=
    h.sub_head_eq_tail
  constructor
  · unfold NumStability.lowRankResidualOperator
    rw [hres, h.operatorNorm_tail_eq hq]
  · unfold NumStability.lowRankResidualFrob
    rw [hres, h.frobNorm_tail_eq, Real.sq_sqrt]
    exact Finset.sum_nonneg fun c _ => sq_nonneg _

end NumStability.HDP.Contract
