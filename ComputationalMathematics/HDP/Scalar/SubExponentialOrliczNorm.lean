import ComputationalMathematics.HDP.Scalar.SubExponentialOrliczDefinitions

/-!
# The Luxemburg gauge norm laws

This module develops the reusable analytic content of Exercise 2.7.11 for an
arbitrary Orlicz function.  It keeps the extended-valued gauge on measurable
representatives until finiteness and almost-everywhere quotienting are applied.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open scoped ENNReal Topology

namespace NumStability.HDP.Scalar.SubExponential

lemma OrliczFunction.measurable_ofReal_comp_of_nonneg
    (ψ : OrliczFunction) {Ω : Type*} [MeasurableSpace Ω]
    {f : Ω → ℝ} (hf : Measurable f) (h0 : ∀ ω, 0 ≤ f ω) :
    Measurable (fun ω => ENNReal.ofReal (ψ (f ω))) := by
  have hmono : Monotone (fun x : ℝ => ψ (max x 0)) := by
    intro x y hxy
    exact ψ.monotoneOn_nonneg (by exact le_max_right x 0) (by exact le_max_right y 0)
      (max_le_max hxy le_rfl)
  have hmeas : Measurable (fun x : ℝ => ENNReal.ofReal (ψ (max x 0))) :=
    ENNReal.measurable_ofReal.comp hmono.measurable
  simpa [Function.comp_def, h0] using hmeas.comp hf

lemma orliczAdmissible_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {t : ℝ≥0∞}
    (ht0 : t ≠ 0) (htTop : t ≠ ∞) :
    orliczAdmissible ψ μ (fun _ : Ω => (0 : ℝ)) t := by
  simp [orliczAdmissible, orliczIntegral, ht0, htTop, ψ.map_zero]

theorem orliczGauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :
    orliczGauge ψ μ (fun _ : Ω => (0 : ℝ)) = 0 := by
  apply le_antisymm
  · apply le_of_forall_gt_imp_ge_of_dense
    intro r hr
    by_cases hrTop : r = ∞
    · simp [hrTop]
    exact sInf_le (orliczAdmissible_zero ψ μ (ne_of_gt hr) hrTop)
  · exact bot_le

lemma orliczAdmissible_neg_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (t : ℝ≥0∞) :
    orliczAdmissible ψ μ (fun ω => -X ω) t ↔
      orliczAdmissible ψ μ X t := by
  simp only [orliczAdmissible, orliczIntegral, abs_neg]

theorem orliczGauge_neg
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) :
    orliczGauge ψ μ (fun ω => -X ω) = orliczGauge ψ μ X := by
  unfold orliczGauge
  congr 1
  ext t
  exact orliczAdmissible_neg_iff ψ μ X t

lemma orliczAdmissible_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ}
    (hXY : X =ᵐ[μ] Y) (t : ℝ≥0∞) :
    orliczAdmissible ψ μ X t ↔ orliczAdmissible ψ μ Y t := by
  have hfun :
      (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) =ᵐ[μ]
        (fun ω => ENNReal.ofReal (ψ (|Y ω| / t.toReal))) := by
    filter_upwards [hXY] with ω hω
    simp [hω]
  constructor <;> rintro ⟨ht0, htTop, hBound⟩
  · refine ⟨ht0, htTop, ?_⟩
    unfold orliczIntegral at hBound ⊢
    rw [← lintegral_congr_ae hfun]
    exact hBound
  · refine ⟨ht0, htTop, ?_⟩
    unfold orliczIntegral at hBound ⊢
    rw [lintegral_congr_ae hfun]
    exact hBound

theorem orliczGauge_ae_congr
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ}
    (hXY : X =ᵐ[μ] Y) :
    orliczGauge ψ μ X = orliczGauge ψ μ Y := by
  unfold orliczGauge
  congr 1
  ext t
  exact orliczAdmissible_ae_congr ψ μ hXY t

