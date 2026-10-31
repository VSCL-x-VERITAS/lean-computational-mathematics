import ComputationalMathematics.HDP.Vector.GaussianMixturePopulationTop

/-!
# All spike eigenvectors of the ordinary population matrix

Normalize an arbitrary nonzero spike eigenvector, apply the unit
Rayleigh-maximizer result, and undo normalization. The conclusion is
parallelism with unrestricted nonzero scale and sign. The ordered version
uses the actual largest eigenvalue without selecting an eigenvector.
-/

noncomputable section

open Matrix
open scoped RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- Every nonzero eigenvector at the spike eigenvalue is a nonzero scalar
multiple of the mean, without selecting a sign or normalization. -/
theorem populationSpikeEigenvector_eq_nonzero_smul_mean {n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (v : EuclideanSpace ℝ (Fin n)) (hv : v ≠ 0)
    (heigen : (populationSecondMoment mean).toEuclideanLin v =
      (1 + NumStability.vecNorm2 mean ^ 2) • v) :
    ∃ a : ℝ, a ≠ 0 ∧
      v = a • (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) := by
  let w := (‖v‖⁻¹ : ℝ) • v
  have hvnorm : ‖v‖ ≠ 0 := norm_ne_zero_iff.mpr hv
  have hw : ‖w‖ = 1 := norm_smul_inv_norm hv
  have hweigen : (populationSecondMoment mean).toEuclideanLin w =
      (1 + NumStability.vecNorm2 mean ^ 2) • w := by
    dsimp [w]
    rw [map_smul, heigen, smul_smul, smul_smul, mul_comm]
  have hvalue : NumStability.matrixRayleighForm (populationSecondMoment mean) w =
      1 + NumStability.vecNorm2 mean ^ 2 := by
    rw [NumStability.matrixRayleighForm, hweigen, real_inner_smul_right,
      real_inner_self_eq_norm_sq, hw, one_pow, mul_one]
  have hmax : ∀ x : EuclideanSpace ℝ (Fin n), ‖x‖ = 1 →
      NumStability.matrixRayleighForm (populationSecondMoment mean) x ≤
        NumStability.matrixRayleighForm (populationSecondMoment mean) w := by
    intro x hx
    rw [hvalue]
    simpa only [hx, one_pow, mul_one] using
      populationSecondMoment_rayleigh_le_spike mean x
  obtain ⟨s, hs, hsign⟩ := populationTopRayleighVector_eq_sign_direction mean hmean w hw hmax
  have hsne : s ≠ 0 := by rcases hs with rfl | rfl <;> norm_num
  have hdir : populationDirection mean = (NumStability.vecNorm2 mean)⁻¹ •
      (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) := by
    rw [mean_eq_norm_smul_populationDirection mean hmean, smul_smul,
      inv_mul_cancel₀ hmean.ne', one_smul]
  refine ⟨(‖v‖ * s) * (NumStability.vecNorm2 mean)⁻¹,
    mul_ne_zero (mul_ne_zero hvnorm hsne) (inv_ne_zero hmean.ne'), ?_⟩
  calc
    v = ‖v‖ • w := by simp [w, smul_smul, hvnorm]
    _ = ‖v‖ • (s • populationDirection mean) := congrArg (‖v‖ • ·) hsign
    _ = ((‖v‖ * s) * (NumStability.vecNorm2 mean)⁻¹) •
        (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) := by
      rw [hdir, smul_smul, smul_smul, mul_assoc]

/-- Every nonzero vector for the actual ordered largest eigenvalue is parallel
to the mean; no eigenvector selector or unit normalization is assumed. -/
theorem populationOrderedTopEigenvector_eq_nonzero_smul_mean {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (v : EuclideanSpace ℝ (Fin n)) (hv : v ≠ 0)
    (heigen : (populationSecondMoment mean).toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue (populationSecondMoment_isHermitian mean)
        (⟨0, hn⟩ : Fin n) • v) :
    ∃ a : ℝ, a ≠ 0 ∧
      v = a • (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) := by
  rw [(populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean).1] at heigen
  exact populationSpikeEigenvector_eq_nonzero_smul_mean mean hmean v hv heigen

end NumStability.HDP.Vector.GaussianMixture
