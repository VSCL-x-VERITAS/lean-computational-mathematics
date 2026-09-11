import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczNorm
import Mathlib.Analysis.Convex.Continuous
import Mathlib.Analysis.Normed.Group.Completeness
import Mathlib.MeasureTheory.Function.LpSpace.Complete

/-!
# Completeness of Orlicz spaces

This module develops the Fatou lower-semicontinuity foundation needed for the
completeness assertion following Exercise 2.7.11.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open scoped ENNReal Topology

namespace NumStability.HDP.Scalar.SubExponential

theorem OrliczFunction.continuousWithinAt_zero (ψ : OrliczFunction) :
    ContinuousWithinAt ψ (Ici 0) 0 := by
  rw [Metric.continuousWithinAt_iff]
  intro ε hε
  let M : ℝ := ψ 1 + 1
  have hM : 0 < M := by
    dsimp [M]
    exact add_pos_of_nonneg_of_pos (ψ.nonnegative 1 zero_le_one) zero_lt_one
  let δ : ℝ := min 1 (ε / M)
  have hδ : 0 < δ := lt_min zero_lt_one (div_pos hε hM)
  refine ⟨δ, hδ, ?_⟩
  intro y hy hydist
  have hy0 : 0 ≤ y := hy
  have hylt : y < δ := by simpa [Real.dist_eq, abs_of_nonneg hy0] using hydist
  have hy1 : y ≤ 1 := (hylt.le.trans (min_le_left _ _))
  have hconv := ψ.convexOn_nonneg.2 (show 0 ≤ (1 : ℝ) by norm_num)
    (show 0 ≤ (0 : ℝ) by norm_num) hy0 (sub_nonneg.mpr hy1) (by ring)
  have hψ : ψ y ≤ y * ψ 1 := by
    simpa [ψ.map_zero] using hconv
  have hyε : y < ε / M := hylt.trans_le (min_le_right _ _)
  have hbound : y * ψ 1 < ε := by
    calc
      y * ψ 1 ≤ y * M := by
        gcongr
        dsimp [M]
        linarith
      _ < (ε / M) * M := (mul_lt_mul_of_pos_right hyε hM)
      _ = ε := by field_simp
  rw [ψ.map_zero, Real.dist_eq, sub_zero,
    abs_of_nonneg (ψ.nonnegative y hy0)]
  exact hψ.trans_lt hbound

theorem OrliczFunction.continuousOn_nonneg (ψ : OrliczFunction) :
    ContinuousOn ψ (Ici 0) := by
  intro x hx
  have hx' : 0 ≤ x := hx
  rcases eq_or_lt_of_le hx' with hx0 | hx
  · subst x
    exact ψ.continuousWithinAt_zero
  · have hxint : x ∈ interior (Ici (0 : ℝ)) := by
      simpa [interior_Ici] using hx
    exact ((ψ.convexOn_nonneg.continuousOn_interior x hxint).continuousAt
      (isOpen_interior.mem_nhds hxint)).continuousWithinAt

/-- An Orlicz function eventually exceeds one at a positive argument. -/
theorem OrliczFunction.exists_pos_one_le (ψ : OrliczFunction) :
    ∃ R : ℝ, 0 < R ∧ 1 ≤ ψ R := by
  obtain ⟨R, hRψ, hR⟩ :=
    ((ψ.tendsto_atTop.eventually (eventually_ge_atTop (1 : ℝ))).and
      (eventually_gt_atTop (0 : ℝ))).exists
  exact ⟨R, hR, hRψ⟩

