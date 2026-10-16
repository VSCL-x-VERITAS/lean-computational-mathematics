import ComputationalMathematics.Optimization.Modeling.Basic

/-!
# Nocedal--Wright formulation (1.1) target
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The constrained minimum notation (1.1) is equivalent to explicitly
requiring feasibility and comparison with every feasible point. -/
def formulation11Target : Prop :=
  ∀ {n : ℕ} {ι : Type} (f : (Fin n → ℝ) → ℝ)
    (c : ι → (Fin n → ℝ) → ℝ) (E I : Set ι) (x : Fin n → ℝ),
    (x ∈ {z | (∀ i ∈ E, c i z = 0) ∧ ∀ i ∈ I, 0 ≤ c i z} ∧
        ∀ y ∈ {z | (∀ i ∈ E, c i z = 0) ∧ ∀ i ∈ I, 0 ≤ c i z}, f x ≤ f y) ↔
      ((∀ i ∈ E, c i x = 0) ∧ (∀ i ∈ I, 0 ≤ c i x) ∧
        ∀ y, ((∀ i ∈ E, c i y = 0) ∧ ∀ i ∈ I, 0 ≤ c i y) → f x ≤ f y)

end ComputationalMathematics.Source.NocedalWright.Chapter01
