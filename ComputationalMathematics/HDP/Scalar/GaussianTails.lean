import ComputationalMathematics.HDP.Scalar.LimitTheorems
/-!
# Standard-normal tail estimates

Density and calculus foundations for the two-sided Mills-ratio estimate in
Proposition 2.1.2.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set Filter
open scoped ENNReal NNReal Topology

namespace NumStability.HDP.Scalar.GaussianTails

open NumStability.HDP.Scalar.LimitTheorems

/-- The upper tail of the standard-normal law is the integral of its printed
density over the open ray.  The endpoint does not matter because Lebesgue
measure has no atoms. -/
theorem standardNormalTail_eq_densityIntegral (t : ℝ) :
    standardNormalLaw.real (Ici t) =
      (Real.sqrt (2 * Real.pi))⁻¹ *
        ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by
  rw [Measure.real_def, standardNormalLaw,
    gaussianReal_apply_eq_integral 0 (by norm_num : (1 : ℝ≥0) ≠ 0) (Ici t)]
  rw [ENNReal.toReal_ofReal (integral_nonneg fun x ↦ gaussianPDFReal_nonneg 0 1 x)]
  rw [standardNormalLaw_pdf, integral_const_mul]
  rw [integral_Ici_eq_integral_Ioi]

/-- The elementary antiderivative identity used in the upper Gaussian-tail
bound. -/
theorem integral_Ioi_mul_exp_neg_sq_div_two (t : ℝ) :
    ∫ x in Ioi t, x * Real.exp (-(x ^ 2) / 2) =
      Real.exp (-(t ^ 2) / 2) := by
  let f : ℝ → ℝ := fun x ↦ -Real.exp (-(x ^ 2) / 2)
  let f' : ℝ → ℝ := fun x ↦ x * Real.exp (-(x ^ 2) / 2)
  have hderiv : ∀ x : ℝ, HasDerivAt f (f' x) x := by
    intro x
    have h := ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ))).exp.neg
    dsimp [f, f']
    convert h using 1
    · ext y
      congr 1
      ring
    · simp
      ring
  have hint : IntegrableOn f' (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_mul_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    dsimp [f']
    congr 1
    ring
  have htend : Tendsto f atTop (𝓝 0) := by
    have hpow : Tendsto (fun x : ℝ ↦ x ^ 2) atTop atTop :=
      tendsto_pow_atTop (by norm_num)
    have hinner : Tendsto (fun x : ℝ ↦ -(1 / 2 : ℝ) * x ^ 2) atTop atBot :=
      hpow.const_mul_atTop_of_neg (by norm_num)
    have hexp : Tendsto (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        atTop (𝓝 0) := Real.tendsto_exp_atBot.comp hinner
    convert hexp.neg using 1
    · ext x
      dsimp [f]
      congr 2
      ring
    · simp
  have hftc := integral_Ioi_of_hasDerivAt_of_tendsto'
    (fun x _ ↦ hderiv x) hint htend
  simpa only [f, f', zero_sub, neg_neg] using hftc

/-- The upper half of the unnormalized Mills-ratio estimate. -/
theorem gaussianIntegral_Ioi_le (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) ≤
      (1 / t) * Real.exp (-(t ^ 2) / 2) := by
  have hgauss : IntegrableOn (fun x : ℝ ↦ Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    apply congrArg Real.exp
    ring
  have hscaled : IntegrableOn
      (fun x : ℝ ↦ (1 / t) * (x * Real.exp (-(x ^ 2) / 2))) (Ioi t) := by
    have hmul : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
      have h : IntegrableOn (fun x : ℝ ↦ x * Real.exp (-(1 / 2 : ℝ) * x ^ 2))
          (Ioi t) := (integrable_mul_exp_neg_mul_sq
            (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
      apply h.congr
      filter_upwards [] with x
      congr 2
      ring
    exact hmul.const_mul _
  calc
    (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) ≤
        ∫ x in Ioi t, (1 / t) * (x * Real.exp (-(x ^ 2) / 2)) := by
      apply setIntegral_mono_on hgauss hscaled measurableSet_Ioi
      intro x hx
      have hratio : 1 ≤ (1 / t) * x := by
        have h' : 1 ≤ x / t := (le_div_iff₀ ht).2 (by simpa using le_of_lt hx)
        simpa [div_eq_mul_inv, mul_comm] using h'
      nlinarith [Real.exp_pos (-(x ^ 2) / 2)]
    _ = (1 / t) * ∫ x in Ioi t, x * Real.exp (-(x ^ 2) / 2) := by
      rw [integral_const_mul]
    _ = (1 / t) * Real.exp (-(t ^ 2) / 2) := by
      rw [integral_Ioi_mul_exp_neg_sq_div_two]

/-- Integration by parts with `x ↦ exp (-x² / 2) / x`.  This identity gives a
slightly stronger lower Mills-ratio bound than the one printed in Proposition
2.1.2. -/
theorem integral_Ioi_one_add_inv_sq_mul_exp_neg_sq_div_two (t : ℝ) (ht : 0 < t) :
    (∫ x in Ioi t, (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) =
      (1 / t) * Real.exp (-(t ^ 2) / 2) := by
  let f : ℝ → ℝ := fun x ↦ -(x⁻¹ * Real.exp (-(x ^ 2) / 2))
  let f' : ℝ → ℝ := fun x ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)
  have hderiv : ∀ x ∈ Ici t, HasDerivAt f (f' x) x := by
    intro x hx
    have hxpos : 0 < x := ht.trans_le hx
    have hexp := ((hasDerivAt_pow 2 x).const_mul (-(1 / 2 : ℝ))).exp
    have hinv := hasDerivAt_inv hxpos.ne'
    dsimp [f, f']
    convert (hinv.mul hexp).neg using 1
    · ext y
      congr 2
      ring
    · field_simp
      ring
  have hnonneg : ∀ x ∈ Ioi t, 0 ≤ f' x := by
    intro x hx
    dsimp [f']
    positivity
  have htend : Tendsto f atTop (𝓝 0) := by
    have hpow : Tendsto (fun x : ℝ ↦ x ^ 2) atTop atTop :=
      tendsto_pow_atTop (by norm_num)
    have hinner : Tendsto (fun x : ℝ ↦ -(1 / 2 : ℝ) * x ^ 2) atTop atBot :=
      hpow.const_mul_atTop_of_neg (by norm_num)
    have hexp : Tendsto (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        atTop (𝓝 0) := Real.tendsto_exp_atBot.comp hinner
    have hprod := (tendsto_inv_atTop_zero :
      Tendsto (fun x : ℝ ↦ x⁻¹) atTop (𝓝 0)).mul hexp
    convert hprod.neg using 1
    · ext x
      dsimp [f]
      congr 3
      ring
    · simp
  have hftc := integral_Ioi_of_hasDerivAt_of_nonneg' hderiv hnonneg htend
  simpa only [f, f', zero_sub, neg_neg, one_div] using hftc

/-- The lower half of the unnormalized Mills-ratio estimate, in the exact form
printed in Proposition 2.1.2. -/
theorem gaussianIntegral_Ioi_ge (t : ℝ) (ht : 0 < t) :
    (1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2) ≤
      ∫ x in Ioi t, Real.exp (-(x ^ 2) / 2) := by
  have hgauss : IntegrableOn (fun x : ℝ ↦ Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    have h : IntegrableOn (fun x : ℝ ↦ Real.exp (-(1 / 2 : ℝ) * x ^ 2))
        (Ioi t) := (integrable_exp_neg_mul_sq
          (by norm_num : (0 : ℝ) < 1 / 2)).integrableOn
    apply h.congr
    filter_upwards [] with x
    apply congrArg Real.exp
    ring
  let c : ℝ := 1 + 1 / t ^ 2
  have hcpos : 0 < c := by
    dsimp [c]
    positivity
  have hscaled : IntegrableOn
      (fun x : ℝ ↦ c * Real.exp (-(x ^ 2) / 2)) (Ioi t) := hgauss.const_mul c
  have hpoint : ∀ x ∈ Ioi t,
      (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2) ≤
        c * Real.exp (-(x ^ 2) / 2) := by
    intro x hx
    have hxpos : 0 < x := ht.trans hx
    have hsq : t ^ 2 ≤ x ^ 2 :=
      (sq_le_sq₀ ht.le hxpos.le).2 (le_of_lt hx)
    have hinv : 1 / x ^ 2 ≤ 1 / t ^ 2 :=
      one_div_le_one_div_of_le (sq_pos_of_pos ht) hsq
    exact mul_le_mul_of_nonneg_right (by simpa [c] using add_le_add_left hinv 1)
      (Real.exp_pos _).le
  have hleft : IntegrableOn
      (fun x : ℝ ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
    apply Integrable.mono hscaled
    · have hcont : ContinuousOn
          (fun x : ℝ ↦ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)) (Ioi t) := by
        intro x hx
        have hx0 : x ≠ 0 := (ht.trans hx).ne'
        have hinvcont : ContinuousAt (fun y : ℝ ↦ 1 / y ^ 2) x :=
          continuousAt_const.div₀ (continuousAt_id.pow 2) (pow_ne_zero 2 hx0)
        have hexpcont : ContinuousAt (fun y : ℝ ↦ Real.exp (-(y ^ 2) / 2)) x :=
          Real.continuous_exp.continuousAt.comp
            ((continuousAt_id.pow 2).neg.div_const (2 : ℝ))
        exact ((continuousAt_const.add hinvcont).mul hexpcont).continuousWithinAt
      exact hcont.aestronglyMeasurable measurableSet_Ioi
    · filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
      simp only [Real.norm_eq_abs]
      rw [abs_of_nonneg (by positivity :
        0 ≤ (1 + 1 / x ^ 2) * Real.exp (-(x ^ 2) / 2)),
        abs_of_nonneg (by positivity : 0 ≤ c * Real.exp (-(x ^ 2) / 2))]
      exact hpoint x hx
  have hmain : (1 / t) * Real.exp (-(t ^ 2) / 2) ≤
      c * (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) := by
    rw [← integral_const_mul]
    rw [← integral_Ioi_one_add_inv_sq_mul_exp_neg_sq_div_two t ht]
    exact setIntegral_mono_on hleft hscaled measurableSet_Ioi hpoint
  apply (mul_le_mul_iff_left₀ hcpos).mp
  calc
    ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) * c =
        ((1 / t - 1 / t ^ 3) * c) * Real.exp (-(t ^ 2) / 2) := by ring
    _ ≤ (1 / t) * Real.exp (-(t ^ 2) / 2) := by
      apply mul_le_mul_of_nonneg_right
      · dsimp [c]
        have hnonneg : 0 ≤ t⁻¹ ^ 5 := by positivity
        field_simp
        nlinarith
      · positivity
    _ ≤ c * (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) := hmain
    _ = (∫ x in Ioi t, Real.exp (-(x ^ 2) / 2)) * c := by ring

/-- Proposition 2.1.2: the standard-normal upper tail lies between the two
printed Mills-ratio expressions. -/
theorem standardNormalTail_bounds (t : ℝ) (ht : 0 < t) :
    (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Ici t) ∧
      standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2)) := by
  rw [standardNormalTail_eq_densityIntegral]
  constructor
  · exact mul_le_mul_of_nonneg_left (gaussianIntegral_Ioi_ge t ht) (by positivity)
  · exact mul_le_mul_of_nonneg_left (gaussianIntegral_Ioi_le t ht) (by positivity)

/-- Equation (2.3): above threshold one, the standard-normal upper tail is at
most the density evaluated at the threshold. -/
theorem standardNormalTail_le_density (t : ℝ) (ht : 1 ≤ t) :
    standardNormalLaw.real (Ici t) ≤
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) := by
  have htpos : 0 < t := zero_lt_one.trans_le ht
  have hinv : 1 / t ≤ 1 := (div_le_one htpos).2 ht
  calc
    standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2)) := (standardNormalTail_bounds t htpos).2
    _ ≤ (Real.sqrt (2 * Real.pi))⁻¹ *
          (1 * Real.exp (-(t ^ 2) / 2)) := by
      exact mul_le_mul_of_nonneg_left
        (mul_le_mul_of_nonneg_right hinv (Real.exp_pos _).le) (by positivity)
    _ = (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) := by ring

end NumStability.HDP.Scalar.GaussianTails
