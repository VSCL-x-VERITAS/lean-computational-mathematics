import Mathlib.Analysis.Calculus.Taylor
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.Probability.Distributions.Exponential

/-! Frozen proof-free signature for Remark 2.7.9.

The local Taylor assertion is witnessed by the symmetric two-point law, while the
domain-sensitive MGF assertion uses Mathlib's exponential distribution of rate one.
-/

noncomputable section

open Filter Set TopologicalSpace
open MeasureTheory
open ProbabilityTheory
open scoped Topology

namespace NumStability.HDP.Contract

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
