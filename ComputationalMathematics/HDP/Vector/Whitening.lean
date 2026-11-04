import ComputationalMathematics.HDP.Vector.CovarianceEstimation
import ComputationalMathematics.HDP.Vector.CovarianceEstimationBound
import ComputationalMathematics.HDP.Vector.IsotropyMarginals
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.MarginalVariance
import ComputationalMathematics.HDP.Vector.SubGaussianL2
import ComputationalMathematics.HDP.Vector.SubGaussianLaw
import Mathlib.Analysis.Matrix.Order
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# Whitening by raw second-moment factors

Canonical square-root whitening in the invertible case and rectangular effective-range transfer.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

namespace NumStability.HDP.Vector.Whitening

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

open NumStability.HDP.Scalar.SubGaussian

theorem integrable_sq_of_isSubGaussian
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {Y : Ω → ℝ} (hSG : IsSubGaussian μ Y) :
    Integrable (fun ω => Y ω ^ 2) μ := by
  have hFinite := (isSubGaussian_iff_psiTwoNorm_finite).mp hSG
  have hMom := psiTwoGaugeToLpMomentGrowth hSG.1 hFinite
  simpa only [Real.rpow_two, sq_abs] using (hMom.2 2 (by norm_num)).1

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem linearMarginal_mulVec
    {Ω : Type*} {n r : ℕ} (B : Matrix (Fin n) (Fin r) ℝ)
    (Z : Fin r → Ω → ℝ) (x : Fin n → ℝ) :
    linearMarginal (fun i ω => B.mulVec (fun j => Z j ω) i) x =
      linearMarginal Z (B.transpose.mulVec x) := by
  funext ω
  have h := NumStability.finiteVecInnerProduct_finiteMatVec_eq_transpose
    B x (fun j => Z j ω)
  simpa only [linearMarginal, NumStability.finiteMatVec,
    NumStability.finiteTranspose, Matrix.mulVec, Matrix.transpose_apply, dotProduct, mul_comm] using h

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem unit_marginal_eLpNorm_of_isotropy
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} {μ : Measure Ω}
    {X : Fin n → Ω → ℝ} (hLp : ∀ i, MemLp (X i) 2 μ)
    (hIso : Isotropy.IsIsotropic μ X) (u : SubGaussian.UnitDirection n) :
    eLpNorm (linearMarginal X u.1) 2 μ = 1 := by
  have hMarginal : MemLp (linearMarginal X u.1) 2 μ :=
    memLp_finset_sum Finset.univ (fun i _ ↦ (hLp i).mul_const (u.1 i))
  have hMoment : (∫ ω, linearMarginal X u.1 ω ^ 2 ∂μ) = 1 := by
    calc
      _ = ∑ i, u.1 i * u.1 i := by
        simpa only [pow_two] using
          Isotropy.integral_linearMarginal_mul_linearMarginal hLp hIso u.1 u.1
      _ = 1 := by
        simpa [NumStability.vecNorm2Sq, pow_two, u.2] using
          (NumStability.vecNorm2_sq u.1).symm
  rw [NumStability.HDP.Scalar.Preliminaries.eLpNorm_two_eq_ofReal_sqrt_integral_sq
    hMarginal, hMoment]
  norm_num

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem measurable_mulVec {m n : ℕ} (B : Matrix (Fin m) (Fin n) ℝ) :
    Measurable (fun x : Fin n → ℝ ↦ B.mulVec x) := by
  exact B.mulVecLin.toContinuousLinearMap.continuous.measurable

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem marginal_ae_eq_zero_of_raw_quadratic_zero
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) (hLp : ∀ j, MemLp (X j) 2 μ) (x : Fin n → ℝ)
    (hZero : (∑ i, ∑ j, x i * Covariance.secondMomentMatrix μ X i j * x j) = 0) :
    linearMarginal X x =ᵐ[μ] 0 := by
  have hMarg := Isotropy.marginal_memLp hLp x
  have hInt : Integrable (fun ω ↦ linearMarginal X x ω ^ 2) μ := by
    simpa only [linearMarginal, pow_two, Pi.mul_apply] using hMarg.integrable_mul hMarg
  have hIntegral : (∫ ω, linearMarginal X x ω ^ 2 ∂μ) = 0 := by
    change Isotropy.marginalSecondMoment μ X x = 0
    rw [Isotropy.marginalSecondMoment_eq_quadraticForm μ X
      (fun i j ↦ (hLp i).integrable_mul (hLp j)) x, hZero]
  have hSq := (integral_eq_zero_iff_of_nonneg (fun ω ↦ sq_nonneg _) hInt).mp hIntegral
  filter_upwards [hSq] with ω hω
  exact sq_eq_zero_iff.mp hω