lemma exists_pos_measure_abs_ge_of_not_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {X : Ω → ℝ}
    (hX : ¬X =ᵐ[μ] (fun _ => (0 : ℝ))) :
    ∃ δ : ℝ, 0 < δ ∧ 0 < μ {ω | δ ≤ |X ω|} := by
  have hsupport : μ (Function.support X) ≠ 0 := by
    intro hzero
    exact hX ((Measure.measure_support_eq_zero_iff μ).mp hzero)
  have hUnion :
      Function.support X =
        ⋃ n : ℕ, {ω | (1 : ℝ) / (n + 1 : ℝ) ≤ |X ω|} := by
    ext ω
    simp only [Function.mem_support, ne_eq, Set.mem_iUnion, Set.mem_setOf_eq]
    constructor
    · intro hne
      obtain ⟨n, hn⟩ := exists_nat_one_div_lt (abs_pos.mpr hne)
      exact ⟨n, hn.le⟩
    · rintro ⟨n, hn⟩
      have hδ : 0 < (1 : ℝ) / (n + 1 : ℝ) := by positivity
      exact abs_pos.mp (hδ.trans_le hn)
  rw [hUnion] at hsupport
  obtain ⟨n, hn⟩ := exists_measure_pos_of_not_measure_iUnion_null hsupport
  exact ⟨(1 : ℝ) / (n + 1 : ℝ), by positivity, hn⟩

theorem orliczGauge_eq_zero_iff_ae_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X) :
    orliczGauge ψ μ X = 0 ↔ X =ᵐ[μ] (fun _ => (0 : ℝ)) := by
  constructor
  · intro hGauge
    by_contra hNotZero
    obtain ⟨δ, hδ, hμA⟩ :=
      exists_pos_measure_abs_ge_of_not_ae_eq_zero μ hNotZero
    let A : Set Ω := {ω | δ ≤ |X ω|}
    have hμATop : μ A ≠ ∞ := measure_ne_top μ A
    have hμAReal : 0 < (μ A).toReal := ENNReal.toReal_pos hμA.ne' hμATop
    let R : ℝ := 2 / (μ A).toReal
    have hR : 0 < R := div_pos (by norm_num) hμAReal
    have hRmul : (1 : ℝ≥0∞) < ENNReal.ofReal R * μ A := by
      have hcalc : R * (μ A).toReal = 2 := by
        dsimp [R]
        field_simp
      rw [← ENNReal.ofReal_toReal hμATop,
        ← ENNReal.ofReal_mul hR.le, hcalc]
      norm_num
    have hev : ∀ᶠ r in 𝓝[>] (0 : ℝ), R < ψ (δ / r) :=
      (ψ.tendsto_scale_separation hδ).eventually (eventually_gt_atTop R)
    obtain ⟨r, hrψ, hr⟩ := (hev.and self_mem_nhdsWithin).exists
    have hrpos : 0 < r := hr
    have hGaugeLt : orliczGauge ψ μ X < ENNReal.ofReal r := by
      rw [hGauge]
      exact ENNReal.ofReal_pos.mpr hrpos
    rw [orliczGauge, sInf_lt_iff] at hGaugeLt
    obtain ⟨u, huAd, huLt⟩ := hGaugeLt
    rcases huAd with ⟨hu0, huTop, huBound⟩
    have hupos : 0 < u.toReal := ENNReal.toReal_pos hu0 huTop
    have huRealLt : u.toReal < r := by
      have := (ENNReal.toReal_lt_toReal huTop ENNReal.ofReal_ne_top).2 huLt
      simpa [ENNReal.toReal_ofReal hrpos.le] using this
    have hψarg : ∀ ω ∈ A, ψ (δ / r) ≤ ψ (|X ω| / u.toReal) := by
      intro ω hω
      have hfirst : δ / r ≤ δ / u.toReal :=
        div_le_div_of_nonneg_left hδ.le hupos huRealLt.le
      have hsecond : δ / u.toReal ≤ |X ω| / u.toReal :=
        div_le_div_of_nonneg_right hω hupos.le
      exact ψ.monotoneOn_nonneg
        (div_nonneg hδ.le hrpos.le)
        (div_nonneg (abs_nonneg _) hupos.le)
        (hfirst.trans hsecond)
    have hlevel : A ⊆ {ω |
        ENNReal.ofReal (ψ (δ / r)) ≤
          ENNReal.ofReal (ψ (|X ω| / u.toReal))} := by
      intro ω hω
      exact ENNReal.ofReal_le_ofReal (hψarg ω hω)
    have hmeas : Measurable
        (fun ω => ENNReal.ofReal (ψ (|X ω| / u.toReal))) :=
      ψ.measurable_ofReal_comp_of_nonneg
        (hX.abs.div_const _)
        (fun _ => div_nonneg (abs_nonneg _) hupos.le)
    have hmarkov := mul_meas_ge_le_lintegral (μ := μ) hmeas
      (ENNReal.ofReal (ψ (δ / r)))
    have hRψ : ENNReal.ofReal R < ENNReal.ofReal (ψ (δ / r)) :=
      (ENNReal.ofReal_lt_ofReal_iff (hR.trans hrψ)).2 hrψ
    have hIntegralGt : (1 : ℝ≥0∞) < orliczIntegral ψ μ X u := by
      calc
        (1 : ℝ≥0∞) < ENNReal.ofReal R * μ A := hRmul
        _ ≤ ENNReal.ofReal (ψ (δ / r)) * μ A :=
          mul_le_mul_right' hRψ.le _
        _ ≤ ENNReal.ofReal (ψ (δ / r)) *
            μ {ω | ENNReal.ofReal (ψ (δ / r)) ≤
              ENNReal.ofReal (ψ (|X ω| / u.toReal))} :=
          mul_le_mul_left' (measure_mono hlevel) _
        _ ≤ orliczIntegral ψ μ X u := by
          simpa [orliczIntegral] using hmarkov
    exact (not_lt_of_ge huBound) hIntegralGt
  · intro hZero
    rw [orliczGauge_ae_congr ψ μ hZero]
    exact orliczGauge_zero ψ μ

