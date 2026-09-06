import ComputationalMathematics.HDP.Scalar.CentralLimit
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds
import Mathlib.Probability.CDF
/-!
# Berry--Esseen foundations

Reusable analytic and distribution-function foundations for quantitative
central-limit estimates. This module is kept separate from `CentralLimit` so
incremental Berry--Esseen work does not invalidate the completed Chapter 1
central-limit audits.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Scalar.BerryEsseen

/-- The pointwise gap between the cumulative distribution functions of two
real measures. -/
noncomputable def cdfGap (μ ν : Measure ℝ) (x : ℝ) : ℝ :=
  |cdf μ x - cdf ν x|

/-- Kolmogorov distance, presented as the supremum of pointwise CDF gaps. -/
noncomputable def kolmogorovDistance (μ ν : Measure ℝ) : ℝ :=
  sSup (Set.range (cdfGap μ ν))

/-- A pointwise CDF bound. Keeping this predicate alongside the supremum form
makes later smoothing estimates convenient to apply. -/
def CDFBound (μ ν : Measure ℝ) (ε : ℝ) : Prop :=
  ∀ x, cdfGap μ ν x ≤ ε

theorem cdfGap_nonneg (μ ν : Measure ℝ) (x : ℝ) :
    0 ≤ cdfGap μ ν x :=
  abs_nonneg _

theorem cdfGap_le_one (μ ν : Measure ℝ) (x : ℝ) :
    cdfGap μ ν x ≤ 1 := by
  rw [cdfGap, abs_le]
  constructor
  · linarith [cdf_nonneg μ x, cdf_le_one ν x]
  · linarith [cdf_nonneg ν x, cdf_le_one μ x]

theorem bddAbove_range_cdfGap (μ ν : Measure ℝ) :
    BddAbove (Set.range (cdfGap μ ν)) := by
  exact ⟨1, by rintro _ ⟨x, rfl⟩; exact cdfGap_le_one μ ν x⟩

theorem cdfGap_le_kolmogorovDistance (μ ν : Measure ℝ) (x : ℝ) :
    cdfGap μ ν x ≤ kolmogorovDistance μ ν :=
  le_csSup (bddAbove_range_cdfGap μ ν) ⟨x, rfl⟩

theorem kolmogorovDistance_nonneg (μ ν : Measure ℝ) :
    0 ≤ kolmogorovDistance μ ν :=
  (cdfGap_nonneg μ ν 0).trans (cdfGap_le_kolmogorovDistance μ ν 0)

theorem kolmogorovDistance_le_one (μ ν : Measure ℝ) :
    kolmogorovDistance μ ν ≤ 1 := by
  apply csSup_le (Set.range_nonempty _)
  rintro _ ⟨x, rfl⟩
  exact cdfGap_le_one μ ν x

theorem kolmogorovDistance_le_iff (μ ν : Measure ℝ) (ε : ℝ) :
    kolmogorovDistance μ ν ≤ ε ↔ CDFBound μ ν ε := by
  constructor
  · intro h x
    exact (cdfGap_le_kolmogorovDistance μ ν x).trans h
  · intro h
    apply csSup_le (Set.range_nonempty _)
    rintro _ ⟨x, rfl⟩
    exact h x

theorem kolmogorovDistance_comm (μ ν : Measure ℝ) :
    kolmogorovDistance μ ν = kolmogorovDistance ν μ := by
  apply le_antisymm
  · apply (kolmogorovDistance_le_iff μ ν _).2
    intro x
    simpa only [cdfGap, abs_sub_comm] using
      cdfGap_le_kolmogorovDistance ν μ x
  · apply (kolmogorovDistance_le_iff ν μ _).2
    intro x
    simpa only [cdfGap, abs_sub_comm] using
      cdfGap_le_kolmogorovDistance μ ν x

