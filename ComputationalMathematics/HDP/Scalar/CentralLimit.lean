import ComputationalMathematics.HDP.Scalar.LimitTheorems
import Mathlib.Analysis.Calculus.Taylor
import Mathlib.MeasureTheory.Measure.CharacteristicFunction
import Mathlib.MeasureTheory.Measure.Prokhorov
import Mathlib.MeasureTheory.Measure.TightNormed
import Mathlib.Probability.Independence.CharacteristicFunction

/-!
# Characteristic-function foundations for scalar limit theorems

Reusable bridge lemmas for the Chapter 1 central-limit and Poisson-limit
targets. This module is deliberately separate from `LimitTheorems` so later
CLT work does not invalidate completed audits of the earlier source contracts.
-/

noncomputable section

open MeasureTheory Filter Set Function

open scoped Topology

namespace NumStability.HDP.Scalar.LimitTheorems

/-- The characteristic function of a pushforward probability law is the
expectation of the usual complex exponential of the original random variable. -/
theorem charFun_probabilityLaw
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (t : ℝ) :
    MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) t =
      ∫ ω, Complex.exp (t * X ω * Complex.I) ∂μ := by
  rw [MeasureTheory.charFun_apply_real]
  change (∫ x : ℝ, Complex.exp (t * x * Complex.I) ∂Measure.map X μ) = _
  rw [MeasureTheory.integral_map hX (by fun_prop)]

/-- The characteristic function of the standard normal law is
`t ↦ exp (-t² / 2)`. -/
theorem standardNormalLaw_charFun (t : ℝ) :
    MeasureTheory.charFun standardNormalLaw t =
      Complex.exp (-(t : ℂ) ^ 2 / 2) := by
  rw [standardNormalLaw, ProbabilityTheory.charFun_gaussianReal]
  congr 1
  push_cast
  ring

/-- A global quadratic domination for the second-order remainder of the
imaginary-axis complex exponential. This is the integrable bound needed for
the finite-variance dominated-convergence step in the CLT proof. -/
theorem norm_cexp_mul_I_sub_one_sub_linear_le (y : ℝ) :
    ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
      3 * y ^ 2 := by
  by_cases hy : |y| ≤ 1
  · have hz : ‖(y : ℂ) * Complex.I‖ ≤ 1 := by
      simpa [Complex.norm_mul, Real.norm_eq_abs] using hy
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
          ‖(y : ℂ) * Complex.I‖ ^ 2 :=
        Complex.norm_exp_sub_one_sub_id_le hz
      _ = y ^ 2 := by simp [Real.norm_eq_abs, sq_abs]
      _ ≤ 3 * y ^ 2 := by nlinarith [sq_nonneg y]
  · have hy1 : 1 < |y| := lt_of_not_ge hy
    calc
      ‖Complex.exp ((y : ℂ) * Complex.I) - 1 - (y : ℂ) * Complex.I‖ ≤
          ‖Complex.exp ((y : ℂ) * Complex.I) - 1‖ +
            ‖(y : ℂ) * Complex.I‖ := norm_sub_le _ _
      _ ≤ (‖Complex.exp ((y : ℂ) * Complex.I)‖ + ‖(1 : ℂ)‖) +
            ‖(y : ℂ) * Complex.I‖ := by
        gcongr
        exact norm_sub_le _ _
      _ = 2 + |y| := by
        norm_num [Complex.norm_exp_ofReal_mul_I, Complex.norm_mul,
          Real.norm_eq_abs]
      _ ≤ 3 * y ^ 2 := by
        rw [← sq_abs]
        nlinarith [abs_nonneg y]

