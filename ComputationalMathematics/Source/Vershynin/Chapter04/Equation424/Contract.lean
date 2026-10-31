import ComputationalMathematics.HDP.Vector.SubGaussianRelativeL2

/-!
# Vershynin Chapter 4, Equation (4.24)

The historical extended-norm wrapper remains available. The separately named
probability-space wrapper uses integrable ordinary moments and a finite real
gauge, with explicit marginal sub-Gaussian membership.
-/

noncomputable section
open MeasureTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Proof-free audit surface for the exact Equation (4.24) condition.  The
selected audit scope is this condition-definition, not an assertion that every
random vector satisfies it and not the conclusion of Theorem 4.7.1. -/
theorem hdp_04_equation_4_24 {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {n : ℕ}
    (X : Fin n → Ω → ℝ) :
    Equation424Condition (μ := μ) X ↔
      (∀ j, Measurable (X j)) ∧
        ∃ K : ℝ≥0, 1 ≤ K ∧
          ∀ x : Fin n → ℝ,
            NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
                (NumStability.HDP.Vector.linearMarginal X x) ∧
              eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ < ∞ ∧
              NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
                  (NumStability.HDP.Vector.linearMarginal X x) ≤
                (K : ℝ≥0∞) *
                  eLpNorm (NumStability.HDP.Vector.linearMarginal X x) 2 μ := by
  rfl

end NumStability.HDP.Contract

namespace NumStability.HDP.Contract

/-- Probability-space source condition, reusing the single transparent
finite real-value producer. No estimate is asserted for an arbitrary vector. -/
def HDP04Equation424ProbabilityOrdinaryCondition {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
    (X : Fin n → Ω → ℝ) : Prop :=
  NumStability.HDP.Vector.SubGaussian.ProbabilityRelativeSecondMomentCondition (μ := μ) X

/-- Exact expanded condition-definition audit surface for Equation (4.24),
on its probability space and finite ordinary-second-moment domain. -/
theorem hdp_04_equation_4_24_probability_ordinary
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ} (X : Fin n → Ω → ℝ) :
    HDP04Equation424ProbabilityOrdinaryCondition (μ := μ) X ↔
      (∀ j, Measurable (X j)) ∧
        ∃ K : ℝ≥0, 1 ≤ K ∧ ∀ x : Fin n → ℝ,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (NumStability.HDP.Vector.linearMarginal X x) ∧
          Integrable (fun ω => (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2) μ ∧
          (NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (NumStability.HDP.Vector.linearMarginal X x)).toReal ≤
            (K : ℝ) * Real.sqrt
              (∫ ω, (NumStability.HDP.Vector.linearMarginal X x ω) ^ 2 ∂μ) := by
  rfl
end NumStability.HDP.Contract

end
