import ComputationalMathematics.HDP.Vector.GaussianMixturePopulationTop

/-!
# Ordered population eigenvalues for a rank-one signal

For a nonzero mean, the first population eigenvalue is the spike. Every
other ordered eigenvalue is one, giving an exact gap of the squared signal
norm. The one-dimensional case has no other eigenvalue index.
-/

namespace NumStability.HDP.Vector.GaussianMixture

open scoped BigOperators RealInnerProductSpace

theorem inner_populationDirection_eq_inv_norm_mul_dotProduct {n : ℕ}
    (mean : Fin n → ℝ) (v : EuclideanSpace ℝ (Fin n)) :
    inner ℝ (populationDirection mean) v =
      (NumStability.vecNorm2 mean)⁻¹ * dotProduct mean v := by
  dsimp [populationDirection]
  change (∑ i, v i * ((NumStability.vecNorm2 mean)⁻¹ * mean i)) =
    (NumStability.vecNorm2 mean)⁻¹ * ∑ i, mean i * v i
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _hi
  ring

theorem populationOrderedEigenvalue_eq_one_of_ne_zero {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (j : Fin n)
    (hj : j ≠ ⟨0, hn⟩) :
    NumStability.hermitianOrderedEigenvalue
      (populationSecondMoment_isHermitian mean) j = 1 := by
  let hA := populationSecondMoment_isHermitian mean
  let b := NumStability.hermitianOrderedEigenbasis hA
  let i0 : Fin n := ⟨0, hn⟩
  obtain ⟨_hvalue, s, hs, hb0⟩ :=
    populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean
  have horth : inner ℝ (b i0) (b j) = 0 := b.inner_eq_zero (Ne.symm hj)
  have hinner : inner ℝ (populationDirection mean) (b j) = 0 := by
    change inner ℝ
      (NumStability.hermitianOrderedEigenbasis
        (populationSecondMoment_isHermitian mean) ⟨0, hn⟩) (b j) = 0 at horth
    rw [hb0, real_inner_smul_left] at horth
    rcases hs with rfl | rfl <;> simpa using horth
  have hdot : dotProduct mean (b j) = 0 := by
    rw [inner_populationDirection_eq_inv_norm_mul_dotProduct] at hinner
    exact (mul_eq_zero.mp hinner).resolve_left (inv_ne_zero hmean.ne')
  have hray := NumStability.matrixRayleighForm_hermitianOrderedEigenbasis hA j
  rw [populationSecondMoment_rayleigh,
    NumStability.norm_hermitianOrderedEigenbasis, hdot] at hray
  simpa using hray.symm

theorem populationOrderedTop_eigengap {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (j : Fin n)
    (hj : j ≠ ⟨0, hn⟩) :
    |NumStability.hermitianOrderedEigenvalue
        (populationSecondMoment_isHermitian mean) ⟨0, hn⟩ -
      NumStability.hermitianOrderedEigenvalue
        (populationSecondMoment_isHermitian mean) j| =
      NumStability.vecNorm2 mean ^ 2 := by
  rw [(populationOrderedTopEigenbasis_eq_sign_direction hn mean hmean).1,
    populationOrderedEigenvalue_eq_one_of_ne_zero hn mean hmean j hj]
  simp

end NumStability.HDP.Vector.GaussianMixture