/-- A normalized Orlicz function controls its argument by an affine function
of its value. -/
theorem OrliczFunction.le_mul_one_add
    (ψ : OrliczFunction) {R z : ℝ} (hR : 0 < R) (hψR : 1 ≤ ψ R)
    (hz : 0 ≤ z) :
    z ≤ R * (1 + ψ z) := by
  by_cases hzR : z ≤ R
  · have hψz : 0 ≤ ψ z := ψ.nonnegative z hz
    nlinarith
  · have hRz : R < z := lt_of_not_ge hzR
    let a : ℝ := R / z
    let b : ℝ := 1 - a
    have hzpos : 0 < z := hR.trans hRz
    have ha : 0 ≤ a := div_nonneg hR.le hzpos.le
    have ha1 : a ≤ 1 := (div_le_one hzpos).2 hRz.le
    have hb : 0 ≤ b := sub_nonneg.mpr ha1
    have hab : a + b = 1 := by simp [b]
    have hconv := ψ.convexOn_nonneg.2 hz (show 0 ≤ (0 : ℝ) by norm_num)
      ha hb hab
    have hψRle : ψ R ≤ a * ψ z := by
      have haR : a * z = R := by
        dsimp [a]
        field_simp
      simpa [haR, b, ψ.map_zero] using hconv
    have hone : 1 ≤ a * ψ z := hψR.trans hψRle
    have hmul := mul_le_mul_of_nonneg_left hone hzpos.le
    have hzle : z ≤ R * ψ z := by
      dsimp [a] at hmul
      field_simp at hmul
      simpa [mul_assoc] using hmul
    have hψz : 0 ≤ ψ z := ψ.nonnegative z hz
    nlinarith

/-- Enlarging a positive finite scale preserves admissibility. -/
lemma orliczAdmissible_mono_scale
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) {s t : ℝ≥0∞}
    (hst : s ≤ t) (ht0 : t ≠ 0) (htTop : t ≠ ∞)
    (hs : orliczAdmissible ψ μ X s) :
    orliczAdmissible ψ μ X t := by
  rcases hs with ⟨hs0, hsTop, hsBound⟩
  have hspos : 0 < s.toReal := ENNReal.toReal_pos hs0 hsTop
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hstReal : s.toReal ≤ t.toReal :=
    (ENNReal.toReal_le_toReal hsTop htTop).2 hst
  refine ⟨ht0, htTop, ?_⟩
  exact (lintegral_mono fun ω => by
    apply ENNReal.ofReal_le_ofReal
    apply ψ.monotoneOn_nonneg
    · exact div_nonneg (abs_nonneg _) htpos.le
    · exact div_nonneg (abs_nonneg _) hspos.le
    · exact div_le_div_of_nonneg_left (abs_nonneg _) hspos hstReal).trans hsBound

/-- Every positive finite scale strictly above the gauge is admissible. -/
lemma orliczAdmissible_of_gauge_lt
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) {t : ℝ≥0∞}
    (hGauge : orliczGauge ψ μ X < t) (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczAdmissible ψ μ X t := by
  rw [orliczGauge, sInf_lt_iff] at hGauge
  obtain ⟨s, hs, hst⟩ := hGauge
  exact orliczAdmissible_mono_scale ψ μ X hst.le ht0 htTop hs

/-- On a probability space, admissibility at scale `t` gives a quantitative
`L¹` bound. -/
theorem eLpNorm_one_le_of_orliczAdmissible
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) {R : ℝ} (hR : 0 < R)
    (hψR : 1 ≤ ψ R) {t : ℝ≥0∞} (ht : orliczAdmissible ψ μ X t) :
    eLpNorm X 1 μ ≤ ENNReal.ofReal (2 * R * t.toReal) := by
  rcases ht with ⟨ht0, htTop, htBound⟩
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  let C : ℝ≥0∞ := ENNReal.ofReal (R * t.toReal)
  let f : Ω → ℝ≥0∞ :=
    fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))
  have hf : Measurable f := ψ.measurable_ofReal_comp_of_nonneg
    (hX.abs.div_const _) (fun _ => div_nonneg (abs_nonneg _) htpos.le)
  have hpoint : ∀ ω, ENNReal.ofReal |X ω| ≤ C + C * f ω := by
    intro ω
    have hz : 0 ≤ |X ω| / t.toReal :=
      div_nonneg (abs_nonneg _) htpos.le
    have hreal : |X ω| ≤ (R * t.toReal) *
        (1 + ψ (|X ω| / t.toReal)) := by
      have hbase := ψ.le_mul_one_add hR hψR hz
      have hmul := mul_le_mul_of_nonneg_left hbase htpos.le
      field_simp at hmul
      nlinarith
    calc
      ENNReal.ofReal |X ω| ≤ ENNReal.ofReal
          ((R * t.toReal) * (1 + ψ (|X ω| / t.toReal))) :=
        ENNReal.ofReal_le_ofReal hreal
      _ = C + C * f ω := by
        rw [ENNReal.ofReal_mul (mul_nonneg hR.le htpos.le),
          ENNReal.ofReal_add (by norm_num)
            (ψ.nonnegative _ hz)]
        simp [C, f, mul_add]
  rw [eLpNorm_one_eq_lintegral_enorm]
  simp_rw [← ofReal_norm_eq_enorm, Real.norm_eq_abs]
  calc
    (∫⁻ ω, ENNReal.ofReal |X ω| ∂μ) ≤
        ∫⁻ ω, C + C * f ω ∂μ := lintegral_mono hpoint
    _ = C * μ univ + C * orliczIntegral ψ μ X t := by
      rw [lintegral_add_left measurable_const,
        lintegral_const, lintegral_const_mul _ hf]
      rfl
    _ ≤ C * 1 + C * 1 := by
      gcongr
      · simp
    _ = ENNReal.ofReal (2 * R * t.toReal) := by
      simp only [mul_one]
      calc
        C + C = (2 : ℝ≥0∞) * C := by ring
        _ = ENNReal.ofReal ((2 : ℝ) * (R * t.toReal)) := by
          rw [show (2 : ℝ≥0∞) = ENNReal.ofReal (2 : ℝ) by norm_num,
            ← ENNReal.ofReal_mul (show 0 ≤ (2 : ℝ) by norm_num)]
        _ = ENNReal.ofReal (2 * R * t.toReal) := by ring_nf

