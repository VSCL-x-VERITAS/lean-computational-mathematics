import ComputationalMathematics.HDP.Scalar.SubGaussian
import Mathlib.Analysis.PSeries

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

end NumStability.HDP.Scalar.SubGaussian
