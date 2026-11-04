import Mathlib.MeasureTheory.Measure.Real

/-!
# Measurable subsets of conditional almost-everywhere certificates

A null-measurable event carrying almost-everywhere conditional success admits
an original-space measurable subset with the same measure and pointwise
conditional success. No completeness assumption or measurability of the
success and qualifying sets is required.
-/

noncomputable section
open MeasureTheory Set

namespace NumStability.HDP.Probability

/-- A null-measurable event with AE conditional success admits a measurable
subset with the same measure and pointwise conditional success. -/
theorem exists_measurable_subset_pointwise_conditional_of_ae
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (success qualifying good : Set Ω)
    (hregular : NullMeasurableSet good μ)
    (hsuccess : ∀ᵐ ω ∂μ, ω ∈ good → ω ∈ qualifying → ω ∈ success) :
    ∃ measurableGood : Set Ω, MeasurableSet measurableGood ∧
      measurableGood ⊆ good ∧ measurableGood =ᵐ[μ] good ∧
      μ measurableGood = μ good ∧ μ.real measurableGood = μ.real good ∧
      ∀ ω ∈ measurableGood, ω ∈ qualifying → ω ∈ success := by
  let conditional : Set Ω := {ω | ω ∈ qualifying → ω ∈ success}
  have hsame : (good ∩ conditional : Set Ω) =ᵐ[μ] good := by
    filter_upwards [hsuccess] with ω hω
    apply propext
    change (ω ∈ good ∧ (ω ∈ qualifying → ω ∈ success)) ↔ ω ∈ good
    exact ⟨And.left, fun hgood ↦ ⟨hgood, hω hgood⟩⟩
  have hvalid : NullMeasurableSet (good ∩ conditional) μ :=
    hregular.congr hsame.symm
  obtain ⟨measurableGood, hsubset, hmeasurable, heq⟩ :=
    hvalid.exists_measurable_subset_ae_eq
  have heqGood : measurableGood =ᵐ[μ] good := heq.trans hsame
  refine ⟨measurableGood, hmeasurable, fun ω hω ↦ (hsubset hω).1,
    heqGood, measure_congr heqGood, measureReal_congr heqGood, ?_⟩
  intro ω hω
  exact (hsubset hω).2

/-- Existence of a regular AE conditional certificate at a given probability
bound is equivalent to existence of an original-space measurable pointwise
certificate at that same bound. -/
theorem exists_regular_ae_conditional_certificate_iff_measurable_pointwise
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    (success qualifying : Set Ω) (lowerBound : ℝ) :
    (∃ good : Set Ω, NullMeasurableSet good μ ∧ lowerBound ≤ μ.real good ∧
      ∀ᵐ ω ∂μ, ω ∈ good → ω ∈ qualifying → ω ∈ success) ↔
    (∃ good : Set Ω, MeasurableSet good ∧ lowerBound ≤ μ.real good ∧
      ∀ ω ∈ good, ω ∈ qualifying → ω ∈ success) := by
  constructor
  · rintro ⟨good, hregular, hbound, hsuccess⟩
    obtain ⟨measurableGood, hmeasurable, _, _, _, hmass, hpointwise⟩ :=
      exists_measurable_subset_pointwise_conditional_of_ae
        μ success qualifying good hregular hsuccess
    exact ⟨measurableGood, hmeasurable, hmass.symm ▸ hbound, hpointwise⟩
  · rintro ⟨good, hmeasurable, hbound, hsuccess⟩
    exact ⟨good, hmeasurable.nullMeasurableSet, hbound,
      Filter.Eventually.of_forall hsuccess⟩

end NumStability.HDP.Probability
