import ComputationalMathematics.HDP.Vector.GaussianMixtureEigenvectorDirection

/-!
# Every population mean is parallel to a top eigenvector

For a positive dimension, the mean is a scalar multiple of any nonzero
vector at the actual top population eigenvalue. The coefficient may be zero,
so the zero mean is included without a separate selector convention.
-/

namespace NumStability.HDP.Vector.GaussianMixture

theorem mean_eq_smul_populationOrderedTopEigenvector {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (v : EuclideanSpace ℝ (Fin n)) (hv : v ≠ 0)
    (heigen : (populationSecondMoment mean).toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue (populationSecondMoment_isHermitian mean)
        (⟨0, hn⟩ : Fin n) • v) :
    ∃ a : ℝ, (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) = a • v := by
  by_cases hmean : 0 < NumStability.vecNorm2 mean
  · obtain ⟨b, hb, hvec⟩ :=
      populationOrderedTopEigenvector_eq_nonzero_smul_mean hn mean hmean v hv heigen
    refine ⟨b⁻¹, ?_⟩
    rw [hvec, smul_smul, inv_mul_cancel₀ hb, one_smul]
  · have hzero : NumStability.vecNorm2 mean = 0 :=
      le_antisymm (le_of_not_gt hmean) (NumStability.vecNorm2_nonneg mean)
    have hmean0 : mean = 0 := funext ((NumStability.vecNorm2_eq_zero_iff mean).mp hzero)
    refine ⟨0, ?_⟩
    simp [hmean0]

end NumStability.HDP.Vector.GaussianMixture
