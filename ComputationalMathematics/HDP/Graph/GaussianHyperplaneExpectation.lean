import ComputationalMathematics.HDP.Graph.HyperplaneApproximation
import ComputationalMathematics.HDP.Graph.RandomizedRounding
import ComputationalMathematics.HDP.Vector.LinearMarginals
import ComputationalMathematics.HDP.Vector.SphericalSubGaussian
import ComputationalMathematics.Analysis.Probability.Gaussian.Planar

/-!
# Gaussian hyperplane-rounding expectations

This module isolates the integration plumbing in Theorem 3.6.5.  The only
remaining probabilistic input is the pairwise sign-correlation formula stated
by `HasGrothendieckSignCorrelation`.
-/

namespace NumStability.HDP.Graph

open MeasureTheory ProbabilityTheory
open scoped BigOperators InnerProductSpace

noncomputable section

theorem measurable_hyperplaneSign_value {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) :
    Measurable (fun g : Fin n → ℝ ↦
      (hyperplaneSign u (WithLp.toLp 2 g)).value) := by
  simp only [hyperplaneSign_value]
  apply Measurable.ite
  · exact measurableSet_lt (by fun_prop) measurable_const
  · exact measurable_const
  · exact measurable_const

theorem integrable_hyperplaneSign_value_mul {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) :
    Integrable (fun g : Fin n → ℝ ↦
      (hyperplaneSign u (WithLp.toLp 2 g)).value *
        (hyperplaneSign v (WithLp.toLp 2 g)).value)
      (NumStability.standardGaussianVectorMeasure n) := by
  apply Integrable.of_bound
    ((measurable_hyperplaneSign_value u).mul
      (measurable_hyperplaneSign_value v)).aestronglyMeasurable 1
  filter_upwards with g
  cases hyperplaneSign u (WithLp.toLp 2 g) <;>
    cases hyperplaneSign v (WithLp.toLp 2 g) <;> norm_num