theorem mulVec_ae_eq_zero_of_annihilates_raw_secondMoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (X : Fin n → Ω → ℝ) (hLp : ∀ j, MemLp (X j) 2 μ)
    (M : Matrix (Fin r) (Fin n) ℝ)
    (hAnnihilator : M * Covariance.secondMomentMatrix μ X = 0) :
    (fun ω ↦ M.mulVec (fun j ↦ X j ω)) =ᵐ[μ] 0 := by
  have hEach : ∀ i, linearMarginal X (M i) =ᵐ[μ] 0 := by
    intro i
    apply marginal_ae_eq_zero_of_raw_quadratic_zero X hLp
    have hRow : Matrix.vecMul (M i) (Covariance.secondMomentMatrix μ X) = 0 := by
      simpa only [Matrix.mul_apply_eq_vecMul, Pi.zero_apply] using congrFun hAnnihilator i
    calc
      (∑ j, ∑ k, M i j * Covariance.secondMomentMatrix μ X j k * M i k) =
          dotProduct (M i) ((Covariance.secondMomentMatrix μ X).mulVec (M i)) := by
        simp only [dotProduct, Matrix.mulVec, Finset.mul_sum, mul_assoc]
      _ = dotProduct (Matrix.vecMul (M i) (Covariance.secondMomentMatrix μ X)) (M i) :=
        Matrix.dotProduct_mulVec _ _ _
      _ = 0 := by rw [hRow]; simp
  have hAll : ∀ᵐ ω ∂μ, ∀ i, linearMarginal X (M i) ω = 0 := ae_all_iff.mpr hEach
  filter_upwards [hAll] with ω hω
  funext i
  simpa only [Matrix.mulVec, dotProduct, linearMarginal, mul_comm, Pi.zero_apply] using hω i

theorem projection_mulVec_ae_eq_self
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) (hLp : ∀ j, MemLp (X j) 2 μ)
    (P : Matrix (Fin n) (Fin n) ℝ)
    (hRange : (1 - P) * Covariance.secondMomentMatrix μ X = 0) :
    (fun ω ↦ P.mulVec (fun j ↦ X j ω)) =ᵐ[μ] (fun ω j ↦ X j ω) := by
  have hZero := mulVec_ae_eq_zero_of_annihilates_raw_secondMoment X hLp (1 - P) hRange
  filter_upwards [hZero] with ω hω
  rw [Matrix.sub_mulVec, Matrix.one_mulVec] at hω
  exact (sub_eq_zero.mp hω).symm

