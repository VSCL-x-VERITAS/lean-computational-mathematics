import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.Analysis.PSeries
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

/-!
# Maxima of countable sub-Gaussian families

This file develops reusable support for logarithmically weighted maxima of a
countable family of real random variables.  Independence is deliberately not
assumed: the first step is the countable union bound.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Scalar.SubGaussian

/-- The weight `sqrt (1 + log (i + 1))` for a zero-based encoding of the
one-based index in the logarithmically weighted maximum. -/
def logIndexWeight (i : ℕ) : ℝ :=
  Real.sqrt (1 + Real.log (i + 1 : ℝ))

lemma one_le_logIndexWeight (i : ℕ) : 1 ≤ logIndexWeight i := by
  rw [logIndexWeight, Real.one_le_sqrt]
  have hi : (1 : ℝ) ≤ (i : ℝ) + 1 := by
    have hi0 : (0 : ℝ) ≤ (i : ℝ) := by positivity
    linarith
  exact le_add_of_nonneg_right (Real.log_nonneg hi)

lemma logIndexWeight_pos (i : ℕ) : 0 < logIndexWeight i :=
  lt_of_lt_of_le zero_lt_one (one_le_logIndexWeight i)

lemma logIndexWeight_sq (i : ℕ) :
    logIndexWeight i ^ 2 = 1 + Real.log ((i : ℝ) + 1) := by
  rw [logIndexWeight, Real.sq_sqrt]
  have hi0 : (0 : ℝ) ≤ (i : ℝ) := by positivity
  have hi1 : (1 : ℝ) ≤ (i : ℝ) + 1 := by linarith
  have hlog : 0 ≤ Real.log ((i : ℝ) + 1) := Real.log_nonneg hi1
  linarith

/-- The event that one member of a countable family exceeds a logarithmically
weighted threshold. -/
def logWeightedAbsTailEvent {Ω : Type*} (X : ℕ → Ω → ℝ) (t : ℝ) : Set Ω :=
  {ω | ∃ i, t < |X i ω| / logIndexWeight i}

/-- The pointwise logarithmically weighted supremum, represented in
`ℝ≥0∞` so that genuinely unbounded sample paths are not silently totalized. -/
def logWeightedAbsSup {Ω : Type*} (X : ℕ → Ω → ℝ) (ω : Ω) : ENNReal :=
  ⨆ i, ENNReal.ofReal (|X i ω| / logIndexWeight i)

/-- The weighted supremum normalized by the common scale `4 * K`. -/
def normalizedLogWeightedAbsSup
    {Ω : Type*} (X : ℕ → Ω → ℝ) (K : ℝ) (ω : Ω) : ENNReal :=
  (ENNReal.ofReal (4 * K))⁻¹ * logWeightedAbsSup X ω

lemma measurable_logWeightedAbsSup
    {Ω : Type*} [MeasurableSpace Ω]
    {X : ℕ → Ω → ℝ} (hX : ∀ i, Measurable (X i)) :
    Measurable (logWeightedAbsSup X) := by
  unfold logWeightedAbsSup
  fun_prop

lemma measurable_normalizedLogWeightedAbsSup
    {Ω : Type*} [MeasurableSpace Ω]
    {X : ℕ → Ω → ℝ} (hX : ∀ i, Measurable (X i)) (K : ℝ) :
    Measurable (normalizedLogWeightedAbsSup X K) := by
  unfold normalizedLogWeightedAbsSup
  exact measurable_const.mul (measurable_logWeightedAbsSup hX)

lemma logWeightedAbsSup_tailEvent
    {Ω : Type*} (X : ℕ → Ω → ℝ) {t : ℝ} (ht : 0 ≤ t) :
    {ω | ENNReal.ofReal t < logWeightedAbsSup X ω} =
      logWeightedAbsTailEvent X t := by
  ext ω
  simp only [logWeightedAbsSup, logWeightedAbsTailEvent, Set.mem_setOf_eq,
    lt_iSup_iff]
  constructor
  · rintro ⟨i, hi⟩
    exact ⟨i, (ENNReal.ofReal_lt_ofReal_iff_of_nonneg ht).mp hi⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, (ENNReal.ofReal_lt_ofReal_iff_of_nonneg ht).mpr hi⟩

lemma normalizedLogWeightedAbsSup_tailEvent
    {Ω : Type*} (X : ℕ → Ω → ℝ) {K t : ℝ}
    (hK : 0 < K) (ht : 0 ≤ t) :
    {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω} =
      logWeightedAbsTailEvent X (4 * K * t) := by
  let a : ENNReal := ENNReal.ofReal (4 * K)
  have ha0 : a ≠ 0 := ENNReal.ofReal_ne_zero_iff.mpr (by positivity)
  have haTop : a ≠ (⊤ : ENNReal) := ENNReal.ofReal_ne_top
  calc
    {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω} =
        {ω | ENNReal.ofReal (4 * K * t) < logWeightedAbsSup X ω} := by
      ext ω
      simp only [Set.mem_setOf_eq]
      change ENNReal.ofReal t < a⁻¹ * logWeightedAbsSup X ω ↔ _
      rw [← ENNReal.div_eq_inv_mul,
        ENNReal.lt_div_iff_mul_lt (Or.inl ha0) (Or.inl haTop)]
      rw [← ENNReal.ofReal_mul ht]
      ring_nf
    _ = logWeightedAbsTailEvent X (4 * K * t) :=
      logWeightedAbsSup_tailEvent X (by positivity)

