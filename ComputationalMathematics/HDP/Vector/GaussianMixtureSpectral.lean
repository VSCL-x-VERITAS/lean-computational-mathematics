import ComputationalMathematics.HDP.Vector.EuclideanSpectralClustering
import ComputationalMathematics.HDP.Vector.GaussianMixtureIdeal
import ComputationalMathematics.HDP.Vector.EigenvectorAlignment

/-!
# Spectral recovery for the symmetric Gaussian mixture

This file supplies the deterministic spectral step between covariance
concentration and clustering.  The population matrix is `I + μμᵀ`; its
Euclidean top direction is the normalized mean.  A leading Euclidean
eigenvector of a nearby empirical second moment is therefore close to that
direction up to global sign.
-/

noncomputable section

open Matrix
open scoped RealInnerProductSpace BigOperators

namespace NumStability.HDP.Vector.GaussianMixture

/-- The population second moment of the symmetric mixture is real
symmetric. -/
theorem populationSecondMoment_isHermitian {n : ℕ} (mean : Fin n → ℝ) :
    (populationSecondMoment mean).IsHermitian := by
  rw [Matrix.IsHermitian]
  ext i j
  simp [populationSecondMoment, Matrix.one_apply, eq_comm, mul_comm]

/-- Exact Rayleigh form of `I + μμᵀ`. -/
theorem populationSecondMoment_rayleigh {n : ℕ} (mean : Fin n → ℝ)
    (x : EuclideanSpace ℝ (Fin n)) :
    NumStability.matrixRayleighForm (populationSecondMoment mean) x =
      ‖x‖ ^ 2 + (dotProduct mean x) ^ 2 := by
  have hmul :
      (populationSecondMoment mean).toEuclideanLin x =
        x + (dotProduct mean x) • (WithLp.toLp 2 mean :
          EuclideanSpace ℝ (Fin n)) := by
    ext i
    change (∑ j, ((if i = j then 1 else 0) + mean i * mean j) * x j) =
      x i + (∑ j, mean j * x j) * mean i
    simp_rw [add_mul]
    rw [Finset.sum_add_distrib]
    have hdiag : (∑ j, (if i = j then 1 else 0) * x j) = x i := by simp
    rw [hdiag]
    rw [mul_comm (∑ j, mean j * x j) (mean i)]
    rw [Finset.mul_sum]
    apply congrArg (x i + ·)
    apply Finset.sum_congr rfl
    intro j _hj
    ring
  rw [NumStability.matrixRayleighForm, hmul, inner_add_right,
    real_inner_self_eq_norm_sq]
  have hinner :
      inner ℝ x (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) =
        dotProduct mean x := by
    simp [PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply,
      dotProduct]
  rw [real_inner_smul_right, hinner]
  ring

/-- The normalized population mean as a Euclidean vector. -/
def populationDirection {n : ℕ} (mean : Fin n → ℝ) :
    EuclideanSpace ℝ (Fin n) :=
  WithLp.toLp 2 (fun i ↦ (NumStability.vecNorm2 mean)⁻¹ * mean i)

