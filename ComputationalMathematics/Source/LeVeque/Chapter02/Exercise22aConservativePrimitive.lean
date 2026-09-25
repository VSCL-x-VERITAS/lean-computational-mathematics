/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise22aConservativePrimitiveTarget
import Mathlib.Tactic

/-!
# Conservative gas equations in pressure-velocity variables
-/

namespace NumStability.Leveque02Tracer

/-- The classical mass and momentum balances give both primitive equations
by product and chain rules at a positive-density state. -/
theorem exercise22aConservativePrimitive :
    exercise22aConservativePrimitiveTarget := by
  intro density velocity pressureLaw densityFromPressure
    x t densityTime densitySpace velocityTime velocitySpace
    momentumTime massFluxSpace momentumFluxSpace pressureSlope
    hpositive hinverse hP hρt hρx hut hux hmt hmx hfx hmass hmomentum
  have hpressureTime :
      HasDerivAt
        (fun τ => pressureLaw (density x τ))
        (pressureSlope * densityTime) t := by
    simpa using hP.comp t hρt
  have hpressureSpace :
      HasDerivAt
        (fun ξ => pressureLaw (density ξ t))
        (pressureSlope * densitySpace) x := by
    simpa using hP.comp x hρx
  have hmassFlux :
      massFluxSpace =
        densitySpace * velocity x t + density x t * velocitySpace := by
    exact hmx.unique (by simpa using hρx.mul hux)
  have hmomentumTime :
      momentumTime =
        densityTime * velocity x t + density x t * velocityTime := by
    exact hmt.unique (by simpa using hρt.mul hut)
  have hmomentumFlux :
      momentumFluxSpace =
        densitySpace * velocity x t ^ 2 +
          density x t * (2 * velocity x t * velocitySpace) +
          pressureSlope * densitySpace := by
    have hcalc := (hρx.mul (hux.pow 2)).add (hP.comp x hρx)
    have h := hfx.unique (by simpa using hcalc)
    exact h
  have hmass' :
      densityTime + densitySpace * velocity x t +
        density x t * velocitySpace = 0 := by
    rw [hmassFlux] at hmass
    linear_combination hmass
  have hmomentum' :
      densityTime * velocity x t + density x t * velocityTime +
        densitySpace * velocity x t ^ 2 +
        density x t * (2 * velocity x t * velocitySpace) +
        pressureSlope * densitySpace = 0 := by
    rw [hmomentumTime, hmomentumFlux] at hmomentum
    linear_combination hmomentum
  dsimp
  refine ⟨hpressureTime, hpressureSpace, ?_, ?_⟩
  · rw [hinverse]
    linear_combination pressureSlope * hmass'
  · rw [hinverse]
    field_simp [ne_of_gt hpositive]
    linear_combination hmomentum' - velocity x t * hmass'

end NumStability.Leveque02Tracer
