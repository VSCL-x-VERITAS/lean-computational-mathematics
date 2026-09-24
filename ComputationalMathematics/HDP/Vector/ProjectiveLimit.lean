import ComputationalMathematics.HDP.Vector.SphericalProjective
import Mathlib.MeasureTheory.Function.ConvergenceInDistribution
import Mathlib.Probability.HasLawExists

/-!
# Gaussian realization of spherical projective limits

This module constructs all finite Gaussian coordinate vectors on one product
probability space and uses their normalized directions for spherical limits.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Filter
open scoped BigOperators ENNReal Topology

namespace NumStability.HDP.Vector.Spherical.ProjectiveLimit

/-- The canonical countable iid standard-Gaussian probability space. -/
def infiniteStandardGaussianMeasure : Measure (ℕ → ℝ) :=
  Measure.infinitePi (fun _ : ℕ => gaussianReal 0 1)

instance infiniteStandardGaussianMeasure_isProbabilityMeasure :
    IsProbabilityMeasure infiniteStandardGaussianMeasure := by
  unfold infiniteStandardGaussianMeasure
  infer_instance

/-- The first `d + 1` coordinates of the countable Gaussian sequence. -/
def firstGaussianVector (d : ℕ) (ω : ℕ → ℝ) : Fin (d + 1) → ℝ :=
  fun i => ω i

theorem measurable_firstGaussianVector (d : ℕ) :
    Measurable (firstGaussianVector d) := by
  unfold firstGaussianVector
  fun_prop

theorem coordinate_hasStandardNormalLaw (i : ℕ) :
    HasLaw (fun ω : ℕ → ℝ => ω i) (gaussianReal 0 1)
      infiniteStandardGaussianMeasure := by
  exact (measurePreserving_eval_infinitePi
    (fun _ : ℕ => gaussianReal 0 1) i).hasLaw

theorem firstGaussianVector_isStandardNormal (d : ℕ) :
    NumStability.HDP.Vector.Gaussian.IsStandardNormal
      infiniteStandardGaussianMeasure
      (fun i ω => firstGaussianVector d ω i) := by
  apply NumStability.HDP.Vector.Gaussian.isStandardNormal_iff_iIndepFun_hasLaw.mpr
  constructor
  · have hIndep : iIndepFun (fun i : ℕ => fun ω : ℕ → ℝ => ω i)
        infiniteStandardGaussianMeasure := by
      unfold infiniteStandardGaussianMeasure
      exact iIndepFun_infinitePi (fun _ => measurable_id)
    simpa [firstGaussianVector] using
      (iIndepFun.precomp (g := fun i : Fin (d + 1) => (i : ℕ))
        Fin.val_injective hIndep)
  · intro i
    simpa [firstGaussianVector] using coordinate_hasStandardNormalLaw (i : ℕ)

/-- The squared-radius average of the first `d + 1` Gaussian coordinates. -/
def gaussianSquaredRadiusAverage (d : ℕ) (ω : ℕ → ℝ) : ℝ :=
  (∑ i : Fin (d + 1), (firstGaussianVector d ω i) ^ 2) / (d + 1)

/-- The radial scale occurring in the Gaussian representation of the sphere. -/
def gaussianRadiusScale (d : ℕ) (ω : ℕ → ℝ) : ℝ :=
  Real.sqrt (d + 1) *
    (NumStability.vecNorm2 (firstGaussianVector d ω))⁻¹

theorem measurable_gaussianRadiusScale (d : ℕ) :
    Measurable (gaussianRadiusScale d) := by
  unfold gaussianRadiusScale NumStability.vecNorm2 NumStability.vecNorm2Sq
    firstGaussianVector
  fun_prop

