import ComputationalMathematics.HDP.Scalar.SubExponential.Basic

/-!
# From sub-exponential tails to the exact `ψ₁` gauge

This module exposes the quantitative tail-to-gauge bridge obtained from the
four-way sub-exponential characterization.  It is useful when a geometric
argument, such as a one-dimensional Borell lemma, naturally produces a tail
bound while the downstream theorem is stated using the exact `ψ₁` gauge.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar.SubExponential

/-- A sub-exponential tail bound at scale `T` controls the exact `ψ₁` gauge
with one universal explicit factor. -/
theorem psiOneGauge_le_of_tailBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {T : ℝ} (hT : 0 < T)
    (hTail : SubExponentialTailBound μ X T) :
    PsiOneGauge μ X ≤
      ENNReal.ofReal (512 * (Real.exp 1) ^ 3 * T) := by
  rcases subExponentialPropertyTransfer .tail .onePoint hT hTail with
    ⟨K, hK, hKBound, hPoint⟩
  change SubExponentialOnePointMGF μ X K at hPoint
  calc
    PsiOneGauge μ X ≤ ENNReal.ofReal K := by
      unfold PsiOneGauge
      exact sInf_le ((psiOneAdmissible_ofReal_iff hK).2 hPoint)
    _ ≤ ENNReal.ofReal (512 * (Real.exp 1) ^ 3 * T) :=
      ENNReal.ofReal_le_ofReal hKBound

/-- Consequently, every variable satisfying a positive-scale
sub-exponential tail estimate has finite exact `ψ₁` gauge. -/
theorem psiOneGauge_lt_top_of_tailBound
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {T : ℝ} (hT : 0 < T)
    (hTail : SubExponentialTailBound μ X T) :
    PsiOneGauge μ X < ∞ := by
  exact (psiOneGauge_le_of_tailBound hT hTail).trans_lt ENNReal.ofReal_lt_top

/-- An essentially bounded measurable random variable has a finite exact
`ψ₁` gauge.  This is the null-set-invariant boundedness interface needed for
laws supported on bounded sets. -/
theorem psiOneGauge_lt_top_of_ae_abs_le_const
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} {B : ℝ} (hX : Measurable X) (hB : 0 < B)
    (hBound : ∀ᵐ ω ∂μ, |X ω| ≤ B) :
    PsiOneGauge μ X < ∞ := by
  let T : ℝ := B / Real.log 2
  have hlog : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hT : 0 < T := div_pos hB hlog
  have hscale : Real.log 2 * T = B := by
    dsimp [T]
    field_simp
  have hPoint : ∀ᵐ ω ∂μ, Real.exp (|X ω| / T) ≤ 2 := by
    filter_upwards [hBound] with ω hω
    have hquot : |X ω| / T ≤ Real.log 2 := by
      rw [div_le_iff₀ hT, hscale]
      exact hω
    calc
      Real.exp (|X ω| / T) ≤ Real.exp (Real.log 2) :=
        Real.exp_le_exp.mpr hquot
      _ = 2 := Real.exp_log (by norm_num)
  have hInt : Integrable (fun ω => Real.exp (|X ω| / T)) μ := by
    refine (integrable_const (μ := μ) (2 : ℝ)).mono' (by fun_prop) ?_
    filter_upwards [hPoint] with ω hω
    simpa [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hω
  apply (psiOneGauge_finite_iff (μ := μ) (X := X)).2
  refine ⟨T, hT, hX, hT, hInt, ?_⟩
  calc
    (∫ ω, Real.exp (|X ω| / T) ∂μ) ≤ ∫ _ω, (2 : ℝ) ∂μ :=
      integral_mono_ae hInt (integrable_const 2) hPoint
    _ = 2 := by simp

end NumStability.HDP.Scalar.SubExponential
