import ComputationalMathematics.HDP.Scalar.SubExponential

/-!
# Frozen contract signature for the Orlicz norm and space definitions

This file is intentionally proof-free.
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hdef_horlicz_hnorm_hspace__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    (ψ : NumStability.HDP.Scalar.SubExponential.OrliczFunction)
    (μ : Measure Ω) (X : Ω → ℝ),
    NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X =
        sInf {t : ℝ≥0∞ |
          t ≠ 0 ∧ t ≠ ∞ ∧
            (∫⁻ ω, ENNReal.ofReal (ψ (|X ω| / t.toReal)) ∂μ) ≤ 1} ∧
      (NumStability.HDP.Scalar.SubExponential.orliczMember ψ μ X ↔
        NumStability.HDP.Scalar.SubExponential.orliczGauge ψ μ X < ∞)

end NumStability.HDP.Contract
