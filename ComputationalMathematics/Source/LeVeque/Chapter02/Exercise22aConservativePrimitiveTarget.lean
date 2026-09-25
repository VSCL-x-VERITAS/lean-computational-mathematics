/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Exercise 2.2(a): conservative to primitive gas equations

This proof-free target covers the first derivation in the exercise at one
space-time point. The pressure law's local inverse is used only to express
the resulting coefficient through pressure; forward differentiation does not
require an inverse derivative.
-/

namespace NumStability.Leveque02Tracer

/-- Smooth conservative mass and momentum balances imply the nonlinear
pressure-velocity equations (2.122) on the positive-density state domain. -/
def exercise22aConservativePrimitiveTarget : Prop :=
  ∀ (density velocity : ℝ → ℝ → ℝ)
    (pressureLaw densityFromPressure : ℝ → ℝ)
    (x t densityTime densitySpace velocityTime velocitySpace
      momentumTime massFluxSpace momentumFluxSpace pressureSlope : ℝ),
    0 < density x t →
    densityFromPressure (pressureLaw (density x t)) = density x t →
    HasDerivAt pressureLaw pressureSlope (density x t) →
    HasDerivAt (density x) densityTime t →
    HasDerivAt (fun ξ => density ξ t) densitySpace x →
    HasDerivAt (velocity x) velocityTime t →
    HasDerivAt (fun ξ => velocity ξ t) velocitySpace x →
    HasDerivAt (fun τ => density x τ * velocity x τ) momentumTime t →
    HasDerivAt (fun ξ => density ξ t * velocity ξ t) massFluxSpace x →
    HasDerivAt
      (fun ξ => density ξ t * velocity ξ t ^ 2 +
        pressureLaw (density ξ t)) momentumFluxSpace x →
    densityTime + massFluxSpace = 0 →
    momentumTime + momentumFluxSpace = 0 →
      let pressure : ℝ → ℝ → ℝ :=
        fun ξ τ => pressureLaw (density ξ τ)
      HasDerivAt (pressure x) (pressureSlope * densityTime) t ∧
      HasDerivAt (fun ξ => pressure ξ t) (pressureSlope * densitySpace) x ∧
      pressureSlope * densityTime + velocity x t *
        (pressureSlope * densitySpace) +
        densityFromPressure (pressure x t) * pressureSlope * velocitySpace = 0 ∧
      velocityTime +
        (densityFromPressure (pressure x t))⁻¹ *
          (pressureSlope * densitySpace) +
        velocity x t * velocitySpace = 0

end NumStability.Leveque02Tracer
