import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Centering a sub-exponential random variable

This module proves the intrinsic `ψ₁`-gauge form of Exercise 2.7.10.  The
universal constant is quantified outside the probability space and random
variable, matching the source's use of an absolute constant.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-! ## The triangle inequality for the exact `ψ₁` gauge -/

/-- Admissible `ψ₁` scales add.  Convexity of the exponential combines the
two normalized exponential moments. -/
lemma psiOneAdmissible_add_of_admissible
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} {s t : ℝ≥0∞}
    (hs : PsiOneAdmissible μ X s) (ht : PsiOneAdmissible μ Y t) :
    PsiOneAdmissible μ (fun ω => X ω + Y ω) (s + t) := by
  rcases hs with ⟨hX, hs0, hsTop, hXs, hXbound⟩
  rcases ht with ⟨hY, ht0, htTop, hYt, hYbound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hstTop : s + t ≠ ∞ := ENNReal.add_ne_top.2 ⟨hsTop, htTop⟩
  have hst0 : s + t ≠ 0 := by simp [hs0, ht0]
  have hstpos : 0 < (s + t).toReal := ENNReal.toReal_pos hst0 hstTop
  have hstreal : (s + t).toReal = s.toReal + t.toReal := by
    simpa using ENNReal.toReal_add hsTop htTop
  let a : ℝ := s.toReal / (s + t).toReal
  let b : ℝ := t.toReal / (s + t).toReal
  have ha : 0 ≤ a := div_nonneg hspos.le hstpos.le
  have hb : 0 ≤ b := div_nonneg htpos.le hstpos.le
  have hab : a + b = 1 := by
    dsimp [a, b]
    rw [hstreal]
    field_simp
  have harg : ∀ ω,
      |X ω + Y ω| / (s + t).toReal ≤
        a * (|X ω| / s.toReal) + b * (|Y ω| / t.toReal) := by
    intro ω
    have habs := abs_add_le (X ω) (Y ω)
    dsimp [a, b]
    rw [hstreal]
    field_simp
    nlinarith
  have hpoint : ∀ ω,
      Real.exp (|X ω + Y ω| / (s + t).toReal) ≤
        a * Real.exp (|X ω| / s.toReal) +
          b * Real.exp (|Y ω| / t.toReal) := by
    intro ω
    have hconv := convexOn_exp.2
      (show |X ω| / s.toReal ∈ Set.univ by trivial)
      (show |Y ω| / t.toReal ∈ Set.univ by trivial)
      ha hb hab
    exact (Real.exp_le_exp.mpr (harg ω)).trans hconv
  have hsum : Integrable (fun ω =>
      a * Real.exp (|X ω| / s.toReal) +
        b * Real.exp (|Y ω| / t.toReal)) μ :=
    (hXs.const_mul a).add (hYt.const_mul b)
  have hInt : Integrable
      (fun ω => Real.exp (|X ω + Y ω| / (s + t).toReal)) μ := by
    refine Integrable.mono' hsum (by fun_prop) ?_
    filter_upwards [] with ω
    simpa only [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hpoint ω
  refine ⟨hX.add hY, hst0, hstTop, hInt, ?_⟩
  have hmono := integral_mono_ae hInt hsum (Filter.Eventually.of_forall hpoint)
  calc
    (∫ ω, Real.exp (|X ω + Y ω| / (s + t).toReal) ∂μ) ≤
        ∫ ω, a * Real.exp (|X ω| / s.toReal) +
          b * Real.exp (|Y ω| / t.toReal) ∂μ := hmono
    _ = a * (∫ ω, Real.exp (|X ω| / s.toReal) ∂μ) +
          b * (∫ ω, Real.exp (|Y ω| / t.toReal) ∂μ) := by
      rw [integral_add (hXs.const_mul a) (hYt.const_mul b),
        integral_const_mul, integral_const_mul]
    _ ≤ a * 2 + b * 2 := by gcongr
    _ = 2 := by rw [← add_mul, hab, one_mul]

lemma psiOneAdmissible_neg_iff
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} {t : ℝ≥0∞} :
    PsiOneAdmissible μ (fun ω => -X ω) t ↔ PsiOneAdmissible μ X t := by
  constructor <;> intro h
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨by simpa using hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa using hInt
    · simpa using hBound
  · rcases h with ⟨hX, ht0, htTop, hInt, hBound⟩
    refine ⟨hX.neg, ht0, htTop, ?_, ?_⟩
    · simpa using hInt
    · simpa using hBound

