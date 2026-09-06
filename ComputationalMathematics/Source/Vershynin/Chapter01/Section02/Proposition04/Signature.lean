import Mathlib.MeasureTheory.Integral.Lebesgue.Markov
import Mathlib.MeasureTheory.Integral.Bochner.Set

/-!
# Frozen contract signature for Markov's inequality

This file is intentionally proof-free.  The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

def hdp_01_hprop_h1_d2_d4__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : Ω → ℝ}
    (hX : Measurable X)
    (hNonneg : ∀ᵐ ω ∂μ, 0 ≤ X ω)
    (hInt : Integrable X μ)
    {t : ℝ} (ht : 0 < t),
    (μ.real (X ⁻¹' Set.Ici t) ≤
      (∫ ω, X ω ∂μ) / t) ∧
      (μ (X ⁻¹' Set.Ici t) ≤
        (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal t)

end NumStability.HDP.Contract
