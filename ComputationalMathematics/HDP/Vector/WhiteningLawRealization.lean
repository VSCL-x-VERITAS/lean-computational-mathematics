import ComputationalMathematics.Algorithms.LinearSystems.Underdetermined.MinimumNorm.Pseudoinverse.SymmetricPartialInverse
import ComputationalMathematics.HDP.Vector.Whitening
import ComputationalMathematics.HDP.Vector.SubGaussianFinite
import Mathlib.MeasureTheory.Function.LpSeminorm.Prod
import Mathlib.MeasureTheory.Integral.Prod

/-!
# Whitening by a constructed population law

Independent Gaussian noise completes the missing raw-moment directions. The
realized population is defined by reconstruction, so factorization is pointwise;
its equality with the original population is needed only almost everywhere to
identify its law. No exact preservation of a sub-Gaussian constant is asserted.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped BigOperators ENNReal NNReal MatrixOrder

namespace NumStability.HDP.Vector.Whitening

/-- The raw second moment transforms by matrix congruence. -/
theorem secondMomentMatrix_mulVec
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (A : Matrix (Fin r) (Fin n) ℝ) (X : Fin n → Ω → ℝ)
    (hLp : ∀ j, MemLp (X j) 2 μ) :
    Covariance.secondMomentMatrix μ (fun i ω ↦ A.mulVec (fun j ↦ X j ω) i) =
      A * Covariance.secondMomentMatrix μ X * A.transpose := by
  ext i j
  have hInt (k l : Fin n) : Integrable
      (fun ω ↦ (A i k * A j l) * (X k ω * X l ω)) μ :=
    ((hLp k).integrable_mul (hLp l)).const_mul _
  change (∫ ω, A.mulVec (fun k ↦ X k ω) i * A.mulVec (fun k ↦ X k ω) j ∂μ) = _
  calc
    _ = ∫ ω, ∑ k, ∑ l, (A i k * A j l) * (X k ω * X l ω) ∂μ := by
      congr 1
      funext ω
      simp only [Matrix.mulVec, dotProduct]
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro k _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro l _
      ring
    _ = ∑ k, ∑ l, (A i k * A j l) * (∫ ω, X k ω * X l ω ∂μ) := by
      rw [integral_finset_sum Finset.univ (fun k _ ↦ integrable_finset_sum _ (fun l _ ↦ hInt k l))]
      apply Finset.sum_congr rfl
      intro k _
      rw [integral_finset_sum Finset.univ (fun l _ ↦ hInt k l)]
      simp only [integral_const_mul]
    _ = (A * Covariance.secondMomentMatrix μ X * A.transpose) i j := by
      simp only [Matrix.mul_apply, Matrix.transpose_apply, Covariance.secondMomentMatrix,
        Finset.sum_mul]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro k _
      apply Finset.sum_congr rfl
      intro l _
      ring

private theorem scalar_subGaussian_of_identDistrib
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {ν : Measure Ω'} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    {X : Ω → ℝ} {Y : Ω' → ℝ} (hX : Measurable X) (hY : Measurable Y)
    (hLaw : IdentDistrib X Y μ ν)
    (hSG : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian ν Y) :
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X := by
  apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mpr
  have hXLaw : HasLaw X (μ.map X) μ := ⟨hX.aemeasurable, rfl⟩
  rw [NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_sameLaw
    hX hY hXLaw (hLaw.hasLaw hXLaw)]
  exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hSG

private theorem scalar_subGaussian_add
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Ω → ℝ}
    (hX : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X)
    (hY : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ Y) :
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (fun ω ↦ X ω + Y ω) := by
  apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mpr
  exact lt_of_le_of_lt NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
    (ENNReal.add_lt_top.mpr
      ⟨NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hX,
       NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mp hY⟩)

