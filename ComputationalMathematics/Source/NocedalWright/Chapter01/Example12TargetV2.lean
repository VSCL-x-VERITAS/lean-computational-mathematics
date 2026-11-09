import ComputationalMathematics.Optimization.Modeling.Basic

/-!
# Nocedal--Wright example (1.2) target, revision 2
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Problem (1.2) has a feasible global solution. The source identifies the
solution graphically but does not assign coordinates to it in the prose. -/
def example12HasSolutionTargetV2 : Prop :=
  ∃ x₁ x₂ : ℝ,
    x₁ ^ 2 - x₂ ≤ 0 ∧
    x₁ + x₂ ≤ 2 ∧
    ∀ y₁ y₂ : ℝ,
      y₁ ^ 2 - y₂ ≤ 0 →
      y₁ + y₂ ≤ 2 →
      (x₁ - 2) ^ 2 + (x₂ - 1) ^ 2 ≤
        (y₁ - 2) ^ 2 + (y₂ - 1) ^ 2

end ComputationalMathematics.Source.NocedalWright.Chapter01