/-- The `L¹` seminorm is bounded linearly by the Luxemburg gauge. -/
theorem eLpNorm_one_le_orliczGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) {R : ℝ} (hR : 0 < R)
    (hψR : 1 ≤ ψ R) :
    eLpNorm X 1 μ ≤ ENNReal.ofReal (2 * R) * orliczGauge ψ μ X := by
  let K : ℝ≥0∞ := ENNReal.ofReal (2 * R)
  have hK0 : K ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 (mul_pos two_pos hR)
  have hKTop : K ≠ ∞ := ENNReal.ofReal_ne_top
  let e : ℝ≥0∞ ≃o ℝ≥0∞ :=
    ENNReal.mulLeftOrderIso K (ENNReal.isUnit_iff.2 ⟨hK0, hKTop⟩)
  have he (t : ℝ≥0∞) : e t = K * t := by rfl
  let S : Set ℝ≥0∞ := {t | orliczAdmissible ψ μ X t}
  have hLower : eLpNorm X 1 μ ≤ sInf (e '' S) := by
    apply le_sInf
    intro u hu
    obtain ⟨t, ht, rfl⟩ := hu
    rw [he]
    calc
      eLpNorm X 1 μ ≤ ENNReal.ofReal (2 * R * t.toReal) :=
        eLpNorm_one_le_of_orliczAdmissible ψ μ X hX hR hψR ht
      _ = K * t := by
        rw [← ENNReal.ofReal_toReal ht.2.1]
        simp only [K]
        rw [← ENNReal.ofReal_mul (mul_nonneg (by norm_num) hR.le)]
        congr 1
        simp [ENNReal.toReal_ofReal ENNReal.toReal_nonneg]
  calc
    eLpNorm X 1 μ ≤ sInf (e '' S) := hLower
    _ = ⨅ t ∈ S, e t := sInf_image
    _ = e (sInf S) := (OrderIso.map_sInf e S).symm
    _ = ENNReal.ofReal (2 * R) * orliczGauge ψ μ X := by
      rw [he]
      rfl

