/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics

/-!
# LeVeque Chapter 2: ConstantAdvectionCharacteristicTarget

Target for constant-velocity characteristic propagation.
-/

namespace NumStability.Leveque02Tracer

/-- Any classical whole-line constant-advection solution is constant on each characteristic. -/
def constantAdvectionCharacteristicTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (velocity : ℝ),
    Differentiable ℝ (Function.uncurry q) →
    NumStability.IsLinearAdvectionSolution q velocity →
    ∀ origin time : ℝ,
      q (origin + velocity * time) time = q origin 0

end NumStability.Leveque02Tracer