/-- Raw moments of a sum on an independent product, with centered second factor.
The first factor need not be centered. -/
theorem secondMomentMatrix_independent_add
    {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {ν : Measure Ω'} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    {n : ℕ} (X : Fin n → Ω → ℝ) (Y : Fin n → Ω' → ℝ)
    (hXLp : ∀ i, MemLp (X i) 2 μ) (hYLp : ∀ i, MemLp (Y i) 2 ν)
    (hYMean : ∀ i, (∫ ω, Y i ω ∂ν) = 0) :
    Covariance.secondMomentMatrix (μ.prod ν) (fun i ω ↦ X i ω.1 + Y i ω.2) =
      Covariance.secondMomentMatrix μ X + Covariance.secondMomentMatrix ν Y := by
  have hX (i : Fin n) := (hXLp i).comp_fst ν
  have hY (i : Fin n) := (hYLp i).comp_snd μ
  ext i j
  change (∫ ω, (X i ω.1 + Y i ω.2) * (X j ω.1 + Y j ω.2) ∂μ.prod ν) = _
  simp_rw [add_mul, mul_add]
  have hXXInt : Integrable (fun ω : Ω × Ω' ↦ X i ω.1 * X j ω.1) (μ.prod ν) :=
    (hX i).integrable_mul (hX j)
  have hXYInt : Integrable (fun ω : Ω × Ω' ↦ X i ω.1 * Y j ω.2) (μ.prod ν) :=
    (hX i).integrable_mul (hY j)
  have hYXInt : Integrable (fun ω : Ω × Ω' ↦ Y i ω.2 * X j ω.1) (μ.prod ν) :=
    (hY i).integrable_mul (hX j)
  have hYYInt : Integrable (fun ω : Ω × Ω' ↦ Y i ω.2 * Y j ω.2) (μ.prod ν) :=
    (hY i).integrable_mul (hY j)
  rw [integral_add
      (f := fun ω : Ω × Ω' ↦ X i ω.1 * X j ω.1 + X i ω.1 * Y j ω.2)
      (g := fun ω : Ω × Ω' ↦ Y i ω.2 * X j ω.1 + Y i ω.2 * Y j ω.2)
      (hXXInt.add hXYInt) (hYXInt.add hYYInt),
    integral_add hXXInt hXYInt, integral_add hYXInt hYYInt]
  have hXX := (measurePreserving_fst (μ := μ) (ν := ν)).hasLaw.integral_comp
    ((hXLp i).integrable_mul (hXLp j)).aestronglyMeasurable
  have hYY := (measurePreserving_snd (μ := μ) (ν := ν)).hasLaw.integral_comp
    ((hYLp i).integrable_mul (hYLp j)).aestronglyMeasurable
  have hYX : (∫ ω, Y i ω.2 * X j ω.1 ∂μ.prod ν) = 0 := by
    simp_rw [mul_comm (Y i _)]
    rw [integral_prod_mul, hYMean, mul_zero]
  rw [integral_prod_mul, hYMean, mul_zero, hYX]
  simpa only [Function.comp_def, Covariance.secondMomentMatrix, Matrix.add_apply,
    add_zero, zero_add] using congrArg₂ (· + ·) hXX hYY

/-- The explicit product law used for one reconstructed population. -/
def lawWhiteningMeasure {n : ℕ} (ν : Measure (Fin n → ℝ)) :
    Measure ((Fin n → ℝ) × (Fin n → ℝ)) :=
  ν.prod (NumStability.standardGaussianVectorMeasure n)

instance {n : ℕ} (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν] :
    IsProbabilityMeasure (lawWhiteningMeasure ν) := by
  unfold lawWhiteningMeasure
  infer_instance

/-- Partial inverse of the population plus independent complementary noise. -/
def lawWhitenedVector {n : ℕ} (T Q : Matrix (Fin n) (Fin n) ℝ)
    (ω : (Fin n → ℝ) × (Fin n → ℝ)) : Fin n → ℝ :=
  T.mulVec ω.1 + Q.mulVec ω.2

/-- The chosen population is defined by exact reconstruction. -/
def lawRealizedVector {n : ℕ} (S T Q : Matrix (Fin n) (Fin n) ℝ)
    (ω : (Fin n → ℝ) × (Fin n → ℝ)) : Fin n → ℝ :=
  S.mulVec (lawWhitenedVector T Q ω)

/-- Both coordinates have their specified laws and are independent. -/
theorem lawWhiteningMeasure_coordinates {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν] :
    HasLaw Prod.fst ν (lawWhiteningMeasure ν) ∧
      HasLaw Prod.snd (NumStability.standardGaussianVectorMeasure n) (lawWhiteningMeasure ν) ∧
      IndepFun Prod.fst Prod.snd (lawWhiteningMeasure ν) := by
  exact ⟨measurePreserving_fst.hasLaw, measurePreserving_snd.hasLaw,
    indepFun_prod measurable_id measurable_id⟩

/-- Reconstruction is pointwise, including at population null-set values. -/
theorem lawRealizedVector_eq_projection {n : ℕ}
    (S T P Q : Matrix (Fin n) (Fin n) ℝ) (h : SymmetricPartialInverseData S T P Q)
    (ω : (Fin n → ℝ) × (Fin n → ℝ)) :
    lawRealizedVector S T Q ω = P.mulVec ω.1 := by
  simp only [lawRealizedVector, lawWhitenedVector, Matrix.mulVec_add,
    Matrix.mulVec_mulVec, h.mul_inverse, h.mul_complement, Matrix.zero_mulVec, add_zero]

/-- The constructed population has the original law. A raw-moment annihilator
only supplies an AE projection identity, which is sufficient for law equality. -/
theorem lawRealizedVector_hasLaw {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (S T P Q : Matrix (Fin n) (Fin n) ℝ) (h : SymmetricPartialInverseData S T P Q)
    (hLp : ∀ i, MemLp (fun y : Fin n → ℝ ↦ y i) 2 ν)
    (hSecond : Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i) = S * S) :
    HasLaw (lawRealizedVector S T Q) ν (lawWhiteningMeasure ν) := by
  have hRange : (1 - P) * Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i) = 0 := by
    rw [← h.complement_eq, hSecond, ← Matrix.mul_assoc, h.complement_mul, zero_mul]
  have hAE := projection_mulVec_ae_eq_self (fun i (y : Fin n → ℝ) ↦ y i) hLp P hRange
  apply (lawWhiteningMeasure_coordinates ν).1.congr
  have hLift := (measurePreserving_fst (μ := ν)
    (ν := NumStability.standardGaussianVectorMeasure n)).quasiMeasurePreserving.ae hAE
  filter_upwards [hLift] with ω hω
  exact (lawRealizedVector_eq_projection S T P Q h ω).trans hω

/-- The Gaussian-completed vector is measurable and square-integrable. -/
theorem lawWhitenedVector_measurable_memLp {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (T Q : Matrix (Fin n) (Fin n) ℝ)
    (hLp : ∀ i, MemLp (fun y : Fin n → ℝ ↦ y i) 2 ν) :
    Measurable (lawWhitenedVector T Q) ∧
      ∀ i, MemLp (fun ω ↦ lawWhitenedVector T Q ω i) 2 (lawWhiteningMeasure ν) := by
  refine ⟨((measurable_mulVec T).comp measurable_fst).add
    ((measurable_mulVec Q).comp measurable_snd), ?_⟩
  intro i
  exact ((memLp_mulVec T (fun j (y : Fin n → ℝ) ↦ y j) hLp i).comp_fst _).add
    ((memLp_mulVec Q (fun j (g : Fin n → ℝ) ↦ g j)
      (NumStability.standardGaussianVectorCoordinate_memLp_two n) i).comp_snd _)

/-- Independent standard noise fills precisely the missing raw-moment range.
There is no mean-zero assumption on the original population. -/
theorem lawWhitenedVector_isIsotropic {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (S T P Q : Matrix (Fin n) (Fin n) ℝ) (h : SymmetricPartialInverseData S T P Q)
    (hLp : ∀ i, MemLp (fun y : Fin n → ℝ ↦ y i) 2 ν)
    (hSecond : Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i) = S * S) :
    Isotropy.IsIsotropic (lawWhiteningMeasure ν)
      (fun i ω ↦ lawWhitenedVector T Q ω i) := by
  have hGLp := NumStability.standardGaussianVectorCoordinate_memLp_two n
  have hGMean (i : Fin n) :
      (∫ g, Q.mulVec g i ∂NumStability.standardGaussianVectorMeasure n) = 0 := by
    simp only [Matrix.mulVec, dotProduct]
    rw [integral_finset_sum Finset.univ (fun j _ ↦ (hGLp j).integrable (by norm_num) |>.const_mul _)]
    simp_rw [integral_const_mul,
      (NumStability.standardGaussianVectorCoordinate_hasLaw n _).integral_eq,
      integral_id_gaussianReal]
    simp
  have hGSecond : Covariance.secondMomentMatrix
      (NumStability.standardGaussianVectorMeasure n) (fun i (g : Fin n → ℝ) ↦ g i) = 1 :=
    Gaussian.isIsotropic_of_isStandardNormal HasLaw.id
  change Covariance.secondMomentMatrix (ν.prod (NumStability.standardGaussianVectorMeasure n))
    (fun i ω ↦ T.mulVec ω.1 i + Q.mulVec ω.2 i) = 1
  rw [secondMomentMatrix_independent_add _ _
      (memLp_mulVec T (fun j (y : Fin n → ℝ) ↦ y j) hLp)
      (memLp_mulVec Q (fun j (g : Fin n → ℝ) ↦ g j) hGLp) hGMean,
    secondMomentMatrix_mulVec T _ hLp, secondMomentMatrix_mulVec Q _ hGLp, hSecond, hGSecond,
    Matrix.mul_one, h.inverse_covariance, h.covariance_completion]

/-- The completion has qualitative finite-vector sub-Gaussianity. This statement
makes no assertion about retaining an exact constant from the original law. -/
theorem lawWhitenedVector_isSubGaussian {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (T Q : Matrix (Fin n) (Fin n) ℝ)
    (hSG : ∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian ν
      (fun y : Fin n → ℝ ↦ y i)) :
    SubGaussian.IsSubGaussian (lawWhiteningMeasure ν)
      (fun i ω ↦ lawWhitenedVector T Q ω i) := by
  have hY : SubGaussian.IsSubGaussian (lawWhiteningMeasure ν) (fun i ω ↦ ω.1 i) := by
    apply SubGaussian.coordinates_vectorSubGaussian
    intro i
    apply scalar_subGaussian_of_identDistrib (by fun_prop) (measurable_pi_apply i)
      (((lawWhiteningMeasure_coordinates ν).1.identDistrib HasLaw.id).comp
        (measurable_pi_apply i)) (hSG i)
  have hG : SubGaussian.IsSubGaussian (lawWhiteningMeasure ν) (fun i ω ↦ ω.2 i) := by
    apply SubGaussian.coordinates_vectorSubGaussian
    intro i
    apply NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite.mpr
    have hLaw := (NumStability.standardGaussianVectorCoordinate_hasLaw n i).fun_comp
      (lawWhiteningMeasure_coordinates ν).2.1
    rw [NumStability.HDP.Scalar.SubGaussian.psiTwoNorm_eq_of_hasLaw (by fun_prop) hLaw]
    exact NumStability.HDP.Scalar.SubGaussian.gaussianPsiTwoGauge_finite.1
  intro u
  have hT := hY (T.transpose.mulVec u)
  have hQ := hG (Q.transpose.mulVec u)
  have hSum := scalar_subGaussian_add hT hQ
  have hMarginal : linearMarginal (fun i ω ↦ lawWhitenedVector T Q ω i) u =
      fun ω ↦ linearMarginal (fun i ω ↦ ω.1 i) (T.transpose.mulVec u) ω +
        linearMarginal (fun i ω ↦ ω.2 i) (Q.transpose.mulVec u) ω := by
    have hSplit : linearMarginal (fun i ω ↦ lawWhitenedVector T Q ω i) u =
        fun ω ↦ linearMarginal (fun i ω ↦ T.mulVec ω.1 i) u ω +
          linearMarginal (fun i ω ↦ Q.mulVec ω.2 i) u ω := by
      funext ω
      simp [linearMarginal, lawWhitenedVector, add_mul, Finset.sum_add_distrib]
    rw [hSplit, linearMarginal_mulVec, linearMarginal_mulVec]
  simpa only [hMarginal] using hSum

/-- The reconstructed population is also measurable and coordinatewise L². -/
theorem lawRealizedVector_measurable_memLp {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (S T Q : Matrix (Fin n) (Fin n) ℝ)
    (hLp : ∀ i, MemLp (fun y : Fin n → ℝ ↦ y i) 2 ν) :
    Measurable (lawRealizedVector S T Q) ∧
      ∀ i, MemLp (fun ω ↦ lawRealizedVector S T Q ω i) 2 (lawWhiteningMeasure ν) := by
  obtain ⟨hZMeas, hZLp⟩ := lawWhitenedVector_measurable_memLp ν T Q hLp
  exact ⟨(measurable_mulVec S).comp hZMeas,
    memLp_mulVec S (fun i ω ↦ lawWhitenedVector T Q ω i) hZLp⟩

/-- Every finite sub-Gaussian population law admits a principal-root constructed
realization with raw-isotropic finite-sub-Gaussian whitening. Singular and zero
raw second moments are included. Population and noise are chosen together on the
explicit product law; an arbitrary supplied population representative is not
required to satisfy pointwise reconstruction. -/
theorem exists_principal_lawWhitening_realization {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (hSG : ∀ i, NumStability.HDP.Scalar.SubGaussian.IsSubGaussian ν
      (fun y : Fin n → ℝ ↦ y i)) :
    let S := CFC.sqrt (Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i))
    ∃ T P Q : Matrix (Fin n) (Fin n) ℝ,
      SymmetricPartialInverseData S T P Q ∧
      Measurable (lawWhitenedVector T Q) ∧
      (∀ i, MemLp (fun ω ↦ lawWhitenedVector T Q ω i) 2 (lawWhiteningMeasure ν)) ∧
      Measurable (lawRealizedVector S T Q) ∧
      (∀ i, MemLp (fun ω ↦ lawRealizedVector S T Q ω i) 2 (lawWhiteningMeasure ν)) ∧
      Isotropy.IsIsotropic (lawWhiteningMeasure ν) (fun i ω ↦ lawWhitenedVector T Q ω i) ∧
      SubGaussian.IsSubGaussian (lawWhiteningMeasure ν) (fun i ω ↦ lawWhitenedVector T Q ω i) ∧
      HasLaw (lawRealizedVector S T Q) ν (lawWhiteningMeasure ν) ∧
      (∀ ω, lawRealizedVector S T Q ω = S.mulVec (lawWhitenedVector T Q ω)) ∧
      (∀ ω, lawRealizedVector S T Q ω = P.mulVec ω.1) := by
  let Sigma := Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i)
  let S := CFC.sqrt Sigma
  have hLp := coordinate_memLp_of_subGaussian (SubGaussian.coordinates_vectorSubGaussian hSG)
  have hPSD : Sigma.PosSemidef := Covariance.secondMomentMatrix_posSemidef _ hLp
  have hSPSD : S.PosSemidef := (CFC.sqrt_nonneg Sigma).posSemidef
  obtain ⟨T, P, Q, hData⟩ := exists_symmetricPartialInverseData_of_posSemidef S hSPSD
  have hSecond : Sigma = S * S := (CFC.sqrt_mul_sqrt_self Sigma hPSD.nonneg).symm
  obtain ⟨hZMeas, hZLp⟩ := lawWhitenedVector_measurable_memLp ν T Q hLp
  obtain ⟨hFMeas, hFLp⟩ := lawRealizedVector_measurable_memLp ν S T Q hLp
  exact ⟨T, P, Q, hData, hZMeas, hZLp, hFMeas, hFLp,
    lawWhitenedVector_isIsotropic ν S T P Q hData hLp hSecond,
    lawWhitenedVector_isSubGaussian ν T Q hSG,
    lawRealizedVector_hasLaw ν S T P Q hData hLp hSecond, fun _ ↦ rfl,
    lawRealizedVector_eq_projection S T P Q hData⟩

/-- Finite independent copies of the entire constructed pair can be chosen
jointly, including a separate index for the population. This preserves the
pointwise factorization, the original population law, and the whitening law.
The independence assertion concerns pairs, hence also either projected family. -/
theorem lawWhitening_independent_copies {ι : Type*} [Fintype ι] {n : ℕ}
    (ν : Measure (Fin n → ℝ)) [IsProbabilityMeasure ν]
    (S T P Q : Matrix (Fin n) (Fin n) ℝ) (h : SymmetricPartialInverseData S T P Q)
    (hLp : ∀ i, MemLp (fun y : Fin n → ℝ ↦ y i) 2 ν)
    (hSecond : Covariance.secondMomentMatrix ν (fun i (y : Fin n → ℝ) ↦ y i) = S * S) :
    let μ := lawWhiteningMeasure ν
    let π := Measure.pi (fun _ : ι ↦ μ)
    (∀ i : ι, HasLaw (fun ω ↦ lawRealizedVector S T Q (ω i)) ν π) ∧
      (∀ i : ι, IdentDistrib (fun ω ↦ lawWhitenedVector T Q (ω i))
        (lawWhitenedVector T Q) π μ) ∧
      iIndepFun (fun i (ω : ι → (Fin n → ℝ) × (Fin n → ℝ)) ↦
        (lawRealizedVector S T Q (ω i), lawWhitenedVector T Q (ω i))) π ∧
      (∀ i (ω : ι → (Fin n → ℝ) × (Fin n → ℝ)),
        lawRealizedVector S T Q (ω i) = S.mulVec (lawWhitenedVector T Q (ω i))) := by
  have hZMeas := (lawWhitenedVector_measurable_memLp ν T Q hLp).1
  have hFMeas := (lawRealizedVector_measurable_memLp ν S T Q hLp).1
  have hZLaw : HasLaw (lawWhitenedVector T Q)
      ((lawWhiteningMeasure ν).map (lawWhitenedVector T Q)) (lawWhiteningMeasure ν) :=
    ⟨hZMeas.aemeasurable, rfl⟩
  have hEval (i : ι) : HasLaw (fun ω : ι → (Fin n → ℝ) × (Fin n → ℝ) ↦ ω i)
      (lawWhiteningMeasure ν) (Measure.pi (fun _ : ι ↦ lawWhiteningMeasure ν)) :=
    (measurePreserving_eval (μ := fun _ : ι ↦ lawWhiteningMeasure ν) i).hasLaw
  refine ⟨fun i ↦ (lawRealizedVector_hasLaw ν S T P Q h hLp hSecond).fun_comp (hEval i),
    fun i ↦ (hZLaw.fun_comp (hEval i)).identDistrib hZLaw, ?_, fun _ _ ↦ rfl⟩
  exact iIndepFun_pi (fun _ ↦ (hFMeas.prodMk hZMeas).aemeasurable)

end NumStability.HDP.Vector.Whitening
