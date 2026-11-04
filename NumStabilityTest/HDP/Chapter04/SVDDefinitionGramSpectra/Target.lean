import ComputationalMathematics.Analysis.SingularValues.RealSVD
import Mathlib.Data.Real.Sqrt

set_option autoImplicit false

namespace NumStability.HDP.Chapter04.SVDDefinitionGramSpectra

open scoped BigOperators

/-- Unsealed primary SVD proposal with the two actual Gram spectra specified by
complete compatible eigenbases at their respective ambient dimensions. -/
def target : Prop :=
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
        s (Fin.castLE hn k) = Real.sqrt (rightEigenvalue (Fin.castLE hn k)))

end NumStability.HDP.Chapter04.SVDDefinitionGramSpectra
