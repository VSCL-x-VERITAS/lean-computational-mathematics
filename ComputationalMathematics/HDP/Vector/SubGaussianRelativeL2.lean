import ComputationalMathematics.HDP.Vector.SubGaussianDomination
import ComputationalMathematics.HDP.Vector.SubGaussianL2
import Mathlib.MeasureTheory.Function.L2Space

/-!
# Relative sub-Gaussian and second-moment conditions

A single finite constant bounds every scalar marginal by its own second
moment. The extended-norm, integrable-moment, and finite real-value
presentations share the existing scalar gauge and norm/moment bridges.
The legacy condition and equivalence names remain available for compatibility.
-/

noncomputable section
open MeasureTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The legacy relative condition with finite marginal norms and one uniform
constant. Its public declaration name is preserved by the producer relocation. -/
def Equation424Condition {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) : Prop :=
  (∀ j, Measurable (X j)) ∧
    ∃ K : ℝ≥0, 1 ≤ K ∧
      ∀ x : Fin n → ℝ,
        NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (NumStability.HDP.Vector.linearMarginal X x) ∧
          eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ < ∞ ∧
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
              (NumStability.HDP.Vector.linearMarginal X x) ≤
            (K : ℝ≥0∞) *
              eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ

/-- The finite marginal norm is the square root of its ordinary second
moment. This exact legacy bridge retains its public name and proof. -/
theorem equation424Condition_iff_ordinary_second_moment
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) :
    Equation424Condition (μ := μ) X ↔
      (∀ j, Measurable (X j)) ∧
        ∃ K : ℝ≥0, 1 ≤ K ∧
          ∀ x : Fin n → ℝ,
            NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
                (NumStability.HDP.Vector.linearMarginal X x) ∧
              MemLp (NumStability.HDP.Vector.linearMarginal X x) 2 μ ∧
              NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (NumStability.HDP.Vector.linearMarginal X x) ≤
                (K : ℝ≥0∞) * ENNReal.ofReal
                  (Real.sqrt (∫ ω,
                    (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ)) := by
  constructor
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hFinite, hBound⟩ := hMarginal x
    have hMarginalMeas :=
      NumStability.HDP.Vector.SubGaussian.measurable_linearMarginal hMeas x
    have hLp : MemLp (NumStability.HDP.Vector.linearMarginal X x) 2 μ :=
      ⟨hMarginalMeas.aestronglyMeasurable, hFinite⟩
    refine ⟨hSG, hLp, ?_⟩
    rwa [NumStability.HDP.Scalar.Preliminaries.eLpNorm_two_eq_ofReal_sqrt_integral_sq
      hLp] at hBound
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hLp, hBound⟩ := hMarginal x
    refine ⟨hSG, hLp.eLpNorm_lt_top, ?_⟩
    rwa [NumStability.HDP.Scalar.Preliminaries.eLpNorm_two_eq_ofReal_sqrt_integral_sq
      hLp]

end NumStability.HDP.Contract

namespace NumStability.HDP.Vector.SubGaussian

/-- A transparent ordinary-second-moment surface for the relative condition.
    This helper is meaningful for arbitrary measures; source review must
    select its probability-space application separately. -/
def RelativeSecondMomentCondition {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {n : ℕ} (X : Fin n → Ω → ℝ) : Prop :=
  (∀ j, Measurable (X j)) ∧
    ∃ K : ℝ≥0, 1 ≤ K ∧ ∀ x : Fin n → ℝ,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (NumStability.HDP.Vector.linearMarginal X x) ∧
      Integrable (fun ω => (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2) μ ∧
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X x) ≤
        (K : ℝ≥0∞) * ENNReal.ofReal (Real.sqrt
          (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ))

/-- Reuse the existing exact norm bridge and pinned Mathlib's square-
    integrability characterization; introduce no new norm or concentration API. -/
theorem relativeSecondMomentCondition_iff_equation424Condition
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) :
    RelativeSecondMomentCondition (μ := μ) X ↔
      NumStability.HDP.Contract.Equation424Condition (μ := μ) X := by
  rw [NumStability.HDP.Contract.equation424Condition_iff_ordinary_second_moment]
  constructor
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hSq, hBound⟩ := hMarginal x
    have hMarginalMeas :=
      NumStability.HDP.Vector.SubGaussian.measurable_linearMarginal hMeas x
    exact ⟨hSG, (memLp_two_iff_integrable_sq hMarginalMeas.aestronglyMeasurable).mpr hSq,
      hBound⟩
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hLp, hBound⟩ := hMarginal x
    exact ⟨hSG, hLp.integrable_sq, hBound⟩

end NumStability.HDP.Vector.SubGaussian



namespace NumStability.HDP.Vector.SubGaussian

/-- A finite real-value presentation restricted to the source probability
space. Sub-Gaussian membership is explicit, so `toReal` never converts an
infinite gauge to zero. The raw second moment is integrable in every direction. -/
def ProbabilityRelativeSecondMomentCondition {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
    (X : Fin n → Ω → ℝ) : Prop :=
  (∀ j, Measurable (X j)) ∧
    ∃ K : ℝ≥0, 1 ≤ K ∧ ∀ x : Fin n → ℝ,
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (NumStability.HDP.Vector.linearMarginal X x) ∧
      Integrable (fun ω => (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2) μ ∧
      (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X x)).toReal ≤
        (K : ℝ) * Real.sqrt
          (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ)

/-- Convert only the finite order comparison, reusing the existing gauge,
second-moment bridge and pinned Mathlib. -/
theorem probabilityRelativeSecondMomentCondition_iff_equation424Condition
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ} (X : Fin n → Ω → ℝ) :
    ProbabilityRelativeSecondMomentCondition (μ := μ) X ↔
      NumStability.HDP.Contract.Equation424Condition (μ := μ) X := by
  rw [← NumStability.HDP.Vector.SubGaussian.relativeSecondMomentCondition_iff_equation424Condition X]
  have hCompare (x : Fin n → ℝ) (K : ℝ≥0)
      (hSG : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (NumStability.HDP.Vector.linearMarginal X x)) :
      (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X x)).toReal ≤
          (K : ℝ) * Real.sqrt
            (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ) ↔
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (NumStability.HDP.Vector.linearMarginal X x) ≤
          (K : ℝ≥0∞) * ENNReal.ofReal (Real.sqrt
            (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ)) := by
    have hFinite :=
      (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite).mp hSG
    have hRhs : (K : ℝ≥0∞) * ENNReal.ofReal (Real.sqrt
        (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ)) ≠ ∞ :=
      ENNReal.mul_ne_top ENNReal.coe_ne_top ENNReal.ofReal_ne_top
    simpa only [ENNReal.toReal_mul, ENNReal.coe_toReal,
      ENNReal.toReal_ofReal (Real.sqrt_nonneg _)] using
      (ENNReal.toReal_le_toReal hFinite.ne hRhs)
  constructor
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hSq, hBound⟩ := hMarginal x
    exact ⟨hSG, hSq, (hCompare x K hSG).mp hBound⟩
  · rintro ⟨hMeas, K, hK, hMarginal⟩
    refine ⟨hMeas, K, hK, ?_⟩
    intro x
    obtain ⟨hSG, hSq, hBound⟩ := hMarginal x
    exact ⟨hSG, hSq, (hCompare x K hSG).mpr hBound⟩

end NumStability.HDP.Vector.SubGaussian

end
