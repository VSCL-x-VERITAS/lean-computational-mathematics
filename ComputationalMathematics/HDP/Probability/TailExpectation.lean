import ComputationalMathematics.HDP.Scalar.Preliminaries.Basic
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral

/-!
# Expectation bounds from Gaussian upper tails

Reusable layer-cake consequences for the expectation exercises in Chapter 4.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Probability

/-- A nonnegative integrable random variable with upper tail bounded by
`2 exp (-t²)` has expectation at most `sqrt π`. -/
theorem expectation_le_sqrt_pi_of_gaussian_upper_tail
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : Ω → ℝ}
    (hZ0 : ∀ ω, 0 ≤ Z ω) (hZInt : Integrable Z μ)
    (htail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | t < Z ω} ≤ 2 * Real.exp (-t ^ 2)) :
    (∫ ω, Z ω ∂μ) ≤ Real.sqrt Real.pi := by
  let F : ℝ → ℝ := fun t => μ.real {ω | t < Z ω}
  let G : ℝ → ℝ := fun t => 2 * Real.exp (-t ^ 2)
  have hFMeas : Measurable F := by
    dsimp [F, Measure.real]
    apply Measurable.ennreal_toReal
    exact Antitone.measurable fun s t hst =>
      measure_mono fun ω hω => lt_of_le_of_lt hst hω
  have hGInt : Integrable G volume := by
    have h := integrable_exp_neg_mul_sq (show (0 : ℝ) < 1 by norm_num)
    simpa [G] using h.const_mul 2
  have hFInt : Integrable F (volume.restrict (Ioi 0)) := by
    apply hGInt.integrableOn.mono' hFMeas.aestronglyMeasurable
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    simpa [F, G, Real.norm_eq_abs, abs_of_nonneg measureReal_nonneg] using htail ht
  have hmono :
      (∫ t in Ioi 0, F t) ≤ ∫ t in Ioi 0, G t := by
    apply integral_mono_ae hFInt hGInt.integrableOn
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    exact htail ht
  rw [hZInt.integral_eq_integral_meas_lt (Filter.Eventually.of_forall hZ0)]
  change (∫ t in Ioi 0, F t) ≤ _
  calc
    (∫ t in Ioi 0, F t) ≤ ∫ t in Ioi 0, G t := hmono
    _ = Real.sqrt Real.pi := by
      rw [show (∫ t in Ioi 0, G t) =
          2 * ∫ t in Ioi 0, Real.exp (-1 * t ^ 2) by
        simp only [G]
        rw [MeasureTheory.integral_const_mul]
        congr 2
        funext t
        ring_nf]
      rw [integral_gaussian_Ioi, div_one]
      nlinarith [Real.sqrt_nonneg Real.pi]

/-- An affine Gaussian upper-tail bound integrates to the corresponding
affine expectation bound. -/
theorem expectation_le_add_mul_sqrt_pi_of_gaussian_upper_tail
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hXInt : Integrable X μ) {a b : ℝ} (hb : 0 < b)
    (htail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | a + b * t < X ω} ≤ 2 * Real.exp (-t ^ 2)) :
    (∫ ω, X ω ∂μ) ≤ a + b * Real.sqrt Real.pi := by
  let Z : Ω → ℝ := fun ω => max ((X ω - a) / b) 0
  have hZ0 : ∀ ω, 0 ≤ Z ω := fun ω => le_max_right _ _
  have hZInt : Integrable Z μ := by
    dsimp [Z]
    exact (hXInt.sub (integrable_const a)).div_const b |>.pos_part
  have hZtail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | t < Z ω} ≤ 2 * Real.exp (-t ^ 2) := by
    intro t ht
    have hevent : {ω | t < Z ω} = {ω | a + b * t < X ω} := by
      ext ω
      dsimp [Z]
      rw [lt_max_iff]
      constructor
      · rintro (h | h)
        · have h' := (lt_div_iff₀ hb).mp h
          linarith
        · exact False.elim ((not_lt_of_ge ht.le) h)
      · intro h
        left
        apply (lt_div_iff₀ hb).2
        linarith
    rw [hevent]
    exact htail ht
  have hZE := expectation_le_sqrt_pi_of_gaussian_upper_tail hZ0 hZInt hZtail
  have hpoint : X ≤ fun ω => a + b * Z ω := by
    intro ω
    have hmax : (X ω - a) / b ≤ Z ω := le_max_left _ _
    have hmul := mul_le_mul_of_nonneg_left hmax hb.le
    have hbne : b ≠ 0 := hb.ne'
    field_simp [Z, hbne] at hmul
    linarith
  have hRhsInt : Integrable (fun ω => a + b * Z ω) μ :=
    (integrable_const a).add (hZInt.const_mul b)
  calc
    (∫ ω, X ω ∂μ) ≤ ∫ ω, (a + b * Z ω) ∂μ :=
      integral_mono hXInt hRhsInt hpoint
    _ = a + b * ∫ ω, Z ω ∂μ := by
      rw [integral_add (integrable_const a) (hZInt.const_mul b),
        integral_const, probReal_univ, one_smul, integral_const_mul]
    _ ≤ a + b * Real.sqrt Real.pi := by gcongr