/-- After division by the square of a nonzero scale, the exponential
remainder is dominated by the square of the underlying value, independently
of the scale. This is the pointwise majorant used in the CLT Taylor step. -/
theorem norm_cexp_scaled_remainder_div_sq_le
    (u x : ℝ) (hu : u ≠ 0) :
    ‖(Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2‖ ≤
      3 * x ^ 2 := by
  have h := norm_cexp_mul_I_sub_one_sub_linear_le (u * x)
  calc
    ‖(Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2‖ =
        ‖Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I‖ / |u| ^ 2 := by
      rw [norm_div, norm_pow]
      simp [Real.norm_eq_abs]
    _ ≤ (3 * (u * x) ^ 2) / |u| ^ 2 :=
      div_le_div_of_nonneg_right h (sq_nonneg |u|)
    _ = 3 * x ^ 2 := by
      rw [mul_pow, sq_abs]
      field_simp

/-- The order-two Taylor polynomial, along the real scale parameter, of the
imaginary-axis exponential used by characteristic functions. -/
theorem taylorWithinEval_cexp_mul_I_order_two (x u : ℝ) :
    taylorWithinEval
        (fun v : ℝ => Complex.exp (((v * x : ℝ) : ℂ) * Complex.I))
        2 Set.univ 0 u =
      1 + ((u * x : ℝ) : ℂ) * Complex.I -
        (((u * x) ^ 2 : ℝ) : ℂ) / 2 := by
  let c : ℂ := (x : ℂ) * Complex.I
  let f : ℝ → ℂ := fun v => Complex.exp ((v : ℂ) * c)
  have hf1 : ∀ v : ℝ,
      HasDerivAt f (Complex.exp ((v : ℂ) * c) * c) v := by
    intro v
    have hc : HasDerivAt (fun z : ℂ => z * c) c (v : ℂ) := by
      simpa only [id_eq, one_mul] using
        (hasDerivAt_id (v : ℂ)).mul_const c
    exact ((Complex.hasDerivAt_exp _).comp (v : ℂ) hc).comp_ofReal
  have hdf : deriv f = fun v : ℝ => Complex.exp ((v : ℂ) * c) * c := by
    funext v
    exact (hf1 v).deriv
  have h0 : iteratedDerivWithin 0 f Set.univ 0 = 1 := by
    simp [f]
  have h1 : iteratedDerivWithin 1 f Set.univ 0 = c := by
    rw [show 1 = 0 + 1 by norm_num, iteratedDerivWithin_succ']
    simp [derivWithin_univ, hdf]
  have h2 : iteratedDerivWithin 2 f Set.univ 0 = c * c := by
    rw [show 2 = 1 + 1 by norm_num, iteratedDerivWithin_succ']
    rw [show iteratedDerivWithin 1 (derivWithin f Set.univ) Set.univ 0 =
      derivWithin (derivWithin f Set.univ) Set.univ 0 by
        rw [show 1 = 0 + 1 by norm_num, iteratedDerivWithin_succ']
        simp]
    rw [derivWithin_univ, derivWithin_univ, hdf]
    simpa [f] using ((hf1 0).mul_const c).deriv
  have h0' : iteratedDeriv 0 f 0 = 1 := by
    rw [← iteratedDerivWithin_univ]
    exact h0
  have h1' : iteratedDeriv 1 f 0 = c := by
    rw [← iteratedDerivWithin_univ]
    exact h1
  have h2' : iteratedDeriv 2 f 0 = c * c := by
    rw [← iteratedDerivWithin_univ]
    exact h2
  have ht : taylorWithinEval f 2 Set.univ 0 u =
      1 + (u : ℂ) * c + ((u : ℂ) ^ 2 / 2) * (c * c) := by
    rw [taylor_within_apply]
    simp [Finset.sum_range_succ, h0', h1', h2']
    change 1 + algebraMap ℝ ℂ u * c +
      algebraMap ℝ ℂ (2⁻¹ * u ^ 2) * (c * c) = _
    rw [Complex.coe_algebraMap]
    push_cast
    ring
  have hfun :
      (fun v : ℝ => Complex.exp (((v * x : ℝ) : ℂ) * Complex.I)) = f := by
    funext v
    dsimp [f, c]
    congr 1
    push_cast
    ring
  rw [hfun]
  calc
    taylorWithinEval f 2 Set.univ 0 u =
        1 + (u : ℂ) * c + ((u : ℂ) ^ 2 / 2) * (c * c) := ht
    _ = 1 + ((u * x : ℝ) : ℂ) * Complex.I -
        (((u * x) ^ 2 : ℝ) : ℂ) / 2 := by
      dsimp [c]
      push_cast
      ring_nf
      rw [Complex.I_sq]
      ring

/-- The scaled characteristic-function integrand has its expected
second-order pointwise limit. The punctured neighborhood matches the quotient
appearing in dominated convergence; the value at zero is immaterial. -/
theorem tendsto_cexp_scaled_remainder_div_sq (x : ℝ) :
    Filter.Tendsto
      (fun u : ℝ =>
        (Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * x : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2)
      (𝓝[≠] 0) (𝓝 (-((x : ℂ) ^ 2) / 2)) := by
  let f : ℝ → ℂ := fun u =>
    Complex.exp (((u * x : ℝ) : ℂ) * Complex.I)
  have hf : ContDiff ℝ 2 f := by
    have hg : ContDiff ℝ 2
        (fun u : ℝ => Complex.ofRealCLM (u * x) * Complex.I) := by
      fun_prop
    simpa only [f, Function.comp_apply, Complex.ofRealCLM_apply] using
      (Complex.contDiff_exp (𝕜 := ℝ)).comp hg
  have ht := taylor_tendsto (f := f) (n := 2) (s := Set.univ)
    (x₀ := 0) convex_univ (Set.mem_univ 0) hf.contDiffOn
  rw [nhdsWithin_univ] at ht
  have hlim : Filter.Tendsto
      (fun u : ℝ => ((u - 0) ^ 2)⁻¹ •
        (f u - taylorWithinEval f 2 Set.univ 0 u) -
          ((x : ℂ) ^ 2) / 2)
      (𝓝 0) (𝓝 (-((x : ℂ) ^ 2) / 2)) := by
    simpa only [zero_sub, neg_div] using
      ht.sub_const (((x : ℂ) ^ 2) / 2)
  refine (tendsto_nhdsWithin_of_tendsto_nhds hlim).congr' ?_
  filter_upwards [self_mem_nhdsWithin] with u hu
  have hu0 : u ≠ 0 := by simpa using hu
  have huc : (u : ℂ) ≠ 0 := by exact_mod_cast hu0
  rw [taylorWithinEval_cexp_mul_I_order_two]
  dsimp [f]
  change algebraMap ℝ ℂ (((u - 0) ^ 2)⁻¹) *
      (Complex.exp (((u * x : ℝ) : ℂ) * Complex.I) -
        (1 + ((u * x : ℝ) : ℂ) * Complex.I -
          (((u * x) ^ 2 : ℝ) : ℂ) / 2)) -
        ((x : ℂ) ^ 2) / 2 = _
  rw [Complex.coe_algebraMap]
  push_cast
  field_simp [huc]
  ring

/-- Dominated convergence passes the pointwise second-order exponential
remainder limit through expectation under a finite second moment. -/
theorem tendsto_integral_cexp_scaled_remainder_div_sq
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    (X : Ω → ℝ) (hX : AEMeasurable X μ)
    (hX2 : Integrable (fun ω => (X ω) ^ 2) μ) :
    Filter.Tendsto
      (fun u : ℝ => ∫ ω,
        (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
          ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2 ∂μ)
      (𝓝[≠] 0)
      (𝓝 (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ)) := by
  let F : ℝ → Ω → ℂ := fun u ω =>
    (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
      ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2
  refine tendsto_integral_filter_of_dominated_convergence
    (F := F) (f := fun ω => -((X ω : ℂ) ^ 2) / 2)
    (fun ω => 3 * (X ω) ^ 2) ?_ ?_ ?_ ?_
  · filter_upwards [self_mem_nhdsWithin] with u hu
    have hu0 : u ≠ 0 := by simpa using hu
    have hmeas : AEMeasurable (F u) μ := by
      dsimp [F]
      fun_prop
    exact hmeas.aestronglyMeasurable
  · filter_upwards [self_mem_nhdsWithin] with u hu
    have hu0 : u ≠ 0 := by simpa using hu
    exact ae_of_all μ fun ω =>
      norm_cexp_scaled_remainder_div_sq_le u (X ω) hu0
  · exact hX2.const_mul 3
  · exact ae_of_all μ fun ω =>
      tendsto_cexp_scaled_remainder_div_sq (X ω)

/-- For a centered, unit-second-moment real random variable, the
characteristic-function integral has the classical quadratic expansion at
zero. -/
theorem tendsto_centered_unitSecondMoment_charFun_remainder_div_sq
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : MemLp X 2 μ)
    (hMean : ∫ ω, X ω ∂μ = 0)
    (hSecond : ∫ ω, (X ω) ^ 2 ∂μ = 1) :
    Filter.Tendsto
      (fun u : ℝ =>
        ((∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) - 1) /
          (u : ℂ) ^ 2)
      (𝓝[≠] 0) (𝓝 (-(1 : ℂ) / 2)) := by
  have hDCT := tendsto_integral_cexp_scaled_remainder_div_sq
    X hX.aemeasurable hX.integrable_sq
  have hlimit :
      (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ) = -(1 : ℂ) / 2 := by
    calc
      (∫ ω, -((X ω : ℂ) ^ 2) / 2 ∂μ) =
          (∫ ω, -((X ω : ℂ) ^ 2) ∂μ) / (2 : ℂ) := integral_div _ _
      _ = -(∫ ω, (X ω : ℂ) ^ 2 ∂μ) / 2 := by
        rw [integral_neg]
      _ = -(1 : ℂ) / 2 := by
        have hpow : (fun ω => (X ω : ℂ) ^ 2) =
            (fun ω => (((X ω) ^ 2 : ℝ) : ℂ)) := by
          funext ω
          push_cast
          rfl
        rw [hpow]
        have hc : (∫ ω, (((X ω) ^ 2 : ℝ) : ℂ) ∂μ) =
            ((∫ ω, (X ω) ^ 2 ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hc, hSecond]
        norm_num
  rw [hlimit] at hDCT
  refine hDCT.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with u hu
  have hu0 : u ≠ 0 := by simpa using hu
  have hXint : Integrable X μ := hX.integrable (by norm_num)
  have hAmeas : AEMeasurable
      (fun ω => Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I)) μ := by
    fun_prop
  have hAint : Integrable
      (fun ω => Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I)) μ := by
    refine Integrable.of_bound hAmeas.aestronglyMeasurable 1 ?_
    exact ae_of_all μ fun ω => by
      simp only [Complex.norm_exp_ofReal_mul_I]
      norm_num
  have hOne : Integrable (fun _ : Ω => (1 : ℂ)) μ := integrable_const 1
  have hLin : Integrable
      (fun ω => ((u * X ω : ℝ) : ℂ) * Complex.I) μ :=
    ((hXint.const_mul u).ofReal).mul_const Complex.I
  have hLinZero :
      (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) = 0 := by
    calc
      (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
          (∫ ω, ((u * X ω : ℝ) : ℂ) ∂μ) * Complex.I :=
        integral_mul_const _ _
      _ = ((∫ ω, u * X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        have hcu : (∫ ω, ((u * X ω : ℝ) : ℂ) ∂μ) =
            ((∫ ω, u * X ω ∂μ : ℝ) : ℂ) := integral_complex_ofReal
        rw [hcu]
      _ = ((u * ∫ ω, X ω ∂μ : ℝ) : ℂ) * Complex.I := by
        rw [integral_const_mul]
      _ = 0 := by rw [hMean]; simp
  have hsubA :
      (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) =
        (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) -
          (∫ _ : Ω, (1 : ℂ) ∂μ) := integral_sub hAint hOne
  have hsubLin :
      (∫ ω, (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1) -
        ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) =
        (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 ∂μ) -
          (∫ ω, ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) :=
    integral_sub (hAint.sub hOne) hLin
  calc
    (∫ ω, (Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
        ((u * X ω : ℝ) : ℂ) * Complex.I) / (u : ℂ) ^ 2 ∂μ) =
      (∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) - 1 -
        ((u * X ω : ℝ) : ℂ) * Complex.I ∂μ) / (u : ℂ) ^ 2 :=
      integral_div _ _
    _ = ((∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ) - 1) /
        (u : ℂ) ^ 2 := by
      rw [hsubLin, hsubA, hLinZero]
      simp [integral_const]

/-- Pointwise convergence of the characteristic-function powers for iid
normalized sums, expressed first at the level of a single centered,
unit-second-moment law. -/
theorem tendsto_centered_unitSecondMoment_charFun_pow_sqrt
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : MemLp X 2 μ)
    (hMean : ∫ ω, X ω ∂μ = 0)
    (hSecond : ∫ ω, (X ω) ^ 2 ∂μ = 1) (t : ℝ) :
    Filter.Tendsto
      (fun n : ℕ =>
        (∫ ω, Complex.exp
          ((((t / Real.sqrt n) * X ω : ℝ) : ℂ) * Complex.I) ∂μ) ^ n)
      atTop (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
  by_cases ht : t = 0
  · subst t
    simp [integral_const]
  · let φ : ℝ → ℂ := fun u =>
      ∫ ω, Complex.exp (((u * X ω : ℝ) : ℂ) * Complex.I) ∂μ
    let u : ℕ → ℝ := fun n => t / Real.sqrt n
    let g : ℕ → ℂ := fun n => φ (u n) - 1
    have hsqrt : Filter.Tendsto
        (fun n : ℕ => Real.sqrt (n : ℝ)) atTop atTop :=
      Real.tendsto_sqrt_atTop.comp tendsto_natCast_atTop_atTop
    have hu : Filter.Tendsto u atTop (𝓝 0) := by
      exact tendsto_const_nhds.div_atTop hsqrt
    have hune : ∀ᶠ n : ℕ in atTop, u n ≠ 0 := by
      filter_upwards [eventually_gt_atTop 0] with n hn
      exact div_ne_zero ht
        (Real.sqrt_ne_zero'.mpr (Nat.cast_pos.mpr hn))
    have huWithin : Filter.Tendsto u atTop (𝓝[≠] 0) :=
      tendsto_nhdsWithin_iff.mpr ⟨hu, by simpa using hune⟩
    have hquot : Filter.Tendsto
        (fun n => (φ (u n) - 1) / (u n : ℂ) ^ 2)
        atTop (𝓝 (-(1 : ℂ) / 2)) := by
      exact (tendsto_centered_unitSecondMoment_charFun_remainder_div_sq
        X hX hMean hSecond).comp huWithin
    have hscale : Filter.Tendsto
        (fun n : ℕ => (n : ℂ) * (u n : ℂ) ^ 2)
        atTop (𝓝 ((t : ℂ) ^ 2)) := by
      refine tendsto_const_nhds.congr' ?_
      filter_upwards [eventually_gt_atTop 0] with n hn
      have hsqrt_sq : (Real.sqrt (n : ℝ)) ^ 2 = (n : ℝ) :=
        Real.sq_sqrt (Nat.cast_nonneg n)
      have hsqrt_sq_c :
          (Real.sqrt (n : ℝ) : ℂ) ^ 2 = (n : ℂ) := by
        exact_mod_cast hsqrt_sq
      have hnc : (n : ℂ) ≠ 0 := by
        exact_mod_cast (Nat.ne_of_gt hn)
      dsimp [u]
      push_cast
      rw [div_pow, hsqrt_sq_c]
      field_simp [hnc]
    have hng : Filter.Tendsto (fun n : ℕ => (n : ℂ) * g n)
        atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
      have hprod := hquot.mul hscale
      have hprod' : Filter.Tendsto
          (fun n : ℕ => ((φ (u n) - 1) / (u n : ℂ) ^ 2) *
            ((n : ℂ) * (u n : ℂ) ^ 2))
          atTop (𝓝 (-((t : ℂ) ^ 2) / 2)) := by
        convert hprod using 1
        ring
      refine hprod'.congr' ?_
      filter_upwards [hune] with n hun
      dsimp [g]
      have hunc : (u n : ℂ) ≠ 0 := by exact_mod_cast hun
      field_simp [hunc]
    have hpow := Complex.tendsto_one_add_pow_exp_of_tendsto hng
    simpa [g, φ, u] using hpow

/-- Joint independence factors the characteristic function of a finite sum
into the product of the summands' characteristic functions. -/
theorem charFun_probabilityLaw_sum_eq_prod
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ) (t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (∑ i, X i) (by fun_prop) : Measure ℝ) t =
      ∏ i, MeasureTheory.charFun
        (probabilityLaw (X i) (hX i) : Measure ℝ) t := by
  change MeasureTheory.charFun (μ.map (∑ i, X i)) t =
    ∏ i, MeasureTheory.charFun (μ.map (X i)) t
  simpa only [Finset.prod_apply] using
    congrFun (hIndep.charFun_map_sum_eq_prod hX) t

/-- Scaling a real random variable scales the argument of its characteristic
function. -/
theorem charFun_probabilityLaw_const_mul
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (a t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (fun ω => a * X ω) (hX.const_mul a) : Measure ℝ) t =
      MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) (a * t) := by
  rw [charFun_probabilityLaw, charFun_probabilityLaw]
  congr with ω
  congr 1
  push_cast
  ring

/-- Centering a real random variable multiplies its characteristic function by
the deterministic phase corresponding to the subtracted center. -/
theorem charFun_probabilityLaw_sub_const
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : AEMeasurable X μ) (m t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (fun ω => X ω - m) (by fun_prop) : Measure ℝ) t =
      MeasureTheory.charFun (probabilityLaw X hX : Measure ℝ) t *
        Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) := by
  rw [charFun_probabilityLaw, charFun_probabilityLaw]
  calc
    (∫ ω, Complex.exp ((t : ℂ) * ((X ω - m : ℝ) : ℂ) * Complex.I) ∂μ) =
        ∫ ω, Complex.exp (t * X ω * Complex.I) *
          Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) ∂μ := by
      apply integral_congr_ae
      filter_upwards with ω
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    _ = (∫ ω, Complex.exp (t * X ω * Complex.I) ∂μ) *
        Complex.exp (-((t : ℂ) * (m : ℂ)) * Complex.I) := by
      exact integral_mul_const _ _

/-- For a finite identically distributed independent family, the
characteristic function of the sum is the corresponding characteristic
function raised to the family cardinality. -/
theorem charFun_map_iid_sum_eq_pow
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (i₀ : ι)
    (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X i₀) μ μ)
    (t : ℝ) :
    MeasureTheory.charFun (μ.map (∑ i, X i)) t =
      MeasureTheory.charFun (μ.map (X i₀)) t ^ Fintype.card ι := by
  calc
    MeasureTheory.charFun (μ.map (∑ i, X i)) t =
        ∏ i, MeasureTheory.charFun (μ.map (X i)) t := by
      simpa only [Finset.prod_apply] using
        congrFun (hIndep.charFun_map_sum_eq_prod hX) t
    _ = MeasureTheory.charFun (μ.map (X i₀)) t ^ Fintype.card ι := by
      simp_rw [fun i => (hIdent i).map_eq]
      simp

/-- Exact characteristic-function formula for a finite centered and uniformly
scaled iid sum. This is the algebraic reduction used before the Taylor-limit
step in the classical characteristic-function proof of the CLT. -/
theorem charFun_map_centered_scaled_iid_sum_eq_pow
    {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ι → Ω → ℝ) (i₀ : ι)
    (hX : ∀ i, AEMeasurable (X i) μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X i₀) μ μ)
    (m a t : ℝ) :
    MeasureTheory.charFun
        (μ.map (∑ i, fun ω => a * (X i ω - m))) t =
      (MeasureTheory.charFun (μ.map (X i₀)) (a * t) *
        Complex.exp (-(((a * t : ℝ) : ℂ) * (m : ℂ)) * Complex.I)) ^
          Fintype.card ι := by
  let Y : ι → Ω → ℝ := fun i ω => a * (X i ω - m)
  have hY : ∀ i, AEMeasurable (Y i) μ := by
    intro i
    dsimp [Y]
    fun_prop
  have hIndepY : ProbabilityTheory.iIndepFun Y μ := by
    have h := hIndep.comp (fun (_ : ι) (x : ℝ) => a * (x - m))
      (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hIdentY : ∀ i, ProbabilityTheory.IdentDistrib (Y i) (Y i₀) μ μ := by
    intro i
    have h := (hIdent i).comp (by fun_prop : Measurable fun x : ℝ => a * (x - m))
    simpa [Y, Function.comp_def] using h
  have hsum := charFun_map_iid_sum_eq_pow Y i₀ hY hIndepY hIdentY t
  change MeasureTheory.charFun (μ.map (∑ i, Y i)) t = _ at hsum
  rw [hsum]
  congr 1
  have hCentered : AEMeasurable (fun ω => X i₀ ω - m) μ := by fun_prop
  have hscale := charFun_probabilityLaw_const_mul
    (fun ω => X i₀ ω - m) hCentered a t
  change MeasureTheory.charFun (μ.map (Y i₀)) t =
    MeasureTheory.charFun (μ.map (fun ω => X i₀ ω - m)) (a * t) at hscale
  rw [hscale]
  exact charFun_probabilityLaw_sub_const (X i₀) (hX i₀) m (a * t)

/-- The centered, unit-variance iid normalization, indexed by `N + 1` so the
denominator is never zero. -/
noncomputable def normalizedCenteredIidSum
    {Ω : Type*} (X : ℕ → Ω → ℝ) (N : ℕ) : Ω → ℝ :=
  fun ω => (Real.sqrt (N + 1 : ℝ))⁻¹ *
    ∑ i : Fin (N + 1), X i.1 ω

/-- The iid normalization with common mean `m` and positive standard
deviation `σ`, again indexed by the first `N + 1` variables. -/
noncomputable def normalizedIidSum
    {Ω : Type*} (X : ℕ → Ω → ℝ) (m σ : ℝ) (N : ℕ) : Ω → ℝ :=
  fun ω => (σ * Real.sqrt (N + 1 : ℝ))⁻¹ *
    ∑ i : Fin (N + 1), (X i.1 ω - m)

theorem normalizedCenteredIidSum_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) (N : ℕ) :
    MemLp (normalizedCenteredIidSum X N) 2 μ := by
  have hs : MemLp (fun ω => ∑ i : Fin (N + 1), X i.1 ω) 2 μ :=
    memLp_finset_sum Finset.univ (fun i _ => hX i.1)
  exact hs.const_mul (Real.sqrt (N + 1 : ℝ))⁻¹

theorem normalizedIidSum_memLp
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ) (N : ℕ) :
    MemLp (normalizedIidSum X m σ N) 2 μ := by
  have hs : MemLp
      (fun ω => ∑ i : Fin (N + 1), (X i.1 ω - m)) 2 μ :=
    memLp_finset_sum Finset.univ
      (fun i _ => (hX i.1).sub (memLp_const m))
  exact hs.const_mul (σ * Real.sqrt (N + 1 : ℝ))⁻¹

theorem integral_normalizedCenteredIidSum_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0) (N : ℕ) :
    ∫ ω, normalizedCenteredIidSum X N ω ∂μ = 0 := by
  unfold normalizedCenteredIidSum
  rw [integral_const_mul, integral_finset_sum]
  · simp_rw [fun i : Fin (N + 1) => (hIdent i.1).integral_eq, hMean]
    simp
  · intro i _
    exact (hX i.1).integrable (by norm_num)

theorem variance_normalizedCenteredIidSum_eq_one
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) (N : ℕ) :
    ProbabilityTheory.variance (normalizedCenteredIidSum X N) μ = 1 := by
  have hvar0 : ProbabilityTheory.variance (X 0) μ = 1 := by
    rw [ProbabilityTheory.variance_eq_integral (hX 0).aemeasurable, hMean]
    simpa using hSecond
  have hpair : Pairwise
      ((fun f g => ProbabilityTheory.IndepFun f g μ) on
        fun i : Fin (N + 1) => X i.1) := by
    intro i j hij
    exact hIndep.indepFun (Fin.val_injective.ne hij)
  have hsum := independentVarianceSum
    (fun i : Fin (N + 1) => hX i.1) hpair
  unfold normalizedCenteredIidSum
  rw [ProbabilityTheory.variance_const_mul]
  have hfun : (fun ω => ∑ i : Fin (N + 1), X i.1 ω) =
      ∑ i : Fin (N + 1), X i.1 := by
    funext ω
    simp
  rw [hfun, hsum]
  simp_rw [fun i : Fin (N + 1) => (hIdent i.1).variance_eq, hvar0]
  rw [Finset.sum_const, Finset.card_fin]
  simp only [nsmul_eq_mul, mul_one]
  have hsqrt : Real.sqrt (N + 1 : ℝ) ^ 2 = (N + 1 : ℝ) :=
    Real.sq_sqrt (by positivity)
  have hsqrt0 : Real.sqrt (N + 1 : ℝ) ≠ 0 := by positivity
  field_simp [hsqrt0]
  simpa [Nat.cast_add, Nat.cast_one] using hsqrt.symm