/-- Pointwise layer-cake identity for an extended nonnegative value. -/
lemma layerCakePointwiseENNReal (z : ENNReal) :
    z = ∫⁻ t in Set.Ioi (0 : ℝ),
      ({s : ℝ | ENNReal.ofReal s < z}).indicator
        (fun _ => (1 : ENNReal)) t ∂volume := by
  by_cases hz : z = (⊤ : ENNReal)
  · subst z
    simp [Real.volume_Ioi]
  · calc
      z = ENNReal.ofReal z.toReal := (ENNReal.ofReal_toReal hz).symm
      _ = ∫⁻ t in Set.Ioi (0 : ℝ),
          (Set.Iio z.toReal).indicator (fun _ => (1 : ENNReal)) t ∂volume :=
        (NumStability.HDP.Scalar.Preliminaries.layerCakePointwise
          ENNReal.toReal_nonneg).2
      _ = ∫⁻ t in Set.Ioi (0 : ℝ),
          ({s : ℝ | ENNReal.ofReal s < z}).indicator
            (fun _ => (1 : ENNReal)) t ∂volume := by
        apply MeasureTheory.setLIntegral_congr_fun measurableSet_Ioi
        intro t ht
        have ht0 : 0 ≤ t := ht.le
        rw [← ENNReal.ofReal_toReal hz]
        by_cases hlt : t < z.toReal <;>
          simp [Set.indicator, hlt,
            ENNReal.ofReal_lt_ofReal_iff_of_nonneg ht0]