/-- A nonnegative integrable random variable with upper tail bounded by
`2 exp (-t)` has expectation at most `2`. -/
theorem expectation_le_two_of_exponential_upper_tail
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : Ω → ℝ}
    (hZ0 : ∀ ω, 0 ≤ Z ω) (hZInt : Integrable Z μ)
    (htail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | t < Z ω} ≤ 2 * Real.exp (-t)) :
    (∫ ω, Z ω ∂μ) ≤ 2 := by
  let F : ℝ → ℝ := fun t => μ.real {ω | t < Z ω}
  let G : ℝ → ℝ := fun t => 2 * Real.exp (-t)
  have hFMeas : Measurable F := by
    dsimp [F, Measure.real]
    apply Measurable.ennreal_toReal
    exact Antitone.measurable fun s t hst =>
      measure_mono fun ω hω => lt_of_le_of_lt hst hω
  have hGInt : Integrable G (volume.restrict (Ioi 0)) := by
    have h := exp_neg_integrableOn_Ioi 0 (show (0 : ℝ) < 1 by norm_num)
    simpa [G] using h.const_mul 2
  have hFInt : Integrable F (volume.restrict (Ioi 0)) := by
    apply hGInt.mono' hFMeas.aestronglyMeasurable
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    simpa [F, G, Real.norm_eq_abs, abs_of_nonneg measureReal_nonneg] using htail ht
  have hmono :
      (∫ t in Ioi 0, F t) ≤ ∫ t in Ioi 0, G t := by
    apply integral_mono_ae hFInt hGInt
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    exact htail ht
  rw [hZInt.integral_eq_integral_meas_lt (Filter.Eventually.of_forall hZ0)]
  change (∫ t in Ioi 0, F t) ≤ _
  calc
    (∫ t in Ioi 0, F t) ≤ ∫ t in Ioi 0, G t := hmono
    _ = 2 := by
      rw [show (∫ t in Ioi 0, G t) =
          2 * ∫ t in Ioi 0, Real.exp (-t) by
        simp only [G]
        rw [MeasureTheory.integral_const_mul]]
      rw [integral_exp_neg_Ioi_zero]
      norm_num

/-- An affine exponential upper-tail bound integrates to `a + 2b`. -/
theorem expectation_le_add_two_mul_of_exponential_upper_tail
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hXInt : Integrable X μ) {a b : ℝ} (hb : 0 < b)
    (htail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | a + b * t < X ω} ≤ 2 * Real.exp (-t)) :
    (∫ ω, X ω ∂μ) ≤ a + 2 * b := by
  let Z : Ω → ℝ := fun ω => max ((X ω - a) / b) 0
  have hZ0 : ∀ ω, 0 ≤ Z ω := fun ω => le_max_right _ _
  have hZInt : Integrable Z μ := by
    dsimp [Z]
    exact (hXInt.sub (integrable_const a)).div_const b |>.pos_part
  have hZtail : ∀ {t : ℝ}, 0 < t →
      μ.real {ω | t < Z ω} ≤ 2 * Real.exp (-t) := by
    intro t ht
    have hevent : {ω | t < Z ω} = {ω | a + b * t < X ω} := by
      ext ω
      dsimp [Z]
      rw [lt_max_iff]
      constructor
      · rintro (h | h)
        · have h' := (lt_div_iff₀ hb).mp h
          linarith
        · exact False.elim ((not_lt_of_ge ht.le) h)
      · intro h
        left
        apply (lt_div_iff₀ hb).2
        linarith
    rw [hevent]
    exact htail ht
  have hZE := expectation_le_two_of_exponential_upper_tail hZ0 hZInt hZtail
  have hpoint : X ≤ fun ω => a + b * Z ω := by
    intro ω
    have hmax : (X ω - a) / b ≤ Z ω := le_max_left _ _
    have hmul := mul_le_mul_of_nonneg_left hmax hb.le
    have hbne : b ≠ 0 := hb.ne'
    field_simp [Z, hbne] at hmul
    linarith
  have hRhsInt : Integrable (fun ω => a + b * Z ω) μ :=
    (integrable_const a).add (hZInt.const_mul b)
  calc
    (∫ ω, X ω ∂μ) ≤ ∫ ω, (a + b * Z ω) ∂μ :=
      integral_mono hXInt hRhsInt hpoint
    _ = a + b * ∫ ω, Z ω ∂μ := by
      rw [integral_add (integrable_const a) (hZInt.const_mul b),
        integral_const, probReal_univ, one_smul, integral_const_mul]
    _ ≤ a + 2 * b := by nlinarith

end NumStability.HDP.Probability
