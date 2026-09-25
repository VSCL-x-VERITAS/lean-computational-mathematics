/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.FinitePipeCharacteristicPDE
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.FinitePipeCharacteristics

/-!
# Proof-free target for the positive-speed finite-pipe formula

The source's two strict regions correspond to characteristics first reaching
either the left inflow boundary or the initial-time line. The corner line is
outside the two printed cases.
-/

namespace NumStability.Leveque02Tracer

/-- Positive-speed advection on a finite pipe selects left-inflow or initial data. -/
def finitePipePositiveTarget : Prop :=
  ∀ (left right speed initialTime : ℝ)
    (field : ℝ → ℝ → ℝ) (initial inflow : ℝ → ℝ) (x time : ℝ),
    left < right → 0 < speed → left < x → x < right → initialTime ≤ time →
    (IsPipeCharacteristicSolution field left right speed initialTime ∨
      (ContinuousOn (Function.uncurry field)
        (Set.prod (Set.Icc left right) (Set.Ici initialTime)) ∧
      DifferentiableOn ℝ (Function.uncurry field)
        (Set.prod (Set.Ioo left right) (Set.Ioi initialTime)) ∧
      (∀ y r, left < y → y < right → initialTime < r →
        IsLinearAdvectionSolutionAt field speed y r))) →
    (∀ s, initialTime ≤ s → field left s = inflow s) →
    (∀ y, left < y → y < right → field y initialTime = initial y) →
    (x < left + speed * (time - initialTime) →
      field x time = inflow (time - (x - left) / speed)) ∧
    (left + speed * (time - initialTime) < x →
      field x time = initial (x - speed * (time - initialTime)))

end NumStability.Leveque02Tracer
