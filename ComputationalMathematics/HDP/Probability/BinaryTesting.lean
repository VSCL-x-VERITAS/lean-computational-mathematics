import Mathlib.MeasureTheory.Measure.MeasureSpace

/-!
# Binary testing bounds from common submeasures

The bounds in this file apply to arbitrary decision sets. This is useful when
the decision rule is defined through a classical choice for which no
measurability theorem is available.
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

end NumStability.HDP.Probability
