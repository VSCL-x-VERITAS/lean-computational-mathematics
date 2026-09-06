import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
# Exact two-sided tail decomposition

Reusable measure identity splitting an absolute-value tail into its disjoint
positive and negative tails at a strictly positive threshold.
-/

noncomputable section

open MeasureTheory Set

namespace NumStability.HDP.Scalar.IndependentSums.TwoSidedTail

theorem measureReal_abs_ge_eq_add
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S) {t : ℝ} (ht : 0 < t) :
    μ.real {ω | |S ω| ≥ t} =
      μ.real {ω | S ω ≥ t} + μ.real {ω | -S ω ≥ t} := by
  let A : Set Ω := {ω | S ω ≥ t}
  let B : Set Ω := {ω | -S ω ≥ t}
  have hA : MeasurableSet A := by
    exact measurableSet_Ici.preimage hS
  have hB : MeasurableSet B := by
    exact measurableSet_Ici.preimage hS.neg
  have hdisjoint : Disjoint A B := by
    rw [Set.disjoint_left]
    intro ω hωA hωB
    change t ≤ S ω at hωA
    change t ≤ -S ω at hωB
    linarith
  have hevent : {ω | |S ω| ≥ t} = A ∪ B := by
    ext ω
    constructor
    · intro hω
      change t ≤ |S ω| at hω
      by_cases hupper : t ≤ S ω
      · exact Or.inl hupper
      · right
        have hSlt : S ω < t := lt_of_not_ge hupper
        by_contra hlower
        have hneglt : -S ω < t := lt_of_not_ge hlower
        exact (not_lt_of_ge hω) ((abs_lt).2 (by constructor <;> linarith))
    · rintro (hupper | hlower)
      · change t ≤ |S ω|
        exact hupper.trans (le_abs_self (S ω))
      · change t ≤ |S ω|
        rw [← abs_neg]
        exact hlower.trans (le_abs_self (-S ω))
  rw [hevent]
  exact measureReal_union₀ hB.nullMeasurableSet hdisjoint.aedisjoint

end NumStability.HDP.Scalar.IndependentSums.TwoSidedTail
