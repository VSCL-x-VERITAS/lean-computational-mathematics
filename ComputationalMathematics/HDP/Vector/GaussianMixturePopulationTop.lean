import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectral

/-!
# The top direction of a rank-one population moment

The existing raw moment and normalized mean give a sharp Rayleigh upper bound.
Every Euclidean unit maximizer equals the normalized mean up to sign when the
mean has positive norm. The first vector of the decreasingly ordered eigenbasis
therefore has this direction and eigenvalue one plus the squared mean norm.
-/

noncomputable section

open Matrix
open scoped RealInnerProductSpace BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

theorem populationSecondMoment_rayleigh_le_spike {n : ℕ}
    (mean : Fin n → ℝ) (x : EuclideanSpace ℝ (Fin n)) :
    NumStability.matrixRayleighForm (populationSecondMoment mean) x ≤
      (1 + NumStability.vecNorm2 mean ^ 2) * ‖x‖ ^ 2 := by
  have hinner : inner ℝ x (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) =
      dotProduct mean x := by
    simp [PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, dotProduct]
  have hbound := abs_real_inner_le_norm x
    (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n))
  have hmeanNorm : ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n))‖ =
      NumStability.vecNorm2 mean :=
    NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2 mean
  rw [hinner, hmeanNorm] at hbound
  have hsq : (dotProduct mean x) ^ 2 ≤
      (‖x‖ * NumStability.vecNorm2 mean) ^ 2 := by
    have h := (sq_le_sq₀ (abs_nonneg (dotProduct mean x))
      (mul_nonneg (norm_nonneg x) (NumStability.vecNorm2_nonneg mean))).2 hbound
    simpa only [sq_abs] using h
  rw [populationSecondMoment_rayleigh]
  nlinarith

theorem populationDirection_isTopRayleigh {n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean) :
    ‖populationDirection mean‖ = 1 ∧
      ∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
        NumStability.matrixRayleighForm (populationSecondMoment mean) w ≤
          NumStability.matrixRayleighForm (populationSecondMoment mean)
            (populationDirection mean) := by
  have hu := norm_populationDirection mean hmean
  refine ⟨hu, ?_⟩
  intro w hw
  have h := populationSecondMoment_rayleigh_le_spike mean w
  have hpopulation : NumStability.matrixRayleighForm (populationSecondMoment mean)
      (populationDirection mean) = 1 + NumStability.vecNorm2 mean ^ 2 := by
    rw [populationSecondMoment_rayleigh, hu, one_pow,
      dotProduct_mean_populationDirection mean hmean]
  rw [hpopulation]
  simpa only [hw, one_pow, mul_one] using h

