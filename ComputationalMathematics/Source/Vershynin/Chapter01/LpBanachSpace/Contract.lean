import ComputationalMathematics.HDP.Scalar.Preliminaries

/-!
Cross-split stable API for `HDP-01-THM-LP-BANACH`.

The source-facing theorem isolates the `p ∈ [1,∞]` normed and complete-space
claim from the reusable model's separate `p < 1` counterexample.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Compatibility source alias for the bundled Chapter 1 `L^p` model. -/
theorem hdp_01_hthm_hlp_hbanach_hquasinorm
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) [Fact (1 ≤ p)] :
    NumStability.HDP.Scalar.Preliminaries.LpQuotientBanachModelData μ p :=
  NumStability.HDP.Scalar.Preliminaries.lpQuotientBanach μ p

/-- For every exponent `p ∈ [1,∞]`, the `L^p` quotient has its normed additive
group structure and is complete. -/
theorem hdp_01_hthm_hlp_hbanach_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (p : ENNReal) [Fact (1 ≤ p)] :
    Nonempty (NormedAddCommGroup (MeasureTheory.Lp ℝ p μ)) ∧
      Nonempty (NormedSpace ℝ (MeasureTheory.Lp ℝ p μ)) ∧
      (∀ f : MeasureTheory.Lp ℝ p μ,
        ‖f‖ = ENNReal.toReal (eLpNorm f p μ)) ∧
      IsComplete (Set.univ : Set (MeasureTheory.Lp ℝ p μ)) := by
  exact
    ⟨⟨inferInstance⟩, ⟨inferInstance⟩,
      fun f => MeasureTheory.Lp.norm_def f, complete_univ⟩

end NumStability.HDP.Contract
