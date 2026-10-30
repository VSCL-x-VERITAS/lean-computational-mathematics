import ComputationalMathematics.HDP.Vector.WhiteningExistence

/-!
# Canonical whitening of the population and independent samples

One fixed inverse square root supplies all marginal laws, coordinate moments,
pointwise reconstruction, and the normalized Gram error bound.
-/

noncomputable section

set_option backward.isDefEq.respectTransparency false

open MeasureTheory ProbabilityTheory Matrix
open scoped ENNReal NNReal BigOperators MatrixOrder
open NumStability.HDP.Vector

universe u

namespace NumStability.HDP.Vector.Whitening

/-- Package the canonical construction over the population/sample family.
Only the samples are required to be mutually independent. -/
theorem canonical_first_case_whitening_family :
  ∀ {Ω : Type u} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {m n : ℕ} (_hm : 0 < m)
    (X : Ω → Fin n → ℝ) (Xsample : Fin m → Ω → Fin n → ℝ)
    (K : ℝ≥0) (_hK : 1 ≤ K)
    (_hSG : Vector.SubGaussian.IsSubGaussian μ (fun j ω ↦ X ω j))
    (_hRelative : Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
      (fun j ω ↦ X ω j) K)
    (_hSampleMeas : ∀ i j, Measurable (fun ω ↦ Xsample i ω j))
    (_hLaw : ∀ i, IdentDistrib (Xsample i) X μ μ)
    (_hIndep : iIndepFun Xsample μ)
    (_hUnit : IsUnit (Vector.Covariance.secondMomentMatrix μ
      (fun j ω ↦ X ω j))),
    -- F2/F4/F6: actual raw matrix, principal root and fixed canonical W.
    let Sigma := Vector.Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
    let S := CFC.sqrt Sigma
    let F := Vector.Whitening.populationSampleFamily X Xsample
    let W : Option (Fin m) → Ω → Fin n → ℝ :=
      fun o ω ↦ S⁻¹.mulVec (F o ω)
    -- F1/F3: all-member marginals; independence only of the sample projection.
    (∀ o j, Measurable (fun ω ↦ W o ω j)) ∧
    (∀ o, Vector.Isotropy.IsIsotropic μ (fun j ω ↦ W o ω j)) ∧
    (∀ o, Vector.SubGaussian.PsiTwoNorm μ (fun j ω ↦ W o ω j) ≤ (K : ℝ≥0∞)) ∧
    (∀ i, IdentDistrib (W (some i)) (W none) μ μ) ∧
    iIndepFun (fun i : Fin m ↦ W (some i)) μ ∧
    -- finite coordinate moments and every coordinate-product integral.
    (∀ j, MemLp (fun ω ↦ X ω j) 2 μ) ∧
    (∀ i j, MemLp (fun ω ↦ Xsample i ω j) 2 μ) ∧
    (∀ o j, MemLp (fun ω ↦ W o ω j) 2 μ) ∧
    (∀ j k, Integrable (fun ω ↦ X ω j * X ω k) μ) ∧
    (∀ i j k, Integrable (fun ω ↦ Xsample i ω j * Xsample i ω k) μ) ∧
    (∀ o j k, Integrable (fun ω ↦ W o ω j * W o ω k) μ) ∧
    -- F2/F5: pointwise reconstruction by this one explicitly chosen family.
    (∀ o ω, F o ω = S.mulVec (W o ω)) ∧
    -- sample rows only, full entrywise formula and actual error/norm chain.
    (let A : Ω → Matrix (Fin m) (Fin n) ℝ := fun ω i ↦ W (some i) ω
     let Rm : Ω → Matrix (Fin n) (Fin n) ℝ :=
       fun ω ↦ (m : ℝ)⁻¹ • ((A ω).transpose * A ω) - 1
     (∀ ω a b, Rm ω a b =
       (m : ℝ)⁻¹ * (∑ i : Fin m, W (some i) ω a * W (some i) ω b) -
         (if a = b then 1 else 0)) ∧
     ∀ ω,
       Vector.Covariance.randomSampleCovariance Xsample ω - Sigma =
         S * Rm ω * S ∧
       ‖NumStability.realMatrixContinuousLinearMap
           (Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ =
         ‖NumStability.realMatrixContinuousLinearMap (S * Rm ω * S)‖ ∧
       ‖NumStability.realMatrixContinuousLinearMap
           (Vector.Covariance.randomSampleCovariance Xsample ω - Sigma)‖ ≤
         ‖NumStability.realMatrixContinuousLinearMap (Rm ω)‖ *
           ‖NumStability.realMatrixContinuousLinearMap Sigma‖) := by
  intro Ω _ μ _ m n _hm X Xsample K _hK hSG hRelative
    hSampleMeas hLaw hIndep hUnit
  dsimp only
  let Sigma := Covariance.secondMomentMatrix μ (fun j ω ↦ X ω j)
  let S := CFC.sqrt Sigma
  let F := populationSampleFamily X Xsample
  let W : Option (Fin m) → Ω → Fin n → ℝ :=
    fun o ω ↦ S⁻¹.mulVec (F o ω)
  obtain ⟨hIso, _hZSG, _hZRelative, hNorm, hZLaw, hZIndep,
      hSampleNorm, hPop, hSamples, hError⟩ :=
    canonical_first_case_whitening X Xsample K hSG hRelative hUnit
      hSampleMeas hLaw hIndep
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
  have hSampleIso : ∀ i,
      Isotropy.IsIsotropic μ (fun j ω ↦ W (some i) ω j) := by
    intro i
    change Covariance.secondMomentMatrix μ (fun j ω ↦ W (some i) ω j) = 1
    have hMoments :
        Covariance.secondMomentMatrix μ (fun j ω ↦ W (some i) ω j) =
          Covariance.secondMomentMatrix μ (fun j ω ↦ W none ω j) := by
      ext j k
      have hprod := (hZLaw i).comp
        ((measurable_pi_apply j).mul (measurable_pi_apply k))
      simpa only [Covariance.secondMomentMatrix, Function.comp_def] using hprod.integral_eq
    exact hMoments.trans hIso
  have hWIso : ∀ o, Isotropy.IsIsotropic μ (fun j ω ↦ W o ω j) := by
    intro o
    cases o with
    | none => exact hIso
    | some i => exact hSampleIso i
  have hWNorm : ∀ o,
      SubGaussian.PsiTwoNorm μ (fun j ω ↦ W o ω j) ≤ (K : ℝ≥0∞) := by
    intro o
    cases o with
    | none => exact hNorm
    | some i => exact hSampleNorm i
  have hLp : ∀ j, MemLp (fun ω ↦ X ω j) 2 μ :=
    coordinate_memLp_of_subGaussian hSG
  have hSampleLp : ∀ i j, MemLp (fun ω ↦ Xsample i ω j) 2 μ := by
    intro i j
    simpa only [Function.comp_def] using
      (((hLaw i).symm.comp (measurable_pi_apply j)).memLp_snd (hLp j))
  have hWLp : ∀ o j, MemLp (fun ω ↦ W o ω j) 2 μ := by
    intro o j
    cases o with
    | none =>
      exact memLp_mulVec S⁻¹ (fun j ω ↦ X ω j) hLp j
    | some i =>
      exact memLp_mulVec S⁻¹ (fun j ω ↦ Xsample i ω j) (hSampleLp i) j
  have hXProducts : ∀ j k,
      Integrable (fun ω ↦ X ω j * X ω k) μ :=
    fun j k ↦ (hLp j).integrable_mul (hLp k)
  have hSampleProducts : ∀ i j k,
      Integrable (fun ω ↦ Xsample i ω j * Xsample i ω k) μ :=
    fun i j k ↦ (hSampleLp i j).integrable_mul (hSampleLp i k)
  have hWProducts : ∀ o j k,
      Integrable (fun ω ↦ W o ω j * W o ω k) μ :=
    fun o j k ↦ (hWLp o j).integrable_mul (hWLp o k)
  have hRows : ∀ o ω, F o ω = S.mulVec (W o ω) := by
    intro o ω
    cases o with
    | none => exact hPop ω
    | some i => exact hSamples i ω
  refine ⟨hWMeas, hWIso, hWNorm, hZLaw, hZIndep,
    hLp, hSampleLp, hWLp, hXProducts, hSampleProducts, hWProducts, hRows, ?_⟩
  constructor
  · intro ω a b
    simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul,
      Matrix.mul_apply, Matrix.transpose_apply, Matrix.one_apply]
  · exact hError

end NumStability.HDP.Vector.Whitening
