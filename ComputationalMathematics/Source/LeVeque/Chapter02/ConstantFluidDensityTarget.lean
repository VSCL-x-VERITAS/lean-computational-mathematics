/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics

/-!
# Fluid density at a prescribed constant velocity

The mass flux is density times the common velocity, giving the same classical
advection equation as for the earlier tracer. Translated differentiable
profiles satisfy that equation and retain their initial values under the
spatial shift; jointly differentiable solutions are exactly the translation
of their initial density.
-/

namespace NumStability.Leveque02Tracer

/-- Constant fluid velocity gives the advection equation and translated profiles. -/
def constantFluidDensityTarget : Prop :=
  (∀ (density : ℝ → ℝ → ℝ) (velocity x t densityX : ℝ),
    HasDerivAt (fun z => density z t) densityX x →
    ((∃ densityT massFluxX : ℝ,
      HasDerivAt (fun τ => density x τ) densityT t ∧
      HasDerivAt (fun z => velocity * density z t) massFluxX x ∧
      densityT + massFluxX = 0) ↔
      IsLinearAdvectionSolutionAt density velocity x t)) ∧
  (∀ (initialDensity : ℝ → ℝ) (profileDerivative velocity x t : ℝ),
    HasDerivAt initialDensity profileDerivative (x - velocity * t) →
    IsLinearAdvectionSolutionAt (travelingWave initialDensity velocity) velocity x t ∧
    travelingWave initialDensity velocity x 0 = initialDensity x ∧
    travelingWave initialDensity velocity (x + velocity * t) t = initialDensity x) ∧
  (∀ (density : ℝ → ℝ → ℝ) (velocity : ℝ),
    Differentiable ℝ (Function.uncurry density) →
    IsLinearAdvectionSolution density velocity →
    density = travelingWave (fun x => density x 0) velocity)

end NumStability.Leveque02Tracer
