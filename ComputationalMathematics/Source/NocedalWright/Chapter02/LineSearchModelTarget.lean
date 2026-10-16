import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Order.Filter.Extr
import Mathlib.Analysis.Normed.Group.Constructions

/-! Nocedal and Wright, Chapter 2, line-search model (2.10). -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The strictly positive step lengths in the line-search subproblem. -/
def lineSearchSteps : Set ℝ := Set.Ioi 0

/-- The one-dimensional objective obtained by restricting `f` to the search ray. -/
def lineSearchObjective {n : ℕ} (f : (Fin n → ℝ) → ℝ)
    (x p : Fin n → ℝ) (α : ℝ) : ℝ := f (x + α • p)

/-- Proof-free interpretation of model (2.10). It identifies the admissible
steps, the objective, and what an *exact* solution would mean, without
asserting that one exists. The book says algorithms usually solve it only
approximately and gives no quantitative approximation condition here. -/
def lineSearchModelTarget : Prop :=
  ∀ {n : ℕ}, 0 < n →
    ∀ (f : (Fin n → ℝ) → ℝ), ContDiff ℝ 2 f →
      ∀ (x p : Fin n → ℝ) (α : ℝ),
        (α ∈ lineSearchSteps ↔ 0 < α) ∧
        lineSearchObjective f x p α = f (x + α • p) ∧
        ((α ∈ lineSearchSteps ∧
            IsMinOn (lineSearchObjective f x p) lineSearchSteps α) ↔
          (0 < α ∧
            ∀ β : ℝ, 0 < β → f (x + α • p) ≤ f (x + β • p)))

end ComputationalMathematics.Source.NocedalWright.Chapter02