/-- Characteristic function of the normalized centered iid sum, expressed as
the `(N + 1)`-st power of the common one-variable characteristic function. -/
theorem charFun_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (N : ℕ) (t : ℝ) :
    MeasureTheory.charFun
        (probabilityLaw (normalizedCenteredIidSum X N)
          (normalizedCenteredIidSum_memLp X hX N).aemeasurable : Measure ℝ) t =
      (∫ ω, Complex.exp
        (((t / Real.sqrt (N + 1 : ℝ) * X 0 ω : ℝ) : ℂ) * Complex.I) ∂μ) ^
          (N + 1) := by
  let i₀ : Fin (N + 1) := ⟨0, Nat.succ_pos N⟩
  have hIndepFin : ProbabilityTheory.iIndepFun
      (fun i : Fin (N + 1) => X i.1) μ :=
    hIndep.precomp Fin.val_injective
  have hIdentFin : ∀ i : Fin (N + 1),
      ProbabilityTheory.IdentDistrib (X i.1) (X i₀.1) μ μ := by
    intro i
    simpa [i₀] using hIdent i.1
  have hf := charFun_map_centered_scaled_iid_sum_eq_pow
    (fun i : Fin (N + 1) => X i.1) i₀
    (fun i => (hX i.1).aemeasurable) hIndepFin hIdentFin
    0 (Real.sqrt (N + 1 : ℝ))⁻¹ t
  change MeasureTheory.charFun (μ.map (normalizedCenteredIidSum X N)) t = _
  rw [show normalizedCenteredIidSum X N =
      ∑ i : Fin (N + 1),
        fun ω => (Real.sqrt (N + 1 : ℝ))⁻¹ * (X i.1 ω - 0) by
    funext ω
    simp [normalizedCenteredIidSum, Finset.mul_sum]]
  rw [hf]
  have hcf := charFun_probabilityLaw (X 0) (hX 0).aemeasurable
    ((Real.sqrt (N + 1 : ℝ))⁻¹ * t)
  change MeasureTheory.charFun (μ.map (X 0)) _ = _ at hcf
  rw [hcf]
  simp only [mul_zero, Complex.ofReal_zero, zero_mul, neg_zero,
    Complex.exp_zero, mul_one, Fintype.card_fin]
  congr 2
  funext ω
  congr 1
  push_cast
  ring

