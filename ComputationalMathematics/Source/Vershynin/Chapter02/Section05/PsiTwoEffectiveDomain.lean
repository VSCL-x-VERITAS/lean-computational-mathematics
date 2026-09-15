import ComputationalMathematics.HDP.Scalar.SubGaussianMinimality

/-!
# Effective-domain ψ₂ displays from Section 2.5

The printed square-MGF and minimality displays divide by the exact ψ₂ gauge.
These contracts use the displays only when that gauge is positive and state
the exact almost-everywhere-zero boundary separately.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubGaussian

/-- The square-MGF display on its positive-gauge domain, together with the
exact zero-gauge boundary. -/
def PsiTwoSquareMomentEffectiveDomain
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) : Prop :=
  (0 < PsiTwoGauge μ X →
      SubGaussianSquarePoint μ X (PsiTwoGauge μ X).toReal) ∧
    (PsiTwoGauge μ X = 0 → X =ᵐ[μ] (fun _ : Ω => (0 : ℝ)))

/-- Section 2.5's square-MGF display without a zero-gauge quotient. -/
theorem hdp_02_hbody_h2_d5_hpsi2_hsquare_hpoint_effectiveDomain
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    PsiTwoSquareMomentEffectiveDomain μ X := by
  refine ⟨psiTwoGauge_squarePoint_of_pos hX hFinite, ?_⟩
  exact fun hZero => (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hZero

/-- The four gauge-normalized displays on the positive-gauge domain, with the
zero-gauge variable identified separately. -/
def PsiTwoDisplayedBoundsEffectiveDomain
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) : Prop :=
  (0 < PsiTwoGauge μ X → PsiTwoGaugeDisplayedBounds μ X) ∧
    (PsiTwoGauge μ X = 0 → X =ᵐ[μ] (fun _ : Ω => (0 : ℝ)))

/-- Section 2.5's quantitative minimality assertion with every quotient kept
on its positive-gauge effective domain. -/
theorem hdp_02_hbody_h2_d5_hpsi2_hminimality_effectiveDomain :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → PsiTwoGauge μ X < ∞ →
          PsiTwoDisplayedBoundsEffectiveDomain μ X ∧
          (∀ i : SubGaussianPropertyKind,
            (i = .tail ∨ i = .moment ∨ i = .squarePoint) →
              ∀ {K : ℝ}, 0 < K → SubGaussianProperty μ X i K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
          ((Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) →
            ∀ {K : ℝ}, 0 < K →
              SubGaussianProperty μ X .linearMGF K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) := by
  rcases psiTwoGauge_smallestDisplayedScale_absolute with ⟨C, hC, hAll⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ X hX hFinite
  rcases hAll hX hFinite with ⟨hBounds, hUncentered, hCentered⟩
  refine ⟨⟨fun _ => hBounds,
    fun hZero => (psiTwoGauge_eq_zero_iff_ae_eq_zero hX).mp hZero⟩,
    hUncentered, hCentered⟩

end NumStability.HDP.Contract
