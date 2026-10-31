import ComputationalMathematics.Analysis.SingularValues.Transpose

set_option autoImplicit false

namespace NumStability.HDP.Chapter04.SVDDefinitionOwnerQualified

open scoped BigOperators

/-- Private owner-qualified PRIMARY SVD proposition. Unsealed proposal only. -/
def target : Prop :=
  ∀ (m n : ℕ) (A : Matrix (Fin m) (Fin n) ℝ),
    ∃ (r : ℕ) (hm : r ≤ m) (hn : r ≤ n)
      (U : OrthonormalBasis (Fin m) ℝ (EuclideanSpace ℝ (Fin m)))
      (V : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))),
      IsRealMatrixSVDWithGramEigenrelations A r (rectSingularValue A)
        (fun k ↦ U (Fin.castLE hm k)) (fun k ↦ V (Fin.castLE hn k)) ∧
      (∀ p i, (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * U p l) =
        (if hp : p.val < r then
          (rectSingularValue A ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0) * U p i) ∧
      (∀ q j, (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * V q l) =
        (rectSingularValue A q) ^ 2 * V q j) ∧
      (∀ k : Fin r, 0 < rectSingularValue A (Fin.castLE hn k)) ∧
      (∀ k : Fin r,
        rectSingularValue A (Fin.castLE hn k) =
          Real.sqrt ((rectRightGram_matrix_posSemidef A.transpose).1.eigenvalues₀
            (finCardIndex m (Fin.castLE hm k))) ∧
        rectSingularValue A (Fin.castLE hn k) =
          Real.sqrt ((rectRightGram_matrix_posSemidef A).1.eigenvalues₀
            (finCardIndex n (Fin.castLE hn k))))

end NumStability.HDP.Chapter04.SVDDefinitionOwnerQualified
