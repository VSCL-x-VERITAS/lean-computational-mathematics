import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Real.Sqrt
import Mathlib.LinearAlgebra.Matrix.Rank

/-!
# Active SVD and scalar Gram witnesses for square zero matrices

For a positive-size real square zero matrix, the active orthonormal families
have rank length zero. The scalar coefficient list and both Gram label lists
have the matrix dimension as their length and vanish. The coordinate Gram
matrices vanish, and each zero label admits a nonzero eigenvector test witness.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Matrix

/-- A positive-size real square zero matrix admits empty active SVD families,
zero scalar coefficients and Gram labels, reconstruction and both coordinate
Gram equations, with nonzero test witnesses for each scalar label. -/
theorem exists_zero_square_matrix_active_svd_gram_witnesses :
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
                lambdaRight (Fin.castLE hwidth k) * v k j)) := by
  classical
  intro N hN A hA
  subst A
  let x : EuclideanSpace ℝ (Fin N) := EuclideanSpace.single ⟨0, hN⟩ 1
  have hx : x ≠ 0 := by
    simp [x, EuclideanSpace.single_eq_zero_iff]
  refine ⟨0, fun _ => 0, fun k => Fin.elim0 k, fun k => Fin.elim0 k,
    Nat.zero_le N, fun _ => 0, fun _ => 0, ?_⟩
  refine ⟨by simp, rfl, by simp, by simp, ?_,
    Orthonormal.of_isEmpty _, Orthonormal.of_isEmpty _, ?_, ?_, ?_, ?_, ?_⟩
  · intro a b _hab
    exact le_rfl
  · intro i j
    simp
  · intro i l
    simp
  · intro j l
    simp
  · intro k
    refine ⟨rfl, rfl, by simp, by simp, ⟨x, hx, ?_⟩, ⟨x, hx, ?_⟩⟩ <;>
      intro i <;> simp
  · intro k
    exact Fin.elim0 k

end NumStability.HDP.Matrix