/-- Probability laws whose identity random variables are centered and have
variance uniformly bounded by one form a tight family. -/
theorem isTight_probabilityMeasure_range_of_variance_le_one
    (P : ℕ → ProbabilityMeasure ℝ)
    (hLp : ∀ n, MemLp (fun x : ℝ => x) 2 (P n : Measure ℝ))
    (hMean : ∀ n, ∫ x : ℝ, x ∂(P n : Measure ℝ) = 0)
    (hVar : ∀ n,
      ProbabilityTheory.variance (fun x : ℝ => x) (P n : Measure ℝ) ≤ 1) :
    IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) | p ∈ Set.range P} := by
  rw [isTightMeasureSet_iff_exists_isCompact_measure_compl_le]
  intro ε hε
  obtain ⟨n, hn⟩ := ENNReal.exists_inv_nat_lt hε.ne'
  have hn0 : n ≠ 0 := by
    intro hnz
    subst n
    simp at hn
  have hnNat : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
  have hnR : (0 : ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn0
  have hnOneR : (1 : ℝ) ≤ n := by exact_mod_cast hnNat
  refine ⟨Set.Icc (-(n : ℝ)) n, isCompact_Icc, ?_⟩
  intro ν hν
  rcases hν with ⟨p, ⟨k, rfl⟩, rfl⟩
  have hcheb := ProbabilityTheory.meas_ge_le_variance_div_sq
    (hLp k) hnR
  calc
    (P k : Measure ℝ) (Set.Icc (-(n : ℝ)) n)ᶜ ≤
        (P k : Measure ℝ)
          {x | (n : ℝ) ≤ |x - ∫ y : ℝ, y ∂(P k : Measure ℝ)|} := by
      apply measure_mono
      intro x hx
      simp only [Set.mem_compl_iff, Set.mem_Icc, Set.mem_setOf_eq,
        hMean, sub_zero] at hx ⊢
      rw [not_and_or, not_le, not_le] at hx
      rcases hx with hx | hx
      · nlinarith [neg_le_abs x]
      · nlinarith [le_abs_self x]
    _ ≤ ENNReal.ofReal
        (ProbabilityTheory.variance (fun x : ℝ => x) (P k : Measure ℝ) /
          (n : ℝ) ^ 2) := hcheb
    _ ≤ ENNReal.ofReal (1 / (n : ℝ) ^ 2) := by
      apply ENNReal.ofReal_le_ofReal
      exact div_le_div_of_nonneg_right (hVar k) (sq_nonneg (n : ℝ))
    _ ≤ ENNReal.ofReal (1 / (n : ℝ)) := by
      apply ENNReal.ofReal_le_ofReal
      have hnSq : (n : ℝ) ≤ (n : ℝ) ^ 2 := by nlinarith
      exact one_div_le_one_div_of_le hnR hnSq
    _ = (n : ENNReal)⁻¹ := by
      rw [one_div, ENNReal.ofReal_inv_of_pos hnR]
      simp
    _ ≤ ε := hn.le

/-- The probability laws of the normalized centered iid sums form a tight
family. -/
theorem isTight_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) :
    IsTightMeasureSet {((p : ProbabilityMeasure ℝ) : Measure ℝ) |
      p ∈ Set.range (fun n => probabilityLaw (normalizedCenteredIidSum X n)
        (normalizedCenteredIidSum_memLp X hX n).aemeasurable)} := by
  let P : ℕ → ProbabilityMeasure ℝ := fun n =>
    probabilityLaw (normalizedCenteredIidSum X n)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
  apply isTight_probabilityMeasure_range_of_variance_le_one P
  · intro n
    change MemLp (fun x : ℝ => x) 2
      (Measure.map (normalizedCenteredIidSum X n) μ)
    rw [memLp_map_measure_iff (g := fun x : ℝ => x)
      continuous_id.aestronglyMeasurable
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable]
    simpa [Function.comp_def] using normalizedCenteredIidSum_memLp X hX n
  · intro n
    change (∫ x : ℝ, x ∂Measure.map (normalizedCenteredIidSum X n) μ) = 0
    have hiMap := integral_map
      (μ := μ) (φ := normalizedCenteredIidSum X n) (f := fun x : ℝ => x)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
      continuous_id.aestronglyMeasurable
    rw [hiMap]
    exact integral_normalizedCenteredIidSum_eq_zero X hX hIdent hMean n
  · intro n
    change ProbabilityTheory.variance (fun x : ℝ => x)
      (Measure.map (normalizedCenteredIidSum X n) μ) ≤ 1
    rw [ProbabilityTheory.variance_map (X := fun x : ℝ => x)
      measurable_id.aemeasurable
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable]
    simpa [Function.comp_def] using
      (variance_normalizedCenteredIidSum_eq_one
        X hX hIndep hIdent hMean hSecond n).le