theorem factor_reconstruction_ae_of_raw_secondMoment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (X : Fin n → Ω → ℝ) (hLp : ∀ j, MemLp (X j) 2 μ)
    (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
    (hSecond : Covariance.secondMomentMatrix μ X = B * B.transpose)
    (hReproduce : B * P * B = B) :
    (fun ω j ↦ X j ω) =ᵐ[μ]
      (fun ω ↦ B.mulVec (P.mulVec (fun j ↦ X j ω))) := by
  have hRange : (1 - B * P) * Covariance.secondMomentMatrix μ X = 0 := by
    rw [hSecond, Matrix.sub_mul, Matrix.one_mul,
      ← Matrix.mul_assoc (B * P) B B.transpose, hReproduce, sub_self]
  have hSupport := projection_mulVec_ae_eq_self X hLp (B * P) hRange
  simpa only [Matrix.mulVec_mulVec] using hSupport.symm

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem memLp_mulVec
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (P : Matrix (Fin r) (Fin n) ℝ) (X : Fin n → Ω → ℝ)
    (hLp : ∀ j, MemLp (X j) 2 μ) (i : Fin r) :
    MemLp (fun ω ↦ P.mulVec (fun j ↦ X j ω) i) 2 μ := by
  simpa only [linearMarginal, Matrix.mulVec, dotProduct, mul_comm] using
    Isotropy.marginal_memLp hLp (P i)

theorem isIsotropic_of_raw_factor_left_inverse
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
    (X : Fin n → Ω → ℝ) (hLp : ∀ j, MemLp (X j) 2 μ)
    (hSecond : Covariance.secondMomentMatrix μ X = B * B.transpose)
    (hLeft : P * B = 1) :
    Isotropy.IsIsotropic μ (fun j ω ↦ P.mulVec (fun i ↦ X i ω) j) := by
  have hZLp := memLp_mulVec P X hLp
  apply (Isotropy.isIsotropic_iff_marginalSecondMoment μ _
    (fun i j ↦ (hZLp i).integrable_mul (hZLp j))).mpr
  intro u
  let v := P.transpose.mulVec u
  have hv : B.transpose.mulVec v = u := by
    dsimp [v]
    rw [Matrix.mulVec_mulVec, ← Matrix.transpose_mul, hLeft,
      Matrix.transpose_one, Matrix.one_mulVec]
  change (∫ ω, linearMarginal (fun j ω ↦ P.mulVec (fun i ↦ X i ω) j) u ω ^ 2 ∂μ) =
    ∑ i, u i ^ 2
  rw [NumStability.HDP.Vector.Whitening.linearMarginal_mulVec]
  change Isotropy.marginalSecondMoment μ X v = ∑ i, u i ^ 2
  rw [Isotropy.marginalSecondMoment_eq_quadraticForm μ X
    (fun i j ↦ (hLp i).integrable_mul (hLp j)) v, hSecond]
  calc
    (∑ i, ∑ j, v i * (B * B.transpose) i j * v j) =
        dotProduct v ((B * B.transpose).mulVec v) := by
      simp only [dotProduct, Matrix.mulVec, Finset.mul_sum, mul_assoc]
    _ = dotProduct (B.transpose.mulVec v) (B.transpose.mulVec v) := by
      rw [← Matrix.mulVec_mulVec, Matrix.dotProduct_mulVec, ← Matrix.mulVec_transpose]
    _ = ∑ i, u i ^ 2 := by
      rw [hv]
      simp only [dotProduct, pow_two]

theorem subGaussian_and_relative_bound_mulVec
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (P : Matrix (Fin r) (Fin n) ℝ) (X : Fin n → Ω → ℝ) (K : ℝ≥0)
    (hSG : SubGaussian.IsSubGaussian μ X)
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ X K) :
    SubGaussian.IsSubGaussian μ (fun j ω ↦ P.mulVec (fun i ↦ X i ω) j) ∧
      SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ P.mulVec (fun i ↦ X i ω) j) K := by
  constructor
  · intro u
    simpa only [NumStability.HDP.Vector.Whitening.linearMarginal_mulVec] using
      hSG (P.transpose.mulVec u)
  · intro u
    simpa only [NumStability.HDP.Vector.Whitening.linearMarginal_mulVec] using
      hRelative (P.transpose.mulVec u)

theorem reconstruction_of_identDistrib
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
    (X Y : Ω → Fin n → ℝ) (hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ)
    (hSecond : Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j) = B * B.transpose)
    (hLeft : P * B = 1) (hLaw : IdentDistrib Y X μ μ) :
    Y =ᵐ[μ] (fun ω ↦ B.mulVec (P.mulVec (Y ω))) := by
  have hYLp : ∀ j, MemLp (fun ω ↦ Y ω j) 2 μ := by
    intro j
    exact ((hLaw.comp (measurable_pi_apply j)).symm.memLp_snd (hLp j))
  have hYSecond : Covariance.secondMomentMatrix μ (fun j ω ↦ Y ω j) =
      Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j) := by
    ext i j
    exact (hLaw.comp ((measurable_pi_apply i).mul (measurable_pi_apply j))).integral_eq
  apply NumStability.HDP.Vector.Whitening.factor_reconstruction_ae_of_raw_secondMoment
    (fun j ω ↦ Y ω j) hYLp B P (hYSecond.trans hSecond)
  rw [Matrix.mul_assoc, hLeft, Matrix.mul_one]

