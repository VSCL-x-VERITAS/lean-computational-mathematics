/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LocalMomentumEquationTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.SpaceTimeFlux

/-!
# LeVeque equation (2.34)

The reusable scalar field-flux localization theorem applies to physical
momentum density and to its pressure-inclusive flux. The hypotheses keep the
integral balance on every subinterval, as needed to infer a local PDE.
-/

namespace NumStability.Leveque02Tracer

/-- The smooth local momentum equation follows from interval conservation. -/
theorem localMomentumEquation : localMomentumEquationTarget := by
  intro density velocity pressure momentumTime fluxDerivative L R c d t
    hLR ht hc hct hdt hdx hcx hbalance
  exact NumStability.local_scalarConservation_of_sectionBalance
    (fluidMomentumDensity density velocity) momentumTime
    (fluidMomentumFlux density velocity pressure) fluxDerivative
    L R c d t hLR ht hc hct hdt hdx hcx hbalance

end NumStability.Leveque02Tracer
