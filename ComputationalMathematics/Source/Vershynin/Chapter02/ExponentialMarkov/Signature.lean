import Mathlib.MeasureTheory.Integral.Bochner.Set
import Mathlib.MeasureTheory.Integral.Lebesgue.Markov

/-!
# Frozen contract signature for exponential Markov

This file is intentionally proof-free.  The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

def hdp_02_hlem_hexponential_hmarkov__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (hS : Measurable S)
    {lam t : ℝ} (hlam : 0 < lam)
    (hExp : Integrable (fun ω => Real.exp (lam * S ω)) μ)
    (hExpNeg : Integrable (fun ω => Real.exp (lam * (-S ω))) μ),
    (μ.real (S ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * S ω) ∂μ)) ∧
      (μ.real ((fun ω => -S ω) ⁻¹' Set.Ici t) ≤
        Real.exp (-(lam * t)) *
          (∫ ω, Real.exp (lam * (-S ω)) ∂μ))

end NumStability.HDP.Contract
