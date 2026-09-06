import Mathlib.Probability.Distributions.Gaussian.Real

/-! Frozen proof-free signature for Exercise 2.5.5(a). -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d5_d5a__contract_type : Prop :=
  ∀ (lam : ℝ),
    (|lam| < (Real.sqrt 2)⁻¹ →
      Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1) ∧
        (∫ x : ℝ, Real.exp (lam ^ 2 * x ^ 2) ∂(gaussianReal 0 1)) =
          (Real.sqrt (1 - 2 * lam ^ 2))⁻¹) ∧
    ((Real.sqrt 2)⁻¹ ≤ |lam| →
      ¬ Integrable (fun x : ℝ => Real.exp (lam ^ 2 * x ^ 2)) (gaussianReal 0 1))

end NumStability.HDP.Contract