theorem norm_populationDirection {n : ℕ} (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) :
    ‖populationDirection mean‖ = 1 := by
  rw [show ‖populationDirection mean‖ =
      NumStability.vecNorm2
        (fun i ↦ (NumStability.vecNorm2 mean)⁻¹ * mean i) by
    simpa [populationDirection] using
      (NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2
        (fun i ↦ (NumStability.vecNorm2 mean)⁻¹ * mean i))]


  rw [NumStability.vecNorm2_smul, abs_inv,
    abs_of_pos hmean, inv_mul_cancel₀ hmean.ne']

theorem mean_eq_norm_smul_populationDirection {n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean) :
    (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) =
      NumStability.vecNorm2 mean • populationDirection mean := by
  ext i
  simp [populationDirection, hmean.ne']

/-- The population direction attains the spike eigenvalue. -/
theorem populationSecondMoment_apply_populationDirection {n : ℕ}
    (mean : Fin n → ℝ) :
    (populationSecondMoment mean).toEuclideanLin (populationDirection mean) =
      (1 + NumStability.vecNorm2 mean ^ 2) • populationDirection mean := by
  have hmul := populationSecondMoment_mulVec_mean mean
  have hscale : populationDirection mean =
      (NumStability.vecNorm2 mean)⁻¹ •
        (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) := by
    ext i
    rfl
  rw [hscale, map_smul]
  change (NumStability.vecNorm2 mean)⁻¹ •
      WithLp.toLp 2 ((populationSecondMoment mean).mulVec mean) = _
  rw [hmul]
  simp [smul_smul, mul_comm]

theorem dotProduct_mean_populationDirection {n : ℕ}
    (mean : Fin n → ℝ) (hmean : 0 < NumStability.vecNorm2 mean) :
    dotProduct mean (populationDirection mean) =
      NumStability.vecNorm2 mean := by
  unfold dotProduct populationDirection
  change (∑ i, mean i * ((NumStability.vecNorm2 mean)⁻¹ * mean i)) = _
  rw [show (∑ i, mean i * ((NumStability.vecNorm2 mean)⁻¹ * mean i)) =
      (NumStability.vecNorm2 mean)⁻¹ * ∑ i, mean i ^ 2 by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _hi
    ring]
  rw [show (∑ i, mean i ^ 2) = NumStability.vecNorm2 mean ^ 2 by
    exact (NumStability.vecNorm2_sq mean).symm]
  field_simp [hmean.ne']

private theorem abs_matrixRayleighForm_le_operatorNorm {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (x : EuclideanSpace ℝ (Fin n))
    (hx : ‖x‖ = 1) :
    |NumStability.matrixRayleighForm A x| ≤
      NumStability.realMatrixOperatorNorm A := by
  calc
    |NumStability.matrixRayleighForm A x| =
        |inner ℝ x (Matrix.toEuclideanLin A x)| := rfl
    _ ≤ ‖x‖ * ‖Matrix.toEuclideanLin A x‖ := abs_real_inner_le_norm _ _
    _ = ‖Matrix.toEuclideanLin A x‖ := by rw [hx, one_mul]
    _ ≤ ‖NumStability.realMatrixContinuousLinearMap A‖ * ‖x‖ := by
      simpa [NumStability.realMatrixContinuousLinearMap] using
        ContinuousLinearMap.le_opNorm
          (NumStability.realMatrixContinuousLinearMap A) x
    _ = NumStability.realMatrixOperatorNorm A := by
      rw [hx, mul_one]
      rfl

private theorem abs_rayleigh_sub_le_operatorNorm {n : ℕ}
    (T S : Matrix (Fin n) (Fin n) ℝ) (x : EuclideanSpace ℝ (Fin n))
    (hx : ‖x‖ = 1) :
    |NumStability.matrixRayleighForm T x -
        NumStability.matrixRayleighForm S x| ≤
      NumStability.realMatrixOperatorNorm (T - S) := by
  have heq : NumStability.matrixRayleighForm T x -
      NumStability.matrixRayleighForm S x =
        NumStability.matrixRayleighForm (T - S) x := by
    simp [NumStability.matrixRayleighForm, Matrix.toLpLin_apply,
      inner_sub_right]
  rw [heq]
  exact abs_matrixRayleighForm_le_operatorNorm (T - S) x hx

/-- A leading empirical Euclidean eigenvector is close, up to sign and at the
natural signal scale, to the population mean.  This direct rank-one
perturbation estimate avoids any arbitrary choice of a population
eigenbasis. -/
theorem exists_sign_mean_sub_scaledLeadingEigenvector_le {m n : ℕ}
    (hn : 0 < n) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean)
    (X : Fin m → Fin n → ℝ) :
    ∃ s : ℝ, (s = -1 ∨ s = 1) ∧
      ‖(WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
          s • (NumStability.vecNorm2 mean •
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              hn X)‖ ≤
        2 * Real.sqrt
          (NumStability.realMatrixOperatorNorm
            (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
              populationSecondMoment mean)) := by
  let r : ℝ := NumStability.vecNorm2 mean
  let u : EuclideanSpace ℝ (Fin n) := populationDirection mean
  let v : EuclideanSpace ℝ (Fin n) :=
    NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X
  let T := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X
  let S := populationSecondMoment mean
  let e : ℝ := NumStability.realMatrixOperatorNorm (T - S)
  have hr : 0 < r := by simpa [r] using hmean
  have hu : ‖u‖ = 1 := by simpa [u] using norm_populationDirection mean hmean
  have hv : ‖v‖ = 1 := by
    simpa [v] using
      NumStability.HDP.Vector.EuclideanSpectralClustering.norm_leadingEigenvector hn X
  have he0 : 0 ≤ e := by
    exact norm_nonneg _
  have htop : NumStability.matrixRayleighForm T u ≤
      NumStability.matrixRayleighForm T v := by
    exact
      (NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector_isTopRayleigh
        hn X).2 u hu
  have hpertU : |NumStability.matrixRayleighForm T u -
      NumStability.matrixRayleighForm S u| ≤ e := by
    exact abs_rayleigh_sub_le_operatorNorm T S u hu
  have hpertV : |NumStability.matrixRayleighForm T v -
      NumStability.matrixRayleighForm S v| ≤ e := by
    exact abs_rayleigh_sub_le_operatorNorm T S v hv
  have hpopulation : NumStability.matrixRayleighForm S u - 2 * e ≤
      NumStability.matrixRayleighForm S v := by
    rw [abs_le] at hpertU hpertV
    linarith
  have hdotU : dotProduct mean u = r := by
    simpa [u, r] using dotProduct_mean_populationDirection mean hmean
  have hrayU : NumStability.matrixRayleighForm S u = 1 + r ^ 2 := by
    rw [show S = populationSecondMoment mean by rfl,
      populationSecondMoment_rayleigh, hu, one_pow, hdotU]
  have hrayV : NumStability.matrixRayleighForm S v =
      1 + (dotProduct mean v) ^ 2 := by
    rw [show S = populationSecondMoment mean by rfl,
      populationSecondMoment_rayleigh, hv, one_pow]
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
  have hgap : r ^ 2 * (1 - (inner ℝ u v) ^ 2) ≤ 2 * e := by
    rw [hrayU, hrayV, hdotV] at hpopulation
    nlinarith
  have hcos : Real.cos (InnerProductGeometry.angle u v) = inner ℝ u v := by
    rw [InnerProductGeometry.cos_angle, hu, hv, one_mul, div_one]
  have htrig := Real.sin_sq_add_cos_sq (InnerProductGeometry.angle u v)
  rw [hcos] at htrig
  have hsinGap : r ^ 2 * Real.sin (InnerProductGeometry.angle u v) ^ 2 ≤
      2 * e := by
    nlinarith
  obtain ⟨s, hs, hdist⟩ :=
    NumStability.HDP.Vector.exists_sign_norm_sub_le_sqrt_two_mul_sin_angle
      u v hu hv
  have hsin0 : 0 ≤ Real.sin (InnerProductGeometry.angle u v) :=
    InnerProductGeometry.sin_angle_nonneg u v
  have hsqrt2 : (Real.sqrt 2) ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hsqrte : (Real.sqrt e) ^ 2 = e := Real.sq_sqrt he0
  have hscaled :
      r * (Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v)) ≤
        2 * Real.sqrt e := by
    have hleft0 : 0 ≤
        r * (Real.sqrt 2 * Real.sin (InnerProductGeometry.angle u v)) := by
      positivity
    have hright0 : 0 ≤ 2 * Real.sqrt e := by positivity
    nlinarith
  refine ⟨s, hs, ?_⟩
  have hvec :
      (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) - s • (r • v) =
        r • (u - s • v) := by
    rw [show (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) = r • u by
      simpa [r, u] using mean_eq_norm_smul_populationDirection mean hmean]
    module
  rw [hvec, norm_smul, Real.norm_eq_abs, abs_of_pos hr]
  exact (mul_le_mul_of_nonneg_left hdist hr.le).trans hscaled

/-- Multiplying a classifying direction by a positive scalar does not change
the sign-thresholded error set. -/
theorem misclassifiedIndices_pos_smul {m n : ℕ}
    (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) (r : ℝ) (hr : 0 < r) :
    misclassifiedIndices labels (r • v) X =
      misclassifiedIndices labels v X := by
  ext i
  simp only [misclassifiedIndices, Set.mem_setOf_eq, dotProduct,
    Pi.smul_apply, smul_eq_mul]
  have hsum : (∑ x, r * v x * X i x) = r * ∑ x, v x * X i x := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _hj
    ring
  rw [hsum]
  constructor <;> intro h
  · have : r * (labels i * ∑ x, v x * X i x) ≤ 0 := by
      convert h using 1 ; ring
    nlinarith
  · have : r * (labels i * ∑ x, v x * X i x) ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos hr.le h
    convert this using 1 ; ring

/-- The up-to-sign clustering guarantee is invariant under positive scaling
of the selected direction. -/
theorem makesAtMostErrorsUpToSign_pos_smul_iff {m n : ℕ}
    (labels : Fin m → ℝ) (v : Fin n → ℝ)
    (X : Fin m → Fin n → ℝ) (budget r : ℝ) (hr : 0 < r) :
    MakesAtMostErrorsUpToSign labels (r • v) X budget ↔
      MakesAtMostErrorsUpToSign labels v X budget := by
  constructor
  · rintro ⟨s, hs, hcard⟩
    refine ⟨s, hs, ?_⟩
    have hset : misclassifiedIndices labels (s • (r • v)) X =
        misclassifiedIndices labels (s • v) X := by
      rw [show s • (r • v) = r • (s • v) by
        simp [smul_smul, mul_comm]]
      exact misclassifiedIndices_pos_smul labels (s • v) X r hr
    rw [hset] at hcard
    exact hcard
  · rintro ⟨s, hs, hcard⟩
    refine ⟨s, hs, ?_⟩
    have hset : misclassifiedIndices labels (s • (r • v)) X =
        misclassifiedIndices labels (s • v) X := by
      rw [show s • (r • v) = r • (s • v) by
        simp [smul_smul, mul_comm]]
      exact misclassifiedIndices_pos_smul labels (s • v) X r hr
    rw [hset]
    exact hcard

/-- A deterministic second-moment bound for the number of rows whose norm is
large enough to consume a direction-perturbation margin. -/
theorem ncard_directionUnstable_mul_margin_sq_le {m n : ℕ}
    (X : Fin m → Fin n → ℝ) (η τ : ℝ)
    (hτ : 0 ≤ τ) :
    (Set.ncard (directionUnstableIndices X η τ) : ℝ) * τ ^ 2 ≤
      η ^ 2 * ∑ i, NumStability.vecNorm2 (X i) ^ 2 := by
  classical
  let U := directionUnstableIndices X η τ
  calc
    (Set.ncard (directionUnstableIndices X η τ) : ℝ) * τ ^ 2 =
        ∑ _i ∈ U.toFinset, τ ^ 2 := by
      simp [U, Set.ncard_eq_toFinset_card']
    _ ≤ ∑ i ∈ U.toFinset, η ^ 2 * NumStability.vecNorm2 (X i) ^ 2 := by
      apply Finset.sum_le_sum
      intro i hi
      have hiU : i ∈ directionUnstableIndices X η τ := by
        simpa [U] using hi
      change τ ≤ η * NumStability.vecNorm2 (X i) at hiU
      have hnorm : 0 ≤ NumStability.vecNorm2 (X i) :=
        NumStability.vecNorm2_nonneg _
      nlinarith
    _ ≤ ∑ i : Fin m, η ^ 2 * NumStability.vecNorm2 (X i) ^ 2 := by
      exact Finset.sum_le_sum_of_subset_of_nonneg
        (by intro i _hi; simp)
        (by intro i _hi _hnot; positivity)
    _ = η ^ 2 * ∑ i, NumStability.vecNorm2 (X i) ^ 2 := by
      rw [Finset.mul_sum]

/-- Total sample energy is the sample size times the diagonal sum of the
uncentered empirical second moment. -/
theorem sum_vecNorm2_sq_eq_card_mul_sampleSecondMoment_diagonal {m n : ℕ}
    (hm : 0 < m) (X : Fin m → Fin n → ℝ) :
    ∑ i, NumStability.vecNorm2 (X i) ^ 2 =
      (m : ℝ) * ∑ j,
        NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X j j := by
  calc
    ∑ i, NumStability.vecNorm2 (X i) ^ 2 =
        ∑ i, ∑ j, X i j ^ 2 := by
      apply Finset.sum_congr rfl
      intro i _hi
      exact NumStability.vecNorm2_sq (X i)
    _ = ∑ j, ∑ i, X i j ^ 2 := Finset.sum_comm
    _ = (m : ℝ) * ∑ j,
        NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X j j := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _hj
      change (∑ i, X i j ^ 2) =
        (m : ℝ) * ((m : ℝ)⁻¹ * ∑ i, X i j * X i j)
      have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast hm.ne'
      field_simp [hmR]

/-- A diagonal entry can increase by at most the operator norm of a matrix
perturbation. -/
theorem diagonal_le_add_operatorNorm_sub {n : ℕ}
    (T S : Matrix (Fin n) (Fin n) ℝ) (j : Fin n) :
    T j j ≤ S j j + NumStability.realMatrixOperatorNorm (T - S) := by
  let e : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single j 1
  have he : ‖e‖ = 1 := by simp [e]
  have h := abs_rayleigh_sub_le_operatorNorm T S e he
  have hT : NumStability.matrixRayleighForm T e = T j j := by
    simp [NumStability.matrixRayleighForm, Matrix.toLpLin_apply,
      e, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply]
  have hS : NumStability.matrixRayleighForm S e = S j j := by
    simp [NumStability.matrixRayleighForm, Matrix.toLpLin_apply,
      e, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply]
  rw [hT, hS] at h
  linarith [le_abs_self (T j j - S j j)]

/-- The population trace is the ambient dimension plus the squared signal
norm. -/
theorem sum_populationSecondMoment_diagonal {n : ℕ}
    (mean : Fin n → ℝ) :
    ∑ j, populationSecondMoment mean j j =
      (n : ℝ) + NumStability.vecNorm2 mean ^ 2 := by
  simp_rw [populationSecondMoment_apply, if_pos]
  rw [Finset.sum_add_distrib]
  have hnorm : (∑ j, mean j * mean j) =
      NumStability.vecNorm2 mean ^ 2 := by
    simpa [NumStability.vecNorm2Sq, pow_two] using
      (NumStability.vecNorm2_sq mean).symm
  rw [hnorm]
  simp

/-- On an operator-norm covariance event, the total observed sample energy
is controlled by the population trace plus `n` copies of the deviation. -/
theorem sum_vecNorm2_sq_le_of_sampleSecondMoment_deviation {m n : ℕ}
    (hm : 0 < m) (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ) :
    ∑ i, NumStability.vecNorm2 (X i) ^ 2 ≤
      (m : ℝ) * ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 +
        (n : ℝ) * NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
            populationSecondMoment mean)) := by
  let T := NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X
  let S := populationSecondMoment mean
  let e := NumStability.realMatrixOperatorNorm (T - S)
  rw [sum_vecNorm2_sq_eq_card_mul_sampleSecondMoment_diagonal hm X]
  apply mul_le_mul_of_nonneg_left _ (Nat.cast_nonneg m)
  calc
    ∑ j, T j j ≤ ∑ j, (S j j + e) := by
      apply Finset.sum_le_sum
      intro j _hj
      exact diagonal_le_add_operatorNorm_sub T S j
    _ = (n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * e := by
      rw [Finset.sum_add_distrib, sum_populationSecondMoment_diagonal]
      simp

/-- A convenient deterministic half-budget criterion for the indices whose
classification margin can be consumed by a direction perturbation. -/
theorem ncard_directionUnstable_le_half_budget_of_sampleSecondMoment_deviation
    {m n : ℕ} (hm : 0 < m) (X : Fin m → Fin n → ℝ)
    (mean : Fin n → ℝ) (η τ ε : ℝ) (hτ : 0 < τ)
    (hbudget :
      η ^ 2 * ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 +
        (n : ℝ) * NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
            populationSecondMoment mean)) ≤
        ε / 2 * τ ^ 2) :
    (Set.ncard (directionUnstableIndices X η τ) : ℝ) ≤ ε * m / 2 := by
  have hcard := ncard_directionUnstable_mul_margin_sq_le
    X η τ hτ.le
  have henergy :=
    sum_vecNorm2_sq_le_of_sampleSecondMoment_deviation hm X mean
  have hscaledEnergy := mul_le_mul_of_nonneg_left henergy (sq_nonneg η)
  have hscaledBudget :=
    mul_le_mul_of_nonneg_left hbudget (Nat.cast_nonneg m)
  have hτsq : 0 < τ ^ 2 := sq_pos_of_pos hτ
  nlinarith

/-- Deterministic spectral-clustering transfer on a covariance-deviation
event.  The single scalar hypothesis is exactly the arithmetic needed for the
direction-instability half of the error budget. -/
theorem makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (ε τ : ℝ) (hτ : 0 < τ)
    (hideal :
      (Set.ncard (idealMarginErrors labels mean X τ) : ℝ) ≤ ε * m / 2)
    (hbudget :
      (2 * Real.sqrt
        (NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
            populationSecondMoment mean))) ^ 2 *
          ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 +
            (n : ℝ) * NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
                populationSecondMoment mean)) ≤
        ε / 2 * τ ^ 2) :
    MakesAtMostErrorsUpToSign labels
      (fun j ↦
        NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
          hn X j) X (ε * m) := by
  let e : ℝ := NumStability.realMatrixOperatorNorm
    (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
      populationSecondMoment mean)
  let η : ℝ := 2 * Real.sqrt e
  let r : ℝ := NumStability.vecNorm2 mean
  let v : Fin n → ℝ := fun j ↦
    NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector hn X j
  obtain ⟨s, hs, hdist⟩ :=
    exists_sign_mean_sub_scaledLeadingEigenvector_le hn mean hmean X
  have hvec :
      (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) -
          s • (r •
            NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
              hn X) =
        WithLp.toLp 2 (mean - s • (r • v)) := by
    ext j
    rfl
  rw [hvec] at hdist
  have hdistRaw : NumStability.vecNorm2 (mean - s • (r • v)) ≤ η := by
    rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
    simpa only [e, η] using hdist
  have hunstable :
      (Set.ncard (directionUnstableIndices X η τ) : ℝ) ≤ ε * m / 2 := by
    apply ncard_directionUnstable_le_half_budget_of_sampleSecondMoment_deviation
      hm X mean η τ ε hτ
    simpa [e, η] using hbudget
  have hscaled : MakesAtMostErrorsUpToSign labels (r • v) X (ε * m) :=
    makesAtMostErrorsUpToSign_of_margin_and_direction
      labels mean (r • v) X s η τ ε hs hlabels hdistRaw hideal hunstable
  exact (makesAtMostErrorsUpToSign_pos_smul_iff labels v X (ε * m) r
    (by simpa [r] using hmean)).1 hscaled