/-- A standard Gaussian has zero probability of landing on the hyperplane
orthogonal to a unit vector. -/
theorem standardGaussian_inner_eq_zero {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) :
    (NumStability.standardGaussianVectorMeasure n)
        {g : Fin n → ℝ | ⟪u, WithLp.toLp 2 g⟫_ℝ = 0} = 0 := by
  let ud : NumStability.HDP.Vector.SubGaussian.UnitDirection n :=
    ⟨fun i ↦ u i, by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact hu⟩
  let f : (Fin n → ℝ) → ℝ := fun g ↦ ∑ i, ud.1 i * g i
  have hf : Measurable f := by
    dsimp [f]
    fun_prop
  have hinner : (fun g : Fin n → ℝ ↦ ⟪u, WithLp.toLp 2 g⟫_ℝ) = f := by
    funext g
    rw [PiLp.inner_apply]
    apply Finset.sum_congr rfl
    intro i _hi
    simpa [ud, f] using (RCLike.inner_apply' (u i) (g i))
  have hLaw := NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw ud
  rw [show {g : Fin n → ℝ | ⟪u, WithLp.toLp 2 g⟫_ℝ = 0} =
      f ⁻¹' ({0} : Set ℝ) by
    ext g
    simp [← hinner]]
  rw [← Measure.map_apply hf (measurableSet_singleton 0), hLaw.map_eq]
  letI : NoAtoms (gaussianReal 0 1) := noAtoms_gaussianReal one_ne_zero
  exact measure_singleton 0

/-- Away from its null tie event, the two-valued rounding label agrees with
the usual real sign. -/
theorem hyperplaneSign_value_ae_eq_real_sign {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) :
    (fun g : Fin n → ℝ ↦
        (hyperplaneSign u (WithLp.toLp 2 g)).value) =ᵐ[NumStability.standardGaussianVectorMeasure n]
    (fun g : Fin n → ℝ ↦ Real.sign ⟪u, WithLp.toLp 2 g⟫_ℝ) := by
  have hzero := standardGaussian_inner_eq_zero u hu
  filter_upwards [measure_eq_zero_iff_ae_notMem.mp hzero] with g hg
  apply hyperplaneSign_value_eq_real_sign
  simpa using hg

/-- The pairwise correlation of two Gaussian hyperplane signs. -/
def gaussianHyperplaneSignCorrelation {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) : ℝ :=
  ∫ g : Fin n → ℝ,
    (hyperplaneSign u (WithLp.toLp 2 g)).value *
      (hyperplaneSign v (WithLp.toLp 2 g)).value
    ∂NumStability.standardGaussianVectorMeasure n

/-- The measurable event that a Gaussian hyperplane separates two vectors. -/
def gaussianHyperplaneOppositeSet {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) : Set (Fin n → ℝ) :=
  {g | hyperplaneSign u (WithLp.toLp 2 g) ≠
    hyperplaneSign v (WithLp.toLp 2 g)}

theorem measurableSet_gaussianHyperplaneOppositeSet {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) :
    MeasurableSet (gaussianHyperplaneOppositeSet u v) := by
  have hset : gaussianHyperplaneOppositeSet u v =
      {g : Fin n → ℝ |
        (hyperplaneSign u (WithLp.toLp 2 g)).value ≠
          (hyperplaneSign v (WithLp.toLp 2 g)).value} := by
    ext g
    cases hu : hyperplaneSign u (WithLp.toLp 2 g) <;>
      cases hv : hyperplaneSign v (WithLp.toLp 2 g) <;>
      simp only [gaussianHyperplaneOppositeSet, Set.mem_setOf_eq, hu, hv,
        NumStability.HDP.Optimization.Sign.value_neg,
        NumStability.HDP.Optimization.Sign.value_pos, ne_eq,
        not_true_eq_false] <;> norm_num <;> decide
  rw [hset]
  exact (measurableSet_eq_fun (measurable_hyperplaneSign_value u)
    (measurable_hyperplaneSign_value v)).compl

/-- The probability that a standard Gaussian hyperplane separates two
vectors. -/
def gaussianHyperplaneOppositeProbability {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) : ℝ :=
  (NumStability.standardGaussianVectorMeasure n).real
    (gaussianHyperplaneOppositeSet u v)

/-- The corresponding separation event on the Euclidean unit sphere. -/
def sphereHyperplaneOppositeSet {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) :
    Set (NumStability.OrthogonalSphere n) :=
  {x | hyperplaneSign u (x : EuclideanSpace ℝ (Fin n)) ≠
    hyperplaneSign v (x : EuclideanSpace ℝ (Fin n))}

theorem measurable_sphereHyperplaneSign_value {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) :
    Measurable (fun x : NumStability.OrthogonalSphere n ↦
      (hyperplaneSign u (x : EuclideanSpace ℝ (Fin n))).value) := by
  simp only [hyperplaneSign_value]
  apply Measurable.ite
  · exact measurableSet_lt (by fun_prop) measurable_const
  · exact measurable_const
  · exact measurable_const

theorem measurableSet_sphereHyperplaneOppositeSet {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) :
    MeasurableSet (sphereHyperplaneOppositeSet u v) := by
  have hset : sphereHyperplaneOppositeSet u v =
      {x : NumStability.OrthogonalSphere n |
        (hyperplaneSign u (x : EuclideanSpace ℝ (Fin n))).value ≠
          (hyperplaneSign v (x : EuclideanSpace ℝ (Fin n))).value} := by
    ext x
    cases hu : hyperplaneSign u (x : EuclideanSpace ℝ (Fin n)) <;>
      cases hv : hyperplaneSign v (x : EuclideanSpace ℝ (Fin n)) <;>
      simp only [sphereHyperplaneOppositeSet, Set.mem_setOf_eq, hu, hv,
        NumStability.HDP.Optimization.Sign.value_neg,
        NumStability.HDP.Optimization.Sign.value_pos, ne_eq,
        not_true_eq_false] <;> norm_num <;> decide
  rw [hset]
  exact (measurableSet_eq_fun (measurable_sphereHyperplaneSign_value u)
    (measurable_sphereHyperplaneSign_value v)).compl

/-- Positive radial normalization does not change a nonzero vector's
hyperplane label. -/
theorem hyperplaneSign_gaussianUnitDirection_of_ne_zero (d : ℕ)
    (u : EuclideanSpace ℝ (Fin (d + 1)))
    (g : Fin (d + 1) → ℝ) (hg : g ≠ 0) :
    hyperplaneSign u
        (NumStability.gaussianUnitDirection d g :
          EuclideanSpace ℝ (Fin (d + 1))) =
      hyperplaneSign u (WithLp.toLp 2 g) := by
  have hnorm : 0 < ‖WithLp.toLp 2 g‖ := by
    rw [norm_pos_iff]
    intro h
    apply hg
    simpa using congrArg WithLp.ofLp h
  have hinv : 0 < ‖WithLp.toLp 2 g‖⁻¹ := inv_pos.mpr hnorm
  change hyperplaneSign u (NumStability.gaussianUnitDirectionValue d g) = _
  unfold NumStability.gaussianUnitDirectionValue
  rw [if_neg hg]
  unfold hyperplaneSign
  rw [inner_smul_right]
  change (if ‖WithLp.toLp 2 g‖⁻¹ * ⟪u, WithLp.toLp 2 g⟫_ℝ < 0 then _ else _) = _
  by_cases hinner : ⟪u, WithLp.toLp 2 g⟫_ℝ < 0
  · have hmul : ‖WithLp.toLp 2 g‖⁻¹ * ⟪u, WithLp.toLp 2 g⟫_ℝ < 0 :=
      mul_neg_of_pos_of_neg hinv hinner
    simp [hinner, hmul]
  · have hmul : ¬‖WithLp.toLp 2 g‖⁻¹ * ⟪u, WithLp.toLp 2 g⟫_ℝ < 0 := by
      rw [mul_neg_iff]
      simp [hinv, not_lt_of_ge hinv.le, hinner]
    simp [hinner, hmul]

/-- Exercise 3.6.7 depends only on the uniform spherical direction of the
Gaussian sample; its radial distribution has been removed. -/
theorem gaussianHyperplaneOppositeProbability_eq_uniformUnitSphereProbability
    (d : ℕ) (u v : EuclideanSpace ℝ (Fin (d + 1))) :
    gaussianHyperplaneOppositeProbability u v =
      (@NumStability.HDP.Vector.Spherical.uniformUnitSphereMeasure (d + 1)).real
        (sphereHyperplaneOppositeSet u v) := by
  unfold gaussianHyperplaneOppositeProbability
  rw [← NumStability.HDP.Vector.Gaussian.standardGaussianDirectionMeasure_eq_uniformUnitSphereMeasure d]
  unfold NumStability.standardGaussianDirectionMeasure
  rw [measureReal_def, measureReal_def]
  rw [Measure.map_apply (NumStability.measurable_gaussianUnitDirection d)
    (measurableSet_sphereHyperplaneOppositeSet u v)]
  apply congrArg ENNReal.toReal
  apply measure_congr
  have hne : ∀ᵐ g ∂NumStability.standardGaussianVectorMeasure (d + 1), g ≠ 0 := by
    rw [ae_iff]
    simpa only [not_ne_iff, Set.setOf_eq_eq_singleton] using
      NumStability.standardGaussianVectorMeasure_singleton_zero d
  filter_upwards [hne] with g hg
  apply propext
  change (hyperplaneSign u (WithLp.toLp 2 g) ≠
      hyperplaneSign v (WithLp.toLp 2 g)) ↔
    (hyperplaneSign u
        (NumStability.gaussianUnitDirection d g :
          EuclideanSpace ℝ (Fin (d + 1))) ≠
      hyperplaneSign v
        (NumStability.gaussianUnitDirection d g :
          EuclideanSpace ℝ (Fin (d + 1))))
  rw [hyperplaneSign_gaussianUnitDirection_of_ne_zero d u g hg,
    hyperplaneSign_gaussianUnitDirection_of_ne_zero d v g hg]

theorem hyperplaneSign_value_mul_eq_one_sub_two_indicator {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) (g : Fin n → ℝ) :
    (hyperplaneSign u (WithLp.toLp 2 g)).value *
        (hyperplaneSign v (WithLp.toLp 2 g)).value =
      1 - 2 * (gaussianHyperplaneOppositeSet u v).indicator
        (fun _ : Fin n → ℝ ↦ (1 : ℝ)) g := by
  cases hu : hyperplaneSign u (WithLp.toLp 2 g) <;>
    cases hv : hyperplaneSign v (WithLp.toLp 2 g) <;>
    simp [gaussianHyperplaneOppositeSet, Set.indicator, hu, hv] <;> norm_num

/-- Correlation equals one minus twice the probability of opposite signs.
This is the algebraic part of Exercise 3.6.7 and isolates its geometric
content as the measure of a planar wedge. -/
theorem gaussianHyperplaneSignCorrelation_eq_one_sub_two_mul_oppositeProbability
    {n : ℕ} (u v : EuclideanSpace ℝ (Fin n)) :
    gaussianHyperplaneSignCorrelation u v =
      1 - 2 * gaussianHyperplaneOppositeProbability u v := by
  let s := gaussianHyperplaneOppositeSet u v
  have hs : MeasurableSet s := measurableSet_gaussianHyperplaneOppositeSet u v
  have hi : Integrable (s.indicator (fun _ : Fin n → ℝ ↦ (1 : ℝ)))
      (NumStability.standardGaussianVectorMeasure n) :=
    (integrable_const (1 : ℝ)).indicator hs
  unfold gaussianHyperplaneSignCorrelation
  rw [show (fun g : Fin n → ℝ ↦
      (hyperplaneSign u (WithLp.toLp 2 g)).value *
        (hyperplaneSign v (WithLp.toLp 2 g)).value) =
      (fun g ↦ 1 - 2 * s.indicator (fun _ ↦ (1 : ℝ)) g) by
    funext g
    exact hyperplaneSign_value_mul_eq_one_sub_two_indicator u v g]
  rw [integral_sub (integrable_const (1 : ℝ)) (hi.const_mul 2),
    integral_const_mul]
  have hind :
      (∫ g : Fin n → ℝ, s.indicator (fun _ ↦ (1 : ℝ)) g
        ∂NumStability.standardGaussianVectorMeasure n) =
      (NumStability.standardGaussianVectorMeasure n).real s := by
    simpa only [Pi.one_apply] using
      (integral_indicator_one (μ := NumStability.standardGaussianVectorMeasure n) hs)
  rw [hind]
  simp [s, gaussianHyperplaneOppositeProbability]

/-- Exercise 3.6.7 implies the arcsine correlation formula after elementary
trigonometric algebra. -/
theorem grothendieckSignCorrelation_of_oppositeProbability_eq_angle_div_pi
    {n : ℕ} (u v : EuclideanSpace ℝ (Fin n))
    (hprob : gaussianHyperplaneOppositeProbability u v =
      Real.arccos ⟪u, v⟫_ℝ / Real.pi) :
    gaussianHyperplaneSignCorrelation u v =
      2 / Real.pi * Real.arcsin ⟪u, v⟫_ℝ := by
  rw [gaussianHyperplaneSignCorrelation_eq_one_sub_two_mul_oppositeProbability,
    hprob, Real.arccos_eq_pi_div_two_sub_arcsin]
  field_simp [Real.pi_ne_zero]
  ring

/-- The pairwise correlation can be written using the ordinary real sign once
the two unit-marginal tie events are removed. -/
theorem gaussianHyperplaneSignCorrelation_eq_integral_real_sign {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) (
      hu : ‖u‖ = 1) (hv : ‖v‖ = 1) :
    gaussianHyperplaneSignCorrelation u v =
      ∫ g : Fin n → ℝ,
        Real.sign ⟪u, WithLp.toLp 2 g⟫_ℝ *
          Real.sign ⟪v, WithLp.toLp 2 g⟫_ℝ
        ∂NumStability.standardGaussianVectorMeasure n := by
  unfold gaussianHyperplaneSignCorrelation
  apply integral_congr_ae
  exact (hyperplaneSign_value_ae_eq_real_sign u hu).mul
    (hyperplaneSign_value_ae_eq_real_sign v hv)

theorem gaussianHyperplaneSignCorrelation_self {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) :
    gaussianHyperplaneSignCorrelation u u = 1 := by
  unfold gaussianHyperplaneSignCorrelation
  have hpoint (g : Fin n → ℝ) :
      (hyperplaneSign u (WithLp.toLp 2 g)).value *
        (hyperplaneSign u (WithLp.toLp 2 g)).value = 1 := by
    cases hyperplaneSign u (WithLp.toLp 2 g) <;> norm_num; rfl
  simp_rw [hpoint]
  simp

theorem gaussianHyperplaneSignCorrelation_neg_self {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) :
    gaussianHyperplaneSignCorrelation u (-u) = -1 := by
  rw [gaussianHyperplaneSignCorrelation_eq_integral_real_sign u (-u) hu (by simpa)]
  calc
    (∫ g : Fin n → ℝ,
        Real.sign ⟪u, WithLp.toLp 2 g⟫_ℝ *
          Real.sign ⟪-u, WithLp.toLp 2 g⟫_ℝ
        ∂NumStability.standardGaussianVectorMeasure n) =
      ∫ _g : Fin n → ℝ, (-1 : ℝ)
        ∂NumStability.standardGaussianVectorMeasure n := by
      apply integral_congr_ae
      have hzero := standardGaussian_inner_eq_zero u hu
      filter_upwards [measure_eq_zero_iff_ae_notMem.mp hzero] with g hg
      have hne : ⟪u, WithLp.toLp 2 g⟫_ℝ ≠ 0 := by simpa using hg
      rw [inner_neg_left, Real.sign_neg]
      rcases Real.sign_apply_eq_of_ne_zero _ hne with hs | hs <;> rw [hs] <;> norm_num
    _ = -1 := by simp

/-- The correlation identity at coincident unit vectors. -/
theorem grothendieckSignCorrelation_self {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) :
    gaussianHyperplaneSignCorrelation u u =
      2 / Real.pi * Real.arcsin ⟪u, u⟫_ℝ := by
  rw [gaussianHyperplaneSignCorrelation_self, real_inner_self_eq_norm_sq, hu,
    one_pow, Real.arcsin_one]
  field_simp [Real.pi_ne_zero]

/-- The correlation identity at antipodal unit vectors. -/
theorem grothendieckSignCorrelation_neg_self {n : ℕ}
    (u : EuclideanSpace ℝ (Fin n)) (hu : ‖u‖ = 1) :
    gaussianHyperplaneSignCorrelation u (-u) =
      2 / Real.pi * Real.arcsin ⟪u, -u⟫_ℝ := by
  rw [gaussianHyperplaneSignCorrelation_neg_self u hu, inner_neg_right,
    real_inner_self_eq_norm_sq, hu, one_pow, Real.arcsin_neg_one]
  field_simp [Real.pi_ne_zero]

/-- Exercise 3.6.7: a standard Gaussian hyperplane separates two unit
vectors with probability equal to their angle divided by `π`. -/
theorem gaussianHyperplaneOppositeProbability_eq_angle_div_pi
    {n : ℕ} (u v : EuclideanSpace ℝ (Fin n))
    (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) :
    gaussianHyperplaneOppositeProbability u v =
      Real.arccos ⟪u, v⟫_ℝ / Real.pi := by
  by_cases huv : u = v
  · subst v
    have hprob : gaussianHyperplaneOppositeProbability u u = 0 := by
      have hcorr :=
        gaussianHyperplaneSignCorrelation_eq_one_sub_two_mul_oppositeProbability u u
      rw [gaussianHyperplaneSignCorrelation_self] at hcorr
      linarith
    rw [hprob, real_inner_self_eq_norm_sq, hu, one_pow, Real.arccos_one]
    norm_num
  by_cases huvneg : v = -u
  · rw [huvneg]
    have hprob : gaussianHyperplaneOppositeProbability u (-u) = 1 := by
      have hcorr :=
        gaussianHyperplaneSignCorrelation_eq_one_sub_two_mul_oppositeProbability u (-u)
      rw [gaussianHyperplaneSignCorrelation_neg_self u hu] at hcorr
      linarith
    rw [hprob, inner_neg_right, real_inner_self_eq_norm_sq, hu, one_pow,
      Real.arccos_neg_one]
    field_simp [Real.pi_ne_zero]
  let rho : ℝ := ⟪u, v⟫_ℝ
  have hrhoLower : -1 ≤ rho :=
    neg_one_le_real_inner_of_norm_eq_one hu hv
  have hrhoUpper : rho ≤ 1 :=
    real_inner_le_one_of_norm_eq_one hu hv
  have hrhoLt : rho < 1 := by
    apply lt_of_le_of_ne hrhoUpper
    intro hrho
    apply huv
    exact (inner_eq_one_iff_of_norm_eq_one hu hv).mp hrho
  have hrhoGt : -1 < rho := by
    apply lt_of_le_of_ne hrhoLower
    intro hrho
    have hinner : ⟪-u, v⟫_ℝ = 1 := by
      rw [inner_neg_left]
      linarith
    have hneg : -u = v :=
      (inner_eq_one_iff_of_norm_eq_one (by simpa using hu) hv).mp hinner
    exact huvneg hneg.symm
  let theta : ℝ := Real.arccos rho
  have hthetaPos : 0 < theta := Real.arccos_pos.mpr hrhoLt
  have hthetaLt : theta < Real.pi := Real.arccos_lt_pi.mpr hrhoGt
  have htheta : theta ∈ Set.Icc (0 : ℝ) Real.pi :=
    ⟨hthetaPos.le, hthetaLt.le⟩
  let s : ℝ := Real.sin theta
  have hsPos : 0 < s := Real.sin_pos_of_pos_of_lt_pi hthetaPos hthetaLt
  let residual : EuclideanSpace ℝ (Fin n) := v - rho • u
  have hresidualSq : ‖residual‖ ^ 2 = 1 - rho ^ 2 := by
    dsimp [residual]
    rw [norm_sub_sq_real, hv, norm_smul, hu, mul_one, Real.norm_eq_abs,
      real_inner_smul_right, real_inner_comm u v]
    change 1 ^ 2 - 2 * (rho * rho) + |rho| ^ 2 = 1 - rho ^ 2
    rw [sq_abs]
    ring
  have hsSq : s ^ 2 = 1 - rho ^ 2 := by
    dsimp [s, theta]
    rw [Real.sin_sq, Real.cos_arccos hrhoLower hrhoUpper]
  have hresidualNorm : ‖residual‖ = s := by
    nlinarith [norm_nonneg residual, hsPos.le]
  let w : EuclideanSpace ℝ (Fin n) := s⁻¹ • residual
  have hw : ‖w‖ = 1 := by
    dsimp [w]
    rw [norm_smul, hresidualNorm, Real.norm_eq_abs,
      abs_of_pos (inv_pos.mpr hsPos)]
    exact inv_mul_cancel₀ hsPos.ne'
  have huw : ⟪u, w⟫_ℝ = 0 := by
    dsimp [w, residual]
    rw [real_inner_smul_right, inner_sub_right, real_inner_smul_right,
      real_inner_self_eq_norm_sq, hu, one_pow]
    change s⁻¹ * (rho - rho * 1) = 0
    ring
  have hvDecomp : rho • u + s • w = v := by
    dsimp [w, residual]
    rw [smul_smul, mul_inv_cancel₀ hsPos.ne', one_smul]
    abel
  let U : (Fin n → ℝ) → ℝ := fun g => ∑ i, u i * g i
  let W : (Fin n → ℝ) → ℝ := fun g => ∑ i, w i * g i
  let ud : NumStability.HDP.Vector.SubGaussian.UnitDirection n :=
    ⟨fun i => u i, by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact hu⟩
  let wd : NumStability.HDP.Vector.SubGaussian.UnitDirection n :=
    ⟨fun i => w i, by
      rw [← NumStability.HDP.Vector.Spherical.norm_toLp_eq_vecNorm2]
      exact hw⟩
  have hULaw : HasLaw U (gaussianReal 0 1)
      (NumStability.standardGaussianVectorMeasure n) := by
    simpa [U, ud] using
      (NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw ud)
  have hWLaw : HasLaw W (gaussianReal 0 1)
      (NumStability.standardGaussianVectorMeasure n) := by
    simpa [W, wd] using
      (NumStability.HDP.Vector.Gaussian.unitWeightedGaussianLaw wd)
  have hsumOrth : ∑ i, (fun i => u i) i * (fun i => w i) i = 0 := by
    rw [PiLp.inner_apply] at huw
    calc
      ∑ i, u i * w i = ∑ i, ⟪u i, w i⟫_ℝ := by
        apply Finset.sum_congr rfl
        intro i _hi
        symm
        simpa using (RCLike.inner_apply' (u i) (w i))
      _ = 0 := huw
  have hIndep : IndepFun U W
      (NumStability.standardGaussianVectorMeasure n) := by
    have h :=
      NumStability.HDP.Vector.Gaussian.indepFun_linearMarginals_of_isStandardNormal
        (NumStability.HDP.Vector.Gaussian.canonical_isStandardNormal n)
        (fun i => u i) (fun i => w i) hsumOrth
    have hU : NumStability.HDP.Vector.linearMarginal
        (fun i (g : Fin n → ℝ) => g i) (fun i => u i) = U := by
      funext g
      simp only [NumStability.HDP.Vector.linearMarginal, U]
      apply Finset.sum_congr rfl
      intro i _hi
      ring
    have hW : NumStability.HDP.Vector.linearMarginal
        (fun i (g : Fin n → ℝ) => g i) (fun i => w i) = W := by
      funext g
      simp only [NumStability.HDP.Vector.linearMarginal, W]
      apply Finset.sum_congr rfl
      intro i _hi
      ring
    rwa [hU, hW] at h
  have hinnerU (g : Fin n → ℝ) :
      ⟪u, WithLp.toLp 2 g⟫_ℝ = U g := by
    rw [PiLp.inner_apply]
    apply Finset.sum_congr rfl
    intro i _hi
    simpa [U] using (RCLike.inner_apply' (u i) (g i))
  have hinnerW (g : Fin n → ℝ) :
      ⟪w, WithLp.toLp 2 g⟫_ℝ = W g := by
    rw [PiLp.inner_apply]
    apply Finset.sum_congr rfl
    intro i _hi
    simpa [W] using (RCLike.inner_apply' (w i) (g i))
  have hcos : Real.cos theta = rho := by
    exact Real.cos_arccos hrhoLower hrhoUpper
  have hevent : gaussianHyperplaneOppositeSet u v =
      {g : Fin n → ℝ |
        (U g < 0) ≠
          (Real.cos theta * U g + Real.sin theta * W g < 0)} := by
    ext g
    have hvinner : ⟪v, WithLp.toLp 2 g⟫_ℝ =
        Real.cos theta * U g + Real.sin theta * W g := by
      rw [← hvDecomp, inner_add_left, real_inner_smul_left,
        real_inner_smul_left, hinnerU, hinnerW, hcos]
    change (hyperplaneSign u (WithLp.toLp 2 g) ≠
        hyperplaneSign v (WithLp.toLp 2 g)) ↔ _
    unfold hyperplaneSign
    rw [hinnerU, hvinner]
    by_cases hleft : U g < 0 <;>
      by_cases hright : Real.cos theta * U g + Real.sin theta * W g < 0 <;>
      simp [hleft, hright]
  unfold gaussianHyperplaneOppositeProbability
  rw [hevent]
  exact
    NumStability.Analysis.Probability.Gaussian.oppositeProbability_of_indep_standardGaussian
      (NumStability.standardGaussianVectorMeasure n) U W hULaw hWLaw hIndep htheta

/-- Lemma 3.6.6, Grothendieck's identity, for two arbitrary unit vectors. -/
theorem grothendieckSignCorrelation {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n))
    (hu : ‖u‖ = 1) (hv : ‖v‖ = 1) :
    gaussianHyperplaneSignCorrelation u v =
      2 / Real.pi * Real.arcsin ⟪u, v⟫_ℝ := by
  apply grothendieckSignCorrelation_of_oppositeProbability_eq_angle_div_pi
  exact gaussianHyperplaneOppositeProbability_eq_angle_div_pi u v hu hv

/-- Matrix form of the cut objective, separated from the graph wrapper so the
expectation algebra applies to arbitrary weights. -/
def signCutValueOfMatrix {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (x : NumStability.HDP.Optimization.SignVector n) : ℝ :=
  (1 / 4 : ℝ) * ∑ i, ∑ j,
    A i j * (1 - (x i).value * (x j).value)

/-- The expected cut objective produced by Gaussian hyperplane rounding. -/
def gaussianHyperplaneCutExpectation {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) : ℝ :=
  ∫ g : Fin n → ℝ,
    signCutValueOfMatrix A
      (hyperplaneRounding X (WithLp.toLp 2 g))
    ∂NumStability.standardGaussianVectorMeasure n

theorem gaussianHyperplaneCutExpectation_eq_correlation_sum {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    gaussianHyperplaneCutExpectation A X =
      (1 / 4 : ℝ) * ∑ i, ∑ j,
        A i j * (1 - gaussianHyperplaneSignCorrelation
          (X i : EuclideanSpace ℝ (Fin n))
          (X j : EuclideanSpace ℝ (Fin n))) := by
  have hprod (i j : Fin n) : Integrable (fun g : Fin n → ℝ ↦
      (hyperplaneSign (X i) (WithLp.toLp 2 g)).value *
        (hyperplaneSign (X j) (WithLp.toLp 2 g)).value)
      (NumStability.standardGaussianVectorMeasure n) :=
    integrable_hyperplaneSign_value_mul
      (X i : EuclideanSpace ℝ (Fin n))
      (X j : EuclideanSpace ℝ (Fin n))
  have hsub (i j : Fin n) : Integrable (fun g : Fin n → ℝ ↦
      1 - (hyperplaneSign (X i) (WithLp.toLp 2 g)).value *
        (hyperplaneSign (X j) (WithLp.toLp 2 g)).value)
      (NumStability.standardGaussianVectorMeasure n) :=
    (integrable_const (1 : ℝ)).sub (hprod i j)
  unfold gaussianHyperplaneCutExpectation signCutValueOfMatrix
  rw [integral_const_mul]
  rw [integral_finset_sum]
  · apply congrArg
    apply Finset.sum_congr rfl
    intro i _hi
    rw [integral_finset_sum]
    · apply Finset.sum_congr rfl
      intro j _hj
      rw [integral_const_mul]
      change A i j *
          (∫ g : Fin n → ℝ,
            (1 - (hyperplaneSign (X i) (WithLp.toLp 2 g)).value *
              (hyperplaneSign (X j) (WithLp.toLp 2 g)).value)
            ∂NumStability.standardGaussianVectorMeasure n) = _
      congr 1
      rw [integral_sub (integrable_const (1 : ℝ)) (hprod i j)]
      simp [gaussianHyperplaneSignCorrelation]
    · intro j _hj
      exact (hsub i j).const_mul (A i j)
  · intro i _hi
    apply integrable_finset_sum
    intro j _hj
    exact (hsub i j).const_mul (A i j)

/-- The exact pairwise identity required from Lemma 3.6.6. -/
def HasGrothendieckSignCorrelation {n : ℕ}
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) : Prop :=
  ∀ i j, gaussianHyperplaneSignCorrelation
      (X i : EuclideanSpace ℝ (Fin n))
      (X j : EuclideanSpace ℝ (Fin n)) =
    2 / Real.pi *
      Real.arcsin ⟪(X i : EuclideanSpace ℝ (Fin n)), X j⟫_ℝ

theorem hasGrothendieckSignCorrelation {n : ℕ}
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    HasGrothendieckSignCorrelation X := by
  intro i j
  apply grothendieckSignCorrelation
  · simp
  · simp

/-- Grothendieck's pairwise sign-correlation identity converts the actual
Gaussian rounding expectation into the deterministic arccos value. -/
theorem gaussianHyperplaneCutExpectation_eq_arccosRoundingValue
    {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (X : NumStability.HDP.Optimization.UnitVectorFamily n)
    (hX : HasGrothendieckSignCorrelation X) :
    gaussianHyperplaneCutExpectation A X = arccosRoundingValue A X := by
  rw [gaussianHyperplaneCutExpectation_eq_correlation_sum]
  unfold arccosRoundingValue
  congr 1
  apply Finset.sum_congr rfl
  intro i _hi
  apply Finset.sum_congr rfl
  intro j _hj
  rw [hX i j, Real.arccos_eq_pi_div_two_sub_arcsin]
  field_simp [Real.pi_ne_zero]

theorem signCutValueOfMatrix_adjMatrix {n : ℕ}
    (G : SimpleGraph (Fin n)) [DecidableRel G.Adj]
    (x : NumStability.HDP.Optimization.SignVector n) :
    signCutValueOfMatrix (G.adjMatrix ℝ) x = signCutValue G x :=
  rfl

/-- For an adjacency matrix, the matrix expectation is literally the expected
graph cut value appearing in Theorem 3.6.5. -/
theorem gaussianHyperplaneCutExpectation_adjMatrix {n : ℕ}
    (G : SimpleGraph (Fin n)) [DecidableRel G.Adj]
    (X : NumStability.HDP.Optimization.UnitVectorFamily n) :
    gaussianHyperplaneCutExpectation (G.adjMatrix ℝ) X =
      ∫ g : Fin n → ℝ,
        signCutValue G (hyperplaneRounding X (WithLp.toLp 2 g))
        ∂NumStability.standardGaussianVectorMeasure n :=
  rfl

/-- Theorem 3.6.5 reduced exactly to Grothendieck's pairwise identity. -/
theorem goemansWilliamson_approximation_of_grothendieckSignCorrelation
    {n : ℕ} [Nonempty (Fin n)] (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj]
    (hCorr : HasGrothendieckSignCorrelation
      (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ))) :
    (439 / 500 : ℝ) * (maxCut G : ℝ) ≤
        (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ∧
      (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ≤
        gaussianHyperplaneCutExpectation (G.adjMatrix ℝ)
          (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ)) := by
  obtain ⟨hcut, hsdp⟩ := goemansWilliamson_deterministic_approximation_chain G
  refine ⟨hcut, ?_⟩
  rw [gaussianHyperplaneCutExpectation_eq_arccosRoundingValue _ _ hCorr]
  exact hsdp

/-- Gaussian hyperplane rounding satisfies the Goemans--Williamson chain for
every supplied optimizer of the semidefinite relaxation.  Keeping the
optimizer as an explicit argument matches the algorithmic theorem: the bound
does not depend on which maximizing family was selected. -/
theorem goemansWilliamson_approximation_of_optimizer
    {n : ℕ} (G : SimpleGraph (Fin n)) [DecidableRel G.Adj]
    (X : NumStability.HDP.Optimization.UnitVectorFamily n)
    (hX : maxCutSemidefiniteValue (G.adjMatrix ℝ) X =
      maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ)) :
    (439 / 500 : ℝ) * (maxCut G : ℝ) ≤
        (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ∧
      (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ≤
        gaussianHyperplaneCutExpectation (G.adjMatrix ℝ) X := by
  have hcut : (439 / 500 : ℝ) * (maxCut G : ℝ) ≤
      (439 / 500 : ℝ) *
        maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) := by
    cases n with
    | zero =>
        simp [maxCut, maxCutSemidefiniteOptimalValue,
          maxCutSemidefiniteValue]
    | succ n =>
        letI : Nonempty (Fin (n + 1)) := inferInstance
        exact mul_le_mul_of_nonneg_left
          (maxCut_le_maxCutSemidefiniteOptimalValue G) (by norm_num)
  refine ⟨hcut, ?_⟩
  rw [← hX]
  calc
    (439 / 500 : ℝ) * maxCutSemidefiniteValue (G.adjMatrix ℝ) X ≤
        arccosRoundingValue (G.adjMatrix ℝ) X := by
      apply goemansWilliamson_mul_maxCutSemidefiniteValue_le_arccosRoundingValue
      intro i j
      by_cases hij : G.Adj i j <;> simp [hij]
    _ = gaussianHyperplaneCutExpectation (G.adjMatrix ℝ) X :=
      (gaussianHyperplaneCutExpectation_eq_arccosRoundingValue
        _ _ (hasGrothendieckSignCorrelation X)).symm

/-- Theorem 3.6.5: Gaussian hyperplane rounding of an optimal semidefinite
solution achieves the `0.878` approximation chain. -/
theorem goemansWilliamson_approximation
    {n : ℕ} (G : SimpleGraph (Fin n))
    [DecidableRel G.Adj] :
    (439 / 500 : ℝ) * (maxCut G : ℝ) ≤
        (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ∧
      (439 / 500 : ℝ) *
          maxCutSemidefiniteOptimalValue (G.adjMatrix ℝ) ≤
        gaussianHyperplaneCutExpectation (G.adjMatrix ℝ)
          (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ)) := by
  exact goemansWilliamson_approximation_of_optimizer G
    (maxCutSemidefiniteOptimizer (G.adjMatrix ℝ)) rfl

end

end NumStability.HDP.Graph
