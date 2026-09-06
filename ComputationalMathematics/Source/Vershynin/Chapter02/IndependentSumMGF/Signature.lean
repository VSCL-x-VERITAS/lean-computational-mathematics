import Mathlib.Probability.Independence.Integration

/-!
# Frozen contract signature for finite independent-sum MGF tensorization

This file is intentionally proof-free.  The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_02_hlem_hmgf_hindependent_hsum__contract_type : Prop :=
  ∀ {ι Ω : Type*} [Fintype ι] [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : ι → Ω → ℝ} (lam : ℝ) (a : ι → ℝ),
    iIndepFun X μ →
      (∀ i, Integrable (fun ω => Real.exp (lam * (a i * X i ω))) μ) →
      (∫ ω, Real.exp (lam * ∑ i, a i * X i ω) ∂μ =
        ∏ i, ∫ ω, Real.exp (lam * (a i * X i ω)) ∂μ)

end NumStability.HDP.Contract