theorem integral_coordinate_sq_eq_one :
    (∫ ω, (ω 0) ^ 2 ∂infiniteStandardGaussianMeasure) = 1 := by
  have hLaw := coordinate_hasStandardNormalLaw 0
  have hSq :
      (∫ ω, (ω 0) ^ 2 ∂infiniteStandardGaussianMeasure) =
        ∫ x : ℝ, x ^ 2 ∂gaussianReal 0 1 := by
    simpa [Function.comp_def] using hLaw.integral_comp
      (ProbabilityTheory.memLp_id_gaussianReal
        (μ := (0 : ℝ)) (v := (1 : NNReal)) 2).integrable_sq.aestronglyMeasurable
  rw [hSq]
  have hv := variance_id_gaussianReal (μ := (0 : ℝ)) (v := (1 : NNReal))
  change Var[(fun x : ℝ => x); gaussianReal 0 1] = ((1 : NNReal) : ℝ) at hv
  rw [variance_of_integral_eq_zero measurable_id'.aemeasurable (by simp)] at hv
  norm_num at hv ⊢
  exact hv

theorem integrable_coordinate_sq :
    Integrable (fun ω : ℕ → ℝ => (ω 0) ^ 2)
      infiniteStandardGaussianMeasure := by
  have hIdent := (coordinate_hasStandardNormalLaw 0).identDistrib
    (show HasLaw (fun x : ℝ => x) (gaussianReal 0 1) (gaussianReal 0 1) from HasLaw.id)
  have hSq := hIdent.comp (measurable_id.pow_const 2)
  apply hSq.integrable_iff.mpr
  simpa using
    (ProbabilityTheory.memLp_id_gaussianReal
      (μ := (0 : ℝ)) (v := (1 : NNReal)) 2).integrable_sq

theorem gaussianSquaredRadiusAverage_tendsto_one_ae :
    ∀ᵐ ω ∂infiniteStandardGaussianMeasure,
      Tendsto (fun d => gaussianSquaredRadiusAverage d ω) atTop (𝓝 1) := by
  let X : ℕ → (ℕ → ℝ) → ℝ := fun i ω => (ω i) ^ 2
  have hIndepCoord : iIndepFun (fun i : ℕ => fun ω : ℕ → ℝ => ω i)
      infiniteStandardGaussianMeasure := by
    unfold infiniteStandardGaussianMeasure
    exact iIndepFun_infinitePi (fun _ => measurable_id)
  have hIndep : iIndepFun X infiniteStandardGaussianMeasure := by
    exact hIndepCoord.comp (fun _ x => x ^ 2) (fun _ => measurable_id.pow_const 2)
  have hIdent : ∀ i, IdentDistrib (X i) (X 0)
      infiniteStandardGaussianMeasure infiniteStandardGaussianMeasure := by
    intro i
    exact ((coordinate_hasStandardNormalLaw i).identDistrib
      (coordinate_hasStandardNormalLaw 0)).comp (measurable_id.pow_const 2)
  have hSLLN := strong_law_ae_real X integrable_coordinate_sq
    (fun i j hij => hIndep.indepFun hij) hIdent
  rw [integral_coordinate_sq_eq_one] at hSLLN
  filter_upwards [hSLLN] with ω hω
  have hcomp := hω.comp (tendsto_add_atTop_nat 1)
  dsimp [Function.comp_def, X] at hcomp
  simp only [Nat.cast_add, Nat.cast_one] at hcomp
  change Tendsto
    (fun d : ℕ => (∑ i ∈ Finset.range (d + 1), ω i ^ 2) / (d + 1))
    atTop (𝓝 1) at hcomp
  apply hcomp.congr'
  filter_upwards [] with d
  unfold gaussianSquaredRadiusAverage firstGaussianVector
  congr 1
  exact (Fin.sum_univ_eq_sum_range (fun i => ω i ^ 2) (d + 1)).symm

theorem gaussianRadiusScale_eq_inv_sqrt_average (d : ℕ) (ω : ℕ → ℝ) :
    gaussianRadiusScale d ω =
      (Real.sqrt (gaussianSquaredRadiusAverage d ω))⁻¹ := by
  have hsum : 0 ≤ ∑ i : Fin (d + 1), (firstGaussianVector d ω i) ^ 2 :=
    Finset.sum_nonneg fun _ _ => sq_nonneg _
  unfold gaussianRadiusScale gaussianSquaredRadiusAverage NumStability.vecNorm2
    NumStability.vecNorm2Sq
  rw [Real.sqrt_div hsum]
  rw [inv_div]
  simp only [div_eq_mul_inv]

theorem gaussianRadiusScale_tendsto_one_ae :
    ∀ᵐ ω ∂infiniteStandardGaussianMeasure,
      Tendsto (fun d => gaussianRadiusScale d ω) atTop (𝓝 1) := by
  filter_upwards [gaussianSquaredRadiusAverage_tendsto_one_ae] with ω hω
  have hsqrt := hω.sqrt
  have hinv := hsqrt.inv₀ (by norm_num : Real.sqrt (1 : ℝ) ≠ 0)
  simpa only [gaussianRadiusScale_eq_inv_sqrt_average, Real.sqrt_one, inv_one] using hinv

theorem gaussianRadiusScale_tendstoInMeasure_one :
    TendstoInMeasure infiniteStandardGaussianMeasure gaussianRadiusScale atTop
      (fun _ => 1) := by
  apply tendstoInMeasure_of_tendsto_ae
  · intro d
    exact (measurable_gaussianRadiusScale d).aestronglyMeasurable
  · exact gaussianRadiusScale_tendsto_one_ae

/-- The Gaussian numerator in a dimension-dependent unit direction. -/
def gaussianProjectiveNumeratorOnSequence
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) (ω : ℕ → ℝ) : ℝ :=
  ∑ i, (u d).1 i * firstGaussianVector d ω i

