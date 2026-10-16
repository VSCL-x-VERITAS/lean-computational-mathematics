import ComputationalMathematics.Optimization.Convex.Euclidean

/-!
# Chapter 1 editorial clarification targets

These proof-free propositions represent the project owner's version-1
clarifications. They are separate from the printed PDF claims and do not
change their deferred audit dispositions.
-/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- C1: the real binary feasible set is a particular nonconvex discrete set. -/
def discreteBinaryClarificationTargetV1 : Prop :=
  ¬ Convex ℝ ({0, 1} : Set ℝ)

/-- C2: the objective's convexity domain explicitly contains the feasible set. -/
def localGlobalClarificationTargetV1 : Prop :=
  ∀ {n : ℕ} (D s : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ),
    ConvexOn ℝ D f → Convex ℝ s → s ⊆ D → x ∈ s →
      IsLocalMinOn f s x → ∀ y ∈ s, f x ≤ f y

/-- C3: zero costs make the objective zero; a nonzero cost makes it nonaffine
on some nonnegative shipment arrays, without asserting transport feasibility. -/
def volumeDiscountClarificationTargetV1 : Prop :=
  (∀ (δ : ℝ) (x : Fin 2 → Fin 12 → ℝ),
    0 < δ → (∑ i, ∑ j, (0 : ℝ) * Real.sqrt (δ + x i j)) = 0) ∧
  ∀ (δ : ℝ) (c : Fin 2 → Fin 12 → ℝ),
    0 < δ → (∃ i j, c i j ≠ 0) →
      ∃ x y : Fin 2 → Fin 12 → ℝ,
        (∀ i j, 0 ≤ x i j) ∧
        (∀ i j, 0 ≤ y i j) ∧
        (∑ i, ∑ j, c i j * Real.sqrt (δ + (x i j + y i j) / 2)) ≠
          ((∑ i, ∑ j, c i j * Real.sqrt (δ + x i j)) +
            (∑ i, ∑ j, c i j * Real.sqrt (δ + y i j))) / 2

end ComputationalMathematics.Source.NocedalWright.Chapter01