lemma orliczAdmissible_smul_iff_of_pos
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    {c : ℝ} (hc : 0 < c) (t : ℝ≥0∞) :
    orliczAdmissible ψ μ X t ↔
      orliczAdmissible ψ μ (fun ω => c * X ω) (ENNReal.ofReal c * t) := by
  have hc0 : ENNReal.ofReal c ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hc
  have hcTop : ENNReal.ofReal c ≠ ∞ := ENNReal.ofReal_ne_top
  constructor
  · rintro ⟨ht0, htTop, hBound⟩
    have htReal : t.toReal ≠ 0 := (ENNReal.toReal_ne_zero).2 ⟨ht0, htTop⟩
    have hfun :
        (fun ω => ENNReal.ofReal
          (ψ (|c * X ω| / (ENNReal.ofReal c * t).toReal))) =
          (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) := by
      funext ω
      rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal hc.le, abs_mul, abs_of_pos hc]
      congr 2
      field_simp
    refine ⟨mul_ne_zero hc0 ht0, ENNReal.mul_ne_top hcTop htTop, ?_⟩
    unfold orliczIntegral at hBound ⊢
    rw [hfun]
    exact hBound
  · rintro ⟨hct0, hctTop, hBound⟩
    have ht0 : t ≠ 0 := fun h => hct0 (by rw [h]; simp)
    have htTop : t ≠ ∞ := fun h => hctTop (by rw [h]; simp [hc0])
    have htReal : t.toReal ≠ 0 := (ENNReal.toReal_ne_zero).2 ⟨ht0, htTop⟩
    have hfun :
        (fun ω => ENNReal.ofReal
          (ψ (|c * X ω| / (ENNReal.ofReal c * t).toReal))) =
          (fun ω => ENNReal.ofReal (ψ (|X ω| / t.toReal))) := by
      funext ω
      rw [ENNReal.toReal_mul, ENNReal.toReal_ofReal hc.le, abs_mul, abs_of_pos hc]
      congr 2
      field_simp
    refine ⟨ht0, htTop, ?_⟩
    unfold orliczIntegral at hBound ⊢
    rw [← hfun]
    exact hBound

