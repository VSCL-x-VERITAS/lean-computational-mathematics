import ComputationalMathematics.HDP.Vector.GaussianMixturePopulationGap
import ComputationalMathematics.HDP.Matrix.UnitEigenvectorAlignment

/-!
# Linear perturbation of the population signal direction

The exact population gap and the unit-eigenvector alignment theorem give a
mean-scale error linear in the operator perturbation and inverse in the signal
norm. Any unit vector at the perturbed top eigenvalue is allowed.
-/

namespace NumStability.HDP.Vector.GaussianMixture

theorem exists_sign_mean_sub_scaledUnitTopEigenvector_le_linear {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (T : Matrix (Fin n) (Fin n) ℝ) (hT : T.IsHermitian)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (hTv : T.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ • v) :
    ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
          s • (NumStability.vecNorm2 mean • v)‖ ≤
        2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm
          (populationSecondMoment mean - T) / NumStability.vecNorm2 mean := by
  let r := NumStability.vecNorm2 mean
  let u := populationDirection mean
  let hS := populationSecondMoment_isHermitian mean
  let i0 : Fin n := ⟨0, hn⟩
  have hr : 0 < r := hmean
  have hsep : ∀ j : Fin n, j ≠ i0 →
      r ^ 2 ≤ |NumStability.hermitianOrderedEigenvalue hS i0 -
        NumStability.hermitianOrderedEigenvalue hS j| := by
    intro j hj
    exact (populationOrderedTop_eigengap hn mean hmean j hj).ge
  obtain ⟨θ, hθ, hbound⟩ :=
    NumStability.HDP.Matrix.exists_sign_unit_eigenvector_norm_sub_le
      (populationSecondMoment mean) T hS hT i0 (r ^ 2)
      (sq_pos_of_pos hr) hsep v hv hTv
  obtain ⟨_hvalue, t, ht, hbasis⟩ :=
    populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean
  have halign : ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖u - s • v‖ ≤
        2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm
          (populationSecondMoment mean - T) / r ^ 2 := by
    rcases ht with rfl | rfl
    · refine ⟨-θ, ?_, ?_⟩
      · rcases hθ with rfl | rfl <;> norm_num
      · rw [hbasis, neg_one_smul] at hbound
        have hvec : u - (-θ) • v = -((-u) - θ • v) := by module
        simpa only [hvec, norm_neg] using hbound
    · refine ⟨θ, hθ, ?_⟩
      rw [hbasis, one_smul] at hbound
      exact hbound
  obtain ⟨s, hs, hdist⟩ := halign
  refine ⟨s, hs, ?_⟩
  calc
    ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v)‖ =
        ‖r • (u - s • v)‖ := by
      congr 1
      rw [mean_eq_norm_smul_populationDirection mean hmean]
      dsimp [r, u]
      module
    _ = r * ‖u - s • v‖ := by
      rw [norm_smul, Real.norm_eq_abs, abs_of_pos hr]
    _ ≤ r * (2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm
        (populationSecondMoment mean - T) / r ^ 2) :=
      mul_le_mul_of_nonneg_left hdist hr.le
    _ = 2 * Real.sqrt 2 * NumStability.realMatrixOperatorNorm
        (populationSecondMoment mean - T) / r := by
      field_simp [hr.ne']

end NumStability.HDP.Vector.GaussianMixture