/-- A tight sequence of real probability laws converges weakly when all of its
characteristic functions converge pointwise to the characteristic function of
the proposed limit law. This is the tightness-assisted form of Lévy's
continuity theorem needed by the finite-variance CLT. -/
theorem tendsto_probabilityMeasure_of_charFun_tendsto_of_tight
    (P : ℕ → ProbabilityMeasure ℝ) (Q : ProbabilityMeasure ℝ)
    (hTight : IsTightMeasureSet
      {((p : ProbabilityMeasure ℝ) : Measure ℝ) | p ∈ Set.range P})
    (hchar : ∀ t : ℝ, Tendsto
      (fun n => MeasureTheory.charFun (P n : Measure ℝ) t)
      atTop (𝓝 (MeasureTheory.charFun (Q : Measure ℝ) t))) :
    Tendsto P atTop (𝓝 Q) := by
  let S : Set (ProbabilityMeasure ℝ) := Set.range P
  have hcompact : IsCompact (closure S) :=
    isCompact_closure_of_isTightMeasureSet hTight
  refine hcompact.tendsto_nhds_of_unique_mapClusterPt ?_ ?_
  · exact Eventually.of_forall fun n => subset_closure ⟨n, rfl⟩
  · intro p hp hcluster
    apply ProbabilityMeasure.toMeasure_injective
    apply Measure.ext_of_charFun
    funext t
    have hc : Continuous
        (fun q : ProbabilityMeasure ℝ =>
          MeasureTheory.charFun (q : Measure ℝ) t) := by
      have hi : Continuous
          (fun q : ProbabilityMeasure ℝ =>
            ∫ x, BoundedContinuousFunction.innerProbChar t x ∂(q : Measure ℝ)) := by
        rw [continuous_iff_continuousAt]
        intro q
        exact (ProbabilityMeasure.tendsto_iff_forall_integral_rclike_tendsto ℂ).1
          continuousAt_id (BoundedContinuousFunction.innerProbChar t)
      simpa only [MeasureTheory.charFun_eq_integral_innerProbChar] using hi
    have hcluster_char : MapClusterPt
        (MeasureTheory.charFun (p : Measure ℝ) t) atTop
        (fun n => MeasureTheory.charFun (P n : Measure ℝ) t) :=
      hcluster.continuousAt_comp hc.continuousAt
    rw [mapClusterPt_iff_ultrafilter] at hcluster_char
    obtain ⟨U, hU, hUt⟩ := hcluster_char
    exact tendsto_nhds_unique hUt ((hchar t).mono_left hU)

