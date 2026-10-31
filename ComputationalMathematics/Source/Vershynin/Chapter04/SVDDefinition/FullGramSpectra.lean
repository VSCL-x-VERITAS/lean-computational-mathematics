import ComputationalMathematics.HDP.Matrix.RealSVDOrderedGram
import ComputationalMathematics.Analysis.SingularValues.Transpose

/-!
# Chapter 4: SVD with complete ambient Gram eigenbases

This owner-qualified reading pairs the positive Gram eigenvalues on the active
rank block and completes both singular-vector families to ambient orthonormal
bases. The two zero-extended spectra keep their respective dimensions. Empty
dimensions and rank zero use the usual empty-family conventions.
-/

namespace NumStability.HDP.Contract

open scoped BigOperators

/-- The complete rectangular SVD and Gram-root statement selected for §4.1.1. -/
theorem hdp_04_svd_full_gram_spectra :
    ∀ (m n : ℕ) (A : Matrix (Fin m) (Fin n) ℝ),
      ∃ (r : ℕ) (hm : r ≤ m) (hn : r ≤ n) (s : Fin n → ℝ)
        (U : OrthonormalBasis (Fin m) ℝ (EuclideanSpace ℝ (Fin m)))
        (V : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
        (leftEigenvalue : Fin m → ℝ) (rightEigenvalue : Fin n → ℝ),
        IsRealMatrixSVDWithGramEigenrelations A r s
          (fun k ↦ U (Fin.castLE hm k)) (fun k ↦ V (Fin.castLE hn k)) ∧
        (∀ p i, (∑ l : Fin m, (∑ j : Fin n, A i j * A l j) * U p l) =
          leftEigenvalue p * U p i) ∧
        (∀ q j, (∑ l : Fin n, (∑ i : Fin m, A i j * A i l) * V q l) =
          rightEigenvalue q * V q j) ∧
        Antitone leftEigenvalue ∧ Antitone rightEigenvalue ∧
        (∀ p, 0 ≤ leftEigenvalue p) ∧ (∀ q, 0 ≤ rightEigenvalue q) ∧
        (∀ p, r ≤ p.val → leftEigenvalue p = 0) ∧
        (∀ q, r ≤ q.val → rightEigenvalue q = 0) ∧
        (∀ k : Fin r, 0 < s (Fin.castLE hn k)) ∧
        (∀ k : Fin r,
          s (Fin.castLE hn k) = Real.sqrt (leftEigenvalue (Fin.castLE hm k)) ∧
          s (Fin.castLE hn k) = Real.sqrt (rightEigenvalue (Fin.castLE hn k))) := by
  intro m n A
  obtain ⟨r, hm, hn, s, U, V, h, hleft, hright, _, _⟩ :=
    NumStability.exists_realMatrixSVD_full_orderedGram A
  let leftEigenvalue : Fin m → ℝ := fun p =>
    if hp : p.val < r then (s ⟨p.val, lt_of_lt_of_le hp hn⟩) ^ 2 else 0
  let rightEigenvalue : Fin n → ℝ := fun q => (s q) ^ 2
  have hprops := h.toIsRealMatrixSVD.fullGramSpectrum_order_and_tail
  refine ⟨r, hm, hn, s, U, V, leftEigenvalue, rightEigenvalue,
    h, hleft, hright, hprops.1, hprops.2.1, hprops.2.2.1,
    hprops.2.2.2.1, hprops.2.2.2.2.1, hprops.2.2.2.2.2, ?_, ?_⟩
  · intro k
    rw [h.toIsRealMatrixSVD.singularValue_eq_rectSingularValue]
    apply (NumStability.rectSingularValue_pos_iff_lt_rank A _).2
    simpa only [Fin.val_castLE, ← h.rank_eq] using k.isLt
  · intro k
    have hsqrt := (Real.sqrt_sq (h.singularValues_nonnegative (Fin.castLE hn k))).symm
    constructor
    · simpa only [leftEigenvalue, Fin.val_castLE, dif_pos k.isLt] using hsqrt
    · exact hsqrt

end NumStability.HDP.Contract