theorem orliczGauge_smul_of_pos
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ)
    {c : ℝ} (hc : 0 < c) :
    orliczGauge ψ μ (fun ω => c * X ω) =
      ENNReal.ofReal c * orliczGauge ψ μ X := by
  let a : ℝ≥0∞ := ENNReal.ofReal c
  have ha0 : a ≠ 0 := (ENNReal.ofReal_ne_zero_iff).2 hc
  have haTop : a ≠ ∞ := ENNReal.ofReal_ne_top
  let e : ℝ≥0∞ ≃o ℝ≥0∞ :=
    ENNReal.mulLeftOrderIso a (ENNReal.isUnit_iff.2 ⟨ha0, haTop⟩)
  have he (t : ℝ≥0∞) : e t = a * t := by rfl
  have hset :
      {u : ℝ≥0∞ | orliczAdmissible ψ μ (fun ω => c * X ω) u} =
        e '' {t : ℝ≥0∞ | orliczAdmissible ψ μ X t} := by
    ext u
    constructor
    · intro hu
      refine ⟨e.symm u, ?_, e.apply_symm_apply u⟩
      apply (orliczAdmissible_smul_iff_of_pos ψ μ X hc (e.symm u)).2
      rw [← he, e.apply_symm_apply]
      exact hu
    · rintro ⟨t, ht, rfl⟩
      rw [he]
      exact (orliczAdmissible_smul_iff_of_pos ψ μ X hc t).1 ht
  unfold orliczGauge
  rw [hset, ← he, OrderIso.map_sInf e, sInf_image]

theorem orliczGauge_smul
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω → ℝ) (c : ℝ) :
    orliczGauge ψ μ (fun ω => c * X ω) =
      ENNReal.ofReal |c| * orliczGauge ψ μ X := by
  by_cases hc0 : c = 0
  · subst c
    simp [orliczGauge_zero]
  by_cases hc : 0 < c
  · simpa [abs_of_pos hc] using orliczGauge_smul_of_pos ψ μ X hc
  · have hcneg : c < 0 := lt_of_le_of_ne (le_of_not_gt hc) hc0
    have hnegc : 0 < -c := neg_pos.mpr hcneg
    calc
      orliczGauge ψ μ (fun ω => c * X ω) =
          orliczGauge ψ μ (fun ω => (-c) * (-X ω)) := by
            congr 2
            funext ω
            ring
      _ = ENNReal.ofReal (-c) * orliczGauge ψ μ (fun ω => -X ω) :=
        orliczGauge_smul_of_pos ψ μ (fun ω => -X ω) hnegc
      _ = ENNReal.ofReal |c| * orliczGauge ψ μ X := by
        rw [orliczGauge_neg, abs_of_neg hcneg]