theorem psiOneGauge_neg
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ} :
    PsiOneGauge μ (fun ω => -X ω) = PsiOneGauge μ X := by
  unfold PsiOneGauge
  congr 1
  ext t
  exact psiOneAdmissible_neg_iff

theorem psiOneGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X Y : Ω → ℝ} :
    PsiOneGauge μ (fun ω => X ω + Y ω) ≤
      PsiOneGauge μ X + PsiOneGauge μ Y := by
  change sInf {t : ℝ≥0∞ | PsiOneAdmissible μ (fun ω => X ω + Y ω) t} ≤
    sInf {s : ℝ≥0∞ | PsiOneAdmissible μ X s} +
      sInf {t : ℝ≥0∞ | PsiOneAdmissible μ Y t}
  simp only [sInf_eq_iInf]
  apply ENNReal.le_iInf₂_add_iInf₂
  intro s hs t ht
  have hadd := psiOneAdmissible_add_of_admissible hs ht
  exact iInf_le_of_le (s + t) (iInf_le_of_le hadd le_rfl)

/-! ## Constants and first moments -/

/-- A constant random variable has `ψ₁` gauge at most twice its absolute
value.  The deliberately non-optimal factor gives a simple universal scale. -/
theorem psiOneGauge_const_le_two_mul_abs
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (c : ℝ) :
    PsiOneGauge μ (fun _ : Ω => c) ≤ ENNReal.ofReal (2 * |c|) := by
  by_cases hc : c = 0
  · subst c
    simpa using (psiOneGauge_zero (Ω := Ω) (μ := μ))
  · unfold PsiOneGauge
    apply sInf_le
    have hcabs : 0 < |c| := abs_pos.mpr hc
    have hscale : 0 < 2 * |c| := by positivity
    have harg : |c| / (2 * |c|) = (1 / 2 : ℝ) := by field_simp
    have hexp : Real.exp (1 / 2 : ℝ) ≤ 2 := by
      calc
        Real.exp (1 / 2 : ℝ) ≤ Real.exp (Real.log 2) :=
          Real.exp_le_exp.mpr (by nlinarith [Real.log_two_gt_d9])
        _ = 2 := Real.exp_log (by norm_num)
    refine ⟨measurable_const, (ENNReal.ofReal_ne_zero_iff).2 hscale,
      ENNReal.ofReal_ne_top, ?_, ?_⟩
    · simp
    · simpa [ENNReal.toReal_ofReal hscale.le, harg] using hexp

/-- The first absolute moment is bounded by one universal multiple of the
exact `ψ₁` gauge. -/
theorem psiOneGaugeToMomentOne
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (hFinite : PsiOneGauge μ X < ∞) :
    Integrable (fun ω => |X ω|) μ ∧
      (∫ ω, |X ω| ∂μ) ≤
        1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
  by_cases hGaugeZero : PsiOneGauge μ X = 0
  · have hXZero : X =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
      (psiOneGauge_eq_zero_iff_ae_eq_zero hX).mp hGaugeZero
    have hAbsZero : (fun ω => |X ω|) =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) := by
      filter_upwards [hXZero] with ω hω
      simp [hω]
    have hInt : Integrable (fun ω => |X ω|) μ :=
      (integrable_zero Ω ℝ μ).congr hAbsZero.symm
    refine ⟨hInt, ?_⟩
    rw [integral_congr_ae hAbsZero]
    simp [hGaugeZero]
  · have hGaugeRealPos : 0 < (PsiOneGauge μ X).toReal :=
      ENNReal.toReal_pos hGaugeZero (ne_of_lt hFinite)
    let K : ℝ := 2 * (PsiOneGauge μ X).toReal
    have hK : 0 < K := by dsimp [K]; positivity
    have hOfRealK : ENNReal.ofReal K = 2 * PsiOneGauge μ X := by
      dsimp [K]
      rw [ENNReal.ofReal_mul (by norm_num : (0 : ℝ) ≤ 2),
        ENNReal.ofReal_toReal (ne_of_lt hFinite)]
      norm_num
    have hGaugeLt : PsiOneGauge μ X < ENNReal.ofReal K := by
      rw [hOfRealK]
      simpa [mul_comm] using ENNReal.mul_lt_mul_right hGaugeZero
        (ne_of_lt hFinite) (by norm_num : (1 : ℝ≥0∞) < 2)
    have hPoint : SubExponentialOnePointMGF μ X K :=
      psiOneGauge_lt_imp_onePointMGF hK hGaugeLt
    obtain ⟨L, _hL, hLBound, hMoment⟩ :=
      subExponentialPropertyTransfer .onePoint .moment hK hPoint
    change SubExponentialMomentBound μ X L at hMoment
    have hMomentOne := hMoment.2.2.2 1 (by norm_num : (1 : ℝ) ≤ 1)
    refine ⟨by simpa using hMomentOne.1, ?_⟩
    calc
      (∫ ω, |X ω| ∂μ) ≤ L := by simpa using hMomentOne.2
      _ ≤ 512 * (Real.exp 1) ^ 3 * K := hLBound
      _ = 1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
        dsimp [K]
        ring

