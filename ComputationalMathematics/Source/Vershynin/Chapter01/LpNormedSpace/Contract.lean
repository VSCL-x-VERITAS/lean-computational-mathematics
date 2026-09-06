import ComputationalMathematics.HDP.Scalar.Preliminaries
/-!
Cross-split stable API for `HDP-01-DEF-LP-NORM` and
`HDP-01-DEF-LP-SPACE`.

The reusable producer owns Mathlib's representative seminorm, membership
predicate, and almost-everywhere quotient.  This leaf owns the book alias and
the displayed finite-exponent and essential-supremum endpoint formulas.
-/

namespace NumStability.HDP.Contract

open MeasureTheory

/-- Stable source-facing representative and quotient `L^p` interface. -/
noncomputable def hdp_01_hdef_hlp_hnorm_hspace
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (p : ENNReal) :
    NumStability.HDP.Scalar.Preliminaries.LpNormSpaceModelData μ p :=
  NumStability.HDP.Scalar.Preliminaries.lpNormSpaceModel μ p

/-- The finite positive-exponent formula for the extended `L^p` norm. -/
theorem hdp_01_hdef_hlp_hnorm_finite_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (p : ENNReal) (hp0 : p ≠ 0) (hpTop : p ≠ ⊤) :
    eLpNorm X p μ =
      (∫⁻ ω, ‖X ω‖ₑ ^ p.toReal ∂μ) ^ (1 / p.toReal) := by
  exact eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hpTop

/-- The `p = ∞` extension is the essential supremum of the pointwise norm. -/
theorem hdp_01_hdef_hlp_hnorm_infty_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) :
    eLpNorm X (⊤ : ENNReal) μ = eLpNormEssSup X μ := by
  exact eLpNorm_exponent_top

/-- The two displayed `L^p` norm clauses, packaged for a single source audit. -/
theorem hdp_01_hdef_hlp_hnorm_spec
    {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) :
    (∀ p : ENNReal, p ≠ 0 → p ≠ ⊤ →
      eLpNorm X p μ =
        (∫⁻ ω, ‖X ω‖ₑ ^ p.toReal ∂μ) ^ (1 / p.toReal)) ∧
      eLpNorm X (⊤ : ENNReal) μ = eLpNormEssSup X μ := by
  constructor
  · intro p hp0 hpTop
    exact hdp_01_hdef_hlp_hnorm_finite_spec μ X p hp0 hpTop
  · exact hdp_01_hdef_hlp_hnorm_infty_spec μ X

end NumStability.HDP.Contract