theorem actual_rectangular_whitening
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ) (P : Matrix (Fin r) (Fin n) ℝ)
    (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ)
    (hSecond : Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j) = B * B.transpose)
    (hLeft : P * B = 1)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ X ω j) K)
    (hMeas : ∀ j, Measurable (fun ω ↦ X ω j))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ) (hIndep : iIndepFun Xsample μ) :
    let Z := fun ω ↦ P.mulVec (X ω)
    let Zsample := fun i ω ↦ P.mulVec (Xsample i ω)
    Isotropy.IsIsotropic μ (fun j ω ↦ Z ω j) ∧
      SubGaussian.IsSubGaussian μ (fun j ω ↦ Z ω j) ∧
      SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ Z ω j) K ∧
      SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤ (K : ℝ≥0∞) ∧
      (∀ i, IdentDistrib (Zsample i) Z μ μ) ∧
      iIndepFun Zsample μ ∧
      (∀ i, SubGaussian.PsiTwoNorm μ (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞)) ∧
      (X =ᵐ[μ] fun ω ↦ B.mulVec (Z ω)) ∧
      (∀ᵐ ω ∂μ, ∀ i, Xsample i ω = B.mulVec (Zsample i ω)) := by
  let Z := fun ω ↦ P.mulVec (X ω)
  let Zsample := fun i ω ↦ P.mulVec (Xsample i ω)
  have hIso := isIsotropic_of_raw_factor_left_inverse B P (fun j ω ↦ X ω j)
    hLp hSecond hLeft
  obtain ⟨hZSG, hZRelative⟩ := subGaussian_and_relative_bound_mulVec P
    (fun j ω ↦ X ω j) K hSG hRelative
  have hNorm : SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤ (K : ℝ≥0∞) :=
    SubGaussian.psiTwoNorm_le_of_unit_marginal_l2 hZRelative
      (NumStability.HDP.Vector.Whitening.unit_marginal_eLpNorm_of_isotropy
        (memLp_mulVec P (fun j ω ↦ X ω j) hLp) hIso)
  have hZMeas : ∀ j, Measurable (fun ω ↦ Z ω j) := fun j ↦
    (measurable_pi_apply j).comp
      ((NumStability.HDP.Vector.Whitening.measurable_mulVec P).comp
        (measurable_pi_iff.mpr hMeas))
  have hZSampleMeas : ∀ i j, Measurable (fun ω ↦ Zsample i ω j) := fun i j ↦
    (measurable_pi_apply j).comp
      ((NumStability.HDP.Vector.Whitening.measurable_mulVec P).comp
        (measurable_pi_iff.mpr (hSampleMeas i)))
  have hZLaw : ∀ i, IdentDistrib (Zsample i) Z μ μ := fun i ↦
    (hLaw i).comp (NumStability.HDP.Vector.Whitening.measurable_mulVec P)
  have hZIndep : iIndepFun Zsample μ :=
    hIndep.comp (fun _ ↦ fun x ↦ P.mulVec x)
      (fun _ ↦ NumStability.HDP.Vector.Whitening.measurable_mulVec P)
  have hZSampleNorm : ∀ i,
      SubGaussian.PsiTwoNorm μ (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞) := by
    intro i
    exact (SubGaussian.psiTwoNorm_eq_of_identDistrib
      (hZSampleMeas i) hZMeas (hZLaw i)).le.trans hNorm
  have hXReconstruct : X =ᵐ[μ] fun ω ↦ B.mulVec (Z ω) :=
    reconstruction_of_identDistrib B P X X hLp hSecond hLeft (IdentDistrib.refl (measurable_pi_iff.mpr hMeas).aemeasurable)
  have hSamples : ∀ i, Xsample i =ᵐ[μ] fun ω ↦ B.mulVec (Zsample i ω) :=
    fun i ↦ reconstruction_of_identDistrib B P X (Xsample i) hLp hSecond hLeft (hLaw i)
  exact ⟨hIso, hZSG, hZRelative, hNorm, hZLaw, hZIndep, hZSampleNorm,
    hXReconstruct, ae_all_iff.mpr hSamples⟩

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem coordinate_isSubGaussian
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ}
    {X : Fin n → Ω → ℝ} (hSG : SubGaussian.IsSubGaussian μ X) (i : Fin n) :
    NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ (X i) := by
  let e : Fin n → ℝ := Pi.single i 1
  have hmarg : linearMarginal X e = X i := by
    funext ω
    unfold linearMarginal e
    rw [Finset.sum_eq_single i]
    · simp
    · intro j _ hji
      simp [hji]
    · simp
  simpa only [hmarg] using hSG e