theorem measurable_gaussianProjectiveNumeratorOnSequence
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) : Measurable (gaussianProjectiveNumeratorOnSequence u d) := by
  unfold gaussianProjectiveNumeratorOnSequence firstGaussianVector
  fun_prop

theorem gaussianProjectiveNumeratorOnSequence_hasStandardNormalLaw
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) :
    HasLaw (gaussianProjectiveNumeratorOnSequence u d) (gaussianReal 0 1)
      infiniteStandardGaussianMeasure := by
  have hNumerator :=
    NumStability.HDP.Vector.Spherical.gaussianProjectiveNumerator_hasStandardNormalLaw
      d (u d)
  have hVector := firstGaussianVector_isStandardNormal d
  simpa [gaussianProjectiveNumeratorOnSequence, firstGaussianVector,
    Function.comp_def] using hNumerator.fun_comp hVector

theorem gaussianProjectiveNumeratorOnSequence_tendstoInDistribution
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1)) :
    TendstoInDistribution (gaussianProjectiveNumeratorOnSequence u) atTop
      (fun ω : ℕ → ℝ => ω 0) infiniteStandardGaussianMeasure := by
  refine ⟨fun d =>
    (measurable_gaussianProjectiveNumeratorOnSequence u d).aemeasurable,
    (measurable_pi_apply 0).aemeasurable, ?_⟩
  let γ : ProbabilityMeasure ℝ := ⟨gaussianReal 0 1, inferInstance⟩
  have hSeq :
      (fun d =>
        (⟨infiniteStandardGaussianMeasure.map
            (gaussianProjectiveNumeratorOnSequence u d),
          Measure.isProbabilityMeasure_map
            (measurable_gaussianProjectiveNumeratorOnSequence u d).aemeasurable⟩ :
          ProbabilityMeasure ℝ)) = fun _ => γ := by
    funext d
    apply Subtype.ext
    exact (gaussianProjectiveNumeratorOnSequence_hasStandardNormalLaw u d).map_eq
  have hLimit :
      (⟨infiniteStandardGaussianMeasure.map (fun ω : ℕ → ℝ => ω 0),
        Measure.isProbabilityMeasure_map (measurable_pi_apply 0).aemeasurable⟩ :
        ProbabilityMeasure ℝ) = γ := by
    apply Subtype.ext
    exact (coordinate_hasStandardNormalLaw 0).map_eq
  rw [hSeq, hLimit]
  exact tendsto_const_nhds

/-- The projective Gaussian ratio on the common iid probability space. -/
def commonGaussianProjectiveRatio
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) (ω : ℕ → ℝ) : ℝ :=
  gaussianProjectiveNumeratorOnSequence u d ω * gaussianRadiusScale d ω

