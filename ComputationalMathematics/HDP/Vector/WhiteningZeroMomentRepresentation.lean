import ComputationalMathematics.HDP.Probability.DiracIndependence
import ComputationalMathematics.HDP.Vector.WhiteningExpectation
import Mathlib.MeasureTheory.Measure.Dirac
import Mathlib.MeasureTheory.MeasurableSpace.Instances
import Mathlib.Probability.Independence.Basic

/-!
# Ordinary null-point obstruction for literal whitening identities

Zero second moment controls almost-everywhere values and expectations. It does
not impose an all-points square-root reconstruction on a chosen representative.
The example uses the two-point measurable space with a point mass at false.
This ordinary distinction does not select the author's equality convention.
-/
noncomputable section
set_option backward.isDefEq.respectTransparency false
open _root_.MeasureTheory _root_.ProbabilityTheory _root_.Matrix
open scoped MatrixOrder NNReal ENNReal

namespace NumStability.HDP.Vector.Whitening

/-- Factorization through a zero population square root at every point is
equivalent to the original vector being zero at every point. -/
theorem exists_zero_squareRoot_factorization_iff_pointwise_zero
    {Ω : Type*} {n : ℕ} (X : Ω → Fin n → ℝ)
    (Sigma : Matrix (Fin n) (Fin n) ℝ) (hZero : Sigma = 0) :
    (∃ Z : Ω → Fin n → ℝ, ∀ ω, X ω = (CFC.sqrt Sigma).mulVec (Z ω)) ↔
      ∀ ω, X ω = 0 := by
  rw [hZero]
  simp only [CFC.sqrt_zero, Matrix.zero_mulVec]
  exact ⟨fun ⟨_, h⟩ ↦ h, fun h ↦ ⟨fun _ ↦ 0, h⟩⟩

/-- A measurable square-integrable vector can have zero raw second moment and
be AE zero while admitting no literal all-points square-root factorization. -/
theorem exists_zero_secondMoment_without_pointwise_squareRoot_factorization :
    ∃ X : Bool → Fin 1 → ℝ,
      Measurable X ∧
      (∀ j, MemLp (fun ω ↦ X ω j) 2 (Measure.dirac false)) ∧
      NumStability.HDP.Vector.Covariance.secondMomentMatrix (Measure.dirac false)
        (fun j ω ↦ X ω j) = 0 ∧
      X =ᵐ[Measure.dirac false] 0 ∧ X false = 0 ∧ X true = (fun _ ↦ 1) ∧
      ¬ ∃ Z : Bool → Fin 1 → ℝ, ∀ ω, X ω =
        (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (Measure.dirac false) (fun j ω ↦ X ω j))).mulVec (Z ω) := by
  let X : Bool → Fin 1 → ℝ := fun ω _ ↦ if ω then 1 else 0
  have hAE : X =ᵐ[Measure.dirac false] 0 := by
    simpa [X, Function.const] using (ae_eq_dirac (a := false) X)
  have hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 (Measure.dirac false) := by
    intro j
    have hcoord : (fun ω ↦ X ω j) =ᵐ[Measure.dirac false] (fun _ ↦ (0 : ℝ)) :=
      hAE.mono (fun ω hω ↦ congrFun hω j)
    exact (memLp_congr_ae hcoord).2 (memLp_const (0 : ℝ))
  have hZero : NumStability.HDP.Vector.Covariance.secondMomentMatrix
      (Measure.dirac false) (fun j ω ↦ X ω j) = 0 := by
    ext i j
    simp [NumStability.HDP.Vector.Covariance.secondMomentMatrix, X]
  refine ⟨X, measurable_of_finite X, hLp, hZero, hAE, rfl, rfl, ?_⟩
  intro hFactor
  have hPoint :=
    (exists_zero_squareRoot_factorization_iff_pointwise_zero X _ hZero).1 hFactor true
  have hBad := congrFun hPoint (0 : Fin 1)
  norm_num [X] at hBad

