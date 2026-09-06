import ComputationalMathematics.HDP.Scalar.Preliminaries
/-!
Cross-split stable API for `HDP-01-DEF-LP-SPACE`.

This leaf states the source's finite-norm membership criterion for measurable
representatives.  The reusable producer also owns the standard
almost-everywhere quotient, but the audited theorem does not attribute that
unstated quotient convention to the printed set-builder.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- For a measurable representative and a positive exponent, membership in
`L^p` is exactly finiteness of the extended `L^p` norm. -/
theorem hdp_01_hdef_hlp_hspace_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (p : ENNReal) (_hp : p ≠ 0)
    (X : Ω → ℝ) (hX : AEStronglyMeasurable X μ) :
    (NumStability.HDP.Scalar.Preliminaries.lpNormSpaceModel μ p).representativeMember X ↔
      eLpNorm X p μ < ⊤ := by
  change MemLp X p μ ↔ eLpNorm X p μ < ⊤
  exact ⟨fun h => h.eLpNorm_lt_top, fun h => ⟨hX, h⟩⟩

end NumStability.HDP.Contract
