import ComputationalMathematics.Optimization.Modeling.Basic

/-!
# Nocedal--Wright transportation model (1.3) target
-/

open scoped BigOperators

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The transportation minimum (1.3) is the explicit conjunction of plant
capacity, outlet demand, nonnegativity, and cost comparison conditions. -/
def transportation13Target : Prop :=
  ∀ (cost shipment : Fin 2 → Fin 12 → ℝ) (capacity : Fin 2 → ℝ)
    (demand : Fin 12 → ℝ),
    (shipment ∈ {x : Fin 2 → Fin 12 → ℝ |
        (∀ i, ∑ j, x i j ≤ capacity i) ∧
        (∀ j, demand j ≤ ∑ i, x i j) ∧
        ∀ i j, 0 ≤ x i j} ∧
      ∀ y ∈ {x : Fin 2 → Fin 12 → ℝ |
        (∀ i, ∑ j, x i j ≤ capacity i) ∧
        (∀ j, demand j ≤ ∑ i, x i j) ∧
        ∀ i j, 0 ≤ x i j},
        (∑ i, ∑ j, cost i j * shipment i j) ≤
          ∑ i, ∑ j, cost i j * y i j) ↔
    ((∀ i, ∑ j, shipment i j ≤ capacity i) ∧
      (∀ j, demand j ≤ ∑ i, shipment i j) ∧
      (∀ i j, 0 ≤ shipment i j) ∧
      ∀ y : Fin 2 → Fin 12 → ℝ,
        ((∀ i, ∑ j, y i j ≤ capacity i) ∧
          (∀ j, demand j ≤ ∑ i, y i j) ∧
          ∀ i j, 0 ≤ y i j) →
        (∑ i, ∑ j, cost i j * shipment i j) ≤
          ∑ i, ∑ j, cost i j * y i j)

end ComputationalMathematics.Source.NocedalWright.Chapter01
