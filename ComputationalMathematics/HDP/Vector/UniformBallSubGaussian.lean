import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import ComputationalMathematics.HDP.Vector.UniformBall

/-!
# Sub-Gaussianity of normalized volume on the Euclidean ball

This module combines the Gaussian-direction estimate for the sphere with the
polar radial-contraction model of normalized Lebesgue volume on the ball.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Vector.UniformBall

lemma measurable_polarBallVector (n : ℕ) (i : Fin n) :
    Measurable (polarBallVector n i) := by
  unfold polarBallVector
    NumStability.HDP.Vector.SubGaussian.radialContraction
  exact (measurable_polarRadius n).mul (measurable_polarSphereVector n i)

/-- The polar ball vector has the normalized Lebesgue law on the Euclidean
ball of radius `sqrt n`. -/
theorem hasLaw_polarBallVector (n : ℕ) (hn : 0 < n) :
    HasLaw (fun p i ↦ polarBallVector n i p)
      (NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionSqrtDimensionBall n))
      (polarBallMeasure n) := by
  exact ⟨(measurable_pi_lambda _ (measurable_polarBallVector n)).aemeasurable,
    map_polarBallVector n hn⟩

/-- Uniform normalized Lebesgue volume on the Euclidean ball of radius
`sqrt n` is a sub-Gaussian vector law with a dimension-free `psi_2` bound. -/
theorem uniformSqrtDimensionBall_isSubGaussian_psiTwoNorm_le :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian
          (NumStability.HDP.Convex.uniformConvexBodyMeasure
            (functionSqrtDimensionBall n))
          (fun i x ↦ x i) ∧
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (NumStability.HDP.Convex.uniformConvexBodyMeasure
            (functionSqrtDimensionBall n))
          (fun i x ↦ x i) ≤ ENNReal.ofReal C := by
  rcases
      NumStability.HDP.Vector.Spherical.sphericalVector_isSubGaussian_psiTwoNorm_le with
    ⟨C, hC, hSphere⟩
  refine ⟨C, hC, ?_⟩
  intro n hn
  letI : IsProbabilityMeasure (polarBallMeasure n) :=
    polarBallMeasure_isProbabilityMeasure hn
  have hLaw := hasLaw_polarBallVector n hn
  letI : IsProbabilityMeasure
      (NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionSqrtDimensionBall n)) :=
    hLaw.isProbabilityMeasure_iff.mp (inferInstance :
      IsProbabilityMeasure (polarBallMeasure n))
  have hEq := NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (measurable_polarBallVector n) hLaw
  have hPolar : NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
      (polarBallMeasure n) (polarBallVector n) ≤ ENNReal.ofReal C := by
    exact (polarBall_psiTwoNorm_le_sphericalVectorMeasure n).trans
      (hSphere n hn).2
  have hTarget : NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
      (NumStability.HDP.Convex.uniformConvexBodyMeasure
        (functionSqrtDimensionBall n))
      (fun i x ↦ x i) ≤ ENNReal.ofReal C := by
    rw [← hEq]
    exact hPolar
  exact ⟨NumStability.HDP.Vector.SubGaussian.isSubGaussian_of_psiTwoNorm_lt_top
      (hTarget.trans_lt ENNReal.ofReal_lt_top), hTarget⟩

end NumStability.HDP.Vector.UniformBall