/-- Extended layer-cake formula for a measurable `ℝ≥0∞`-valued function. -/
theorem layerCakeLIntegralENNReal
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [SFinite μ]
    {f : Ω → ENNReal} (hf : Measurable f) :
    (∫⁻ ω, f ω ∂μ) =
      ∫⁻ t in Set.Ioi (0 : ℝ), μ {ω | ENNReal.ofReal t < f ω} := by
  let A : Set (Ω × ℝ) :=
    {p | p.2 ∈ Set.Ioi (0 : ℝ) ∧ ENNReal.ofReal p.2 < f p.1}
  let g : Ω → ℝ → ENNReal := fun ω t =>
    A.indicator (fun _ => (1 : ENNReal)) (ω, t)
  have hA : MeasurableSet A := by
    exact (measurableSet_lt measurable_const measurable_snd).inter
      (measurableSet_lt measurable_snd.ennreal_ofReal
        (hf.comp measurable_fst))
  have hg : Measurable (Function.uncurry g) := by
    exact measurable_const.indicator hA
  calc
    (∫⁻ ω, f ω ∂μ) = ∫⁻ ω, ∫⁻ t, g ω t ∂volume ∂μ := by
      apply lintegral_congr
      intro ω
      rw [layerCakePointwiseENNReal (f ω)]
      rw [← lintegral_indicator measurableSet_Ioi]
      apply lintegral_congr
      intro t
      by_cases ht : t ∈ Set.Ioi (0 : ℝ)
      · have ht' : 0 < t := ht
        by_cases hfω : ENNReal.ofReal t < f ω <;>
          simp [g, A, Set.indicator, ht', hfω]
      · have ht' : ¬0 < t := by simpa only [Set.mem_Ioi] using ht
        by_cases hfω : ENNReal.ofReal t < f ω <;>
          simp [g, A, Set.indicator, ht', hfω]
    _ = ∫⁻ t, ∫⁻ ω, g ω t ∂μ ∂volume :=
      lintegral_lintegral_swap hg.aemeasurable
    _ = ∫⁻ t in Set.Ioi (0 : ℝ), μ {ω | ENNReal.ofReal t < f ω} := by
      rw [← lintegral_indicator measurableSet_Ioi]
      apply lintegral_congr
      intro t
      by_cases ht : t ∈ Set.Ioi (0 : ℝ)
      · have hEvent : MeasurableSet {ω | ENNReal.ofReal t < f ω} := by
          exact measurableSet_lt measurable_const hf
        have ht' : 0 < t := ht
        simpa [g, A, Set.indicator, ht'] using
          (lintegral_indicator_one (μ := μ) hEvent)
      · have ht' : ¬0 < t := by simpa only [Set.mem_Ioi] using ht
        simp [g, A, Set.indicator, ht']

lemma logWeightedAbsTailEvent_eq_iUnion
    {Ω : Type*} (X : ℕ → Ω → ℝ) (t : ℝ) :
    logWeightedAbsTailEvent X t =
      ⋃ i, {ω | t * logIndexWeight i < |X i ω|} := by
  ext ω
  simp only [logWeightedAbsTailEvent, Set.mem_setOf_eq, Set.mem_iUnion]
  constructor
  · rintro ⟨i, hi⟩
    exact ⟨i, (lt_div_iff₀ (logIndexWeight_pos i)).mp hi⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, (lt_div_iff₀ (logIndexWeight_pos i)).mpr hi⟩

/-- A countable union bound for the logarithmically weighted maximum event. -/
theorem measure_logWeightedAbsTailEvent_le_tsum
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (t : ℝ) :
    μ (logWeightedAbsTailEvent X t) ≤
      ∑' i, μ {ω | t * logIndexWeight i < |X i ω|} := by
  rw [logWeightedAbsTailEvent_eq_iUnion]
  exact measure_iUnion_le _

/-- The union bound with a user-supplied summable majorant for the individual
tail events. -/
theorem measure_logWeightedAbsTailEvent_le_tsum_of_le
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (t : ℝ) (q : ℕ → ENNReal)
    (hTail : ∀ i, μ {ω | t * logIndexWeight i < |X i ω|} ≤ q i) :
    μ (logWeightedAbsTailEvent X t) ≤ ∑' i, q i :=
  (measure_logWeightedAbsTailEvent_le_tsum μ X t).trans
    (ENNReal.tsum_le_tsum hTail)

/-- Real-valued form of the weighted countable union bound when the supplied
majorant is summable. -/
theorem measureReal_logWeightedAbsTailEvent_le_tsum_of_le
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsFiniteMeasure μ]
    (X : ℕ → Ω → ℝ) (t : ℝ) (q : ℕ → ℝ)
    (hqNonneg : ∀ i, 0 ≤ q i) (hqSummable : Summable q)
    (hTail : ∀ i, μ.real {ω | t * logIndexWeight i < |X i ω|} ≤ q i) :
    μ.real (logWeightedAbsTailEvent X t) ≤ ∑' i, q i := by
  apply (ENNReal.ofReal_le_ofReal_iff (tsum_nonneg hqNonneg)).mp
  rw [ofReal_measureReal, ENNReal.ofReal_tsum_of_nonneg hqNonneg hqSummable]
  apply measure_logWeightedAbsTailEvent_le_tsum_of_le
  intro i
  rw [← ofReal_measureReal]
  exact ENNReal.ofReal_le_ofReal (hTail i)

/-- The shifted inverse-square sequence is summable. -/
lemma summable_one_div_natCast_add_one_sq :
    Summable (fun i : ℕ => 1 / ((i : ℝ) + 1) ^ 2) := by
  have h := (Real.summable_one_div_nat_add_rpow 1 2).2 (by norm_num)
  apply h.congr
  intro i
  have hi : 0 ≤ (i : ℝ) + 1 := by positivity
  rw [abs_of_nonneg hi]
  exact congrArg (fun z : ℝ => 1 / z)
    (Real.rpow_natCast ((i : ℝ) + 1) 2)

/-- The universal shifted inverse-square sum used in the maximum estimate. -/
def inverseSquareIndexSum : ℝ :=
  ∑' i : ℕ, 1 / ((i : ℝ) + 1) ^ 2

lemma inverseSquareIndexSum_nonneg : 0 ≤ inverseSquareIndexSum := by
  exact tsum_nonneg (fun _ => by positivity)

/-- A concrete universal constant for the weighted maximum estimate. -/
def logWeightedMaxConstant : ℝ :=
  4 * (1 + 2 * inverseSquareIndexSum)

lemma logWeightedMaxConstant_pos : 0 < logWeightedMaxConstant := by
  unfold logWeightedMaxConstant
  nlinarith [inverseSquareIndexSum_nonneg]

/-- The supremum of the exact `ψ₂` gauges of a countable family. -/
def sequencePsiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) : ENNReal :=
  ⨆ i, PsiTwoGauge μ (X i)

lemma psiTwoGauge_le_sequencePsiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (i : ℕ) :
    PsiTwoGauge μ (X i) ≤ sequencePsiTwoGauge μ X :=
  le_iSup (fun j => PsiTwoGauge μ (X j)) i

/-- Pointwise comparison between a logarithmically weighted Gaussian tail and
the shifted inverse-square sequence. -/
lemma two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq_le
    {t : ℝ} (ht : 1 ≤ t) (i : ℕ) :
    2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2) ≤
      (2 * Real.exp (-2 * t ^ 2)) * (1 / ((i : ℝ) + 1) ^ 2) := by
  have htSq : 1 ≤ t ^ 2 := by nlinarith
  have hx : 0 < (i : ℝ) + 1 := by positivity
  have hi0 : (0 : ℝ) ≤ (i : ℝ) := by positivity
  have hi1 : (1 : ℝ) ≤ (i : ℝ) + 1 := by linarith
  have hlog : 0 ≤ Real.log ((i : ℝ) + 1) := Real.log_nonneg hi1
  have hcoef : 0 ≤ 4 * t ^ 2 - 2 := by nlinarith
  have hExp :
      -4 * t ^ 2 * logIndexWeight i ^ 2 ≤
        -2 * t ^ 2 + -(2 * Real.log ((i : ℝ) + 1)) := by
    rw [logIndexWeight_sq]
    nlinarith [mul_nonneg hcoef hlog]
  have hExpLog :
      Real.exp (-(2 * Real.log ((i : ℝ) + 1))) =
        1 / ((i : ℝ) + 1) ^ 2 := by
    rw [Real.exp_neg]
    have hTwoLog :
        Real.exp (2 * Real.log ((i : ℝ) + 1)) = ((i : ℝ) + 1) ^ 2 := by
      rw [show 2 * Real.log ((i : ℝ) + 1) =
        Real.log ((i : ℝ) + 1) + Real.log ((i : ℝ) + 1) by ring,
        Real.exp_add, Real.exp_log hx, pow_two]
    rw [hTwoLog]
    simp only [one_div]
  calc
    2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2) ≤
        2 * Real.exp (-2 * t ^ 2 + -(2 * Real.log ((i : ℝ) + 1))) :=
      mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hExp) (by norm_num)
    _ = (2 * Real.exp (-2 * t ^ 2)) *
        (1 / ((i : ℝ) + 1) ^ 2) := by
      rw [Real.exp_add, hExpLog]
      ring

