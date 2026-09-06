import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability

/-! Frozen proof-free signature for Exercise 2.6.9.

The witness is the asymmetric two-point law with masses `999/1000` and
`1/1000`; the two `sInf` expressions are the finite-law `ψ₂` gauges. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d6_d9__contract_type : Prop :=
  ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
    IsProbabilityMeasure μ ∧
    μ = (999 / 1000 : ENNReal) • Measure.dirac (-1) +
      (1 / 1000 : ENNReal) • Measure.dirac 4 ∧
    X = (fun x : ℝ => x) ∧
    (∫ x, X x ∂μ) = (999 / 1000 : ℝ) * (-1) + (1 / 1000 : ℝ) * 4 ∧
    sInf {t : ℝ | 0 < t ∧
      (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / t) ^ 2) +
        (1 / 1000 : ℝ) * Real.exp ((4 / t) ^ 2) ≤ 2} <
      sInf {t : ℝ | 0 < t ∧
        (1 - (1 / 1000 : ℝ)) * Real.exp ((-1 / 200 / t) ^ 2) +
          (1 / 1000 : ℝ) * Real.exp ((999 / 200 / t) ^ 2) ≤ 2}

end NumStability.HDP.Contract