/-- Every finite-gauge almost-everywhere class belongs to `L¹`. -/
theorem orliczAEEqSpace_memLp_one
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : orliczAEEqSpace ψ μ) :
    MemLp (X.1 : Ω → ℝ) 1 μ := by
  obtain ⟨R, hR, hψR⟩ := ψ.exists_pos_one_le
  refine ⟨X.1.aestronglyMeasurable, ?_⟩
  refine (eLpNorm_one_le_orliczGauge ψ μ X.1 X.1.measurable hR hψR).trans_lt ?_
  exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top X.2

/-- The canonical inclusion of the finite-gauge space into `L¹`. -/
noncomputable def orliczToLpOne
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : orliczAEEqSpace ψ μ) : Lp ℝ 1 μ :=
  (orliczAEEqSpace_memLp_one ψ μ X).toLp X.1

@[simp]
theorem orliczToLpOne_val
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : orliczAEEqSpace ψ μ) :
    (orliczToLpOne ψ μ X).1 = X.1 := by
  rw [orliczToLpOne, MemLp.toLp_val, AEEqFun.mk_coeFn]

theorem orliczToLpOne_norm_le
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    {R : ℝ} (hR : 0 < R) (hψR : 1 ≤ ψ R)
    (X : orliczAEEqSpace ψ μ) :
    ‖orliczToLpOne ψ μ X‖ ≤ (2 * R) * ‖X‖ := by
  rw [orliczToLpOne, Lp.norm_toLp, orliczAEEqSpace_norm_def]
  have hBound := eLpNorm_one_le_orliczGauge ψ μ X.1 X.1.measurable hR hψR
  have hRightTop : ENNReal.ofReal (2 * R) * orliczAEEqGauge ψ μ X.1 ≠ ∞ :=
    ne_of_lt (ENNReal.mul_lt_top ENNReal.ofReal_lt_top X.2)
  have hReal := (ENNReal.toReal_le_toReal
    (orliczAEEqSpace_memLp_one ψ μ X).2.ne hRightTop).2 hBound
  have h2R : 0 ≤ 2 * R := mul_nonneg (by norm_num) hR.le
  rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal h2R] at hReal
  exact hReal

/-- The `L¹` inclusion is real-linear. -/
noncomputable def orliczToLpOneLinear
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    orliczAEEqSpace ψ μ →ₗ[ℝ] Lp ℝ 1 μ where
  toFun := orliczToLpOne ψ μ
  map_add' X Y := by
    apply Lp.ext
    filter_upwards [
      (orliczAEEqSpace_memLp_one ψ μ (X + Y)).coeFn_toLp,
      AEEqFun.coeFn_add X.1 Y.1,
      Lp.coeFn_add (orliczToLpOne ψ μ X) (orliczToLpOne ψ μ Y),
      (orliczAEEqSpace_memLp_one ψ μ X).coeFn_toLp.add
        (orliczAEEqSpace_memLp_one ψ μ Y).coeFn_toLp] with ω h₁ h₂ h₃ h₄
    simpa [orliczToLpOne] using h₁.trans (h₂.trans (h₄.symm.trans h₃.symm))
  map_smul' c X := by
    apply Lp.ext
    filter_upwards [
      (orliczAEEqSpace_memLp_one ψ μ (c • X)).coeFn_toLp,
      AEEqFun.coeFn_smul c X.1,
      Lp.coeFn_smul c (orliczToLpOne ψ μ X),
      (orliczAEEqSpace_memLp_one ψ μ X).coeFn_toLp.const_smul c] with ω h₁ h₂ h₃ h₄
    simpa [orliczToLpOne] using h₁.trans (h₂.trans (h₄.symm.trans h₃.symm))

/-- On the finite-gauge subtype, the extended gauge is the ENNReal coercion
of the norm. -/
theorem orliczAEEqGauge_eq_ofReal_norm
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : orliczAEEqSpace ψ μ) :
    orliczAEEqGauge ψ μ X.1 = ENNReal.ofReal ‖X‖ := by
  rw [orliczAEEqSpace_norm_def]
  exact (ENNReal.ofReal_toReal (ne_of_lt X.2)).symm

