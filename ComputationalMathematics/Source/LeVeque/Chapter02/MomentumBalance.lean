/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumBalanceTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.IntegralMassBalanceCumulative

/-!
# LeVeque equation (2.33)

The existing finite-time conservation theorem applies to momentum density,
with its endpoint transport given by convective momentum plus pressure. The
momentum models then expose the source's signed bracket formula.
-/

namespace NumStability.Leveque02Tracer

/-- The instantaneous momentum law follows from finite-time section
conservation and continuous net endpoint momentum flux. -/
theorem momentumBalance : momentumBalanceTarget := by
  intro density velocity pressure a b t hconservation
  have hrate := integralMassBalance_fromCumulative
    (fluidMomentumDensity density velocity)
    (fun τ => fluidMomentumFlux density velocity pressure a τ)
    (fun τ => fluidMomentumFlux density velocity pressure b τ)
    a b t hconservation
  simpa only [fluidSectionMomentum, fluidMomentumFlux, fluidMomentumDensity,
    pow_two, mul_assoc, neg_sub] using hrate.2.2

end NumStability.Leveque02Tracer