theorem kolmogorovDistance_triangle (μ ν ρ : Measure ℝ) :
    kolmogorovDistance μ ρ ≤
      kolmogorovDistance μ ν + kolmogorovDistance ν ρ := by
  apply (kolmogorovDistance_le_iff μ ρ _).2
  intro x
  change |cdf μ x - cdf ρ x| ≤ _
  calc
    |cdf μ x - cdf ρ x| =
        |(cdf μ x - cdf ν x) + (cdf ν x - cdf ρ x)| := by
      congr 1
      ring
    _ ≤ |cdf μ x - cdf ν x| + |cdf ν x - cdf ρ x| :=
      abs_add_le _ _
    _ ≤ kolmogorovDistance μ ν + kolmogorovDistance ν ρ := by
      exact add_le_add
        (cdfGap_le_kolmogorovDistance μ ν x)
        (cdfGap_le_kolmogorovDistance ν ρ x)

@[simp] theorem kolmogorovDistance_self (μ : Measure ℝ) :
    kolmogorovDistance μ μ = 0 := by
  apply le_antisymm
  · apply (kolmogorovDistance_le_iff μ μ 0).2
    intro x
    simp [cdfGap]
  · exact kolmogorovDistance_nonneg μ μ

theorem kolmogorovDistance_eq_zero_iff
    (μ ν : Measure ℝ)
    [IsProbabilityMeasure μ] [IsProbabilityMeasure ν] :
    kolmogorovDistance μ ν = 0 ↔ μ = ν := by
  constructor
  · intro h
    apply MeasureTheory.Measure.eq_of_cdf μ ν
    ext x
    have hx : cdfGap μ ν x ≤ 0 := by
      rw [← h]
      exact cdfGap_le_kolmogorovDistance μ ν x
    have habs : |cdf μ x - cdf ν x| = 0 :=
      le_antisymm hx (abs_nonneg _)
    exact sub_eq_zero.mp (abs_eq_zero.mp habs)
  · rintro rfl
    exact kolmogorovDistance_self μ