/-- Fatou lower semicontinuity of the Orlicz modular at a fixed positive,
finite scale. -/
theorem orliczIntegral_le_liminf_of_ae_tendsto
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ)
    (hXn : ∀ n, Measurable (Xn n))
    (hlim : ∀ᵐ ω ∂μ, Tendsto (fun n => Xn n ω) atTop (𝓝 (X ω)))
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczIntegral ψ μ X t ≤
      liminf (fun n => orliczIntegral ψ μ (Xn n) t) atTop := by
  have htpos : 0 < t.toReal := ENNReal.toReal_pos ht0 htTop
  have hmeas : ∀ n, Measurable
      (fun ω => ENNReal.ofReal (ψ (|Xn n ω| / t.toReal))) := by
    intro n
    exact ψ.measurable_ofReal_comp_of_nonneg
      ((hXn n).abs.div_const _)
      (fun _ => div_nonneg (abs_nonneg _) htpos.le)
  have heq :
      (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) =ᵐ[μ]
        (fun ω => liminf
          (fun n => ENNReal.ofReal (ψ (|Xn n ω| / t.toReal))) atTop) := by
    filter_upwards [hlim] with ω hω
    have harg : Tendsto (fun n => |Xn n ω| / t.toReal) atTop
        (𝓝 (|X ω| / t.toReal)) := hω.abs.div_const _
    have hargWithin : Tendsto (fun n => |Xn n ω| / t.toReal) atTop
        (𝓝[Ici 0] (|X ω| / t.toReal)) :=
      tendsto_nhdsWithin_iff.2 ⟨harg,
        Filter.Eventually.of_forall
          (fun n => div_nonneg (abs_nonneg _) htpos.le)⟩
    have hcont : Tendsto ψ (𝓝[Ici 0] (|X ω| / t.toReal))
        (𝓝 (ψ (|X ω| / t.toReal))) :=
      ψ.continuousOn_nonneg _ (div_nonneg (abs_nonneg _) htpos.le)
    have hψ : Tendsto (fun n => ψ (|Xn n ω| / t.toReal)) atTop
        (𝓝 (ψ (|X ω| / t.toReal))) := hcont.comp hargWithin
    exact (ENNReal.tendsto_ofReal hψ).liminf_eq.symm
  unfold orliczIntegral
  rw [lintegral_congr_ae heq]
  exact lintegral_liminf_le hmeas

/-- A common strict gauge bound survives an almost-everywhere pointwise
limit.  This is the closed-ball form of Fatou lower semicontinuity needed in
the completeness argument. -/
theorem orliczGauge_le_scale_of_ae_tendsto
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ)
    (hXn : ∀ n, Measurable (Xn n))
    (hlim : ∀ᵐ ω ∂μ, Tendsto (fun n => Xn n ω) atTop (𝓝 (X ω)))
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞)
    (hGauge : ∀ n, orliczGauge ψ μ (Xn n) < t) :
    orliczGauge ψ μ X ≤ t := by
  have hAdmissible : ∀ n, orliczAdmissible ψ μ (Xn n) t :=
    fun n => orliczAdmissible_of_gauge_lt ψ μ (Xn n) (hGauge n) ht0 htTop
  have hIntegral : orliczIntegral ψ μ X t ≤ 1 :=
    (orliczIntegral_le_liminf_of_ae_tendsto ψ μ Xn X hXn hlim ht0 htTop).trans
      (liminf_le_of_frequently_le'
        (Filter.Frequently.of_forall fun n => (hAdmissible n).2.2))
  exact sInf_le ⟨ht0, htTop, hIntegral⟩

