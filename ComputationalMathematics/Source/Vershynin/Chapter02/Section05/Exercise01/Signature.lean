import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.MeasureTheory.Function.LpSeminorm.Defs

/-! Frozen proof-free signature for Exercise 2.5.1. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory

namespace NumStability.HDP.Contract

def hdp_02_hex_h2_d5_d1__contract_type : Prop :=
  ∀ (p : ℝ),
    1 ≤ p →
      (eLpNorm' (fun x : ℝ => x) p (gaussianReal 0 1)).toReal =
        (2 ^ (p / 2) * Real.Gamma ((1 + p) / 2) / Real.Gamma (1 / 2)) ^ (1 / p)

end NumStability.HDP.Contract
