import Mathlib.Probability.StrongLaw

/-!
# Frozen contract signature for the strong law of large numbers

This file is intentionally proof-free. The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory Filter
open ProbabilityTheory
open scoped BigOperators Function

namespace NumStability.HDP.Contract

def hdp_01_hthm_h1_d3_d1__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {X : ℕ → Ω → ℝ}
    (hInt : Integrable (X 0) μ)
    (hIndep : Pairwise ((· ⟂ᵢ[μ] ·) on X))
    (hIdent : ∀ i, IdentDistrib (X i) (X 0) μ μ),
    ∀ᵐ ω ∂μ, Tendsto
      (fun n : ℕ => (∑ i ∈ Finset.range n, X i ω) / n) atTop
      (nhds (∫ ω, X 0 ω ∂μ))

end NumStability.HDP.Contract