lemma summable_two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq
    {t : ℝ} (ht : 1 ≤ t) :
    Summable (fun i : ℕ =>
      2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2)) := by
  have hRight : Summable (fun i : ℕ =>
      (2 * Real.exp (-2 * t ^ 2)) * (1 / ((i : ℝ) + 1) ^ 2)) :=
    summable_one_div_natCast_add_one_sq.mul_left _
  exact hRight.of_nonneg_of_le (fun _ => by positivity)
    (two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq_le ht)

/-- A Gaussian tail at the logarithmic index weight is bounded by a fixed
Gaussian factor times the shifted inverse-square series. -/
lemma tsum_two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq_le
    {t : ℝ} (ht : 1 ≤ t) :
    (∑' i : ℕ, 2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2)) ≤
      (2 * Real.exp (-2 * t ^ 2)) *
        ∑' i : ℕ, 1 / ((i : ℝ) + 1) ^ 2 := by
  have hRight : Summable (fun i : ℕ =>
      (2 * Real.exp (-2 * t ^ 2)) * (1 / ((i : ℝ) + 1) ^ 2)) :=
    summable_one_div_natCast_add_one_sq.mul_left _
  calc
    (∑' i : ℕ, 2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2)) ≤
        ∑' i : ℕ, (2 * Real.exp (-2 * t ^ 2)) *
          (1 / ((i : ℝ) + 1) ^ 2) :=
      (summable_two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq ht).tsum_le_tsum
        (two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq_le ht) hRight
    _ = (2 * Real.exp (-2 * t ^ 2)) *
        ∑' i : ℕ, 1 / ((i : ℝ) + 1) ^ 2 := by
      rw [tsum_mul_left]

/-- A common sub-Gaussian tail bound for a countable family.  No independence
between the coordinates is part of this predicate. -/
def UniformSubGaussianTail
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : ℕ → Ω → ℝ) (K : ℝ) : Prop :=
  ∀ i s, 0 ≤ s →
    μ.real {ω | |X i ω| ≥ s} ≤
      2 * Real.exp (-s ^ 2 / (4 * K ^ 2))

/-- A uniform upper bound on the exact `ψ₂` gauges supplies the common tail
predicate.  The zero-gauge case is treated separately because real division is
totalized at zero. -/
theorem uniformSubGaussianTail_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    UniformSubGaussianTail μ X K := by
  intro i s hs
  have hFinite : PsiTwoGauge μ (X i) < (⊤ : ENNReal) :=
    lt_of_le_of_lt (hGauge i) ENNReal.ofReal_lt_top
  by_cases hGaugeZero : PsiTwoGauge μ (X i) = 0
  · by_cases hsZero : s = 0
    · subst s
      calc
        μ.real {ω | |X i ω| ≥ 0} ≤ 1 := measureReal_le_one
        _ ≤ 2 * Real.exp (-0 ^ 2 / (4 * K ^ 2)) := by
          rw [zero_pow (by norm_num : (2 : ℕ) ≠ 0), neg_zero, zero_div,
            Real.exp_zero]
          norm_num
    · have hXZero : X i =ᵐ[μ] (fun _ω : Ω => (0 : ℝ)) :=
        (psiTwoGauge_eq_zero_iff_ae_eq_zero (hX i)).mp hGaugeZero
      have hEvent : {ω | |X i ω| ≥ s} =ᵐ[μ] (∅ : Set Ω) := by
        filter_upwards [hXZero] with ω hω
        change (s ≤ |X i ω|) = False
        rw [hω, abs_zero]
        exact propext (iff_false_intro
          (not_le_of_gt (lt_of_le_of_ne hs (Ne.symm hsZero))))
      rw [Measure.real_def, measure_congr hEvent]
      simp only [measure_empty, ENNReal.toReal_zero]
      positivity
  · have hGaugeRealPos : 0 < (PsiTwoGauge μ (X i)).toReal :=
      ENNReal.toReal_pos hGaugeZero (ne_of_lt hFinite)
    have hGaugeRealLe : (PsiTwoGauge μ (X i)).toReal ≤ K := by
      have h := ENNReal.toReal_mono ENNReal.ofReal_ne_top (hGauge i)
      simpa [ENNReal.toReal_ofReal hK.le] using h
    have hDenom :
        (2 * (PsiTwoGauge μ (X i)).toReal) ^ 2 ≤ 4 * K ^ 2 := by
      have hsq := (sq_le_sq₀ hGaugeRealPos.le hK.le).2 hGaugeRealLe
      nlinarith
    have hRatio :
        s ^ 2 / (4 * K ^ 2) ≤
          s ^ 2 / (2 * (PsiTwoGauge μ (X i)).toReal) ^ 2 := by
      exact div_le_div_of_nonneg_left (sq_nonneg s) (by positivity) hDenom
    have hTail := psiTwoGaugeToTail (hX i) hFinite hs
    calc
      μ.real {ω | |X i ω| ≥ s} ≤
          2 * Real.exp
            (-s ^ 2 / (2 * (PsiTwoGauge μ (X i)).toReal) ^ 2) := hTail
      _ ≤ 2 * Real.exp (-s ^ 2 / (4 * K ^ 2)) := by
        apply mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr ?_) (by norm_num)
        simpa only [neg_div] using neg_le_neg hRatio

