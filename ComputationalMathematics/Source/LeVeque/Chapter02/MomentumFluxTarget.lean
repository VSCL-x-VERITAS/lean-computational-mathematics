/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumFluxModel

/-!
# Momentum flux formula

The product of momentum density and velocity supplies the convective part.
Adding pressure gives the source's displayed total momentum flux.
-/

namespace NumStability.Leveque02Tracer

/-- The fluid momentum flux is density times squared velocity, plus pressure. -/
def momentumFluxTarget : Prop :=
  ∀ (density velocity pressure : ℝ → ℝ → ℝ) (x t : ℝ),
    fluidMomentumFlux density velocity pressure x t =
      density x t * velocity x t ^ 2 + pressure x t

end NumStability.Leveque02Tracer
