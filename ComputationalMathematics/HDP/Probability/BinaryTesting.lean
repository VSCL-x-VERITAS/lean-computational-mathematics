import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Measure.Real

/-!
# Binary testing bounds and measurable success certificates

The bounds in this file apply to arbitrary decision sets. This is useful when
the decision rule is defined through a classical choice for which no
measurability theorem is available.
An outer failure bound also supplies an original-space measurable subset of
success, without asserting measurability of the full decision or success set.
-/

noncomputable section

open MeasureTheory Set

namespace NumStability.HDP.Probability

/-- The infimum of two measures lower-bounds the sum of the two complementary
decision errors. No measurability assumption on the decision set is needed. -/
theorem measure_inf_univ_le_add_compl
    {Ω : Type*} [MeasurableSpace Ω]
    (μ ν : Measure Ω) (decision : Set Ω) :
    (μ ⊓ ν) univ ≤ μ decision + ν decisionᶜ := by
  rw [Measure.inf_apply MeasurableSet.univ]
  exact sInf_le ⟨decision, by simp⟩

/-- Any common submeasure lower-bounds the sum of the two complementary
decision errors. No measurability assumption on the decision set is needed. -/
theorem commonMeasure_univ_le_add_compl
    {Ω : Type*} [MeasurableSpace Ω]
    (μ ν κ : Measure Ω) (decision : Set Ω)
    (hκμ : κ ≤ μ) (hκν : κ ≤ ν) :
    κ univ ≤ μ decision + ν decisionᶜ := by
  exact (show κ univ ≤ (μ ⊓ ν) univ from
    (le_inf hκμ hκν) univ).trans
      (measure_inf_univ_le_add_compl μ ν decision)

/-- An outer failure bound for any success set yields a measurable subset
with the corresponding ordinary probability lower bound. No measurability of
the full success set or decision rule is required. -/
theorem exists_measurable_subset_of_failure_measureReal_le
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] (success : Set Ω) {eta : ℝ}
    (hfailure : μ.real successᶜ ≤ eta) :
    ∃ good : Set Ω, MeasurableSet good ∧ good ⊆ success ∧
      1 - eta ≤ μ.real good := by
  let failureHull := toMeasurable μ successᶜ
  have hmeas : MeasurableSet failureHull := measurableSet_toMeasurable μ successᶜ
  have hmass : μ.real failureHull = μ.real successᶜ := by
    simp only [failureHull, Measure.real_def, measure_toMeasurable]
  refine ⟨failureHullᶜ, hmeas.compl, ?_, ?_⟩
  · intro ω hω
    by_contra hnot
    exact hω (subset_toMeasurable μ successᶜ hnot)
  · rw [probReal_compl_eq_one_sub hmeas, hmass]
    linarith

end NumStability.HDP.Probability