/-- The logarithmically weighted maximum event has a Gaussian tail under a
common coordinatewise sub-Gaussian tail bound. -/
theorem measureReal_logWeightedAbsTailEvent_four_mul_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K t : ℝ}
    (hK : 0 < K) (ht : 1 ≤ t) (hTail : UniformSubGaussianTail μ X K) :
    μ.real (logWeightedAbsTailEvent X (4 * K * t)) ≤
      (2 * Real.exp (-2 * t ^ 2)) *
        ∑' i : ℕ, 1 / ((i : ℝ) + 1) ^ 2 := by
  have ht0 : 0 ≤ t := le_trans zero_le_one ht
  have hUnion := measureReal_logWeightedAbsTailEvent_le_tsum_of_le
    μ X (4 * K * t)
    (fun i => 2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2))
    (fun _ => by positivity)
    (summable_two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq ht)
    (fun i => by
      have hsNonneg : 0 ≤ 4 * K * t * logIndexWeight i :=
        mul_nonneg (mul_nonneg (mul_nonneg (by norm_num) hK.le) ht0)
          (logIndexWeight_pos i).le
      calc
        μ.real {ω | 4 * K * t * logIndexWeight i < |X i ω|} ≤
            μ.real {ω | |X i ω| ≥ 4 * K * t * logIndexWeight i} := by
          refine measureReal_mono ?_ (by finiteness)
          intro ω hω
          change 4 * K * t * logIndexWeight i < |X i ω| at hω
          change 4 * K * t * logIndexWeight i ≤ |X i ω|
          exact hω.le
        _ ≤ 2 * Real.exp
            (-(4 * K * t * logIndexWeight i) ^ 2 / (4 * K ^ 2)) :=
          hTail i _ hsNonneg
        _ = 2 * Real.exp (-4 * t ^ 2 * logIndexWeight i ^ 2) := by
          congr 2
          field_simp [hK.ne'])
  exact hUnion.trans
    (tsum_two_mul_exp_neg_four_mul_sq_mul_logIndexWeight_sq_le ht)

/-- Tail bound for the logarithmically weighted maximum stated directly from
a common upper bound on the exact `ψ₂` gauges. -/
theorem measureReal_logWeightedAbsTailEvent_four_mul_le_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K t : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K)
    (ht : 1 ≤ t) :
    μ.real (logWeightedAbsTailEvent X (4 * K * t)) ≤
      (2 * Real.exp (-2 * t ^ 2)) *
        ∑' i : ℕ, 1 / ((i : ℝ) + 1) ^ 2 :=
  measureReal_logWeightedAbsTailEvent_four_mul_le hK ht
    (uniformSubGaussianTail_of_psiTwoGauge_le hX hK hGauge)

/-- Extended expectation bound for the normalized logarithmically weighted
supremum. -/
theorem lintegral_normalizedLogWeightedAbsSup_le_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    (∫⁻ ω, normalizedLogWeightedAbsSup X K ω ∂μ) ≤
      ENNReal.ofReal (1 + 2 * inverseSquareIndexSum) := by
  have hCake := layerCakeLIntegralENNReal μ
    (measurable_normalizedLogWeightedAbsSup hX K)
  rw [hCake]
  have hSplit : Set.Ioi (0 : ℝ) =
      Set.Ioc (0 : ℝ) 1 ∪ Set.Ioi (1 : ℝ) := by
    ext t
    simp only [Set.mem_Ioi, Set.mem_union, Set.mem_Ioc]
    constructor
    · intro ht
      by_cases ht1 : t ≤ 1
      · exact Or.inl ⟨ht, ht1⟩
      · exact Or.inr (lt_of_not_ge ht1)
    · rintro (ht | ht)
      · exact ht.1
      · linarith
  rw [hSplit, lintegral_union measurableSet_Ioi Set.Ioc_disjoint_Ioi_same]
  have hLow :
      (∫⁻ t in Set.Ioc (0 : ℝ) 1,
        μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω}) ≤ 1 := by
    calc
      (∫⁻ t in Set.Ioc (0 : ℝ) 1,
          μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω}) ≤
          ∫⁻ _t in Set.Ioc (0 : ℝ) 1, (1 : ENNReal) := by
        apply setLIntegral_mono' measurableSet_Ioc
        intro t ht
        simpa using (measure_mono (μ := μ)
          (Set.subset_univ {ω | ENNReal.ofReal t <
            normalizedLogWeightedAbsSup X K ω}))
      _ = 1 := by simp
  have hTail : ∀ t : ℝ, 1 < t →
      μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω} ≤
        ENNReal.ofReal
          ((2 * inverseSquareIndexSum) * Real.exp (-t)) := by
    intro t ht
    have htOne : 1 ≤ t := ht.le
    have ht0 : 0 ≤ t := le_trans zero_le_one htOne
    rw [normalizedLogWeightedAbsSup_tailEvent X hK ht0]
    rw [← ofReal_measureReal]
    apply ENNReal.ofReal_le_ofReal
    calc
      μ.real (logWeightedAbsTailEvent X (4 * K * t)) ≤
          (2 * Real.exp (-2 * t ^ 2)) * inverseSquareIndexSum := by
        simpa [inverseSquareIndexSum] using
          measureReal_logWeightedAbsTailEvent_four_mul_le_of_psiTwoGauge_le
            hX hK hGauge htOne
      _ ≤ (2 * inverseSquareIndexSum) * Real.exp (-t) := by
        have hExp : Real.exp (-2 * t ^ 2) ≤ Real.exp (-t) := by
          apply Real.exp_le_exp.mpr
          nlinarith
        calc
          (2 * Real.exp (-2 * t ^ 2)) * inverseSquareIndexSum =
              (2 * inverseSquareIndexSum) * Real.exp (-2 * t ^ 2) := by ring
          _ ≤ (2 * inverseSquareIndexSum) * Real.exp (-t) :=
            mul_le_mul_of_nonneg_left hExp
              (mul_nonneg (by norm_num) inverseSquareIndexSum_nonneg)
  have hHigh :
      (∫⁻ t in Set.Ioi (1 : ℝ),
        μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω}) ≤
        ENNReal.ofReal (2 * inverseSquareIndexSum) := by
    calc
      (∫⁻ t in Set.Ioi (1 : ℝ),
          μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω}) ≤
          ∫⁻ t in Set.Ioi (1 : ℝ),
            ENNReal.ofReal
              ((2 * inverseSquareIndexSum) * Real.exp (-t)) := by
        apply setLIntegral_mono' measurableSet_Ioi
        intro t ht
        exact hTail t ht
      _ = ENNReal.ofReal
          (∫ t in Set.Ioi (1 : ℝ),
            (2 * inverseSquareIndexSum) * Real.exp (-t) ∂volume) := by
        symm
        apply ofReal_integral_eq_lintegral_ofReal
        · exact (integrableOn_exp_neg_Ioi 1).const_mul _
        · filter_upwards [] with t
          exact mul_nonneg (mul_nonneg (by norm_num) inverseSquareIndexSum_nonneg)
            (Real.exp_nonneg _)
      _ = ENNReal.ofReal
          ((2 * inverseSquareIndexSum) * Real.exp (-1)) := by
        congr 1
        rw [MeasureTheory.integral_const_mul, integral_exp_neg_Ioi]
      _ ≤ ENNReal.ofReal (2 * inverseSquareIndexSum) := by
        apply ENNReal.ofReal_le_ofReal
        have hexp : Real.exp (-1) ≤ 1 := by
          exact Real.exp_le_one_iff.mpr (by norm_num : (-1 : ℝ) ≤ 0)
        exact mul_le_of_le_one_right
          (mul_nonneg (by norm_num) inverseSquareIndexSum_nonneg) hexp
  calc
    (∫⁻ t in Set.Ioc (0 : ℝ) 1,
        μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω}) +
        ∫⁻ t in Set.Ioi (1 : ℝ),
          μ {ω | ENNReal.ofReal t < normalizedLogWeightedAbsSup X K ω} ≤
        1 + ENNReal.ofReal (2 * inverseSquareIndexSum) := add_le_add hLow hHigh
    _ = ENNReal.ofReal (1 + 2 * inverseSquareIndexSum) := by
      rw [ENNReal.ofReal_add (by norm_num : (0 : ℝ) ≤ 1)
        (mul_nonneg (by norm_num) inverseSquareIndexSum_nonneg)]
      norm_num

