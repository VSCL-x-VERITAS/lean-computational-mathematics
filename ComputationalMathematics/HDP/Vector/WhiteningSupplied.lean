import ComputationalMathematics.HDP.Vector.Whitening

/-!
# Supplied witnesses for square-root whitening

Transport canonical inverse-whitening norm bounds to supplied witnesses with
almost-sure factorization relations, and lift the pointwise empirical error
identity and norm bound to their shared full-measure set.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder

namespace NumStability.HDP.Vector.Whitening

/-- Existing canonical norm bounds transport to supplied witnesses with AE
square-root factorizations. Independence retains the population member. -/
theorem supplied_first_case_whitening_norms_of_ae_factorization
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X Z : Ω → Fin n → ℝ)
    (Xsample Zsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hSG : NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K)
    (hUnit : IsUnit (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j)))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hZMeas : ∀ j, Measurable (fun ω ↦ Z ω j))
    (hZSampleMeas : ∀ i j, Measurable (fun ω ↦ Zsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hIndep : iIndepFun (fun o : Option (Fin m) ↦
      (match o with | none => Z | some i => Zsample i : Ω → Fin n → ℝ)) μ)
    (hPop : X =ᵐ[μ] (fun ω ↦
      (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
        (fun j ω ↦ X ω j) : Matrix (Fin n) (Fin n) ℝ)).mulVec (Z ω)))
    (hSamples : ∀ i, Xsample i =ᵐ[μ] (fun ω ↦
      (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
        (fun j ω ↦ X ω j) : Matrix (Fin n) (Fin n) ℝ)).mulVec (Zsample i ω))) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ Z ω j) ≤
        (K : ℝ≥0∞) ∧
      ∀ i, NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
        (fun j ω ↦ Zsample i ω j) ≤ (K : ℝ≥0∞) := by
  let Sigma := NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
    (fun j ω ↦ X ω j)
  let S := CFC.sqrt Sigma
  have hIndepImages := hIndep.comp (fun _ z ↦ S.mulVec z)
    (fun _ ↦ NumStability.HDP.Vector.Whitening.measurable_mulVec S)
  have hFamilyEq : ∀ o : Option (Fin m),
      (fun ω ↦ S.mulVec ((match o with | none => Z | some i => Zsample i) ω)) =ᵐ[μ]
        (match o with | none => X | some i => Xsample i) := by
    intro o
    cases o with
    | none => exact hPop.symm
    | some i => exact (hSamples i).symm
  have hIndepX : iIndepFun (fun o : Option (Fin m) ↦
      match o with | none => X | some i => Xsample i) μ :=
    hIndepImages.congr hFamilyEq
  have hIndepSamples : iIndepFun Xsample μ :=
    iIndepFun.precomp (g := Option.some) (fun _ _ h ↦ Option.some.inj h) hIndepX
  obtain ⟨_, _, _, hCanonicalNorm, _, _, hCanonicalSampleNorm, _, _, _⟩ :=
    NumStability.HDP.Vector.Whitening.canonical_first_case_whitening
      X Xsample K hSG hRelative hUnit hSampleMeas hLaw hIndepSamples
  have hLp := NumStability.HDP.Vector.Whitening.coordinate_memLp_of_subGaussian hSG
  have hPSD : Sigma.PosSemidef :=
    NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef _ hLp
  have hS : IsUnit S :=
    (NumStability.HDP.Vector.Whitening.positive_squareRoot_factor Sigma hPSD).2.mpr hUnit
  have hDet : IsUnit S.det := (Matrix.isUnit_iff_isUnit_det S).mp hS
  have hXMeas : Measurable X := measurable_pi_iff.mpr (fun j ↦
    (NumStability.HDP.Vector.Whitening.coordinate_isSubGaussian hSG j).1)
  have hCanonicalMeas : ∀ j, Measurable (fun ω ↦ S⁻¹.mulVec (X ω) j) :=
    fun j ↦ (measurable_pi_apply j).comp
      ((NumStability.HDP.Vector.Whitening.measurable_mulVec S⁻¹).comp hXMeas)
  have hCanonicalSampleMeas : ∀ i j,
      Measurable (fun ω ↦ S⁻¹.mulVec (Xsample i ω) j) :=
    fun i j ↦ (measurable_pi_apply j).comp
      ((NumStability.HDP.Vector.Whitening.measurable_mulVec S⁻¹).comp
        (measurable_pi_iff.mpr (hSampleMeas i)))
  have hZEq : Z =ᵐ[μ] (fun ω ↦ S⁻¹.mulVec (X ω)) := by
    filter_upwards [hPop] with ω hω
    rw [hω, Matrix.mulVec_mulVec, Matrix.nonsing_inv_mul S hDet, Matrix.one_mulVec]
  have hZSampleEq : ∀ i, Zsample i =ᵐ[μ] (fun ω ↦ S⁻¹.mulVec (Xsample i ω)) := by
    intro i
    filter_upwards [hSamples i] with ω hω
    rw [hω, Matrix.mulVec_mulVec, Matrix.nonsing_inv_mul S hDet, Matrix.one_mulVec]
  constructor
  · exact (NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_identDistrib
      hZMeas hCanonicalMeas (IdentDistrib.of_ae_eq
        (measurable_pi_iff.mpr hZMeas).aemeasurable hZEq)).le.trans hCanonicalNorm
  · intro i
    exact (NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_identDistrib
      (hZSampleMeas i) (hCanonicalSampleMeas i) (IdentDistrib.of_ae_eq
        (measurable_pi_iff.mpr (hZSampleMeas i)).aemeasurable (hZSampleEq i))).le.trans
          (hCanonicalSampleNorm i)


/-- The existing pointwise square-root empirical error result holds on the
shared full-measure set for supplied rows with AE factorization relations. -/
theorem supplied_squareRoot_sample_error_of_ae_rows
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hPSD : Sigma.PosSemidef)
    (Xsample Zsample : Fin m → Ω → Fin n → ℝ)
    (hRows : ∀ i, Xsample i =ᵐ[μ]
      (fun ω ↦ (CFC.sqrt Sigma).mulVec (Zsample i ω))) :
    let S := CFC.sqrt Sigma
    let A : Ω → Matrix (Fin m) (Fin n) ℝ := fun ω i ↦ Zsample i ω
    let Rm := fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
    ∀ᵐ ω ∂μ,
      NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma =
          S * Rm ω * S ∧
        ‖NumStability.realMatrixContinuousLinearMap
            (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ =
          ‖NumStability.realMatrixContinuousLinearMap (S * Rm ω * S)‖ ∧
        ‖NumStability.realMatrixContinuousLinearMap
            (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ ≤
          ‖NumStability.realMatrixContinuousLinearMap (Rm ω)‖ *
            ‖NumStability.realMatrixContinuousLinearMap Sigma‖ := by
  dsimp only
  filter_upwards [ae_all_iff.mpr hRows] with ω hω
  exact NumStability.HDP.Vector.Whitening.canonical_squareRoot_sample_error_of_factor
    Sigma hPSD (fun i ↦ Xsample i ω) (fun i ↦ Zsample i ω) hω


end NumStability.HDP.Vector.Whitening