/-- Closed gauge balls are also closed under `L¹` convergence. -/
theorem orliczAEEqGauge_le_scale_of_Lp_tendsto
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Xn : ℕ → orliczAEEqSpace ψ μ) (Y : Lp ℝ 1 μ)
    (hlim : Tendsto (fun n => orliczToLpOne ψ μ (Xn n)) atTop (𝓝 Y))
    {t : ℝ≥0∞} (ht0 : t ≠ 0) (htTop : t ≠ ∞)
    (hGauge : ∀ n, orliczAEEqGauge ψ μ (Xn n).1 < t) :
    orliczAEEqGauge ψ μ Y.1 ≤ t := by
  obtain ⟨ns, -, hAE⟩ :=
    (tendstoInMeasure_of_tendsto_Lp hlim).exists_seq_tendsto_ae
  apply orliczGauge_le_scale_of_ae_tendsto ψ μ
    (fun n => (orliczToLpOne ψ μ (Xn (ns n)) : Ω → ℝ))
    (Y : Ω → ℝ)
  · exact fun n => (orliczToLpOne ψ μ (Xn (ns n))).1.measurable
  · exact hAE
  · exact ht0
  · exact htTop
  · intro n
    change orliczGauge ψ μ
      (orliczToLpOne ψ μ (Xn (ns n)) : Ω → ℝ) < t
    have hg := hGauge (ns n)
    change orliczGauge ψ μ ((Xn (ns n)).1 : Ω → ℝ) < t at hg
    refine (orliczGauge_ae_congr ψ μ ?_).trans_lt hg
    exact (orliczAEEqSpace_memLp_one ψ μ (Xn (ns n))).coeFn_toLp