/-- Monotone-threshold form of the deterministic transfer.  It is convenient
on a probabilistic event that supplies a fixed upper bound `q` for the sample
second-moment deviation. -/
theorem makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation_le
    {m n : ℕ} (hm : 0 < m) (hn : 0 < n)
    (labels : Fin m → ℝ) (hlabels : ∀ i, labels i = -1 ∨ labels i = 1)
    (X : Fin m → Fin n → ℝ) (mean : Fin n → ℝ)
    (hmean : 0 < NumStability.vecNorm2 mean) (ε τ q : ℝ)
    (hτ : 0 < τ) (hq : 0 ≤ q)
    (hdeviation :
      NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
            populationSecondMoment mean) ≤ q)
    (hideal :
      (Set.ncard (idealMarginErrors labels mean X τ) : ℝ) ≤ ε * m / 2)
    (hbudget :
      (2 * Real.sqrt q) ^ 2 *
          ((n : ℝ) + NumStability.vecNorm2 mean ^ 2 + (n : ℝ) * q) ≤
        ε / 2 * τ ^ 2) :
    MakesAtMostErrorsUpToSign labels
      (fun j ↦
        NumStability.HDP.Vector.EuclideanSpectralClustering.leadingEigenvector
          hn X j) X (ε * m) := by
  let e : ℝ := NumStability.realMatrixOperatorNorm
    (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
      populationSecondMoment mean)
  have he : 0 ≤ e := norm_nonneg _
  have hsqrte : (Real.sqrt e) ^ 2 = e := Real.sq_sqrt he
  have hsqrtq : (Real.sqrt q) ^ 2 = q := Real.sq_sqrt hq
  have hen : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
  have hbase : 0 ≤ (n : ℝ) + NumStability.vecNorm2 mean ^ 2 := by positivity
  have heq : e ≤ q := by simpa [e] using hdeviation
  have he2 : e ^ 2 ≤ q ^ 2 := by nlinarith
  have hescale : (2 * Real.sqrt e) ^ 2 = 4 * e := by nlinarith
  have hqscale : (2 * Real.sqrt q) ^ 2 = 4 * q := by nlinarith
  apply makesAtMostErrorsUpToSign_leadingEigenvector_of_deviation
    hm hn labels hlabels X mean hmean ε τ hτ hideal
  rw [show NumStability.realMatrixOperatorNorm
      (NumStability.HDP.Vector.EuclideanSpectralClustering.sampleSecondMoment X -
        populationSecondMoment mean) = e by rfl,
    hescale]
  rw [hqscale] at hbudget
  nlinarith [mul_nonneg hen he, mul_nonneg hen hq]

end NumStability.HDP.Vector.GaussianMixture