/-- The same zero-moment vector yields an AE zero actual sample error and
zero error expectation, while its empirical matrix at the null point is one. -/
theorem exists_zero_secondMoment_sample_error_ae_zero_nonzero_at_null_point :
    ∃ X : Bool → Fin 1 → ℝ,
      Measurable X ∧
      NumStability.HDP.Vector.Covariance.secondMomentMatrix (Measure.dirac false)
        (fun j ω ↦ X ω j) = 0 ∧
      let Xsample : Fin 1 → Bool → Fin 1 → ℝ := fun _ ↦ X
      let Error := fun ω ↦ NumStability.realMatrixOperatorNorm
        (NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample ω -
          NumStability.HDP.Vector.Covariance.secondMomentMatrix (Measure.dirac false)
            (fun j ω ↦ X ω j))
      Integrable Error (Measure.dirac false) ∧
      Error =ᵐ[Measure.dirac false] 0 ∧
      (∫ ω, Error ω ∂Measure.dirac false) = 0 ∧
      NumStability.HDP.Vector.Covariance.randomSampleCovariance Xsample true = 1 := by
  obtain ⟨X, hMeas, hLp, hZero, _hAE, _hFalse, hTrue, _hFactor⟩ :=
    exists_zero_secondMoment_without_pointwise_squareRoot_factorization
  let Xsample : Fin 1 → Bool → Fin 1 → ℝ := fun _ ↦ X
  have hLaw : ∀ i, IdentDistrib (Xsample i) X (Measure.dirac false) (Measure.dirac false) :=
    fun _ ↦ IdentDistrib.refl hMeas.aemeasurable
  obtain ⟨hInt, hAE, hExpect⟩ :=
    actual_error_ae_and_expectation_zero_of_secondMoment_zero X Xsample hLp hLaw hZero
  refine ⟨X, hMeas, hZero, hInt, hAE, hExpect, ?_⟩
  ext i j
  fin_cases i
  fin_cases j
  simp [NumStability.HDP.Vector.Covariance.randomSampleCovariance,
    NumStability.HDP.Vector.Covariance.sampleCovariance, hTrue]

/-- A measurable AE zero vector has zero vector gauge, is sub-Gaussian, and
satisfies the relative marginal bound with every nonnegative constant. -/
theorem zero_psiTwoNorm_subGaussian_relative_bound_of_ae_vector_zero
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ} {μ : Measure Ω}
    [IsProbabilityMeasure μ] (X : Ω → Fin n → ℝ)
    (hMeas : Measurable X) (hAE : X =ᵐ[μ] 0) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ X ω j) = 0 ∧
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j) ∧
    ∀ K : ℝ≥0, NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K := by
  have hCoords : ∀ j, Measurable (fun ω ↦ X ω j) :=
    fun j ↦ (measurable_pi_apply j).comp hMeas
  have hMarginalZero (u : Fin n → ℝ) :
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal (fun j ω ↦ X ω j) u) = 0 := by
    change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ _ = 0
    apply (NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_eq_zero_iff_ae_eq_zero
      (by unfold NumStability.HDP.Vector.linearMarginal; fun_prop)).2
    filter_upwards [hAE] with ω hω
    simp [NumStability.HDP.Vector.linearMarginal, hω]
  have hNorm : NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
      (fun j ω ↦ X ω j) = 0 := by
    unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
    apply le_antisymm
    · exact iSup_le fun _ ↦ (hMarginalZero _).le
    · exact bot_le
  refine ⟨hNorm, ?_, ?_⟩
  · apply NumStability.HDP.Vector.SubGaussian.isSubGaussian_of_psiTwoNorm_lt_top
    rw [hNorm]
    exact ENNReal.zero_lt_top
  · intro K u
    rw [hMarginalZero]
    exact bot_le