lemma orliczAdmissible_add_of_admissible
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ} {s t : ℝ≥0∞}
    (hX : Measurable X) (hY : Measurable Y)
    (hs : orliczAdmissible ψ μ X s) (ht : orliczAdmissible ψ μ Y t) :
    orliczAdmissible ψ μ (fun ω => X ω + Y ω) (s + t) := by
  rcases hs with ⟨hs0, hsTop, hXbound⟩
  rcases ht with ⟨ht0, htTop, hYbound⟩
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
      ENNReal.ofReal (ψ (|X ω + Y ω| / (s + t).toReal)) ≤
        ENNReal.ofReal a * ENNReal.ofReal (ψ (|X ω| / s.toReal)) +
          ENNReal.ofReal b * ENNReal.ofReal (ψ (|Y ω| / t.toReal)) := by
    intro ω
    have hx0 : 0 ≤ |X ω| / s.toReal := div_nonneg (abs_nonneg _) hspos.le
    have hy0 : 0 ≤ |Y ω| / t.toReal := div_nonneg (abs_nonneg _) htpos.le
    have hsum0 : 0 ≤ a * (|X ω| / s.toReal) + b * (|Y ω| / t.toReal) :=
      add_nonneg (mul_nonneg ha hx0) (mul_nonneg hb hy0)
    have hmono := ψ.monotoneOn_nonneg
      (div_nonneg (abs_nonneg _) hstpos.le) hsum0 (harg ω)
    have hconv := ψ.convexOn_nonneg.2 hx0 hy0 ha hb hab
    calc
      ENNReal.ofReal (ψ (|X ω + Y ω| / (s + t).toReal)) ≤
          ENNReal.ofReal (ψ (a * (|X ω| / s.toReal) +
            b * (|Y ω| / t.toReal))) := ENNReal.ofReal_le_ofReal hmono
      _ ≤ ENNReal.ofReal (a * ψ (|X ω| / s.toReal) +
            b * ψ (|Y ω| / t.toReal)) := ENNReal.ofReal_le_ofReal hconv
      _ = ENNReal.ofReal a * ENNReal.ofReal (ψ (|X ω| / s.toReal)) +
            ENNReal.ofReal b * ENNReal.ofReal (ψ (|Y ω| / t.toReal)) := by
        rw [ENNReal.ofReal_add (mul_nonneg ha (ψ.nonnegative _ hx0))
          (mul_nonneg hb (ψ.nonnegative _ hy0)), ENNReal.ofReal_mul ha,
          ENNReal.ofReal_mul hb]
  have hψX : Measurable
      (fun ω => ENNReal.ofReal (ψ (|X ω| / s.toReal))) :=
    ψ.measurable_ofReal_comp_of_nonneg
      (hX.abs.div_const _) (fun _ => div_nonneg (abs_nonneg _) hspos.le)
  have hψY : Measurable
      (fun ω => ENNReal.ofReal (ψ (|Y ω| / t.toReal))) :=
    ψ.measurable_ofReal_comp_of_nonneg
      (hY.abs.div_const _) (fun _ => div_nonneg (abs_nonneg _) htpos.le)
  refine ⟨hst0, hstTop, ?_⟩
  calc
    orliczIntegral ψ μ (fun ω => X ω + Y ω) (s + t) ≤
        ∫⁻ ω, ENNReal.ofReal a * ENNReal.ofReal (ψ (|X ω| / s.toReal)) +
          ENNReal.ofReal b * ENNReal.ofReal (ψ (|Y ω| / t.toReal)) ∂μ :=
      lintegral_mono hpoint
    _ = ENNReal.ofReal a * orliczIntegral ψ μ X s +
          ENNReal.ofReal b * orliczIntegral ψ μ Y t := by
      rw [lintegral_add_left (measurable_const.mul hψX),
        lintegral_const_mul _ hψX, lintegral_const_mul _ hψY]
      rfl
    _ ≤ ENNReal.ofReal a * 1 + ENNReal.ofReal b * 1 := by gcongr
    _ = 1 := by
      rw [mul_one, mul_one, ← ENNReal.ofReal_add ha hb, hab]
      simp

theorem orliczGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ}
    (hX : Measurable X) (hY : Measurable Y) :
    orliczGauge ψ μ (fun ω => X ω + Y ω) ≤
      orliczGauge ψ μ X + orliczGauge ψ μ Y := by
  change sInf {u : ℝ≥0∞ | orliczAdmissible ψ μ (fun ω => X ω + Y ω) u} ≤
    sInf {s : ℝ≥0∞ | orliczAdmissible ψ μ X s} +
      sInf {t : ℝ≥0∞ | orliczAdmissible ψ μ Y t}
  simp only [sInf_eq_iInf]
  apply ENNReal.le_iInf₂_add_iInf₂
  intro s hs t ht
  have hadd := orliczAdmissible_add_of_admissible ψ μ hX hY hs ht
  exact iInf_le_of_le (s + t) (iInf_le_of_le hadd le_rfl)

theorem orliczMember_add
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) {X Y : Ω → ℝ}
    (hX : Measurable X) (hY : Measurable Y)
    (hXm : orliczMember ψ μ X) (hYm : orliczMember ψ μ Y) :
    orliczMember ψ μ (fun ω => X ω + Y ω) :=
  lt_of_le_of_lt (orliczGauge_add_le ψ μ hX hY) (ENNReal.add_lt_top.2 ⟨hXm, hYm⟩)