/-- The finite-gauge Orlicz space is complete. -/
noncomputable instance orliczAEEqSpaceCompleteSpace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    CompleteSpace (orliczAEEqSpace ψ μ) :=
  NormedAddCommGroup.completeSpace_of_summable_imp_tendsto (by
    intro u hu
    let S : ℕ → orliczAEEqSpace ψ μ :=
      fun n => ∑ i ∈ Finset.range n, u i
    obtain ⟨R, hR, hψR⟩ := ψ.exists_pos_one_le
    have hImageSummable :
        Summable (fun n => ‖orliczToLpOne ψ μ (u n)‖) := by
      apply Summable.of_nonneg_of_le (fun n => norm_nonneg _)
        (fun n => orliczToLpOne_norm_le ψ μ hR hψR (u n))
      exact hu.mul_left (2 * R)
    obtain ⟨Y, hY⟩ :=
      NormedAddCommGroup.summable_imp_tendsto_of_complete
        (fun n => orliczToLpOne ψ μ (u n)) hImageSummable
    have hSY : Tendsto (fun n => orliczToLpOne ψ μ (S n)) atTop (𝓝 Y) := by
      have hMap : (fun n => orliczToLpOne ψ μ (S n)) =
          fun n => ∑ i ∈ Finset.range n, orliczToLpOne ψ μ (u i) := by
        funext n
        change orliczToLpOneLinear ψ μ (S n) =
          ∑ i ∈ Finset.range n, orliczToLpOneLinear ψ μ (u i)
        exact map_sum (orliczToLpOneLinear ψ μ) _ _
      rw [hMap]
      exact hY
    let T : ℝ := ∑' n, ‖u n‖
    have hTnonneg : 0 ≤ T := tsum_nonneg fun _ => norm_nonneg _
    have hSnNorm : ∀ n, ‖S n‖ ≤ T := by
      intro n
      calc
        ‖S n‖ ≤ ∑ i ∈ Finset.range n, ‖u i‖ := by
          exact norm_sum_le _ _
        _ ≤ T := hu.sum_le_tsum (Finset.range n)
          (fun _ _ => norm_nonneg _)
    let t : ℝ≥0∞ := ENNReal.ofReal (T + 1)
    have htposReal : 0 < T + 1 := add_pos_of_nonneg_of_pos hTnonneg zero_lt_one
    have ht0 : t ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 htposReal
    have htTop : t ≠ ∞ := ENNReal.ofReal_ne_top
    have hSnGauge : ∀ n, orliczAEEqGauge ψ μ (S n).1 < t := by
      intro n
      rw [orliczAEEqGauge_eq_ofReal_norm]
      exact (ENNReal.ofReal_le_ofReal (hSnNorm n)).trans_lt
        ((ENNReal.ofReal_lt_ofReal_iff htposReal).2 (lt_add_one T))
    have hYGauge : orliczAEEqGauge ψ μ Y.1 ≤ t :=
      orliczAEEqGauge_le_scale_of_Lp_tendsto ψ μ S Y hSY ht0 htTop hSnGauge
    have hYmem : orliczAEEqGauge ψ μ Y.1 < ∞ :=
      hYGauge.trans_lt ENNReal.ofReal_lt_top
    let a : orliczAEEqSpace ψ μ := ⟨Y.1, hYmem⟩
    have hLa : orliczToLpOne ψ μ a = Y := by
      apply Subtype.ext
      exact orliczToLpOne_val ψ μ a
    have hSCauchy : CauchySeq S := by
      apply cauchySeq_of_summable_dist
      simpa [S, dist_eq_norm, Finset.sum_range_succ] using hu
    refine ⟨a, Metric.tendsto_atTop.mpr fun ε hε => ?_⟩
    obtain ⟨N, hN⟩ :=
      (Metric.cauchySeq_iff.1 hSCauchy (ε / 2) (half_pos hε))
    refine ⟨N, fun n hn => ?_⟩
    let Xtail : ℕ → orliczAEEqSpace ψ μ :=
      fun k => S (k + n) - S n
    have hTailLim : Tendsto
        (fun k => orliczToLpOne ψ μ (Xtail k)) atTop
        (𝓝 (Y - orliczToLpOne ψ μ (S n))) := by
      have hShift := hSY.comp (tendsto_add_atTop_nat n)
      have hSub := hShift.sub_const (orliczToLpOne ψ μ (S n))
      have hMap : (fun k => orliczToLpOne ψ μ (Xtail k)) =
          fun k => orliczToLpOne ψ μ (S (k + n)) -
            orliczToLpOne ψ μ (S n) := by
        funext k
        change orliczToLpOneLinear ψ μ (Xtail k) =
          orliczToLpOneLinear ψ μ (S (k + n)) -
            orliczToLpOneLinear ψ μ (S n)
        change orliczToLpOneLinear ψ μ (S (k + n) - S n) = _
        exact map_sub (orliczToLpOneLinear ψ μ) _ _
      rw [hMap]
      exact hSub
    have hTailGauge : ∀ k,
        orliczAEEqGauge ψ μ (Xtail k).1 < ENNReal.ofReal (ε / 2) := by
      intro k
      rw [orliczAEEqGauge_eq_ofReal_norm]
      apply (ENNReal.ofReal_lt_ofReal_iff (half_pos hε)).2
      simpa [Xtail, dist_eq_norm] using
        hN (k + n) (by omega) n hn
    have hLimitGauge := orliczAEEqGauge_le_scale_of_Lp_tendsto ψ μ Xtail
      (Y - orliczToLpOne ψ μ (S n)) hTailLim
      ((ENNReal.ofReal_ne_zero_iff).2 (half_pos hε)) ENNReal.ofReal_ne_top
      hTailGauge
    have hMapSub : orliczToLpOne ψ μ (a - S n) =
        orliczToLpOne ψ μ a - orliczToLpOne ψ μ (S n) := by
      change orliczToLpOneLinear ψ μ (a - S n) =
        orliczToLpOneLinear ψ μ a - orliczToLpOneLinear ψ μ (S n)
      exact map_sub (orliczToLpOneLinear ψ μ) _ _
    have hVal : (Y - orliczToLpOne ψ μ (S n)).1 = (a - S n).1 := by
      calc
        (Y - orliczToLpOne ψ μ (S n)).1 =
            (orliczToLpOne ψ μ a - orliczToLpOne ψ μ (S n)).1 := by rw [hLa]
        _ = (orliczToLpOne ψ μ (a - S n)).1 := by rw [hMapSub]
        _ = (a - S n).1 := orliczToLpOne_val ψ μ (a - S n)
    rw [hVal] at hLimitGauge
    rw [orliczAEEqGauge_eq_ofReal_norm] at hLimitGauge
    have hNorm : ‖a - S n‖ ≤ ε / 2 :=
      (ENNReal.ofReal_le_ofReal_iff (half_pos hε).le).1 hLimitGauge
    rw [dist_eq_norm, norm_sub_rev]
    exact hNorm.trans_lt (half_lt_self hε))

end NumStability.HDP.Scalar.SubExponential
