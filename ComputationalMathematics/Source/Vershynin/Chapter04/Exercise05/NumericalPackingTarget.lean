import ComputationalMathematics.HDP.Metric.Packing

/-!
# Exercise 4.2.5: numerical packing target

Part (a) compares unrestricted ENat suprema over all center subsets of an
arbitrary real normed space. Part (b) asks for a genuine positive-radius metric
counterexample to that numerical equality, without prescribing its witness.
-/

noncomputable section

open Set
open scoped ENNReal NNReal

universe u

namespace NumStability.HDP.Contract

/-- Both numerical parts of Exercise 4.2.5 under the admitted positive-radius
ENat convention. The denominator is the real image of the natural number two.
Closed half-radius balls are ambient balls, even when their
centers belong to `K`; no finite packing or attained maximum is assumed. -/
def exercise425NumericalPackingTarget : Prop :=
  (∀ (E : Type u) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (K : Set E) (ε : ℝ≥0), 0 < ε →
      Metric.packingNumber ε K =
        ⨆ (C : Set E) (_ : C ⊆ K)
          (_ : C.Pairwise fun x y ↦
            Disjoint (Metric.closedBall x ((ε : ℝ) / (↑(2 : ℕ) : ℝ)))
              (Metric.closedBall y ((ε : ℝ) / (↑(2 : ℕ) : ℝ)))), C.encard) ∧
    ∃ (T : Type) (inst : MetricSpace T),
      letI := inst
      ∃ (ε : ℝ≥0), 0 < ε ∧
        ∃ (K : Set T),
          Metric.packingNumber ε K ≠
            ⨆ (C : Set T) (_ : C ⊆ K)
              (_ : C.Pairwise fun x y ↦
                Disjoint (Metric.closedBall x ((ε : ℝ) / (↑(2 : ℕ) : ℝ)))
                  (Metric.closedBall y ((ε : ℝ) / (↑(2 : ℕ) : ℝ)))), C.encard

end NumStability.HDP.Contract
