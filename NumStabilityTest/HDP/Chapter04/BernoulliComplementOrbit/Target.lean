import ComputationalMathematics.HDP.Probability.FiniteSignProducts

/-!
Unsealed ordinary conditional guarantee for an explicitly realized finite
Bernoulli product measure. This draft selects no interpretation of the book.
Its proof may be sought only after the owning target-freeze intake.
-/

set_option autoImplicit false

open MeasureTheory
open scoped NNReal

universe u

/-- A supplied weak coordinate mode maximizes the real mass of the two-point
Boolean-complement orbit, including the singleton orbit for an empty index. -/
def BernoulliComplementOrbitModalTarget : Prop :=
  ∀ (ι : Type u) [Fintype ι] (p : ι → ℝ≥0) (hp : ∀ i, p i ≤ 1)
      (d : ι → Bool),
    (∀ i, if d i then 1 - (p i : ℝ) ≤ (p i : ℝ)
      else (p i : ℝ) ≤ 1 - (p i : ℝ)) →
    ∀ s : ι → Bool,
      (Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)).real
          ({s, fun i ↦ !(s i)} : Set (ι → Bool)) ≤
        (Measure.pi (fun i ↦ (PMF.bernoulli (p i) (hp i)).toMeasure)).real
          ({d, fun i ↦ !(d i)} : Set (ι → Bool))
