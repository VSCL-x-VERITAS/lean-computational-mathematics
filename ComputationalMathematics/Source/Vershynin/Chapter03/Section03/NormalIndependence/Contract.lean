import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.NormalIndependence.Signature

/-!
# Gaussian independence, uncorrelatedness, and the identity-covariance discrepancy

The independence/uncorrelated equivalence is correct for jointly Gaussian
coordinates.  The printed parenthetical “in this case `Σ = Iₙ`” is not: even a
one-dimensional centered normal of variance four has an independent coordinate
family and covariance different from the identity.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Section 3.3.2, printed page 51: finite jointly Gaussian coordinates are
mutually independent exactly when distinct coordinates are uncorrelated. -/
theorem hdp_03_body_3_3_normal_independent_iff_uncorrelated :
    hdp_03_body_3_3_normal_independent_iff_uncorrelated__contract_type := by
  intro n Ω _ μ X hX
  exact
    NumStability.HDP.Vector.Gaussian.iIndepFun_iff_covariance_eq_zero_of_hasGaussianLaw hX

/-- Concrete obstruction to the printed parenthetical `Σ = Iₙ`: the affine
Gaussian law with one-dimensional scale two has covariance four, its singleton
coordinate family is independent, and its covariance is not the identity. -/
theorem hdp_03_body_3_3_normal_identity_parenthetical_obstruction :
    hdp_03_body_3_3_normal_identity_parenthetical_obstruction__contract_type := by
  let B : Matrix (Fin 1) (Fin 1) ℝ := Matrix.diagonal (fun _ => 2)
  let S : Matrix (Fin 1) (Fin 1) ℝ := Matrix.diagonal (fun _ => 4)
  refine ⟨S, B, ?_, ?_, ?_, ?_, ?_⟩
  · exact Matrix.PosSemidef.diagonal (by intro i; norm_num)
  · rw [Matrix.isUnit_diagonal, Pi.isUnit_iff]
    intro i
    exact isUnit_iff_ne_zero.mpr (by norm_num)
  · exact Matrix.PosSemidef.diagonal (by intro i; norm_num)
  · ext i j
    fin_cases i
    fin_cases j
    norm_num [B, S, Matrix.mul_apply]
  · let ν := NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure
      (0 : Fin 1 → ℝ) B
    let X : Fin 1 → (Fin 1 → ℝ) → ℝ := fun i x => x i
    letI : IsProbabilityMeasure ν := by
      unfold ν NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure
      exact Measure.isProbabilityMeasure_map
        (NumStability.HDP.Vector.Gaussian.measurable_affineGaussianMap 0 B).aemeasurable
    have hLaw :
        NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw ν X 0 B := by
      unfold NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw X
      simpa only [id_eq] using
        (HasLaw.id : HasLaw id
          (NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure 0 B)
          (NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure 0 B))
    refine ⟨hLaw, iIndepFun.of_subsingleton, ?_, ?_⟩
    · rw [NumStability.HDP.Vector.Gaussian.covarianceMatrix_eq_mul_transpose_of_hasAffineStandardNormalLaw
        hLaw]
      have hBT : B.transpose = B := by simp [B]
      rw [hBT]
      ext i j
      fin_cases i
      fin_cases j
      norm_num [B, S, Matrix.mul_apply]
    · intro h
      have hij := congrFun (congrFun h (0 : Fin 1)) (0 : Fin 1)
      norm_num [S] at hij

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_normal_independent_iff_uncorrelated__contract :
    hdp_03_body_3_3_normal_independent_iff_uncorrelated__contract_type :=
  hdp_03_body_3_3_normal_independent_iff_uncorrelated

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_normal_identity_parenthetical_obstruction__contract :
    hdp_03_body_3_3_normal_identity_parenthetical_obstruction__contract_type :=
  hdp_03_body_3_3_normal_identity_parenthetical_obstruction

end NumStability.HDP.Contract
