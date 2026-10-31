import ComputationalMathematics.Analysis.SingularValues.ExtremeValues

/-!
# Vershynin Chapter 4, Equation (4.5)

The extreme coefficients of an ordered real SVD give the optimal two-sided
Euclidean expansion bounds, expressed in ordinary matrix coordinates.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.5): the smallest and largest singular values are
the largest lower and smallest upper expansion constants. Every matrix admits
the SVD certificate used here, and the result holds for every such certificate.
The positive column dimension makes both extreme indices meaningful. The
zero-row case is a nonvacuous extension of the printed matrix convention. -/
theorem hdp_04_equation_4_5 {m n r : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ)
    (s : Fin (n + 1) → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin (n + 1)))
    (hSVD : NumStability.IsRealMatrixSVD A r s u v) :
    (∀ x : Fin (n + 1) → ℝ,
      s (Fin.last n) * Real.sqrt (∑ j, x j ^ 2) ≤
          Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ∧
        Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ≤
          s ⟨0, Nat.succ_pos n⟩ * Real.sqrt (∑ j, x j ^ 2)) ∧
    (∀ upper : ℝ,
      (∀ x : Fin (n + 1) → ℝ,
        Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ≤
          upper * Real.sqrt (∑ j, x j ^ 2)) →
      s ⟨0, Nat.succ_pos n⟩ ≤ upper) ∧
    (∀ lower : ℝ,
      (∀ x : Fin (n + 1) → ℝ,
        lower * Real.sqrt (∑ j, x j ^ 2) ≤
          Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2)) →
      lower ≤ s (Fin.last n)) := by
  have h := hSVD.extremeSingularValues_areOptimalBounds
  have hnorm {d : ℕ} (x : EuclideanSpace ℝ (Fin d)) :
      ‖x‖ = Real.sqrt (∑ j, x j ^ 2) := by
    simp [EuclideanSpace.norm_eq, Real.norm_eq_abs, sq_abs]
  have haction (x : EuclideanSpace ℝ (Fin (n + 1))) :
      ‖Matrix.toLpLin 2 2 A x‖ =
        Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) := by
    rw [hnorm]
    simp [Matrix.toLpLin_apply, Matrix.mulVec, dotProduct]
  refine ⟨fun x ↦ ?_, fun upper hu ↦ h.2.1 upper ?_,
    fun lower hl ↦ h.2.2 lower ?_⟩
  · simpa only [haction, hnorm] using
      h.1 (WithLp.toLp 2 x)
  · intro x
    simpa only [haction, hnorm] using hu (WithLp.ofLp x)
  · intro x
    simpa only [haction, hnorm] using hl (WithLp.ofLp x)

/-- Equation (4.5) with the complete coordinate SVD conditions as its
decomposition premise. Both optimality directions are retained. -/
theorem hdp_04_equation_4_5_explicit_svd {m n r : ℕ}
    (A : Matrix (Fin m) (Fin (n + 1)) ℝ)
    (s : Fin (n + 1) → ℝ)
    (u : Fin r → EuclideanSpace ℝ (Fin m))
    (v : Fin r → EuclideanSpace ℝ (Fin (n + 1)))
    (hSVD : NumStability.RealMatrixSVDExplicitFields A r s u v) :
    (∀ x : Fin (n + 1) → ℝ,
      s (Fin.last n) * Real.sqrt (∑ j, x j ^ 2) ≤
          Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ∧
        Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ≤
          s ⟨0, Nat.succ_pos n⟩ * Real.sqrt (∑ j, x j ^ 2)) ∧
    (∀ upper : ℝ,
      (∀ x : Fin (n + 1) → ℝ,
        Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2) ≤
          upper * Real.sqrt (∑ j, x j ^ 2)) →
      s ⟨0, Nat.succ_pos n⟩ ≤ upper) ∧
    (∀ lower : ℝ,
      (∀ x : Fin (n + 1) → ℝ,
        lower * Real.sqrt (∑ j, x j ^ 2) ≤
          Real.sqrt (∑ i, (∑ j, A i j * x j) ^ 2)) →
      lower ≤ s (Fin.last n)) := by
  exact hdp_04_equation_4_5 A s u v
    (NumStability.isRealMatrixSVD_iff_explicit_fields.mpr hSVD)

end NumStability.HDP.Contract
