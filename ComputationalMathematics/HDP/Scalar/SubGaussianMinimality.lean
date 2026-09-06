import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Absolute minimality bounds for sub-Gaussian scales

This module isolates the reverse, gauge-facing half of the sub-Gaussian
characterization: any positive scale witnessing one of the four uncentered
properties controls the exact `ψ₂` gauge up to one universal factor, and the
same holds for the linear-MGF property under centering.
-/

namespace NumStability.HDP.Scalar.SubGaussian

open MeasureTheory
open scoped ENNReal

/-- One universal constant compares the exact `ψ₂` gauge with every admissible
scale in the four uncentered sub-Gaussian properties.  For the linear-MGF
property, the comparison has precisely the centering assumption that property
requires in Proposition 2.5.2. -/
theorem psiTwoGauge_le_of_property_absolute :
    ∃ C : ℝ, 1 ≤ C ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X →
          ∀ i : SubGaussianPropertyKind, i ≠ .linearMGF →
            ∀ {K : ℝ}, 0 < K → SubGaussianProperty μ X i K →
              PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
      (∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0 →
          ∀ {K : ℝ}, 0 < K →
            SubGaussianProperty μ X .linearMGF K →
              PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) := by
  rcases subGaussianCharacterization_absolute with
    ⟨C, hC, hUncentered, hCentered⟩
  refine ⟨C, hC, ?_, ?_⟩
  · intro Ω _ μ _ X hX i hi K hK hProp
    rcases hUncentered hX i .squarePoint hi (by intro h; cases h) hK hProp with
      ⟨Kpoint, hKpoint, hKpointBound, hPoint⟩
    have hSquarePoint : SubGaussianSquarePoint μ X Kpoint := by
      simpa [SubGaussianProperty] using hPoint
    exact (psiTwoGauge_le_of_squarePoint hSquarePoint).trans
      (ENNReal.ofReal_mono hKpointBound)
  · intro Ω _ μ _ X hX hCenter K hK hProp
    rcases hCentered hX hCenter .linearMGF .squarePoint hK hProp with
      ⟨Kpoint, hKpoint, hKpointBound, hPoint⟩
    have hSquarePoint : SubGaussianSquarePoint μ X Kpoint := by
      simpa [SubGaussianProperty] using hPoint
    exact (psiTwoGauge_le_of_squarePoint hSquarePoint).trans
      (ENNReal.ofReal_mono hKpointBound)

/-- The four gauge-normalized bounds restated after Definition 2.5.6, with
explicit universal constants.  Centering is scoped only to the linear-MGF
clause. -/
def PsiTwoGaugeDisplayedBounds
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) : Prop :=
  (∀ t : ℝ, 0 ≤ t →
    μ.real {ω | |X ω| ≥ t} ≤
      2 * Real.exp
        (-t ^ 2 / (2 * (PsiTwoGauge μ X).toReal) ^ 2)) ∧
  LpMomentGrowth μ X
    (16 * Real.exp 1 * (PsiTwoGauge μ X).toReal) ∧
  (Integrable
      (fun ω => Real.exp
        (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2)) μ ∧
    (∫ ω, Real.exp
      (X ω ^ 2 / (PsiTwoGauge μ X).toReal ^ 2) ∂μ) ≤ 2) ∧
  ((Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) →
    ∀ lam : ℝ,
      Integrable (fun ω => Real.exp (lam * X ω)) μ ∧
        (∫ ω, Real.exp (lam * X ω) ∂μ) ≤
          Real.exp
            ((128 * Real.exp 1) ^ 2 * lam ^ 2 *
              (PsiTwoGauge μ X).toReal ^ 2))

/-- Every measurable finite-gauge variable satisfies all four displayed
gauge-normalized bounds. -/
theorem psiTwoGauge_displayedBounds
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : Measurable X) (hFinite : PsiTwoGauge μ X < ∞) :
    PsiTwoGaugeDisplayedBounds μ X := by
  refine ⟨fun _t ht => psiTwoGaugeToTail hX hFinite ht,
    psiTwoGaugeToLpMomentGrowth hX hFinite,
    psiTwoGauge_squareMoment hX hFinite, ?_⟩
  intro hCenter lam
  exact psiTwoGaugeToMGF hX hFinite hCenter lam

/-- Source-facing quantitative minimality statement for the four bounds after
Definition 2.5.6.  The exact gauge supplies every displayed inequality, and a
single absolute factor compares it with any positive scale witnessing the
tail, moment, square-point, or (when centered) linear-MGF formulation. -/
theorem psiTwoGauge_smallestDisplayedScale_absolute :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω]
          {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ},
        Measurable X → PsiTwoGauge μ X < ∞ →
          PsiTwoGaugeDisplayedBounds μ X ∧
          (∀ i : SubGaussianPropertyKind,
            (i = .tail ∨ i = .moment ∨ i = .squarePoint) →
              ∀ {K : ℝ}, 0 < K → SubGaussianProperty μ X i K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) ∧
          ((Integrable X μ ∧ (∫ ω, X ω ∂μ) = 0) →
            ∀ {K : ℝ}, 0 < K →
              SubGaussianProperty μ X .linearMGF K →
                PsiTwoGauge μ X ≤ ENNReal.ofReal (C * K)) := by
  rcases psiTwoGauge_le_of_property_absolute with
    ⟨C, hC, hUncentered, hCentered⟩
  refine ⟨C, hC, ?_⟩
  intro Ω _ μ _ X hX hFinite
  refine ⟨psiTwoGauge_displayedBounds hX hFinite, ?_, ?_⟩
  · intro i hi K hK hProp
    have hiLinear : i ≠ .linearMGF := by
      rintro rfl
      rcases hi with h | h | h <;> cases h
    exact hUncentered hX i hiLinear hK hProp
  · intro hCenter K hK hProp
    exact hCentered hX hCenter hK hProp

end NumStability.HDP.Scalar.SubGaussian
