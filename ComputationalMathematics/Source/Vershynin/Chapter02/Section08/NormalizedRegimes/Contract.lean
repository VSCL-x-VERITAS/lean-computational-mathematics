import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.NormalizedRegimes.Signature

/-!
# Obstruction to the literal normalized large-deviation branch

The centered scale-two rate-one exponential variable is a source-compatible
singleton family, but its upper tail decays too slowly for the printed
coefficient-one exponent.  Thus changing only the threshold cannot validate
the display for every common sub-exponential scale `K`.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Source discrepancy witness for the unnumbered display on printed page 37. -/
theorem hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction :
    hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type := by
  letI : IsProbabilityMeasure (expMeasure 1) :=
    ProbabilityTheory.isProbabilityMeasure_expMeasure (by norm_num)
  exact ⟨inferInstance, measurable_centeredScaledExponential,
    integrable_centeredScaledExponential, integral_centeredScaledExponential,
    psiOneGauge_centeredScaledExponential_lt_top,
    iIndepFun_centeredScaledExponential_unit,
    no_literal_normalizedLargeTail_threshold⟩

/-- Mechanical receipt for the frozen proof-free obstruction proposition. -/
theorem hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract :
    hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type :=
  hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction

end NumStability.HDP.Contract
