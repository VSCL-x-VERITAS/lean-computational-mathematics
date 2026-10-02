import ComputationalMathematics.HDP.Vector.SubGaussianL2

/-!
# Vershynin Chapter 4, Equation (4.24)
-/

noncomputable section

open MeasureTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.24), as the operative condition imposed on the
sub-Gaussian random vector in Theorem 4.7.1.  Coordinate measurability and
finite `L²`/`ψ₂` effective domains exclude the unintended extended-real
tautology `⊤ ≤ K * ⊤`; one *uniform* finite constant `K ≥ 1` controls every
linear marginal by the `L²` norm of that same marginal.

This is deliberately a proposition-valued definition rather than a theorem
asserting that every random vector has the property: in the source, (4.24) is
a hypothesis. -/
def Equation424Condition {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
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

/-- Proof-free audit surface for the exact Equation (4.24) condition.  The
selected audit scope is this condition-definition, not an assertion that every
random vector satisfies it and not the conclusion of Theorem 4.7.1. -/
theorem hdp_04_equation_4_24 {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {n : ℕ}
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