/-- Extended expectation form of the countable weighted maximum estimate. -/
theorem lintegral_logWeightedAbsSup_le_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    (∫⁻ ω, logWeightedAbsSup X ω ∂μ) ≤
      ENNReal.ofReal (logWeightedMaxConstant * K) := by
  let a : ENNReal := ENNReal.ofReal (4 * K)
  have ha0 : a ≠ 0 := ENNReal.ofReal_ne_zero_iff.mpr (by positivity)
  have haTop : a ≠ (⊤ : ENNReal) := ENNReal.ofReal_ne_top
  have hPoint : ∀ ω,
      logWeightedAbsSup X ω =
        a * normalizedLogWeightedAbsSup X K ω := by
    intro ω
    unfold normalizedLogWeightedAbsSup
    change logWeightedAbsSup X ω =
      a * (a⁻¹ * logWeightedAbsSup X ω)
    rw [← mul_assoc, ENNReal.mul_inv_cancel ha0 haTop, one_mul]
  calc
    (∫⁻ ω, logWeightedAbsSup X ω ∂μ) =
        ∫⁻ ω, a * normalizedLogWeightedAbsSup X K ω ∂μ := by
      apply lintegral_congr
      exact hPoint
    _ = a * ∫⁻ ω, normalizedLogWeightedAbsSup X K ω ∂μ := by
      rw [lintegral_const_mul _
        (measurable_normalizedLogWeightedAbsSup hX K)]
    _ ≤ a * ENNReal.ofReal (1 + 2 * inverseSquareIndexSum) :=
      by
        gcongr
        exact lintegral_normalizedLogWeightedAbsSup_le_of_psiTwoGauge_le
          hX hK hGauge
    _ = ENNReal.ofReal (logWeightedMaxConstant * K) := by
      dsimp [a]
      rw [← ENNReal.ofReal_mul (by positivity : 0 ≤ 4 * K)]
      congr 1
      unfold logWeightedMaxConstant
      ring

