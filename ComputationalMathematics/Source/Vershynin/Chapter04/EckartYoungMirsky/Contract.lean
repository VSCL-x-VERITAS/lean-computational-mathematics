import ComputationalMathematics.Analysis.SingularValues.EckartYoung

/-!
# Vershynin Chapter 4, Eckart--Young--Mirsky theorem

Thin source contract for the best rank-`k` approximation obtained by
truncating a real singular-value decomposition.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, printed page 78, Eckart--Young--Mirsky: if
`A = ∑ᵢ sᵢ uᵢvᵢᵀ` has rank `k+q` with `q>0`, its first `k` SVD terms
form a rank-at-most-`k` approximation whose operator-norm error is the next
singular value.  The same truncation is best in Frobenius norm and,
simultaneously, in every real unitarily invariant norm. -/
theorem hdp_04_eckart_young_mirsky {m n k q : ℕ}
    {A : Matrix (Fin m) (Fin n) ℝ}
    {s : Fin n → ℝ}
    {u : Fin (k + q) → EuclideanSpace ℝ (Fin m)}
    {v : Fin (k + q) → EuclideanSpace ℝ (Fin n)}
    (h : NumStability.IsRealMatrixSVD A (k + q) s u v) (hq : 0 < q) :
    let Ak := NumStability.realSVDHead s u v h.rank_le_width
    NumStability.lowRankResidualOperator A Ak =
        s (Fin.castLE h.rank_le_width
          (Fin.natAdd k (⟨0, hq⟩ : Fin q))) ∧
      NumStability.IsBestRankApproxOperator m n k A Ak ∧
      NumStability.IsBestRankApproxFrob m n k A Ak ∧
      NumStability.IsBestRankApproxUnitaryInvariant m n k A Ak := by
  let Ak := NumStability.realSVDHead s u v h.rank_le_width
  have hres : (fun i j => A i j - Ak i j) =
      NumStability.realSVDTail s u v h.rank_le_width :=
    h.sub_head_eq_tail
  refine ⟨?_, h.isBestRankApproxOperator_head hq,
    h.isBestRankApproxFrob_head,
    h.isBestRankApproxUnitaryInvariant_head⟩
  unfold NumStability.lowRankResidualOperator
  rw [hres, h.operatorNorm_tail_eq hq]

end NumStability.HDP.Contract
