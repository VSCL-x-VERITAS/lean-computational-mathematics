import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import ComputationalMathematics.HDP.Vector.SubGaussianDomination

/-!
# A dependent isotropic sub-Gaussian vector without norm concentration

This module supplies the reusable counterexample behind Vershynin's
Exercise 3.4.10.  A uniform spherical vector is independently multiplied by
either zero or two, with probabilities `3/4` and `1/4`.  The radial second
moment remains one, while the Euclidean norm is always a distance `sqrt n`
from its isotropic scale.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Metric
open scoped ENNReal BigOperators

namespace NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration

def quarterCoinPMF : PMF Bool :=
  PMF.bernoulli (1 / 4 : NNReal) (by rw [div_le_one] <;> norm_num)

abbrev SampleSpace (n : ℕ) :=
  Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 × Bool

def modelMeasure (n : ℕ) : Measure (SampleSpace n) :=
  (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n).prod
    quarterCoinPMF.toMeasure

theorem modelMeasure_isProbabilityMeasure {n : ℕ} (hn : 0 < n) :
    IsProbabilityMeasure (modelMeasure n) := by
  letI : IsProbabilityMeasure
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n) :=
    NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure_isProbabilityMeasure hn
  unfold modelMeasure
  infer_instance

def radialFactor (b : Bool) : ℝ := if b then 2 else 0

def liftedSphereVector (n : ℕ) : Fin n → SampleSpace n → ℝ :=
  fun i p ↦ Real.sqrt n *
    WithLp.ofLp (p.1 : EuclideanSpace ℝ (Fin n)) i

def modelVector (n : ℕ) : Fin n → SampleSpace n → ℝ :=
  fun i p ↦ radialFactor p.2 * liftedSphereVector n i p

lemma measurable_liftedSphereVector (n : ℕ) (i : Fin n) :
    Measurable (liftedSphereVector n i) := by
  unfold liftedSphereVector
  fun_prop

lemma measurable_modelVector (n : ℕ) (i : Fin n) :
    Measurable (modelVector n i) := by
  apply (((measurable_of_countable radialFactor).comp measurable_snd).mul
    (measurable_liftedSphereVector n i))

lemma radialFactor_sq_integral :
    (∫ b, radialFactor b ^ 2 ∂quarterCoinPMF.toMeasure) = 1 := by
  rw [PMF.integral_eq_sum]
  simp [radialFactor, quarterCoinPMF, PMF.bernoulli_apply]
  norm_num

lemma liftedSphere_coordinate_mul_integral {n : ℕ} (hn : 0 < n)
    (i j : Fin n) :
    (∫ x, (Real.sqrt n *
          WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i) *
        (Real.sqrt n *
          WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) j)
      ∂(@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n)) =
      if i = j then 1 else 0 := by
  have hpoint (x : Metric.sphere
      (0 : EuclideanSpace ℝ (Fin n)) 1) :
      (Real.sqrt n * WithLp.ofLp
          (x : EuclideanSpace ℝ (Fin n)) i) *
        (Real.sqrt n * WithLp.ofLp
          (x : EuclideanSpace ℝ (Fin n)) j) =
      (Real.sqrt n * Real.sqrt n) *
        (NumStability.HDP.Vector.Spherical.unitSphereCoordinate i x *
          NumStability.HDP.Vector.Spherical.unitSphereCoordinate j x) := by
    simp only [NumStability.HDP.Vector.Spherical.unitSphereCoordinate]
    ring
  simp_rw [hpoint]
  rw [integral_const_mul,
    NumStability.HDP.Vector.Spherical.integral_unitSphereCoordinate_mul hn]
  have hsqrt : Real.sqrt (n : ℝ) * Real.sqrt (n : ℝ) = (n : ℝ) :=
    Real.mul_self_sqrt (Nat.cast_nonneg n)
  have hn0 : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  by_cases hij : i = j
  · simp [hij, hsqrt, hn0]
  · simp [hij]