theorem populationTopRayleighVector_eq_sign_direction {n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean)
    (v : EuclideanSpace ℝ (Fin n)) (hv : ‖v‖ = 1)
    (htop : ∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
      NumStability.matrixRayleighForm (populationSecondMoment mean) w ≤
        NumStability.matrixRayleighForm (populationSecondMoment mean) v) :
    ∃ s : ℝ, (s = -1 ∨ s = 1) ∧ v = s • populationDirection mean := by
  let r := NumStability.vecNorm2 mean
  let u := populationDirection mean
  have hr : 0 < r := hmean
  have hu : ‖u‖ = 1 := norm_populationDirection mean hmean
  have hpopulation := htop u hu
  have hdotU : dotProduct mean u = r := dotProduct_mean_populationDirection mean hmean
  have hinner : inner ℝ u v = r⁻¹ * dotProduct mean v := by
    dsimp [u, r, populationDirection]
    change (∑ i, v i * ((NumStability.vecNorm2 mean)⁻¹ * mean i)) =
      (NumStability.vecNorm2 mean)⁻¹ * ∑ i, mean i * v i
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _hi
    ring
  have hdotV : dotProduct mean v = r * inner ℝ u v := by
    rw [hinner]
    field_simp [hr.ne']
  rw [populationSecondMoment_rayleigh, populationSecondMoment_rayleigh,
    hu, hv, one_pow, hdotU, hdotV] at hpopulation
  have hbound := abs_real_inner_le_norm u v
  rw [hu, hv, one_mul] at hbound
  have hbounds := abs_le.mp hbound
  have hsquare : (inner ℝ u v) ^ 2 = 1 := by
    have hr2 : 0 < r ^ 2 := sq_pos_of_pos hr
    nlinarith [sq_nonneg (inner ℝ u v)]
  by_cases hnonneg : 0 ≤ inner ℝ u v
  · have hone : inner ℝ u v = 1 := by nlinarith
    have heq := (inner_eq_one_iff_of_norm_eq_one hu hv).mp hone
    exact ⟨1, Or.inr rfl, by simpa only [one_smul] using heq.symm⟩
  · have hneg : inner ℝ u v = -1 := by nlinarith
    have heq := (inner_eq_neg_one_iff_of_norm_eq_one hu hv).mp hneg
    refine ⟨-1, Or.inl rfl, ?_⟩
    simpa only [neg_smul, one_smul, neg_neg] using congrArg Neg.neg heq.symm

/-- The first vector in the actual decreasingly ordered population eigenbasis
has the spike eigenvalue and is the normalized mean up to global sign. -/
theorem populationOrderedTopEigenbasis_eq_sign_direction {n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean) :
    let hA := populationSecondMoment_isHermitian mean
    let i0 : Fin n := ⟨0, hn⟩
    NumStability.hermitianOrderedEigenvalue hA i0 =
      1 + NumStability.vecNorm2 mean ^ 2 ∧
      ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
        NumStability.hermitianOrderedEigenbasis hA i0 =
          s • populationDirection mean := by
  let hA := populationSecondMoment_isHermitian mean
  let i0 : Fin n := ⟨0, hn⟩
  let v := NumStability.hermitianOrderedEigenbasis hA i0
  have hv : ‖v‖ = 1 := NumStability.norm_hermitianOrderedEigenbasis hA i0
  have htrailtop : NumStability.hermitianTrailSubspace hA i0 = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [NumStability.finrank_hermitianTrailSubspace, finrank_euclideanSpace_fin]
    simp [i0]
  have hmax : ∀ w : EuclideanSpace ℝ (Fin n), ‖w‖ = 1 →
      NumStability.matrixRayleighForm (populationSecondMoment mean) w ≤
        NumStability.matrixRayleighForm (populationSecondMoment mean) v := by
    intro w hw
    have hwtrail : w ∈ NumStability.hermitianTrailSubspace hA i0 := by
      rw [htrailtop]
      trivial
    have hbound :=
      NumStability.rayleigh_le_hermitianOrderedEigenvalue_mul_norm_sq_of_mem_trail
        hA i0 hwtrail
    rw [hw, one_pow, mul_one] at hbound
    exact hbound.trans_eq
      (NumStability.matrixRayleighForm_hermitianOrderedEigenbasis hA i0).symm
  have hu := norm_populationDirection mean hmean
  have hpopulation : NumStability.matrixRayleighForm (populationSecondMoment mean)
      (populationDirection mean) = 1 + NumStability.vecNorm2 mean ^ 2 := by
    rw [populationSecondMoment_rayleigh, hu, one_pow,
      dotProduct_mean_populationDirection mean hmean]
  have hupper := populationSecondMoment_rayleigh_le_spike mean v
  rw [hv, one_pow, mul_one] at hupper
  have hlower := hmax (populationDirection mean) hu
  rw [hpopulation] at hlower
  have hvalue : NumStability.hermitianOrderedEigenvalue hA i0 =
      1 + NumStability.vecNorm2 mean ^ 2 := by
    exact (NumStability.matrixRayleighForm_hermitianOrderedEigenbasis hA i0).symm.trans
      (le_antisymm hupper hlower)
  exact ⟨hvalue, populationTopRayleighVector_eq_sign_direction mean hmean v hv hmax⟩

end NumStability.HDP.Vector.GaussianMixture
