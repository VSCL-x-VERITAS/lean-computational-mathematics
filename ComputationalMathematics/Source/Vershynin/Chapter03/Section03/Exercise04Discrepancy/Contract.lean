import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise04Discrepancy.Signature

/-!
# Exercise 3.3.4 nondegeneracy discrepancy

The printed characterization admits a constant vector on its marginal side,
because zero-variance scalar normal laws are allowed, but the preceding source
definition requires an invertible multivariate covariance matrix.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- A constant one-dimensional vector is Gaussian in Mathlib's standard broad
sense and all of its scalar marginals are Gaussian, but it cannot have the
invertible-covariance affine normal law required by the preceding source
definition. -/
theorem hdp_03_ex_3_3_4_degenerate_obstruction :
    hdp_03_ex_3_3_4_degenerate_obstruction__contract_type := by
  let X : Unit → EuclideanSpace ℝ (Fin 1) := fun _ => 0
  have hX : HasGaussianLaw X (Measure.dirac ()) := by
    refine ⟨?_⟩
    simpa [X] using
      (inferInstance : IsGaussian (Measure.dirac (0 : EuclideanSpace ℝ (Fin 1))))
  refine ⟨X, hX, fun theta => ?_, ?_⟩
  · simpa [X] using hX.map_fun (innerSL ℝ theta)
  · rintro ⟨m, S, B, hSpos, hSunit, hBpos, hBB, hLaw⟩
    have hCov :=
      NumStability.HDP.Vector.Gaussian.covarianceMatrix_eq_mul_transpose_of_hasAffineStandardNormalLaw
        hLaw
    have hBT : B.transpose = B := by
      simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using hBpos.1
    have hCovZero :
        NumStability.HDP.Vector.Covariance.covarianceMatrix (Measure.dirac ())
            (fun i omega => X omega i) = 0 := by
      ext i j
      rw [NumStability.HDP.Vector.Covariance.covarianceMatrix_apply]
      simp [X]
    have hSzero : S = 0 := by
      calc
        S = B * B := hBB.symm
        _ = B * B.transpose := by rw [hBT]
        _ = NumStability.HDP.Vector.Covariance.covarianceMatrix (Measure.dirac ())
              (fun i omega => X omega i) := hCov.symm
        _ = 0 := hCovZero
    exact hSunit.ne_zero hSzero

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_4_degenerate_obstruction__contract :
    hdp_03_ex_3_3_4_degenerate_obstruction__contract_type :=
  hdp_03_ex_3_3_4_degenerate_obstruction

end NumStability.HDP.Contract
