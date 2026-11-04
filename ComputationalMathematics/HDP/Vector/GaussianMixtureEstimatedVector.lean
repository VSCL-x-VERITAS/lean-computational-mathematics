import ComputationalMathematics.HDP.Vector.GaussianMixtureLinearPerturbation
import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectralAmplitude

/-!
# Sign-aligned estimate of the Gaussian population mean

Scale any unit perturbed top eigenvector by the clipped square root of its
actual top eigenvalue minus one. The existing direction and amplitude bounds
control the resulting mean error linearly in the operator perturbation.
-/

namespace NumStability.HDP.Vector.GaussianMixture

theorem exists_sign_mean_sub_spectralAmplitudeTopEigenvector_le {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (T : Matrix (Fin n) (Fin n) ℝ) (hT : T.IsHermitian)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (hTv : T.toEuclideanLin v =
      NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ • v) :
    ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
          s • (Real.sqrt (max
            (NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1) 0) • v)‖ ≤
        (2 * Real.sqrt 2 + 1) * NumStability.realMatrixOperatorNorm
          (populationSecondMoment mean - T) / NumStability.vecNorm2 mean := by
  let r := NumStability.vecNorm2 mean
  let a := Real.sqrt (max (NumStability.hermitianOrderedEigenvalue hT ⟨0, hn⟩ - 1) 0)
  let e := NumStability.realMatrixOperatorNorm (populationSecondMoment mean - T)
  obtain ⟨s, hs, hdirection⟩ :=
    exists_sign_mean_sub_scaledUnitTopEigenvector_le_linear hn mean hmean T hT v hv hTv
  have hamplitude := spectralAmplitude_sub_meanNorm_abs_le hn mean hmean T hT
  change |a - r| ≤ e / r at hamplitude
  change ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v)‖ ≤
    2 * Real.sqrt 2 * e / r at hdirection
  have hsabs : |s| = 1 := by rcases hs with rfl | rfl <;> norm_num
  have hscale : ‖s • (r • v) - s • (a • v)‖ = |a - r| := by
    rw [show s • (r • v) - s • (a • v) = (s * (r - a)) • v by module]
    rw [norm_smul, Real.norm_eq_abs, hv, mul_one, abs_mul, hsabs, one_mul,
      abs_sub_comm]
  have hscaleBound : ‖s • (r • v) - s • (a • v)‖ ≤ e / r := by
    rw [hscale]
    exact hamplitude
  refine ⟨s, hs, ?_⟩
  calc
    ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (a • v)‖ =
        ‖((WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v)) +
          (s • (r • v) - s • (a • v))‖ := by
      congr 1
      abel
    _ ≤ ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v)‖ +
        ‖s • (r • v) - s • (a • v)‖ := norm_add_le _ _
    _ ≤ 2 * Real.sqrt 2 * e / r + e / r := add_le_add hdirection hscaleBound
    _ = (2 * Real.sqrt 2 + 1) * e / r := by ring

end NumStability.HDP.Vector.GaussianMixture
