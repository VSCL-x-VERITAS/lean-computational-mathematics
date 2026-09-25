/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.FinitePipeCharacteristics

/-!
# Proof-free target for LeVeque Figure 2.1(b)

For negative constant speed, right-end data enter the pipe. The reflected
characteristic predicate states constancy along the corresponding physical
left-moving rays and leaves the omitted right-corner ray unconstrained.
-/

namespace NumStability.Leveque02Tracer

/-- Negative-speed advection selects the right-inflow or initial trace; no
left-outflow trace is required. -/
def finitePipeNegativeTarget : Prop :=
  ∀ (left right speed initialTime : ℝ)
    (field : ℝ → ℝ → ℝ) (initial rightInflow : ℝ → ℝ) (x time : ℝ),
    left < right → speed < 0 → left < x → x < right → initialTime ≤ time →
    IsPipeCharacteristicSolution (fun y s => field (-y) s)
      (-right) (-left) (-speed) initialTime →
    (∀ s, initialTime ≤ s → field right s = rightInflow s) →
    (∀ y, left < y → y < right → field y initialTime = initial y) →
    (right + speed * (time - initialTime) < x →
      field x time = rightInflow (time - (x - right) / speed)) ∧
    (x < right + speed * (time - initialTime) →
      field x time = initial (x - speed * (time - initialTime)))

end NumStability.Leveque02Tracer
