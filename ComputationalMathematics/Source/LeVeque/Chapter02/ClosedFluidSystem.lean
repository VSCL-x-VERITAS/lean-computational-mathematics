/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ClosedFluidSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MassFluxContinuity
import ComputationalMathematics.Source.LeVeque.Chapter02.LocalMomentumEquation

/-!
# LeVeque equation (2.38)

Apply the two already proved local conservation laws to the same density and
velocity, with the momentum pressure supplied by the equation of state.
-/

namespace NumStability.Leveque02Tracer

/-- Smooth section balances give both equations of the closed fluid system. -/
theorem closedFluidSystem : closedFluidSystemTarget := by
  intro density velocity pressureLaw densityTime massFluxSpace momentumTime
    momentumFluxSpace L R c d t hLR ht hdc hdct hddt hdm hcm hbm
    hmc hmct hmdt hdf hcf hbf x hx
  have hmass := massFluxContinuity density velocity densityTime
    (fun x => massFluxSpace x t) L R c d t hLR ht hdc hdct hddt hdm hcm hbm
  have hmomentum := localMomentumEquation density velocity
    (barotropicPressure pressureLaw density) momentumTime
    (fun x => momentumFluxSpace x t) L R c d t
    hLR ht hmc hmct hmdt hdf hcf hbf
  refine ⟨hddt t ht x hx, hdm x hx, hmass x hx, ?_, ?_, hmomentum x hx⟩
  · simpa only [fluidMomentumDensity] using hmdt t ht x hx
  · simpa only [fluidMomentumFlux, fluidMomentumDensity, barotropicPressure,
      pow_two, mul_assoc] using hdf x hx

end NumStability.Leveque02Tracer