/-- The countable weighted supremum is finite almost everywhere under the
uniform exact-`ψ₂` gauge bound. -/
theorem ae_logWeightedAbsSup_lt_top_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    ∀ᵐ ω ∂μ, logWeightedAbsSup X ω < (⊤ : ENNReal) := by
  apply ae_lt_top (measurable_logWeightedAbsSup hX)
  exact ne_top_of_le_ne_top ENNReal.ofReal_ne_top
    (lintegral_logWeightedAbsSup_le_of_psiTwoGauge_le hX hK hGauge)

/-- Real representative of the countable weighted supremum.  The accompanying
almost-everywhere finiteness theorem is what makes this representative
semantically valid in the maximum estimate. -/
def logWeightedAbsSupReal {Ω : Type*} (X : ℕ → Ω → ℝ) (ω : Ω) : ℝ :=
  (logWeightedAbsSup X ω).toReal

lemma measurable_logWeightedAbsSupReal
    {Ω : Type*} [MeasurableSpace Ω]
    {X : ℕ → Ω → ℝ} (hX : ∀ i, Measurable (X i)) :
    Measurable (logWeightedAbsSupReal X) :=
  (measurable_logWeightedAbsSup hX).ennreal_toReal

/-- Real expectation form of Exercise 2.5.10's first estimate, with the common
upper bound `K` on exact `ψ₂` gauges made explicit. -/
theorem expectation_logWeightedAbsSupReal_le_of_psiTwoGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 < K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    Integrable (logWeightedAbsSupReal X) μ ∧
      NumStability.HDP.Scalar.Preliminaries.expectation μ
        (logWeightedAbsSupReal X) ≤
        logWeightedMaxConstant * K := by
  have hBound := lintegral_logWeightedAbsSup_le_of_psiTwoGauge_le
    hX hK hGauge
  have hFinite : (∫⁻ ω, logWeightedAbsSup X ω ∂μ) < (⊤ : ENNReal) :=
    lt_of_le_of_lt hBound ENNReal.ofReal_lt_top
  have hAeFinite := ae_logWeightedAbsSup_lt_top_of_psiTwoGauge_le
    hX hK hGauge
  have hAe : (fun ω => ENNReal.ofReal (logWeightedAbsSupReal X ω)) =ᵐ[μ]
      logWeightedAbsSup X := by
    filter_upwards [hAeFinite] with ω hω
    exact ENNReal.ofReal_toReal hω.ne
  have hAeNorm :
      (fun ω => ENNReal.ofReal |logWeightedAbsSupReal X ω|) =ᵐ[μ]
        logWeightedAbsSup X := by
    filter_upwards [hAe] with ω hω
    have hNonneg : 0 ≤ logWeightedAbsSupReal X ω := ENNReal.toReal_nonneg
    rw [abs_of_nonneg hNonneg]
    exact hω
  have hInt : Integrable (logWeightedAbsSupReal X) μ := by
    refine ⟨(measurable_logWeightedAbsSupReal hX).aestronglyMeasurable, ?_⟩
    rw [hasFiniteIntegral_iff_norm]
    simp only [Real.norm_eq_abs]
    exact lt_of_eq_of_lt (lintegral_congr_ae hAeNorm) hFinite
  refine ⟨hInt, ?_⟩
  apply (ENNReal.ofReal_le_ofReal_iff
    (mul_nonneg logWeightedMaxConstant_pos.le hK.le)).mp
  unfold NumStability.HDP.Scalar.Preliminaries.expectation
  rw [ofReal_integral_eq_lintegral_ofReal hInt
    (Filter.Eventually.of_forall (fun _ => ENNReal.toReal_nonneg))]
  exact (lintegral_congr_ae hAe).trans_le hBound

