import ComputationalMathematics.HDP.Matrix.OrderedEigenbasis
import ComputationalMathematics.HDP.Matrix.RealSVDFullBases

/-!
# Complete ordered Gram spectra for real rectangular SVD

The rank-length compatible singular families extend to full ambient Gram
eigenbases. Their descending squared eigenvalue lists are the actual ordered
spectra on the separate left and right dimensions.
-/

namespace NumStability

open scoped BigOperators

/-- Every real rectangular matrix admits one compatible full SVD whose two
ambient Gram lists are the actual ordered eigenvalue lists. -/
theorem exists_realMatrixSVD_full_orderedGram
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) :
    ∃ r : ℕ, ∃ hm : r ≤ m, ∃ hn : r ≤ n,
      ∃ (s : Fin n → ℝ)
        (U : OrthonormalBasis (Fin m) ℝ (EuclideanSpace ℝ (Fin m)))
        (V : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n))),
        IsRealMatrixSVDWithGramEigenrelations A r s
          (fun k ↦ U (Fin.castLE hm k)) (fun k ↦ V (Fin.castLE hn k)) ∧
        (∀ p i, (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * U p l) =
          (if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0) * U p i) ∧
        (∀ q j, (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * V q l) =
          (s q) ^ 2 * V q j) ∧
        (fun p : Fin m =>
          if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0) =
          hermitianOrderedEigenvalue (rectRightGram_matrix_posSemidef A.transpose).1 ∧
        (fun q : Fin n => (s q) ^ 2) =
          hermitianOrderedEigenvalue (rectRightGram_matrix_posSemidef A).1 := by
  classical
  obtain ⟨r, hm, hn, s, U, V, h, hleft, hright⟩ :=
    exists_realMatrixSVD_full_orthonormal_bases_all_gram_relations A
  let leftEig : Fin m → ℝ := fun p =>
    if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0
  let rightEig : Fin n → ℝ := fun q => (s q) ^ 2
  have hprops := h.toIsRealMatrixSVD.fullGramSpectrum_order_and_tail
  have hleftMono : Antitone leftEig := hprops.1
  have hrightMono : Antitone rightEig := hprops.2.1
  have hleftCoord : ∀ p i, (∑ l : Fin m,
      rectRightGram A.transpose i l * U p l) = leftEig p * U p i := by
    simpa only [leftEig, rectRightGram, Matrix.transpose_apply] using hleft
  have hrightCoord : ∀ q j, (∑ l : Fin n,
      rectRightGram A j l * V q l) = rightEig q * V q j := by
    simpa only [rightEig, rectRightGram] using hright
  have hleftActual := HDP.Matrix.antitone_eigenvalue_eq_ordered_of_coordinate_eigenbasis
    (rectRightGram_matrix_posSemidef A.transpose).1 leftEig U hleftMono hleftCoord
  have hrightActual := HDP.Matrix.antitone_eigenvalue_eq_ordered_of_coordinate_eigenbasis
    (rectRightGram_matrix_posSemidef A).1 rightEig V hrightMono hrightCoord
  exact ⟨r, hm, hn, s, U, V, h, hleft, hright, hleftActual, hrightActual⟩

end NumStability