/-! ## The normed Orlicz space on almost-everywhere classes -/

/-- The Luxemburg gauge on Mathlib's canonical almost-everywhere function
space. -/
noncomputable def orliczAEEqGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : Ω →ₘ[μ] ℝ) : ℝ≥0∞ :=
  orliczGauge ψ μ X

theorem orliczAEEqGauge_zero
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) :
    orliczAEEqGauge ψ μ (0 : Ω →ₘ[μ] ℝ) = 0 := by
  calc
    orliczAEEqGauge ψ μ (0 : Ω →ₘ[μ] ℝ) =
        orliczGauge ψ μ (fun _ : Ω => (0 : ℝ)) :=
      orliczGauge_ae_congr ψ μ (AEEqFun.coeFn_zero (α := Ω) (μ := μ))
    _ = 0 := orliczGauge_zero ψ μ

theorem orliczAEEqGauge_add_le
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X Y : Ω →ₘ[μ] ℝ) :
    orliczAEEqGauge ψ μ (X + Y) ≤
      orliczAEEqGauge ψ μ X + orliczAEEqGauge ψ μ Y := by
  calc
    orliczAEEqGauge ψ μ (X + Y) =
        orliczGauge ψ μ (fun ω => X ω + Y ω) :=
      orliczGauge_ae_congr ψ μ (AEEqFun.coeFn_add X Y)
    _ ≤ orliczGauge ψ μ X + orliczGauge ψ μ Y :=
      orliczGauge_add_le ψ μ X.measurable Y.measurable

theorem orliczAEEqGauge_smul
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (c : ℝ) (X : Ω →ₘ[μ] ℝ) :
    orliczAEEqGauge ψ μ (c • X) =
      ENNReal.ofReal |c| * orliczAEEqGauge ψ μ X := by
  calc
    orliczAEEqGauge ψ μ (c • X) =
        orliczGauge ψ μ (fun ω => c * X ω) :=
      orliczGauge_ae_congr ψ μ (AEEqFun.coeFn_smul c X)
    _ = ENNReal.ofReal |c| * orliczGauge ψ μ X :=
      orliczGauge_smul ψ μ X c

theorem orliczAEEqGauge_eq_zero_iff
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω →ₘ[μ] ℝ) :
    orliczAEEqGauge ψ μ X = 0 ↔ X = 0 := by
  constructor
  · intro hzero
    apply AEEqFun.ext
    have hXzero : (X : Ω → ℝ) =ᵐ[μ] (fun _ => (0 : ℝ)) :=
      (orliczGauge_eq_zero_iff_ae_eq_zero ψ μ X.measurable).mp hzero
    exact hXzero.trans (AEEqFun.coeFn_zero (α := Ω) (μ := μ)).symm
  · rintro rfl
    exact orliczAEEqGauge_zero ψ μ

/-- The linear subspace of almost-everywhere classes having finite Luxemburg
gauge. -/
noncomputable def orliczAEEqSpace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : Submodule ℝ (Ω →ₘ[μ] ℝ) where
  carrier := {X | orliczAEEqGauge ψ μ X < ∞}
  zero_mem' := by simp [orliczAEEqGauge_zero]
  add_mem' := by
    intro X Y hX hY
    exact lt_of_le_of_lt (orliczAEEqGauge_add_le ψ μ X Y)
      (ENNReal.add_lt_top.2 ⟨hX, hY⟩)
  smul_mem' := by
    intro c X hX
    change orliczAEEqGauge ψ μ (c • X) < ∞
    change orliczAEEqGauge ψ μ X < ∞ at hX
    rw [orliczAEEqGauge_smul]
    exact ENNReal.mul_lt_top ENNReal.ofReal_lt_top hX

noncomputable instance orliczAEEqSpaceNorm
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) : Norm (orliczAEEqSpace ψ μ) where
  norm X := (orliczAEEqGauge ψ μ X.1).toReal

theorem orliczAEEqSpace_norm_def
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) (X : orliczAEEqSpace ψ μ) :
    ‖X‖ = (orliczAEEqGauge ψ μ X.1).toReal := rfl

