/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumFluxModel
import ComputationalMathematics.Source.LeVeque.Chapter02.CumulativeSectionConservationModel

/-!
# Integral momentum balance for one-dimensional fluid flow

The physical premise is a finite-time conservation balance: changes in section
momentum equal accumulated incoming minus outgoing total momentum flux. This is
independent of the displayed instantaneous derivative in LeVeque (2.33).
Continuity of that endpoint flux is included in the premise so the ordinary
time derivative exists.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Cumulative momentum conservation gives the actual section derivative with
the negative right-minus-left momentum-flux bracket of (2.33). -/
def momentumBalanceTarget : Prop :=
  ∀ (density velocity pressure : ℝ → ℝ → ℝ) (a b t : ℝ),
    IsCumulativeSectionConservation
      (fluidMomentumDensity density velocity)
      (fun τ => fluidMomentumFlux density velocity pressure a τ)
      (fun τ => fluidMomentumFlux density velocity pressure b τ) a b t →
    HasDerivAt (fun τ => fluidSectionMomentum density velocity a b τ)
      (-((density b t * velocity b t ^ 2 + pressure b t) -
        (density a t * velocity a t ^ 2 + pressure a t))) t

end NumStability.Leveque02Tracer