lemma ae_logWeightedAbsSup_eq_zero_of_psiTwoGauge_eq_zero
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hGaugeZero : ∀ i, PsiTwoGauge μ (X i) = 0) :
    logWeightedAbsSup X =ᵐ[μ] (fun _ => (0 : ENNReal)) := by
  have hAll : ∀ᵐ ω ∂μ, ∀ i, X i ω = 0 :=
    ae_all_iff.2 fun i =>
      (psiTwoGauge_eq_zero_iff_ae_eq_zero (hX i)).mp (hGaugeZero i)
  filter_upwards [hAll] with ω hω
  simp [logWeightedAbsSup, hω]

/-- Common-gauge-bound form including the zero-scale endpoint. -/
theorem expectation_logWeightedAbsSupReal_le_of_psiTwoGauge_le_of_nonneg
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ} {K : ℝ}
    (hX : ∀ i, Measurable (X i)) (hK : 0 ≤ K)
    (hGauge : ∀ i, PsiTwoGauge μ (X i) ≤ ENNReal.ofReal K) :
    Integrable (logWeightedAbsSupReal X) μ ∧
      NumStability.HDP.Scalar.Preliminaries.expectation μ
        (logWeightedAbsSupReal X) ≤ logWeightedMaxConstant * K := by
  rcases eq_or_lt_of_le hK with rfl | hKPos
  · have hGaugeZero : ∀ i, PsiTwoGauge μ (X i) = 0 := by
      intro i
      simpa only [ENNReal.ofReal_zero, nonpos_iff_eq_zero] using hGauge i
    have hSupZero :=
      ae_logWeightedAbsSup_eq_zero_of_psiTwoGauge_eq_zero hX hGaugeZero
    have hRealZero : logWeightedAbsSupReal X =ᵐ[μ] (fun _ => (0 : ℝ)) := by
      filter_upwards [hSupZero] with ω hω
      simp [logWeightedAbsSupReal, hω]
    have hInt : Integrable (logWeightedAbsSupReal X) μ :=
      (integrable_zero Ω ℝ μ).congr hRealZero.symm
    refine ⟨hInt, ?_⟩
    unfold NumStability.HDP.Scalar.Preliminaries.expectation
    rw [integral_congr_ae hRealZero]
    simp
  · exact expectation_logWeightedAbsSupReal_le_of_psiTwoGauge_le
      hX hKPos hGauge

/-- Exercise 2.5.10's first estimate using the actual supremum of the exact
`ψ₂` gauges of the sequence.  No independence assumption is present. -/
theorem expectation_logWeightedAbsSupReal_le_sequencePsiTwoGauge
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ℕ → Ω → ℝ}
    (hX : ∀ i, Measurable (X i))
    (hFinite : sequencePsiTwoGauge μ X < (⊤ : ENNReal)) :
    Integrable (logWeightedAbsSupReal X) μ ∧
      NumStability.HDP.Scalar.Preliminaries.expectation μ
        (logWeightedAbsSupReal X) ≤
          logWeightedMaxConstant * (sequencePsiTwoGauge μ X).toReal := by
  apply expectation_logWeightedAbsSupReal_le_of_psiTwoGauge_le_of_nonneg
    hX ENNReal.toReal_nonneg
  intro i
  rw [ENNReal.ofReal_toReal hFinite.ne]
  exact psiTwoGauge_le_sequencePsiTwoGauge μ X i

end NumStability.HDP.Scalar.SubGaussian