/-! ## Exercise 2.7.10 -/

/-- Intrinsic quantitative centering: subtracting the expectation preserves
finite `ψ₁` gauge and increases that gauge by at most one fixed factor. -/
theorem centeredSubExponentialPsiOneNorm
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) (hFinite : PsiOneGauge μ X < ∞) :
    PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) < ∞ ∧
      PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
        ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) * PsiOneGauge μ X := by
  have hMomentOne := psiOneGaugeToMomentOne hX hFinite
  have hInt : Integrable X μ := by
    apply (integrable_norm_iff hX.aestronglyMeasurable).mp
    simpa [Real.norm_eq_abs] using hMomentOne.1
  let m : ℝ := ∫ x, X x ∂μ
  have hMean : |m| ≤
      1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
    have hIntegralNorm := norm_integral_le_integral_norm X (μ := μ)
    dsimp [m]
    calc
      |∫ x, X x ∂μ| ≤ ∫ x, ‖X x‖ ∂μ := hIntegralNorm
      _ = ∫ x, |X x| ∂μ := by simp only [Real.norm_eq_abs]
      _ ≤ 1024 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal :=
        hMomentOne.2
  have hCenterGauge :
      PsiOneGauge μ (fun ω => X ω - m) ≤
        ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) * PsiOneGauge μ X := by
    have hAdd := psiOneGauge_add_le (μ := μ)
      (X := X) (Y := fun _ : Ω => -m)
    have hConst := psiOneGauge_const_le_two_mul_abs
      (Ω := Ω) (μ := μ) (-m)
    have hMeanTwo : 2 * |-m| ≤
        2048 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal := by
      rw [abs_neg]
      nlinarith [hMean]
    calc
      PsiOneGauge μ (fun ω => X ω - m) ≤
          PsiOneGauge μ X + PsiOneGauge μ (fun _ : Ω => -m) := by
            simpa [sub_eq_add_neg] using hAdd
      _ ≤ PsiOneGauge μ X + ENNReal.ofReal (2 * |-m|) := by gcongr
      _ ≤ PsiOneGauge μ X +
          ENNReal.ofReal
            (2048 * (Real.exp 1) ^ 3 * (PsiOneGauge μ X).toReal) := by gcongr
      _ = ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          PsiOneGauge μ X := by
        rw [ENNReal.ofReal_mul
          (by positivity : 0 ≤ 2048 * (Real.exp 1) ^ 3)]
        rw [ENNReal.ofReal_toReal (ne_of_lt hFinite)]
        have hcoef : ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) =
            1 + ENNReal.ofReal (2048 * (Real.exp 1) ^ 3) := by
          rw [ENNReal.ofReal_add (by norm_num : 0 ≤ (1 : ℝ))
            (by positivity : 0 ≤ 2048 * (Real.exp 1) ^ 3)]
          norm_num
        rw [hcoef]
        ring
  have hCenterFinite : PsiOneGauge μ (fun ω => X ω - m) < ∞ :=
    lt_of_le_of_lt hCenterGauge
      (ENNReal.mul_lt_top ENNReal.ofReal_lt_top hFinite)
  simpa [m] using And.intro hCenterFinite hCenterGauge

/-- Uniform-constant form of Exercise 2.7.10. -/
theorem centeredSubExponentialPsiOneNorm_uniform :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
        {μ : Measure Ω} [IsProbabilityMeasure μ]
        {X : Ω → ℝ},
        Measurable X → PsiOneGauge μ X < ∞ →
          PsiOneGauge μ (fun ω => X ω - ∫ x, X x ∂μ) ≤
            ENNReal.ofReal C * PsiOneGauge μ X := by
  refine ⟨1 + 2048 * (Real.exp 1) ^ 3, ?_, ?_⟩
  · have hnonneg : 0 ≤ 2048 * (Real.exp 1) ^ 3 := by positivity
    linarith
  · intro Ω _ μ _ X hX hFinite
    exact (centeredSubExponentialPsiOneNorm hX hFinite).2

end NumStability.HDP.Scalar.SubExponential