theorem cdf_map_eq_real_preimage
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (x : ℝ) :
    cdf (μ.map X) x = μ.real (X ⁻¹' Iic x) := by
  letI : IsProbabilityMeasure (μ.map X) :=
    Measure.isProbabilityMeasure_map hX.aemeasurable
  rw [cdf_eq_real, map_measureReal_apply hX measurableSet_Iic]

/-- A first absolute moment gives the characteristic function a quantitative
modulus at the origin. This removes the apparent `1 / |t|` singularity in the
truncated integral occurring in Esseen smoothing. -/
theorem norm_charFun_sub_one_le_firstMoment
    {μ : Measure ℝ} [IsProbabilityMeasure μ]
    (hμ1 : Integrable (fun x : ℝ => |x|) μ) (t : ℝ) :
    ‖MeasureTheory.charFun μ t - 1‖ ≤
      |t| * ∫ x, |x| ∂μ := by
  have hExp : Integrable
      (fun x : ℝ => Complex.exp (((t * x : ℝ) : ℂ) * Complex.I)) μ := by
    refine Integrable.of_bound (by fun_prop) 1 ?_
    exact ae_of_all μ fun x => by
      simp only [Complex.norm_exp_ofReal_mul_I]
      norm_num
  have hOne : Integrable (fun _ : ℝ => (1 : ℂ)) μ := integrable_const 1
  have hSub :
      (∫ x : ℝ, Complex.exp (((t * x : ℝ) : ℂ) * Complex.I) - 1 ∂μ) =
        (∫ x : ℝ, Complex.exp (((t * x : ℝ) : ℂ) * Complex.I) ∂μ) - 1 := by
    rw [integral_sub hExp hOne]
    simp [integral_const]
  rw [MeasureTheory.charFun_apply_real]
  simp_rw [← Complex.ofReal_mul]
  rw [← hSub]
  calc
    ‖∫ x : ℝ, Complex.exp (((t * x : ℝ) : ℂ) * Complex.I) - 1 ∂μ‖ ≤
        ∫ x : ℝ, |t| * |x| ∂μ :=
      norm_integral_le_of_norm_le (hμ1.const_mul |t|) <|
        ae_of_all μ fun x => by
          simpa only [mul_comm ((t * x : ℝ) : ℂ), Real.norm_eq_abs,
            abs_mul] using
            (Real.norm_exp_I_mul_ofReal_sub_one_le (x := t * x))
    _ = |t| * ∫ x : ℝ, |x| ∂μ := by rw [integral_const_mul]

/-- The characteristic functions of two laws with finite first moments differ
by `O(|t|)` at the origin. -/
theorem norm_charFun_sub_charFun_le_firstMoments
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (hμ1 : Integrable (fun x : ℝ => |x|) μ)
    (hν1 : Integrable (fun x : ℝ => |x|) ν) (t : ℝ) :
    ‖MeasureTheory.charFun μ t - MeasureTheory.charFun ν t‖ ≤
      |t| * ((∫ x, |x| ∂μ) + ∫ x, |x| ∂ν) := by
  calc
    ‖MeasureTheory.charFun μ t - MeasureTheory.charFun ν t‖ =
        ‖(MeasureTheory.charFun μ t - 1) +
          (1 - MeasureTheory.charFun ν t)‖ := by
      congr 1
      ring
    _ ≤ ‖MeasureTheory.charFun μ t - 1‖ +
        ‖1 - MeasureTheory.charFun ν t‖ := norm_add_le _ _
    _ = ‖MeasureTheory.charFun μ t - 1‖ +
        ‖MeasureTheory.charFun ν t - 1‖ := by
      rw [← norm_neg (1 - MeasureTheory.charFun ν t)]
      congr 2
      ring
    _ ≤ |t| * (∫ x, |x| ∂μ) + |t| * ∫ x, |x| ∂ν :=
      add_le_add
        (norm_charFun_sub_one_le_firstMoment hμ1 t)
        (norm_charFun_sub_one_le_firstMoment hν1 t)
    _ = |t| * ((∫ x, |x| ∂μ) + ∫ x, |x| ∂ν) := by ring

/-- The discrepancy quotient used in Esseen's truncated Fourier integral,
defined to be zero at the removable singularity. -/
noncomputable def charFunDiscrepancyQuotient
    (μ ν : Measure ℝ) (t : ℝ) : ℝ :=
  if t = 0 then 0
  else ‖MeasureTheory.charFun μ t - MeasureTheory.charFun ν t‖ / |t|

theorem charFunDiscrepancyQuotient_nonneg (μ ν : Measure ℝ) (t : ℝ) :
    0 ≤ charFunDiscrepancyQuotient μ ν t := by
  rw [charFunDiscrepancyQuotient]
  split_ifs
  · exact le_rfl
  · positivity

theorem stronglyMeasurable_charFunDiscrepancyQuotient
    (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    StronglyMeasurable (charFunDiscrepancyQuotient μ ν) := by
  unfold charFunDiscrepancyQuotient
  exact (Measurable.ite (measurableSet_singleton 0) measurable_const
    (by fun_prop)).stronglyMeasurable

theorem charFunDiscrepancyQuotient_le_firstMoments
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (hμ1 : Integrable (fun x : ℝ => |x|) μ)
    (hν1 : Integrable (fun x : ℝ => |x|) ν) (t : ℝ) :
    charFunDiscrepancyQuotient μ ν t ≤
      (∫ x, |x| ∂μ) + ∫ x, |x| ∂ν := by
  rw [charFunDiscrepancyQuotient]
  split_ifs with ht
  · exact add_nonneg (integral_nonneg fun _ => abs_nonneg _)
      (integral_nonneg fun _ => abs_nonneg _)
  · rw [div_le_iff₀ (abs_pos.mpr ht)]
    simpa only [mul_comm] using
      norm_charFun_sub_charFun_le_firstMoments hμ1 hν1 t

/-- Under finite first moments the discrepancy quotient is integrable on
every bounded interval, so the truncated Esseen integral is well-defined. -/
theorem intervalIntegrable_charFunDiscrepancyQuotient
    {μ ν : Measure ℝ} [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (hμ1 : Integrable (fun x : ℝ => |x|) μ)
    (hν1 : Integrable (fun x : ℝ => |x|) ν) (a b : ℝ) :
    IntervalIntegrable (charFunDiscrepancyQuotient μ ν) volume a b := by
  let M : ℝ := (∫ x, |x| ∂μ) + ∫ x, |x| ∂ν
  have hM : IntervalIntegrable (fun _ : ℝ => M) volume a b :=
    intervalIntegrable_const
  refine hM.mono_fun' ?_ ?_
  · exact (stronglyMeasurable_charFunDiscrepancyQuotient μ ν).aestronglyMeasurable
  · exact ae_of_all (volume.restrict (uIoc a b)) fun t => by
      change |charFunDiscrepancyQuotient μ ν t| ≤ M
      rw [abs_of_nonneg (charFunDiscrepancyQuotient_nonneg μ ν t)]
      simpa only [M] using
        charFunDiscrepancyQuotient_le_firstMoments hμ1 hν1 t

/-- A global cubic remainder bound for the imaginary-axis exponential.

The constant is deliberately nonoptimal. Its global form is the useful point:
after substituting `y = u * X`, a finite third absolute moment supplies an
integrable majorant without any boundedness assumption on `X`. -/
theorem norm_cexp_mul_I_sub_quadratic_le (y : ℝ) :
    ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I +
        (((y ^ 2 : ℝ) : ℂ) / 2)‖ ≤
      4 * |y| ^ 3 := by
  by_cases hy : |y| ≤ 1
  · have hz : ‖(y : ℂ) * Complex.I‖ ≤ 1 := by
      simpa [Complex.norm_mul, Real.norm_eq_abs] using hy
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I +
          (((y ^ 2 : ℝ) : ℂ) / 2)‖ =
          ‖Complex.exp ((y : ℂ) * Complex.I) -
            ∑ m ∈ Finset.range 3,
              (((y : ℂ) * Complex.I) ^ m / m.factorial)‖ := by
            congr 1
            simp [Finset.sum_range_succ, Nat.factorial]
            ring_nf
            rw [Complex.I_sq]
            ring
      _ ≤ ‖(y : ℂ) * Complex.I‖ ^ 3 *
          ((Nat.succ 3 : ℝ) * ((Nat.factorial 3) * (3 : ℕ) : ℝ)⁻¹) :=
        Complex.exp_bound hz (by decide)
      _ ≤ 4 * |y| ^ 3 := by
        simp [Real.norm_eq_abs, Nat.factorial]
        nlinarith [pow_nonneg (abs_nonneg y) 3]
  · have hy1 : 1 < |y| := lt_of_not_ge hy
    have hy1' : 1 ≤ |y| := hy1.le
    have hy_sq : |y| ≤ |y| ^ 2 := by
      nlinarith [mul_nonneg (abs_nonneg y) (sub_nonneg.mpr hy1')]
    have hy_cube : |y| ^ 2 ≤ |y| ^ 3 := by
      nlinarith [mul_nonneg (sq_nonneg |y|) (sub_nonneg.mpr hy1')]
    have hone_cube : 1 ≤ |y| ^ 3 :=
      hy1'.trans (hy_sq.trans hy_cube)
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I +
          (((y ^ 2 : ℝ) : ℂ) / 2)‖ ≤
          ‖Complex.exp ((y : ℂ) * Complex.I)‖ + ‖(1 : ℂ)‖ +
            ‖(y : ℂ) * Complex.I‖ + ‖(((y ^ 2 : ℝ) : ℂ) / 2)‖ := by
              calc
                _ ≤ ‖Complex.exp ((y : ℂ) * Complex.I) - 1 -
                    (y : ℂ) * Complex.I‖ + ‖(((y ^ 2 : ℝ) : ℂ) / 2)‖ :=
                  norm_add_le _ _
                _ ≤ (‖Complex.exp ((y : ℂ) * Complex.I) - 1‖ +
                    ‖(y : ℂ) * Complex.I‖) +
                    ‖(((y ^ 2 : ℝ) : ℂ) / 2)‖ := by
                  gcongr
                  exact norm_sub_le _ _
                _ ≤ (‖Complex.exp ((y : ℂ) * Complex.I)‖ + ‖(1 : ℂ)‖ +
                    ‖(y : ℂ) * Complex.I‖) +
                    ‖(((y ^ 2 : ℝ) : ℂ) / 2)‖ := by
                  gcongr
                  exact norm_sub_le _ _
                _ = _ := by ring
      _ = 2 + |y| + |y| ^ 2 / 2 := by
        norm_num [Complex.norm_exp_ofReal_mul_I, Complex.norm_mul,
          Complex.norm_div, Real.norm_eq_abs, sq_abs]
      _ ≤ 4 * |y| ^ 3 := by
        nlinarith [hy_sq.trans hy_cube, hone_cube]

/-- The cubic exponential remainder passes through expectation under a finite
third absolute moment. This is the quantitative Taylor input used in the
characteristic-function half of Berry--Esseen. -/
theorem norm_integral_cexp_mul_I_sub_quadratic_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    (X : Ω → ℝ) (hX3 : Integrable (fun ω => |X ω| ^ 3) μ) (u : ℝ) :
    ‖∫ ω,
        (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * X ω : ℝ) : ℂ) * Complex.I +
          ((((u * X ω) ^ 2 : ℝ) : ℂ) / 2)) ∂μ‖ ≤
      4 * |u| ^ 3 * ∫ ω, |X ω| ^ 3 ∂μ := by
  have hg : Integrable (fun ω => 4 * |u| ^ 3 * |X ω| ^ 3) μ :=
    hX3.const_mul (4 * |u| ^ 3)
  calc
    ‖∫ ω,
        (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * X ω : ℝ) : ℂ) * Complex.I +
          ((((u * X ω) ^ 2 : ℝ) : ℂ) / 2)) ∂μ‖ ≤
        ∫ ω, 4 * |u| ^ 3 * |X ω| ^ 3 ∂μ :=
      norm_integral_le_of_norm_le hg <| ae_of_all μ fun ω => by
        simpa only [abs_mul, mul_pow, mul_assoc] using
          norm_cexp_mul_I_sub_quadratic_le (u * X ω)
    _ = 4 * |u| ^ 3 * ∫ ω, |X ω| ^ 3 ∂μ := by
      rw [integral_const_mul]

/-- A centered unit-second-moment characteristic function differs from its
quadratic Taylor polynomial by at most a universal constant times the third
absolute moment. This is the first quantitative replacement for the
qualitative `o(t²)` estimate used by the ordinary CLT. -/
theorem norm_charFun_probabilityLaw_sub_quadratic_le_thirdMoment
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : MemLp X 3 μ)
    (hMean : ∫ ω, X ω ∂μ = 0)
    (hSecond : ∫ ω, (X ω) ^ 2 ∂μ = 1)
    (t : ℝ) :
    ‖MeasureTheory.charFun
          (NumStability.HDP.Scalar.LimitTheorems.probabilityLaw
            X hX.aemeasurable : Measure ℝ) t -
        (1 - (t : ℂ) ^ 2 / 2)‖ ≤
      4 * |t| ^ 3 * ∫ ω, |X ω| ^ 3 ∂μ := by
  have hXint : Integrable X μ := hX.integrable (by norm_num)
  have hX2 : Integrable (fun ω => (X ω) ^ 2) μ :=
    (hX.mono_exponent (by norm_num : (2 : ENNReal) ≤ 3)).integrable_sq
  have hX3 : Integrable (fun ω => |X ω| ^ 3) μ := by
    simpa only [Real.norm_eq_abs] using hX.integrable_norm_pow (by norm_num)
  have hExp : Integrable
      (fun ω => Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I)) μ := by
    refine Integrable.of_bound (by fun_prop) 1 ?_
    exact ae_of_all μ fun ω => by
      simp only [Complex.norm_exp_ofReal_mul_I]
      norm_num
  have hOne : Integrable (fun _ : Ω => (1 : ℂ)) μ := integrable_const 1
  have hLin : Integrable
      (fun ω => ((t * X ω : ℝ) : ℂ) * Complex.I) μ :=
    ((hXint.const_mul t).ofReal).mul_const Complex.I
  have hQuadReal : Integrable (fun ω => (t * X ω) ^ 2) μ := by
    simpa only [mul_pow] using hX2.const_mul (t ^ 2)
  have hQuad : Integrable
      (fun ω => ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2)) μ :=
    hQuadReal.ofReal.div_const 2
  have hLinZero :
      (∫ ω, ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ) = 0 := by
    calc
      (∫ ω, ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
          (∫ ω, ((t * X ω : ℝ) : ℂ) ∂μ) * Complex.I :=
        integral_mul_const _ _
      _ = ((∫ ω, t * X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        have hc : (∫ ω, ((t * X ω : ℝ) : ℂ) ∂μ) =
            ((∫ ω, t * X ω ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hc]
      _ = ((t * ∫ ω, X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        rw [integral_const_mul]
      _ = 0 := by rw [hMean]; simp
  have hQuadIntegral :
      (∫ ω, ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2) ∂μ) =
        (t : ℂ) ^ 2 / 2 := by
    calc
      (∫ ω, ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2) ∂μ) =
          (∫ ω, (((t * X ω) ^ 2 : ℝ) : ℂ) ∂μ) / 2 :=
        integral_div _ _
      _ = ((∫ ω, (t * X ω) ^ 2 ∂μ : ℝ) : ℂ) / 2 := by
        have hc : (∫ ω, (((t * X ω) ^ 2 : ℝ) : ℂ) ∂μ) =
            ((∫ ω, (t * X ω) ^ 2 ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hc]
      _ = ((t ^ 2 * ∫ ω, (X ω) ^ 2 ∂μ : ℝ) : ℂ) / 2 := by
        congr 2
        simpa only [mul_pow] using
          (integral_const_mul (μ := μ) (t ^ 2) (fun ω => (X ω) ^ 2))
      _ = (t : ℂ) ^ 2 / 2 := by rw [hSecond]; norm_num
  have hsubExp :
      (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) =
        (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) ∂μ) -
          (∫ _ : Ω, (1 : ℂ) ∂μ) :=
    integral_sub hExp hOne
  have hsubLin :
      (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 -
        ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
        (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) -
          (∫ ω, ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ) :=
    integral_sub (hExp.sub hOne) hLin
  have hRemainderIntegral :
      (∫ ω,
        (Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 -
          ((t * X ω : ℝ) : ℂ) * Complex.I +
          ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2)) ∂μ) =
        (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) ∂μ) - 1 +
          (t : ℂ) ^ 2 / 2 := by
    calc
      _ = (∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 -
            ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ) +
          (∫ ω, ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2) ∂μ) := by
        exact integral_add (hExp.sub hOne |>.sub hLin) hQuad
      _ = ((∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) -
            (∫ ω, ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ)) +
          (∫ ω, ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2) ∂μ) := by
        rw [hsubLin]
      _ = (((∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) ∂μ) -
            (∫ _ : Ω, (1 : ℂ) ∂μ)) -
            (∫ ω, ((t * X ω : ℝ) : ℂ) * Complex.I ∂μ)) +
          (∫ ω, ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2) ∂μ) := by
        rw [hsubExp]
      _ = _ := by rw [hLinZero, hQuadIntegral]; simp [integral_const]
  rw [NumStability.HDP.Scalar.LimitTheorems.charFun_probabilityLaw]
  simp_rw [← Complex.ofReal_mul]
  calc
    ‖(∫ ω, Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) ∂μ) -
        (1 - (t : ℂ) ^ 2 / 2)‖ =
        ‖∫ ω,
          (Complex.exp (((t * X ω : ℝ) : ℂ) * Complex.I) - 1 -
            ((t * X ω : ℝ) : ℂ) * Complex.I +
            ((((t * X ω) ^ 2 : ℝ) : ℂ) / 2)) ∂μ‖ := by
      rw [hRemainderIntegral]
      congr 1
      ring
    _ ≤ 4 * |t| ^ 3 * ∫ ω, |X ω| ^ 3 ∂μ :=
      norm_integral_cexp_mul_I_sub_quadratic_le X hX3 t

end NumStability.HDP.Scalar.BerryEsseen
