import ComputationalMathematics.HDP.Vector.WhiteningIndependence

/-!
# Existence of invertible raw-moment whitening families

The population and every sample share an explicitly measurable, independent
whitened family with raw isotropy and the same marginal `ψ₂` bound. The canonical
inverse square root supplies pointwise reconstruction and therefore also AE
reconstruction. The existential equivalence concerns a choice of family; it does
not impose pointwise reconstruction on a fixed supplied AE family.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal MatrixOrder

namespace NumStability.HDP.Vector.Whitening

/-- The joint family retains the population as well as every sample. -/
def populationSampleFamily {Ω : Type*} {m n : ℕ}
    (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) :
    Option (Fin m) → Ω → Fin n → ℝ :=
  fun o ↦ match o with
    | none => X
    | some i => Xsample i

/-- Measurable raw-isotropic population and samples, with one exact `ψ₂`
bound, identical sample/population laws, and independence of the entire family. -/
def IsWhiteningFamily {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (W : Option (Fin m) → Ω → Fin n → ℝ) (K : ℝ≥0) : Prop :=
  (∀ o j, Measurable (fun ω ↦ W o ω j)) ∧
    (∀ o, Isotropy.IsIsotropic μ (fun j ω ↦ W o ω j)) ∧
    (∀ o, SubGaussian.PsiTwoNorm μ (fun j ω ↦ W o ω j) ≤ (K : ℝ≥0∞)) ∧
    (∀ i, IdentDistrib (W (some i)) (W none) μ μ) ∧
    iIndepFun W μ

/-- Existence of a whitening family reconstructing the original joint family
at every outcome. The matrix and original family are fixed before the witness. -/
def PWExists {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (S : Matrix (Fin n) (Fin n) ℝ)
    (F : Option (Fin m) → Ω → Fin n → ℝ) (K : ℝ≥0) : Prop :=
  ∃ W : Option (Fin m) → Ω → Fin n → ℝ,
    IsWhiteningFamily μ W K ∧ ∀ o ω, F o ω = S.mulVec (W o ω)

/-- Existence of a whitening family reconstructing each original family
member almost everywhere on the same measure space. -/
def AEExists {Ω : Type*} [MeasurableSpace Ω] {m n : ℕ}
    (μ : Measure Ω) (S : Matrix (Fin n) (Fin n) ℝ)
    (F : Option (Fin m) → Ω → Fin n → ℝ) (K : ℝ≥0) : Prop :=
  ∃ W : Option (Fin m) → Ω → Fin n → ℝ,
    IsWhiteningFamily μ W K ∧
      ∀ o, F o =ᵐ[μ] (fun ω ↦ S.mulVec (W o ω))

/-- Existing inverse-root whitening produces an entire independent measurable
population-and-sample family with pointwise reconstruction. -/
theorem exists_pointwise_first_case_whitening
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ X ω j) K)
    (hUnit : IsUnit (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hJoint : iIndepFun (populationSampleFamily X Xsample) μ) :
    PWExists μ (CFC.sqrt (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
      (populationSampleFamily X Xsample) K := by
  let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
  let S := CFC.sqrt Sigma
  let F := populationSampleFamily X Xsample
  let W : Option (Fin m) → Ω → Fin n → ℝ := fun o ω ↦ S⁻¹.mulVec (F o ω)
  have hSampleIndep : iIndepFun Xsample μ := by
    simpa only [populationSampleFamily] using
      (iIndepFun.precomp (g := Option.some)
        (fun _ _ h ↦ Option.some.inj h) hJoint)
  obtain ⟨hIso, _hZSG, _hZRelative, hNorm, hZLaw, _hZSampleIndep,
      hSampleNorm, hPop, hSamples, _hError⟩ :=
    canonical_first_case_whitening X Xsample K hSG hRelative hUnit
      hSampleMeas hLaw hSampleIndep
  have hXMeas : Measurable X :=
    measurable_pi_iff.mpr (fun j ↦ (coordinate_isSubGaussian hSG j).1)
  have hWMeas : ∀ o j, Measurable (fun ω ↦ W o ω j) := by
    intro o j
    cases o with
    | none =>
      exact (measurable_pi_apply j).comp ((measurable_mulVec S⁻¹).comp hXMeas)
    | some i =>
      exact (measurable_pi_apply j).comp
        ((measurable_mulVec S⁻¹).comp (measurable_pi_iff.mpr (hSampleMeas i)))
  have hSampleIso : ∀ i, Isotropy.IsIsotropic μ (fun j ω ↦ W (some i) ω j) := by
    intro i
    change Covariance.secondMomentMatrix μ (fun j ω ↦ W (some i) ω j) = 1
    have hMoments : Covariance.secondMomentMatrix μ (fun j ω ↦ W (some i) ω j) =
        Covariance.secondMomentMatrix μ (fun j ω ↦ W none ω j) := by
      ext j k
      have hprod := (hZLaw i).comp
        ((measurable_pi_apply j).mul (measurable_pi_apply k))
      simpa only [Covariance.secondMomentMatrix, Function.comp_def] using hprod.integral_eq
    exact hMoments.trans hIso
  have hWJoint : iIndepFun W μ :=
    (canonical_raw_population_whitening_samples_independent_iff_original
      μ X F hSG hUnit).mpr hJoint
  change PWExists μ S F K
  refine ⟨W, ⟨hWMeas, ?_, ?_, hZLaw, hWJoint⟩, ?_⟩
  · intro o
    cases o with
    | none => exact hIso
    | some i => exact hSampleIso i
  · intro o
    cases o with
    | none => exact hNorm
    | some i => exact hSampleNorm i
  · intro o ω
    cases o with
    | none => exact hPop ω
    | some i => exact hSamples i ω

/-- On the explicit invertible raw-moment domain, the existing pointwise
chosen witness makes the pointwise and AE existence predicates equivalent.
The reverse implication chooses the canonical family rather than changing
the pointwise values of an arbitrary supplied AE witness. -/
theorem pointwise_first_case_whitening_exists_iff_ae
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]
    {m n : ℕ} (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0)
    (hSG : SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (hRelative : SubGaussian.SatisfiesPsiTwoL2Bound μ (fun j ω ↦ X ω j) K)
    (hUnit : IsUnit (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
    (hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (hJoint : iIndepFun (populationSampleFamily X Xsample) μ) :
    PWExists μ (CFC.sqrt (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
        (populationSampleFamily X Xsample) K ↔
      AEExists μ (CFC.sqrt (Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)))
        (populationSampleFamily X Xsample) K := by
  constructor
  · rintro ⟨W, hW, hRows⟩
    refine ⟨W, hW, ?_⟩
    intro o
    exact Filter.Eventually.of_forall (hRows o)
  · intro _hAE
    exact exists_pointwise_first_case_whitening X Xsample K hSG hRelative hUnit
      hSampleMeas hLaw hJoint

end NumStability.HDP.Vector.Whitening