/-- Lindeberg–Lévy for a centered unit-variance iid real sequence. The
normalization uses the first `N + 1` variables. -/
theorem tendsto_probabilityLaw_normalizedCenteredIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = 0)
    (hSecond : ∫ ω, (X 0 ω) ^ 2 ∂μ = 1) :
    Tendsto (fun n => probabilityLaw (normalizedCenteredIidSum X n)
        (normalizedCenteredIidSum_memLp X hX n).aemeasurable)
      atTop (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let P : ℕ → ProbabilityMeasure ℝ := fun n =>
    probabilityLaw (normalizedCenteredIidSum X n)
      (normalizedCenteredIidSum_memLp X hX n).aemeasurable
  let Q : ProbabilityMeasure ℝ := ⟨standardNormalLaw, inferInstance⟩
  change Tendsto P atTop (𝓝 Q)
  apply tendsto_probabilityMeasure_of_charFun_tendsto_of_tight P Q
  · exact isTight_probabilityLaw_normalizedCenteredIidSum
      X hX hIndep hIdent hMean hSecond
  · intro t
    have hbase := tendsto_centered_unitSecondMoment_charFun_pow_sqrt
      (X 0) (hX 0) hMean hSecond t
    have hsucc : Tendsto (fun n : ℕ => n + 1) atTop atTop :=
      Filter.tendsto_atTop_mono (fun n => Nat.le_succ n) tendsto_id
    have hlim := hbase.comp hsucc
    have hformula : ∀ n,
        MeasureTheory.charFun (P n : Measure ℝ) t =
          (∫ ω, Complex.exp
            (((t / Real.sqrt (n + 1 : ℝ) * X 0 ω : ℝ) : ℂ) * Complex.I) ∂μ) ^
              (n + 1) := by
      intro n
      exact charFun_probabilityLaw_normalizedCenteredIidSum
        X hX hIndep hIdent n t
    have hlimP : Tendsto
        (fun n => MeasureTheory.charFun (P n : Measure ℝ) t) atTop
        (𝓝 (Complex.exp (-(t : ℂ) ^ 2 / 2))) := by
      apply hlim.congr'
      filter_upwards with n
      symm
      simpa [P, Nat.cast_add, Nat.cast_one] using hformula n
    simpa [Q, standardNormalLaw_charFun] using hlimP

/-- Lindeberg–Lévy for iid real variables with common mean `m` and
variance `σ²`, with `σ > 0`. -/
theorem tendsto_probabilityLaw_normalizedIidSum
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : ℕ → Ω → ℝ) (m σ : ℝ) (hσ : 0 < σ)
    (hX : ∀ i, MemLp (X i) 2 μ)
    (hIndep : ProbabilityTheory.iIndepFun X μ)
    (hIdent : ∀ i, ProbabilityTheory.IdentDistrib (X i) (X 0) μ μ)
    (hMean : ∫ ω, X 0 ω ∂μ = m)
    (hVariance : ProbabilityTheory.variance (X 0) μ = σ ^ 2) :
    Tendsto (fun n => probabilityLaw (normalizedIidSum X m σ n)
        (normalizedIidSum_memLp X m σ hX n).aemeasurable)
      atTop (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ)) := by
  let Y : ℕ → Ω → ℝ := fun i ω => σ⁻¹ * (X i ω - m)
  have hY : ∀ i, MemLp (Y i) 2 μ := by
    intro i
    exact ((hX i).sub (memLp_const m)).const_mul σ⁻¹
  have hIndepY : ProbabilityTheory.iIndepFun Y μ := by
    have h := hIndep.comp
      (fun _ (x : ℝ) => σ⁻¹ * (x - m)) (fun _ => by fun_prop)
    simpa [Y, Function.comp_def] using h
  have hIdentY : ∀ i, ProbabilityTheory.IdentDistrib (Y i) (Y 0) μ μ := by
    intro i
    have h := (hIdent i).comp
      (by fun_prop : Measurable fun x : ℝ => σ⁻¹ * (x - m))
    simpa [Y, Function.comp_def] using h
  have hMeanY : ∫ ω, Y 0 ω ∂μ = 0 := by
    dsimp [Y]
    rw [integral_const_mul,
      integral_sub ((hX 0).integrable (by norm_num)) (integrable_const m), hMean]
    simp
  have hSecondY : ∫ ω, (Y 0 ω) ^ 2 ∂μ = 1 := by
    have hc : (∫ ω, (X 0 ω - m) ^ 2 ∂μ) = σ ^ 2 := by
      calc
        (∫ ω, (X 0 ω - m) ^ 2 ∂μ) =
            ProbabilityTheory.variance (X 0) μ := by
          rw [ProbabilityTheory.variance_eq_integral (hX 0).aemeasurable, hMean]
        _ = σ ^ 2 := hVariance
    dsimp [Y]
    calc
      (∫ ω, (σ⁻¹ * (X 0 ω - m)) ^ 2 ∂μ) =
          ∫ ω, σ⁻¹ ^ 2 * (X 0 ω - m) ^ 2 ∂μ := by
        congr 1
        funext ω
        ring
      _ = σ⁻¹ ^ 2 * ∫ ω, (X 0 ω - m) ^ 2 ∂μ :=
        integral_const_mul _ _
      _ = 1 := by
        rw [hc]
        field_simp [hσ.ne']
  have hEq (N : ℕ) :
      normalizedCenteredIidSum Y N = normalizedIidSum X m σ N := by
    funext ω
    simp only [normalizedCenteredIidSum, normalizedIidSum, Y]
    rw [← Finset.mul_sum Finset.univ
      (fun i : Fin (N + 1) => X i.1 ω - m) σ⁻¹]
    rw [← mul_assoc]
    apply congrArg
      (fun c : ℝ => c * ∑ i : Fin (N + 1), (X i.1 ω - m))
    rw [mul_inv_rev]
  have hclt := tendsto_probabilityLaw_normalizedCenteredIidSum
    Y hY hIndepY hIdentY hMeanY hSecondY
  apply hclt.congr'
  filter_upwards with n
  simp only [hEq n]

end NumStability.HDP.Scalar.LimitTheorems
