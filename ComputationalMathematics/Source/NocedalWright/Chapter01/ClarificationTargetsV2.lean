import ComputationalMathematics.Source.NocedalWright.Chapter01.ClarificationTargetsV1

/-!
# Revised Chapter 1 editorial clarification targets

C2 retains its v1 target; its editorial source now states the total-function
and zero-dimensional conventions explicitly. C3 restricts its zero-cost
identity to nonnegative shipment arrays, matching the intended real square-root
domain. The v1 target and its audit remain intact.
-/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- C3 v2: zero costs give zero on the nonnegative orthant, and a nonzero
cost makes the objective nonaffine there. -/
def volumeDiscountClarificationTargetV2 : Prop :=
  (∀ (δ : ℝ) (x : Fin 2 → Fin 12 → ℝ),
    0 < δ → (∀ i j, 0 ≤ x i j) →
      (∑ i, ∑ j, (0 : ℝ) * Real.sqrt (δ + x i j)) = 0) ∧
  ∀ (δ : ℝ) (c : Fin 2 → Fin 12 → ℝ),
    0 < δ → (∃ i j, c i j ≠ 0) →
      ∃ x y : Fin 2 → Fin 12 → ℝ,
        (∀ i j, 0 ≤ x i j) ∧
        (∀ i j, 0 ≤ y i j) ∧
        (∑ i, ∑ j, c i j * Real.sqrt (δ + (x i j + y i j) / 2)) ≠
          ((∑ i, ∑ j, c i j * Real.sqrt (δ + x i j)) +
            (∑ i, ∑ j, c i j * Real.sqrt (δ + y i j))) / 2

end ComputationalMathematics.Source.NocedalWright.Chapter01
