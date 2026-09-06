import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.Probability.Distributions.Exponential

/-! Frozen proof-free signatures for Remark 2.7.9.

The exact source-facing signature quantifies over every bounded, centered,
unit-variance random variable.  The older two-point witness is retained below as
a compatibility contract for the declaration already exposed by the original
monolithic development.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology

namespace NumStability.HDP.Contract

/-- Local analytic and exponential-counterexample clauses used by the complete
source-facing contract for Remark 2.7.9. -/
def hdp_02_hrem_h2_d7_d9_local__contract_type : Prop :=
  (∀ {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) [IsProbabilityMeasure μ]
      (X : Ω → ℝ),
      Measurable X →
      (∃ C : ℝ, ∀ ω, |X ω| ≤ C) →
      (∫ ω, X ω ∂μ) = 0 →
      (∫ ω, (X ω) ^ 2 ∂μ) = 1 →
      (fun lam : ℝ =>
        (∫ ω, Real.exp (lam * X ω) ∂μ) - 1 -
          lam * (∫ ω, X ω ∂μ) -
          lam ^ 2 / 2 * (∫ ω, (X ω) ^ 2 ∂μ)) =o[𝓝 (0 : ℝ)]
        (fun lam : ℝ => lam ^ 2)) ∧
  ((fun lam : ℝ => Real.exp (lam ^ 2 / 2) - (1 + lam ^ 2 / 2))
      =o[𝓝 (0 : ℝ)] (fun lam : ℝ => lam ^ 2)) ∧
  (∀ lam : ℝ, 1 ≤ lam →
    ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1))

/-- Compatibility contract predating the source-faithful universal wrapper. -/
def hdp_02_hrem_h2_d7_d9__contract_type : Prop :=
  ∃ (μ : Measure ℝ) (X : ℝ → ℝ),
    IsProbabilityMeasure μ ∧
    μ = (1 / 2 : ENNReal) • Measure.dirac (-1) +
      (1 / 2 : ENNReal) • Measure.dirac 1 ∧
    X = (fun x : ℝ => x) ∧
    (∫ x, X x ∂μ) = 0 ∧
    (∫ x, (X x) ^ 2 ∂μ) = 1 ∧
    (fun lam : ℝ =>
      (∫ x, Real.exp (lam * X x) ∂μ) - 1 -
        lam * (∫ x, X x ∂μ) -
        lam ^ 2 / 2 * (∫ x, (X x) ^ 2 ∂μ)) =o[𝓝 (0 : ℝ)]
      (fun lam : ℝ => lam ^ 2) ∧
    (∀ lam : ℝ, lam < 1 →
      Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1) ∧
        (∫ x, Real.exp (lam * x) ∂(expMeasure 1)) = (1 - lam)⁻¹) ∧
    (∀ lam : ℝ, 1 ≤ lam →
      ¬ Integrable (fun x : ℝ => Real.exp (lam * x)) (expMeasure 1))

end NumStability.HDP.Contract
