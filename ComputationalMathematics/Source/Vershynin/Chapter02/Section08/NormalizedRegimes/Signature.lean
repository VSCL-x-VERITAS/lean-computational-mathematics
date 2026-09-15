import ComputationalMathematics.HDP.Scalar.IndependentSums.NormalizedRegimesDiscrepancy

/-!
# Discrepancy signature for the normalized two-regime display

The large-deviation branch printed after Corollary 2.8.3 has coefficient one
in its exponent.  This proof-free proposition packages a centered
sub-exponential singleton family and states that no positive regime threshold
can make that literal branch valid for it.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein
open NumStability.HDP.Scalar.SubExponential

def hdp_02_body_h2_d8_hnormalized_hregimes_source_obstruction__contract_type : Prop :=
  IsProbabilityMeasure (expMeasure 1) ∧
    Measurable centeredScaledExponential ∧
    Integrable centeredScaledExponential (expMeasure 1) ∧
    (∫ x : ℝ, centeredScaledExponential x ∂expMeasure 1) = 0 ∧
    PsiOneGauge (expMeasure 1) centeredScaledExponential < ∞ ∧
    iIndepFun (fun _u : Unit ↦ centeredScaledExponential) (expMeasure 1) ∧
    ¬ ∃ C : ℝ, 0 < C ∧
      ∀ {t : ℝ}, 0 ≤ t → C ≤ t →
        (expMeasure 1).real {x | centeredScaledExponential x ≥ t} ≤
          2 * Real.exp (-t)

end NumStability.HDP.Contract