/-- The three norm laws and separation property for the finite-gauge
almost-everywhere quotient. -/
noncomputable def orliczNormedSpaceCore
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    NormedSpace.Core ℝ (orliczAEEqSpace ψ μ) where
  norm_nonneg X := ENNReal.toReal_nonneg
  norm_smul c X := by
    rw [orliczAEEqSpace_norm_def, orliczAEEqSpace_norm_def]
    change (orliczAEEqGauge ψ μ (c • X.1)).toReal =
      ‖c‖ * (orliczAEEqGauge ψ μ X.1).toReal
    rw [orliczAEEqGauge_smul, ENNReal.toReal_mul,
      ENNReal.toReal_ofReal (abs_nonneg c), Real.norm_eq_abs]
  norm_triangle X Y := by
    rw [orliczAEEqSpace_norm_def, orliczAEEqSpace_norm_def,
      orliczAEEqSpace_norm_def]
    change (orliczAEEqGauge ψ μ (X.1 + Y.1)).toReal ≤
      (orliczAEEqGauge ψ μ X.1).toReal +
        (orliczAEEqGauge ψ μ Y.1).toReal
    have hXTop : orliczAEEqGauge ψ μ X.1 ≠ ∞ := ne_of_lt X.2
    have hYTop : orliczAEEqGauge ψ μ Y.1 ≠ ∞ := ne_of_lt Y.2
    have hXYTop : orliczAEEqGauge ψ μ (X.1 + Y.1) ≠ ∞ :=
      ne_of_lt (show (X + Y : orliczAEEqSpace ψ μ).1 ∈ orliczAEEqSpace ψ μ from
        (X + Y).2)
    rw [← ENNReal.toReal_add hXTop hYTop]
    exact (ENNReal.toReal_le_toReal hXYTop (ENNReal.add_ne_top.2 ⟨hXTop, hYTop⟩)).2
      (orliczAEEqGauge_add_le ψ μ X.1 Y.1)
  norm_eq_zero_iff X := by
    constructor
    · intro hzero
      apply Subtype.ext
      apply (orliczAEEqGauge_eq_zero_iff ψ μ X.1).mp
      exact (ENNReal.toReal_eq_zero_iff _).mp hzero |>.resolve_right (ne_of_lt X.2)
    · rintro rfl
      simp [orliczAEEqSpace_norm_def, orliczAEEqGauge_zero]

noncomputable instance orliczAEEqSpaceNormedAddCommGroup
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    NormedAddCommGroup (orliczAEEqSpace ψ μ) :=
  NormedAddCommGroup.ofCore (orliczNormedSpaceCore ψ μ)

noncomputable instance orliczAEEqSpaceNormedSpace
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    NormedSpace ℝ (orliczAEEqSpace ψ μ) :=
  NormedSpace.ofCore (orliczNormedSpaceCore ψ μ)

/-- The Luxemburg functional satisfies the four explicit norm laws on the
finite-gauge almost-everywhere quotient. -/
theorem orliczAEEqSpace_norm_axioms
    {Ω : Type*} [MeasurableSpace Ω]
    (ψ : OrliczFunction) (μ : Measure Ω) [IsProbabilityMeasure μ] :
    (∀ X : orliczAEEqSpace ψ μ, 0 ≤ ‖X‖) ∧
      (∀ X : orliczAEEqSpace ψ μ, ‖X‖ = 0 ↔ X = 0) ∧
      (∀ X Y : orliczAEEqSpace ψ μ, ‖X + Y‖ ≤ ‖X‖ + ‖Y‖) ∧
      (∀ (c : ℝ) (X : orliczAEEqSpace ψ μ), ‖c • X‖ = |c| * ‖X‖) := by
  refine ⟨fun X => norm_nonneg X, fun X => norm_eq_zero, fun X Y => norm_add_le X Y, ?_⟩
  intro c X
  simpa [Real.norm_eq_abs] using norm_smul c X

end NumStability.HDP.Scalar.SubExponential