theorem coordinate_memLp_of_subGaussian
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {n : ℕ} {X : Fin n → Ω → ℝ} (hSG : SubGaussian.IsSubGaussian μ X) (i : Fin n) :
    MemLp (X i) 2 μ := by
  have hCoord := coordinate_isSubGaussian hSG i
  exact (memLp_two_iff_integrable_sq hCoord.1.aestronglyMeasurable).mpr
    (NumStability.HDP.Vector.Whitening.integrable_sq_of_isSubGaussian hCoord)

theorem positive_squareRoot_factor {n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef) :
    Sigma = CFC.sqrt Sigma * (CFC.sqrt Sigma).transpose ∧
      (IsUnit (CFC.sqrt Sigma) ↔ IsUnit Sigma) := by
  have hHerm := (CFC.sqrt_nonneg Sigma).posSemidef.isHermitian.eq
  have hTranspose : (CFC.sqrt Sigma).transpose = CFC.sqrt Sigma := by
    ext i j
    simpa only [Matrix.transpose_apply, Matrix.conjTranspose_apply, star_trivial] using
      congrFun (congrFun hHerm i) j
  refine ⟨?_, CFC.isUnit_sqrt_iff Sigma hPSD.nonneg⟩
  rw [hTranspose]
  exact (CFC.sqrt_mul_sqrt_self Sigma hPSD.nonneg).symm

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

open NumStability.HDP.Vector.Covariance

theorem sampleCovariance_eq_normalizedGram {m n : ℕ}
    (X : Matrix (Fin m) (Fin n) ℝ) :
    sampleCovariance X = (m : ℝ)⁻¹ • (X.transpose * X) := by
  ext a b
  simp only [sampleCovariance, Matrix.smul_apply, smul_eq_mul,
    Matrix.mul_apply, Matrix.transpose_apply]

theorem sampleCovariance_factor {m n r : ℕ}
    (B : Matrix (Fin n) (Fin r) ℝ) (Z : Matrix (Fin m) (Fin r) ℝ) :
    sampleCovariance (fun i ↦ B.mulVec (Z i)) =
      B * ((m : ℝ)⁻¹ • (Z.transpose * Z)) * B.transpose := by
  have hRows : (fun i ↦ B.mulVec (Z i)) = Z * B.transpose := by
    ext i j
    simp only [Matrix.mulVec, dotProduct, Matrix.mul_apply, Matrix.transpose_apply]
    apply Finset.sum_congr rfl
    intro k _
    exact mul_comm _ _
  rw [hRows, sampleCovariance_eq_normalizedGram]
  simp only [Matrix.transpose_mul, Matrix.transpose_transpose,
    Matrix.mul_assoc, Matrix.mul_smul, Matrix.smul_mul]

theorem canonical_squareRoot_sample_error_of_factor {m n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef)
    (X Z : Matrix (Fin m) (Fin n) ℝ)
    (hRows : ∀ i, X i = (CFC.sqrt Sigma).mulVec (Z i)) :
    let S := CFC.sqrt Sigma
    let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
    sampleCovariance X - Sigma = S * Rm * S ∧
      ‖NumStability.realMatrixContinuousLinearMap (sampleCovariance X - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap (S * Rm * S)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap (sampleCovariance X - Sigma)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap Rm‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  let S := CFC.sqrt Sigma
  let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
  have hTranspose : S.transpose = S := by
    have hHerm := (CFC.sqrt_nonneg Sigma).posSemidef.isHermitian.eq
    ext i j
    simpa only [Matrix.transpose_apply, Matrix.conjTranspose_apply, star_trivial] using
      congrFun (congrFun hHerm i) j
  have hSigma : Sigma = S * S.transpose :=
    (NumStability.HDP.Vector.Whitening.positive_squareRoot_factor Sigma hPSD).1
  have hEmpirical : sampleCovariance X = S * (1 + Rm) * S.transpose := by
    have hX : X = (fun i ↦ S.mulVec (Z i)) := funext hRows
    rw [hX, sampleCovariance_factor]
    have hCancel : 1 + Rm = (m : ℝ)⁻¹ • (Z.transpose * Z) := by
      dsimp [Rm]
      abel
    rw [hCancel]
  have hFactor := singularWhitening_error_factorization S Rm Sigma
    (sampleCovariance X) hSigma hEmpirical
  rw [hTranspose] at hFactor
  have hNorm := sampleCovariance_error_norm_le_covariance_mul_gram S Rm Sigma
    (sampleCovariance X) hSigma hEmpirical
  dsimp [NumStability.realMatrixOperatorNorm] at hNorm
  refine ⟨hFactor, congrArg (‖NumStability.realMatrixContinuousLinearMap ·‖) hFactor, ?_⟩
  simpa only [mul_comm] using hNorm

theorem canonical_inverse_whitened_sample_error {m n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef)
    (hUnit : IsUnit Sigma) (X : Matrix (Fin m) (Fin n) ℝ) :
    let S := CFC.sqrt Sigma
    let Z : Matrix (Fin m) (Fin n) ℝ := fun i ↦ S⁻¹.mulVec (X i)
    let Rm := (m : ℝ)⁻¹ • (Z.transpose * Z) - 1
    sampleCovariance X - Sigma = S * Rm * S ∧
      ‖NumStability.realMatrixContinuousLinearMap (sampleCovariance X - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap (S * Rm * S)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap (sampleCovariance X - Sigma)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap Rm‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  let S := CFC.sqrt Sigma
  have hS : IsUnit S := (CFC.isUnit_sqrt_iff Sigma hPSD.nonneg).mpr hUnit
  apply canonical_squareRoot_sample_error_of_factor Sigma hPSD X
    (fun i ↦ S⁻¹.mulVec (X i))
  intro i
  rw [Matrix.mulVec_mulVec,
    Matrix.mul_nonsing_inv S ((Matrix.isUnit_iff_isUnit_det S).mp hS), Matrix.one_mulVec]

end

section

open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix

open scoped ENNReal NNReal BigOperators MatrixOrder

open NumStability.HDP.Vector

theorem canonical_raw_population_sample_error
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hUnit : IsUnit (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j))) :
    let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
    let S := CFC.sqrt Sigma
    let Zsample : Fin m → Ω → Fin n → ℝ := fun i ω ↦ S⁻¹.mulVec (Xsample i ω)
    let A : Ω → Matrix (Fin m) (Fin n) ℝ := fun ω i ↦ Zsample i ω
    let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
    ∀ ω,
      Covariance.randomSampleCovariance Xsample ω - Sigma = S * Rm ω * S ∧
      ‖NumStability.realMatrixContinuousLinearMap
          (Covariance.randomSampleCovariance Xsample ω - Sigma)‖ =
        ‖NumStability.realMatrixContinuousLinearMap (S * Rm ω * S)‖ ∧
      ‖NumStability.realMatrixContinuousLinearMap
          (Covariance.randomSampleCovariance Xsample ω - Sigma)‖ ≤
        ‖NumStability.realMatrixContinuousLinearMap (Rm ω)‖ *
          ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hPSD : Sigma.PosSemidef := Covariance.secondMomentMatrix_posSemidef _ hLp
  dsimp only
  intro ω
  exact NumStability.HDP.Vector.Whitening.canonical_inverse_whitened_sample_error
    Sigma hPSD hUnit (fun i ↦ Xsample i ω)

