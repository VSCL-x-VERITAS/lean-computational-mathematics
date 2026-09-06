import Mathlib.Probability.Distributions.Gaussian.Real

/-!
# Frozen contract signature for the standard-normal MGF identity

This file is intentionally proof-free. The implementation is checked in the
semantic module and the contract wrapper is checked against this type.
-/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_02_heq_h2_d12__contract_type : Prop :=
  ∀ (lam : ℝ),
    (∫ x, Real.exp (lam * x) ∂(gaussianReal 0 1) =
      Real.exp (lam ^ 2 / 2))

end NumStability.HDP.Contract
