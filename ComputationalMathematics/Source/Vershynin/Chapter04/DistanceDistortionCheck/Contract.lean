import ComputationalMathematics.Source.Vershynin.Chapter04.Equation45.Contract

/-!
# Vershynin Chapter 4, distance-distortion check

The extreme singular values bound every pairwise Euclidean distance under
ordinary coordinate matrix multiplication.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, the check following Equation (4.5): apply the sharp expansion
bounds to the difference of two arbitrary points. No matrix-shape or rank
restriction is imposed. As in Equation (4.5), zero rows are an extension of
the meaningful printed matrix domain. -/
theorem hdp_04_distance_distortion_check {m n r : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ)
    (s : Fin (n + 1) → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin (n + 1)))
    (hSVD : NumStability.IsRealMatrixSVD A r s u v) :
    ∀ x y : Fin (n + 1) → ℝ,
      s (Fin.last n) * Real.sqrt (∑ j, (x j - y j) ^ 2) ≤
          Real.sqrt (∑ i, ((∑ j, A i j * x j) - (∑ j, A i j * y j)) ^ 2) ∧
        Real.sqrt (∑ i, ((∑ j, A i j * x j) - (∑ j, A i j * y j)) ^ 2) ≤
          s ⟨0, Nat.succ_pos n⟩ * Real.sqrt (∑ j, (x j - y j) ^ 2) := by
  intro x y
  simpa only [Pi.sub_apply, mul_sub, Finset.sum_sub_distrib] using
    (hdp_04_equation_4_5 A s u v hSVD).1 (x - y)

/-- The distance-distortion check for the same exhaustive coordinate SVD
data, applied to the difference of any two points. -/
theorem hdp_04_distance_distortion_explicit_svd {m n r : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ)
    (s : Fin (n + 1) → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin (n + 1)))
    (hSVD : NumStability.RealMatrixSVDExplicitFields A r s u v) :
    ∀ x y : Fin (n + 1) → ℝ,
      s (Fin.last n) * Real.sqrt (∑ j, (x j - y j) ^ 2) ≤
          Real.sqrt (∑ i, ((∑ j, A i j * x j) - (∑ j, A i j * y j)) ^ 2) ∧
        Real.sqrt (∑ i, ((∑ j, A i j * x j) - (∑ j, A i j * y j)) ^ 2) ≤
          s ⟨0, Nat.succ_pos n⟩ * Real.sqrt (∑ j, (x j - y j) ^ 2) := by
  exact hdp_04_distance_distortion_check A s u v
    (NumStability.isRealMatrixSVD_iff_explicit_fields.mpr hSVD)

end NumStability.HDP.Contract