theorem modelVector_isIsotropic {n : ℕ} (hn : 0 < n) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (modelMeasure n) (modelVector n) := by
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  have hpoint (p : SampleSpace n) :
      modelVector n i p * modelVector n j p =
        ((Real.sqrt n * WithLp.ofLp
            (p.1 : EuclideanSpace ℝ (Fin n)) i) *
          (Real.sqrt n * WithLp.ofLp
            (p.1 : EuclideanSpace ℝ (Fin n)) j)) *
          radialFactor p.2 ^ 2 := by
    simp only [modelVector, liftedSphereVector]
    ring
  unfold modelMeasure
  simp_rw [hpoint]
  calc
    (∫ p,
        ((Real.sqrt n * WithLp.ofLp
            (p.1 : EuclideanSpace ℝ (Fin n)) i) *
          (Real.sqrt n * WithLp.ofLp
            (p.1 : EuclideanSpace ℝ (Fin n)) j)) *
          radialFactor p.2 ^ 2
        ∂(@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n).prod
          quarterCoinPMF.toMeasure) =
        (∫ x,
          (Real.sqrt n * WithLp.ofLp
              (x : EuclideanSpace ℝ (Fin n)) i) *
            (Real.sqrt n * WithLp.ofLp
              (x : EuclideanSpace ℝ (Fin n)) j)
          ∂(@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n)) *
        ∫ b, radialFactor b ^ 2 ∂quarterCoinPMF.toMeasure :=
      MeasureTheory.integral_prod_mul
        (μ := @NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n)
        (ν := quarterCoinPMF.toMeasure)
        (fun x ↦
          (Real.sqrt n * WithLp.ofLp
              (x : EuclideanSpace ℝ (Fin n)) i) *
            (Real.sqrt n * WithLp.ofLp
              (x : EuclideanSpace ℝ (Fin n)) j))
        (fun b ↦ radialFactor b ^ 2)
    _ = _ := by
      rw [liftedSphere_coordinate_mul_integral hn,
        radialFactor_sq_integral]
      simp

private lemma psiTwoNorm_const_mul
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : Measure Ω) (X : Fin n → Ω → ℝ) {c : ℝ} (hc : c ≠ 0) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ
        (fun i ω ↦ c * X i ω) =
      ENNReal.ofReal |c| *
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm μ X := by
  unfold NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
  rw [ENNReal.mul_iSup]
  apply iSup_congr
  intro u
  have hMarginal :
      NumStability.HDP.Vector.linearMarginal
          (fun i ω ↦ c * X i ω) u.1 =
        fun ω ↦ c * NumStability.HDP.Vector.linearMarginal X u.1 ω := by
    funext ω
    simp only [NumStability.HDP.Vector.linearMarginal]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hMarginal]
  change NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
      (fun ω ↦ c * NumStability.HDP.Vector.linearMarginal X u.1 ω) =
    ENNReal.ofReal |c| *
      NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
        (NumStability.HDP.Vector.linearMarginal X u.1)
  exact NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_smul_of_ne_zero hc

/-- The lifted direction on the product space has the canonical spherical
vector law. -/
theorem hasLaw_liftedSphereVector (n : ℕ) :
    HasLaw (fun p i ↦ liftedSphereVector n i p)
      (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
      (modelMeasure n) := by
  letI : IsProbabilityMeasure quarterCoinPMF.toMeasure := inferInstance
  have hFst : HasLaw Prod.fst
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n)
      (modelMeasure n) := by
    exact MeasureTheory.measurePreserving_fst.hasLaw
  have hSphere : HasLaw
      (fun x : Metric.sphere (0 : EuclideanSpace ℝ (Fin n)) 1 ↦
        fun i ↦ Real.sqrt n *
          WithLp.ofLp (x : EuclideanSpace ℝ (Fin n)) i)
      (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure n) := by
    refine ⟨(by fun_prop), ?_⟩
    rfl
  simpa [liftedSphereVector, Function.comp_def] using hSphere.comp hFst

