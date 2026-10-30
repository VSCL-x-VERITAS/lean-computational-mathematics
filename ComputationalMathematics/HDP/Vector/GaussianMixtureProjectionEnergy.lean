import ComputationalMathematics.HDP.Vector.GaussianMixtureSpectral
import ComputationalMathematics.Analysis.SingularValues.CourantFischer

/-! Ordinary directional-energy foundations; no source convention is selected. -/
noncomputable section
open Matrix
open scoped BigOperators RealInnerProductSpace

namespace NumStability.HDP.Vector.GaussianMixture

/-- Empirical projection energy is the sample size times the empirical Rayleigh form. -/
theorem sum_dotProduct_sq_eq_card_mul_sampleSecondMoment_rayleigh
    {m n : ℕ} (hm : 0 < m) (X : Fin m → Fin n → ℝ) (d : Fin n → ℝ) :
    (∑ i, dotProduct d (X i) ^ 2) = (m : ℝ) *
      NumStability.matrixRayleighForm
        (EuclideanSpectralClustering.sampleSecondMoment X)
        (WithLp.toLp 2 d : EuclideanSpace ℝ (Fin n)) := by
  let x : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 d
  let G := NumStability.rectCourantFischerRightGram X
  have haction : (EuclideanSpectralClustering.sampleSecondMoment X).toEuclideanLin x =
      (m : ℝ)⁻¹ • G.toEuclideanLin x := by
    ext j
    change (∑ k, ((m : ℝ)⁻¹ * G j k) * d k) =
      (m : ℝ)⁻¹ * ∑ k, G j k * d k
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _
    ring
  have hray : NumStability.matrixRayleighForm
      (EuclideanSpectralClustering.sampleSecondMoment X) x =
      (m : ℝ)⁻¹ * NumStability.matrixRayleighForm G x := by
    rw [NumStability.matrixRayleighForm, haction, real_inner_smul_right]
    rfl
  have hnorm : ‖Matrix.toEuclideanLin X x‖ ^ 2 = ∑ i, dotProduct d (X i) ^ 2 := by
    rw [EuclideanSpace.norm_sq_eq]
    apply Finset.sum_congr rfl
    intro i _
    simp [Matrix.toLpLin_apply, Matrix.mulVec, x, dotProduct, mul_comm]
  rw [show (WithLp.toLp 2 d : EuclideanSpace ℝ (Fin n)) = x by rfl,
    hray, show G = NumStability.rectCourantFischerRightGram X by rfl,
    NumStability.matrixRayleighForm_rectRightGram_eq_norm_sq, hnorm]
  have hmR : (m : ℝ) ≠ 0 := by exact_mod_cast hm.ne'
  rw [← mul_assoc, mul_inv_cancel₀ hmR, one_mul]

/-- A fixed projection has an energy bound with no ambient-dimension factor. -/
theorem sum_dotProduct_sq_le_of_sampleSecondMoment_deviation
    {m n : ℕ} (hm : 0 < m) (X : Fin m → Fin n → ℝ)
    (mean d : Fin n → ℝ) :
    (∑ i, dotProduct d (X i) ^ 2) ≤
      (m : ℝ) * (1 + NumStability.vecNorm2 mean ^ 2 +
        NumStability.realMatrixOperatorNorm
          (EuclideanSpectralClustering.sampleSecondMoment X - populationSecondMoment mean)) *
        NumStability.vecNorm2 d ^ 2 := by
  let x : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 d
  let T := EuclideanSpectralClustering.sampleSecondMoment X
  let S := populationSecondMoment mean
  let e := NumStability.realMatrixOperatorNorm (T - S)
  have hpert : |NumStability.matrixRayleighForm (T - S) x| ≤ e * ‖x‖ ^ 2 := by
    calc
      _ ≤ ‖x‖ * ‖Matrix.toEuclideanLin (T - S) x‖ := abs_real_inner_le_norm _ _
      _ ≤ ‖x‖ * (e * ‖x‖) := by
        apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
        exact ContinuousLinearMap.le_opNorm (NumStability.realMatrixContinuousLinearMap (T - S)) x
      _ = _ := by ring
  have hsub : NumStability.matrixRayleighForm (T - S) x =
      NumStability.matrixRayleighForm T x - NumStability.matrixRayleighForm S x := by
    simp [NumStability.matrixRayleighForm, Matrix.toLpLin_apply, inner_sub_right]
  have hdot : (dotProduct mean x) ^ 2 ≤ NumStability.vecNorm2 mean ^ 2 * ‖x‖ ^ 2 := by
    have h := abs_real_inner_le_norm
      (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) x
    have heq : inner ℝ (WithLp.toLp 2 mean : EuclideanSpace ℝ (Fin n)) x =
        dotProduct mean x := by
      simp [PiLp.inner_apply, real_inner_eq_re_inner, RCLike.inner_apply, dotProduct, mul_comm]
    rw [heq, Spherical.norm_toLp_eq_vecNorm2] at h
    have ha := abs_nonneg (dotProduct mean x)
    have hb : 0 ≤ NumStability.vecNorm2 mean * ‖x‖ :=
      mul_nonneg (NumStability.vecNorm2_nonneg mean) (norm_nonneg x)
    have hsq : |dotProduct mean x| ^ 2 = (dotProduct mean x) ^ 2 := sq_abs _
    nlinarith
  have hray : NumStability.matrixRayleighForm T x ≤
      (1 + NumStability.vecNorm2 mean ^ 2 + e) * ‖x‖ ^ 2 := by
    rw [hsub] at hpert
    have hpop := populationSecondMoment_rayleigh mean x
    change NumStability.matrixRayleighForm S x = _ at hpop
    nlinarith [le_abs_self (NumStability.matrixRayleighForm T x - NumStability.matrixRayleighForm S x)]
  rw [sum_dotProduct_sq_eq_card_mul_sampleSecondMoment_rayleigh hm X d]
  have hnorm : ‖x‖ = NumStability.vecNorm2 d := Spherical.norm_toLp_eq_vecNorm2 d
  have hscaled := mul_le_mul_of_nonneg_left hray (Nat.cast_nonneg m)
  simpa only [hnorm, x, T, S, e, mul_assoc] using hscaled

end NumStability.HDP.Vector.GaussianMixture
