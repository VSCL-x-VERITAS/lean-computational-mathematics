import ComputationalMathematics.HDP.Matrix.ZeroSquareActiveSVDGram

/-!
# Qualified positive-size square zero SVD component

This alias records the selected positive-size square zero case of the
Section 4.1.1 SVD paragraph in Vershynin, *High-Dimensional Probability*.
It retains the rank-zero active reconstruction, zero scalar coefficients,
zero Gram labels, and nonzero scalar eigenvalue-test witnesses. The active
vector families are empty; the statement supplies no complete singular-vector
bases, general spectral enumeration, norm or variational characterization,
or comparison with the source proof account.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Contract

/-- The qualified positive-size square zero active/numerical SVD component
of Vershynin, *High-Dimensional Probability*, Section 4.1.1. -/
theorem hdp_04_svd_positive_square_zero_active_scalar_gram :
  ∀ (N : ℕ), 0 < N →
    ∀ (A : Matrix (Fin N) (Fin N) ℝ), A = 0 →
      ∃ (r : ℕ) (s : Fin N → ℝ)
        (u v : Fin r → EuclideanSpace ℝ (Fin N))
        (hwidth : r ≤ N) (lambdaLeft lambdaRight : Fin N → ℝ),
        r = A.rank ∧ r = 0 ∧
          (∀ k, s k = 0) ∧ (∀ k, 0 ≤ s k) ∧ Antitone s ∧
          Orthonormal ℝ u ∧ Orthonormal ℝ v ∧
          (∀ i j, A i j = ∑ k : Fin r,
            s (Fin.castLE hwidth k) * u k i * v k j) ∧
          (∀ i l : Fin N, (∑ j : Fin N, A i j * A l j) = 0) ∧
          (∀ j l : Fin N, (∑ i : Fin N, A i j * A i l) = 0) ∧
          (∀ k, lambdaLeft k = 0 ∧ lambdaRight k = 0 ∧
            s k = Real.sqrt (lambdaLeft k) ∧
            s k = Real.sqrt (lambdaRight k) ∧
            (∃ x : EuclideanSpace ℝ (Fin N), x ≠ 0 ∧
              ∀ i : Fin N,
                (∑ l : Fin N, (∑ j : Fin N, A i j * A l j) * x l) =
                  lambdaLeft k * x i) ∧
            (∃ x : EuclideanSpace ℝ (Fin N), x ≠ 0 ∧
              ∀ j : Fin N,
                (∑ l : Fin N, (∑ i : Fin N, A i j * A i l) * x l) =
                  lambdaRight k * x j)) ∧
          (∀ k : Fin r,
            (∀ i : Fin N,
              (∑ l : Fin N, (∑ j : Fin N, A i j * A l j) * u k l) =
                lambdaLeft (Fin.castLE hwidth k) * u k i) ∧
            (∀ j : Fin N,
              (∑ l : Fin N, (∑ i : Fin N, A i j * A i l) * v k l) =
                lambdaRight (Fin.castLE hwidth k) * v k j)) :=
  NumStability.HDP.Matrix.exists_zero_square_matrix_active_svd_gram_witnesses

end NumStability.HDP.Contract