theorem canonical_first_case_whitening
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ X ω j) K)
    (hUnit : IsUnit (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ) (hIndep : iIndepFun Xsample μ) :
    let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
    let S := CFC.sqrt Sigma
    let Z : Ω → Fin n → ℝ := fun ω ↦ S⁻¹.mulVec (X ω)
    let Zsample : Fin m → Ω → Fin n → ℝ := fun i ω ↦ S⁻¹.mulVec (Xsample i ω)
    let A : Ω → Matrix (Fin m) (Fin n) ℝ := fun ω i ↦ Zsample i ω
    let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
    Isotropy.IsIsotropic μ (fun j ω ↦ Z ω j) ∧
      SubGaussian.IsSubGaussian μ (fun j ω ↦ Z ω j) ∧
      SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ Z ω j) K ∧
      SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤ (K : ℝ≥0∞) ∧
      (∀ i, IdentDistrib (Zsample i) Z μ μ) ∧
      iIndepFun Zsample μ ∧
      (∀ i, SubGaussian.PsiTwoNorm μ (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞)) ∧
      (∀ ω, X ω = S.mulVec (Z ω)) ∧
      (∀ i ω, Xsample i ω = S.mulVec (Zsample i ω)) ∧
      (∀ ω,
        Covariance.randomSampleCovariance Xsample ω - Sigma = S * Rm ω * S ∧
        ‖NumStability.realMatrixContinuousLinearMap
            (Covariance.randomSampleCovariance Xsample ω - Sigma)‖ =
          ‖NumStability.realMatrixContinuousLinearMap (S * Rm ω * S)‖ ∧
        ‖NumStability.realMatrixContinuousLinearMap
            (Covariance.randomSampleCovariance Xsample ω - Sigma)‖ ≤
          ‖NumStability.realMatrixContinuousLinearMap (Rm ω)‖ *
            ‖NumStability.realMatrixContinuousLinearMap Sigma‖) := by
  let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
  let S := CFC.sqrt Sigma
  let Z : Ω → Fin n → ℝ := fun ω ↦ S⁻¹.mulVec (X ω)
  let Zsample : Fin m → Ω → Fin n → ℝ := fun i ω ↦ S⁻¹.mulVec (Xsample i ω)
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hPSD : Sigma.PosSemidef := Covariance.secondMomentMatrix_posSemidef _ hLp
  obtain ⟨hFactor, hInv⟩ :=
    NumStability.HDP.Vector.Whitening.positive_squareRoot_factor Sigma hPSD
  have hS : IsUnit S := hInv.mpr hUnit
  have hLeft : S⁻¹ * S = 1 :=
    Matrix.nonsing_inv_mul S ((Matrix.isUnit_iff_isUnit_det S).mp hS)
  have hMeas : ∀ j, Measurable (fun ω ↦ X ω j) := fun j ↦
    (NumStability.HDP.Vector.Whitening.coordinate_isSubGaussian hSG j).1
  obtain ⟨hIso, hZSG, hZRelative, hNorm, hZLaw, hZIndep, hSampleNorm, _hPopAE, _hSampleAE⟩ :=
    NumStability.HDP.Vector.Whitening.actual_rectangular_whitening
      S S⁻¹ X Xsample K hLp hFactor hLeft hSG hRelative hMeas hSampleMeas hLaw hIndep
  have hPop : ∀ ω, X ω = S.mulVec (Z ω) := by
    intro ω
    dsimp [Z]
    rw [Matrix.mulVec_mulVec,
      Matrix.mul_nonsing_inv S ((Matrix.isUnit_iff_isUnit_det S).mp hS), Matrix.one_mulVec]
  have hSamples : ∀ i ω, Xsample i ω = S.mulVec (Zsample i ω) := by
    intro i ω
    dsimp [Zsample]
    rw [Matrix.mulVec_mulVec,
      Matrix.mul_nonsing_inv S ((Matrix.isUnit_iff_isUnit_det S).mp hS), Matrix.one_mulVec]
  exact ⟨hIso, hZSG, hZRelative, hNorm, hZLaw, hZIndep, hSampleNorm, hPop, hSamples,
    canonical_raw_population_sample_error X Xsample hSG hUnit⟩

end

end NumStability.HDP.Vector.Whitening

end