theorem measurable_commonGaussianProjectiveRatio
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) : Measurable (commonGaussianProjectiveRatio u d) := by
  unfold commonGaussianProjectiveRatio
  exact (measurable_gaussianProjectiveNumeratorOnSequence u d).mul
    (measurable_gaussianRadiusScale d)

theorem commonGaussianProjectiveRatio_tendstoInDistribution
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1)) :
    TendstoInDistribution (commonGaussianProjectiveRatio u) atTop
      (fun ω : ℕ → ℝ => ω 0) infiniteStandardGaussianMeasure := by
  have h :=
    (gaussianProjectiveNumeratorOnSequence_tendstoInDistribution u).continuous_comp_prodMk_of_tendstoInMeasure_const
      (g := fun p : ℝ × ℝ => p.1 * p.2) (by fun_prop)
      gaussianRadiusScale_tendstoInMeasure_one
      (fun d => (measurable_gaussianRadiusScale d).aemeasurable)
  simpa [commonGaussianProjectiveRatio] using h

theorem commonGaussianProjectiveRatio_hasLaw_sphericalMarginal
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1))
    (d : ℕ) :
    HasLaw (commonGaussianProjectiveRatio u d)
      (NumStability.HDP.Vector.Spherical.sphericalMarginalMeasure d (u d).1)
      infiniteStandardGaussianMeasure := by
  have hFinite :=
    NumStability.HDP.Vector.Spherical.gaussianProjectiveRatio_hasLaw_sphericalMarginal
      d (u d).1
  have hVector := firstGaussianVector_isStandardNormal d
  have h := hFinite.fun_comp hVector
  apply h.congr
  filter_upwards [] with ω
  unfold commonGaussianProjectiveRatio gaussianProjectiveNumeratorOnSequence
    gaussianRadiusScale NumStability.HDP.Vector.Spherical.gaussianProjectiveRatio
  ring

/-- The spherical marginal as a probability measure, with positivity supplied
by its common-space Gaussian-ratio representation. -/
def sphericalMarginalProbabilityMeasure (d : ℕ)
    (u : NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1)) :
    ProbabilityMeasure ℝ :=
  ⟨NumStability.HDP.Vector.Spherical.sphericalMarginalMeasure d u.1,
    (NumStability.HDP.Vector.Spherical.gaussianProjectiveRatio_hasLaw_sphericalMarginal
      d u.1).isProbabilityMeasure_iff.mp inferInstance⟩

/-- Projective central limit theorem for every sequence of unit directions.
The direction may vary with the dimension; rotational invariance makes this
equivalent to the source's fixed-direction formulation. -/
theorem tendsto_sphericalMarginalProbabilityMeasure
    (u : ∀ d, NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1)) :
    Tendsto (fun d => sphericalMarginalProbabilityMeasure d (u d)) atTop
      (𝓝 (⟨gaussianReal 0 1, inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  have h := (commonGaussianProjectiveRatio_tendstoInDistribution u).tendsto
  have hSeq :
      (fun d =>
        (⟨infiniteStandardGaussianMeasure.map
            (commonGaussianProjectiveRatio u d),
          Measure.isProbabilityMeasure_map
            (measurable_commonGaussianProjectiveRatio u d).aemeasurable⟩ :
          ProbabilityMeasure ℝ)) =
        fun d => sphericalMarginalProbabilityMeasure d (u d) := by
    funext d
    apply Subtype.ext
    exact (commonGaussianProjectiveRatio_hasLaw_sphericalMarginal u d).map_eq
  have hLimit :
      (⟨infiniteStandardGaussianMeasure.map (fun ω : ℕ → ℝ => ω 0),
        Measure.isProbabilityMeasure_map (measurable_pi_apply 0).aemeasurable⟩ :
        ProbabilityMeasure ℝ) = ⟨gaussianReal 0 1, inferInstance⟩ := by
    apply Subtype.ext
    exact (coordinate_hasStandardNormalLaw 0).map_eq
  rw [hSeq, hLimit] at h
  exact h

end NumStability.HDP.Vector.Spherical.ProjectiveLimit