/-- Sub-Gaussianity, arbitrary relative bounds, finite second moments, and
an independent identically distributed singleton family still do not force
a chosen zero-moment representative to factor at every point. -/
theorem exists_subGaussian_zero_secondMoment_iid_without_pointwise_factorization :
    ∃ X : Bool → Fin 1 → ℝ,
      Measurable X ∧
      (∀ j, MemLp (fun ω ↦ X ω j) 2 (Measure.dirac false)) ∧
      NumStability.HDP.Vector.Covariance.secondMomentMatrix (Measure.dirac false)
        (fun j ω ↦ X ω j) = 0 ∧
      X =ᵐ[Measure.dirac false] 0 ∧
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian (Measure.dirac false)
        (fun j ω ↦ X ω j) ∧
      (∀ K : ℝ≥0, NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
        (Measure.dirac false) (fun j ω ↦ X ω j) K) ∧
      iIndepFun (fun _ : Fin 1 ↦ X) (Measure.dirac false) ∧
      (∀ i : Fin 1, IdentDistrib ((fun _ : Fin 1 ↦ X) i) X
        (Measure.dirac false) (Measure.dirac false)) ∧
      ¬ ∃ Z : Bool → Fin 1 → ℝ, ∀ ω, X ω =
        (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (Measure.dirac false) (fun j ω ↦ X ω j))).mulVec (Z ω) := by
  obtain ⟨X, hMeas, hLp, hZero, hAE, _hFalse, _hTrue, hFactor⟩ :=
    exists_zero_secondMoment_without_pointwise_squareRoot_factorization
  obtain ⟨_hNorm, hSG, hRelative⟩ :=
    zero_psiTwoNorm_subGaussian_relative_bound_of_ae_vector_zero X hMeas hAE
  exact ⟨X, hMeas, hLp, hZero, hAE, hSG, hRelative,
    iIndepFun.of_subsingleton, fun _ ↦ IdentDistrib.refl hMeas.aemeasurable, hFactor⟩


/-- The existing sub-Gaussian zero-moment representative has a jointly
independent population member and any finite identical-law sample family,
while still admitting no all-points square-root reconstruction. -/
theorem exists_subGaussian_zero_secondMoment_joint_iid_without_pointwise_factorization
    (m : ℕ) :
    ∃ X : Bool → Fin 1 → ℝ,
      Measurable X ∧
      (∀ j, MemLp (fun ω ↦ X ω j) 2 (Measure.dirac false)) ∧
      NumStability.HDP.Vector.Covariance.secondMomentMatrix (Measure.dirac false)
        (fun j ω ↦ X ω j) = 0 ∧
      X =ᵐ[Measure.dirac false] 0 ∧
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian (Measure.dirac false)
        (fun j ω ↦ X ω j) ∧
      (∀ K : ℝ≥0, NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound
        (Measure.dirac false) (fun j ω ↦ X ω j) K) ∧
      iIndepFun (fun _ : Option (Fin m) ↦ X) (Measure.dirac false) ∧
      (∀ i : Fin m, IdentDistrib ((fun _ : Fin m ↦ X) i) X
        (Measure.dirac false) (Measure.dirac false)) ∧
      ¬ ∃ Z : Bool → Fin 1 → ℝ, ∀ ω, X ω =
        (CFC.sqrt (NumStability.HDP.Vector.Covariance.secondMomentMatrix
          (Measure.dirac false) (fun j ω ↦ X ω j))).mulVec (Z ω) := by
  obtain ⟨X, hMeas, hLp, hZero, hAE, hSG, hRelative, _hSingle, _hSingleLaw, hFactor⟩ :=
    exists_subGaussian_zero_secondMoment_iid_without_pointwise_factorization
  exact ⟨X, hMeas, hLp, hZero, hAE, hSG, hRelative,
    NumStability.HDP.Probability.iIndepFun_dirac (fun _ : Option (Fin m) ↦ X) false,
    fun _ ↦ IdentDistrib.refl hMeas.aemeasurable, hFactor⟩


end NumStability.HDP.Vector.Whitening


