import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer
import ComputationalMathematics.HDP.Vector.CovarianceEstimation

/-!
# Euclidean spectral clustering of a point sample

This module gives the source algorithm a genuinely Euclidean leading
eigenvector.  It is separate from the older `IsTopRayleighVector` interface,
whose function-space norm is the Pi sup norm rather than the Euclidean norm.
-/

noncomputable section

open Matrix

namespace NumStability.HDP.Vector.EuclideanSpectralClustering

/-- The empirical second-moment matrix used by spectral clustering. -/
def sampleSecondMoment {m n : ℕ} (X : Fin m → Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  NumStability.HDP.Vector.Covariance.sampleCovariance X

/-- An empirical second-moment matrix is real symmetric. -/
theorem sampleSecondMoment_isHermitian {m n : ℕ}
    (X : Fin m → Fin n → ℝ) : (sampleSecondMoment X).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext a b
  simp [sampleSecondMoment,
    NumStability.HDP.Vector.Covariance.sampleCovariance, mul_comm]

/-- The algorithm's selected leading eigenvector: index zero in the
decreasingly ordered orthonormal eigenbasis of the empirical second moment. -/
def leadingEigenvector {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) : EuclideanSpace ℝ (Fin n) :=
  NumStability.hermitianOrderedEigenbasis
    (sampleSecondMoment_isHermitian X) ⟨0, hn⟩

/-- The selected leading vector has Euclidean norm one. -/
theorem norm_leadingEigenvector {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) : ‖leadingEigenvector hn X‖ = 1 :=
  NumStability.norm_hermitianOrderedEigenbasis
    (sampleSecondMoment_isHermitian X) ⟨0, hn⟩

/-- The selected leading vector is an eigenvector of the empirical second
moment at the decreasing-order index-zero eigenvalue. -/
theorem sampleSecondMoment_apply_leadingEigenvector {m n : ℕ}
    (hn : 0 < n) (X : Fin m → Fin n → ℝ) :
    (sampleSecondMoment X).toEuclideanLin (leadingEigenvector hn X) =
      NumStability.hermitianOrderedEigenvalue
          (sampleSecondMoment_isHermitian X) ⟨0, hn⟩ •
        leadingEigenvector hn X :=
  NumStability.hermitianOrderedEigenbasis_apply
    (sampleSecondMoment_isHermitian X) ⟨0, hn⟩

/-- Every empirical eigenvalue is at most the selected index-zero
eigenvalue, since the eigenvalue family is decreasing. -/
theorem eigenvalue_le_leadingEigenvalue {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) (j : Fin n) :
    NumStability.hermitianOrderedEigenvalue
        (sampleSecondMoment_isHermitian X) j ≤
      NumStability.hermitianOrderedEigenvalue
        (sampleSecondMoment_isHermitian X) ⟨0, hn⟩ := by
  letI : NeZero n := ⟨Nat.ne_of_gt hn⟩
  exact NumStability.hermitianOrderedEigenvalue_antitone
    (sampleSecondMoment_isHermitian X) (Fin.zero_le j)

/-- The selected index-zero eigenvector maximizes the Euclidean Rayleigh
form on the unit sphere.  This is the Euclidean normalization required by
the source spectral-clustering algorithm. -/
theorem leadingEigenvector_isTopRayleigh {m n : ℕ} (hn : 0 < n)
    (X : Fin m → Fin n → ℝ) :
    ‖leadingEigenvector hn X‖ = 1 ∧
      ∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
        NumStability.matrixRayleighForm (sampleSecondMoment X) w ≤
          NumStability.matrixRayleighForm (sampleSecondMoment X)
            (leadingEigenvector hn X) := by
  let i0 : Fin n := ⟨0, hn⟩
  let hA := sampleSecondMoment_isHermitian X
  have htrailtop : NumStability.hermitianTrailSubspace hA i0 = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [NumStability.finrank_hermitianTrailSubspace,
      finrank_euclideanSpace_fin]
    simp [i0]
  refine ⟨norm_leadingEigenvector hn X, ?_⟩
  intro w hw
  have hwtrail : w ∈ NumStability.hermitianTrailSubspace hA i0 := by
    rw [htrailtop]
    trivial
  have hbound :=
    NumStability.rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
      hA i0 hwtrail
  rw [hw, one_pow, mul_one] at hbound
  have hattain := NumStability.matrixRayleighForm_hermitianOrderedEigenbasis hA i0
  change NumStability.matrixRayleighForm (sampleSecondMoment X) w ≤
      NumStability.matrixRayleighForm (sampleSecondMoment X)
        (leadingEigenvector hn X)
  exact hbound.trans_eq hattain.symm

end NumStability.HDP.Vector.EuclideanSpectralClustering