theorem liftedSphere_psiTwoNorm_eq_sphericalVectorMeasure (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (modelMeasure n) (liftedSphereVector n) =
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
        (fun i x ↦ x i) := by
  exact NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (measurable_liftedSphereVector n) (hasLaw_liftedSphereVector n)

def radialIndicator (b : Bool) : ℝ := if b then 1 else 0

lemma measurable_radialIndicator (n : ℕ) :
    Measurable (fun p : SampleSpace n ↦ radialIndicator p.2) :=
  (measurable_of_countable radialIndicator).comp measurable_snd

lemma radialIndicator_abs_le_one (b : Bool) : |radialIndicator b| ≤ 1 := by
  cases b <;> simp [radialIndicator]

lemma modelVector_eq_radialContraction (n : ℕ) :
    modelVector n =
      NumStability.HDP.Vector.SubGaussian.radialContraction
        (fun p : SampleSpace n ↦ radialIndicator p.2)
        (fun i p ↦ 2 * liftedSphereVector n i p) := by
  funext i p
  cases p.2 <;> simp [modelVector, radialFactor, radialIndicator,
    NumStability.HDP.Vector.SubGaussian.radialContraction]

/-- The random radial spike costs at most a factor two in vector `ψ₂`
norm relative to the canonical spherical law. -/
theorem modelVector_psiTwoNorm_le_spherical (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (modelMeasure n) (modelVector n) ≤
      ENNReal.ofReal 2 *
        NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
          (fun i x ↦ x i) := by
  rw [modelVector_eq_radialContraction]
  calc
    _ ≤ NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (modelMeasure n) (fun i p ↦ 2 * liftedSphereVector n i p) := by
      apply NumStability.HDP.Vector.SubGaussian.radialContraction_psiTwoNorm_le
      · exact measurable_radialIndicator n
      · intro i
        exact measurable_const.mul (measurable_liftedSphereVector n i)
      · intro p
        exact radialIndicator_abs_le_one p.2
    _ = ENNReal.ofReal 2 *
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
            (modelMeasure n) (liftedSphereVector n) := by
      simpa using psiTwoNorm_const_mul (modelMeasure n) (liftedSphereVector n)
        (c := 2) (by norm_num)
    _ = _ := by rw [liftedSphere_psiTwoNorm_eq_sphericalVectorMeasure]

lemma liftedSphereVector_vecNorm2 (n : ℕ) (p : SampleSpace n) :
    NumStability.vecNorm2 (fun i ↦ liftedSphereVector n i p) =
      Real.sqrt n := by
  have hp : ‖(p.1 : EuclideanSpace ℝ (Fin n))‖ = 1 := by
    simp
  have hcoord : NumStability.vecNorm2
      (fun i ↦ WithLp.ofLp
        (p.1 : EuclideanSpace ℝ (Fin n)) i) = 1 := by
    rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
    exact hp
  unfold liftedSphereVector
  rw [NumStability.vecNorm2_smul,
    abs_of_nonneg (Real.sqrt_nonneg _), hcoord, mul_one]

/-- Every realization has norm either zero or `2 * sqrt n`, hence its
distance from the isotropic scale `sqrt n` is exactly `sqrt n`. -/
theorem modelVector_norm_deviation (n : ℕ) (p : SampleSpace n) :
    |NumStability.vecNorm2 (fun i ↦ modelVector n i p) - Real.sqrt n| =
      Real.sqrt n := by
  rw [show (fun i ↦ modelVector n i p) =
      fun i ↦ radialFactor p.2 * liftedSphereVector n i p by rfl,
    NumStability.vecNorm2_smul, liftedSphereVector_vecNorm2]
  cases p.2
  · simp [radialFactor, abs_of_nonneg (Real.sqrt_nonneg _)]
  · simp only [radialFactor, if_true]
    rw [abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)]
    rw [show 2 * Real.sqrt (n : ℝ) - Real.sqrt n = Real.sqrt n by ring,
      abs_of_nonneg (Real.sqrt_nonneg _)]

def jointModelVector (n : ℕ) : SampleSpace n → (Fin n → ℝ) :=
  fun p i ↦ modelVector n i p

lemma measurable_jointModelVector (n : ℕ) :
    Measurable (jointModelVector n) := by
  exact measurable_pi_lambda _ (measurable_modelVector n)

/-- The canonical law of the radial-spike counterexample. -/
def counterexampleMeasure (n : ℕ) : Measure (Fin n → ℝ) :=
  Measure.map (jointModelVector n) (modelMeasure n)

theorem hasLaw_modelVector (n : ℕ) :
    HasLaw (jointModelVector n) (counterexampleMeasure n) (modelMeasure n) := by
  exact ⟨(measurable_jointModelVector n).aemeasurable, rfl⟩

theorem counterexampleMeasure_isProbabilityMeasure {n : ℕ} (hn : 0 < n) :
    IsProbabilityMeasure (counterexampleMeasure n) := by
  letI : IsProbabilityMeasure (modelMeasure n) :=
    modelMeasure_isProbabilityMeasure hn
  exact (hasLaw_modelVector n).isProbabilityMeasure_iff.mp inferInstance

theorem counterexampleMeasure_isIsotropic {n : ℕ} (hn : 0 < n) :
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (counterexampleMeasure n) (fun i x ↦ x i) := by
  rw [NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul]
  intro i j
  unfold counterexampleMeasure
  rw [integral_map (measurable_jointModelVector n).aemeasurable]
  · exact (NumStability.HDP.Vector.Isotropy.isIsotropic_iff_integral_mul
      (modelMeasure n) (modelVector n)).1 (modelVector_isIsotropic hn) i j
  · fun_prop

theorem counterexampleMeasure_psiTwoNorm_eq_model (n : ℕ) :
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (counterexampleMeasure n) (fun i x ↦ x i) =
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (modelMeasure n) (modelVector n) := by
  exact (NumStability.HDP.Vector.SubGaussian.psiTwoNorm_eq_of_hasLaw
    (measurable_modelVector n) (hasLaw_modelVector n)).symm

theorem counterexampleMeasure_norm_deviation_one {n : ℕ} (hn : 0 < n) :
    (counterexampleMeasure n).real
        {x | |NumStability.vecNorm2 x - Real.sqrt n| ≥ Real.sqrt n} = 1 := by
  letI : IsProbabilityMeasure (modelMeasure n) :=
    modelMeasure_isProbabilityMeasure hn
  unfold counterexampleMeasure
  rw [map_measureReal_apply (measurable_jointModelVector n)]
  · have hpreimage : jointModelVector n ⁻¹'
        {x | |NumStability.vecNorm2 x - Real.sqrt n| ≥ Real.sqrt n} = Set.univ := by
      apply Set.eq_univ_of_forall
      intro p
      change Real.sqrt n ≤
        |NumStability.vecNorm2 (fun i ↦ modelVector n i p) - Real.sqrt n|
      rw [modelVector_norm_deviation]
    rw [hpreimage]
    simp
  · exact measurableSet_le measurable_const
      ((NumStability.continuous_vecNorm2.measurable.sub measurable_const).abs)

/-- There is a dimension-free family of isotropic sub-Gaussian vectors whose
Euclidean norms fail to concentrate at their natural scale in the strongest
possible way.  This is the reusable mathematical content of Vershynin's
Exercise 3.4.10. -/
theorem exists_isotropicSubGaussian_nonconcentrated :
    ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
      IsProbabilityMeasure (counterexampleMeasure n) ∧
      NumStability.HDP.Vector.Isotropy.IsIsotropic
        (counterexampleMeasure n) (fun i x ↦ x i) ∧
      NumStability.HDP.Vector.SubGaussian.IsSubGaussian
        (counterexampleMeasure n) (fun i x ↦ x i) ∧
      NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (counterexampleMeasure n) (fun i x ↦ x i) ≤ ENNReal.ofReal C ∧
      (counterexampleMeasure n).real
          {x | |NumStability.vecNorm2 x - Real.sqrt n| ≥ Real.sqrt n} = 1 := by
  rcases
      NumStability.HDP.Vector.Spherical.sphericalVector_isSubGaussian_psiTwoNorm_le with
    ⟨C, hC, hSphere⟩
  refine ⟨2 * C, by positivity, ?_⟩
  intro n hn
  have hProbability := counterexampleMeasure_isProbabilityMeasure hn
  letI : IsProbabilityMeasure (counterexampleMeasure n) := hProbability
  have hBound : NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
      (counterexampleMeasure n) (fun i x ↦ x i) ≤ ENNReal.ofReal (2 * C) := by
    calc
      _ = NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
          (modelMeasure n) (modelVector n) :=
        counterexampleMeasure_psiTwoNorm_eq_model n
      _ ≤ ENNReal.ofReal 2 *
          NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
            (NumStability.HDP.Vector.Spherical.sphericalVectorMeasure n)
            (fun i x ↦ x i) := modelVector_psiTwoNorm_le_spherical n
      _ ≤ ENNReal.ofReal 2 * ENNReal.ofReal C :=
        mul_le_mul_right (hSphere n hn).2 _
      _ = ENNReal.ofReal (2 * C) := by
        rw [ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 2)]
  exact ⟨hProbability, counterexampleMeasure_isIsotropic hn,
    NumStability.HDP.Vector.SubGaussian.isSubGaussian_of_psiTwoNorm_lt_top
      (hBound.trans_lt ENNReal.ofReal_lt_top), hBound,
    counterexampleMeasure_norm_deviation_one hn⟩

end NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration
