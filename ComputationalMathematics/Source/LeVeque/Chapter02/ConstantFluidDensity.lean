/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConstantFluidDensityTarget

/-!
# Fluid density at a prescribed constant velocity

The constant mass-flux balance is the scalar advection equation. Differentiable
initial densities generate translated solutions, and every jointly
differentiable global solution is determined by its time-zero profile.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.31) and the translation of initial density at constant speed. -/
theorem constantFluidDensity : constantFluidDensityTarget := by
  constructor
  · intro density velocity x t densityX hspace
    constructor
    · rintro ⟨densityT, massFluxX, htime, hflux, hbalance⟩
      refine ⟨densityT, densityX, htime, hspace, ?_⟩
      have hscaled : HasDerivAt (fun z => velocity * density z t)
          (velocity * densityX) x := hspace.const_mul velocity
      have hvalue : velocity * densityX = massFluxX := hscaled.unique hflux
      simpa [smul_eq_mul, hvalue] using hbalance
    · rintro ⟨densityT, densityX', htime, hspace', hbalance⟩
      have hvalue : densityX' = densityX := hspace'.unique hspace
      subst densityX'
      refine ⟨densityT, velocity * densityX, htime, hspace.const_mul velocity, ?_⟩
      simpa [smul_eq_mul] using hbalance
  · constructor
    · intro initialDensity profileDerivative velocity x t hprofile
      exact ⟨travelingWave_isLinearAdvectionSolutionAt velocity x t hprofile,
        travelingWave_zero initialDensity velocity x,
        travelingWave_at_translated_point initialDensity velocity x t⟩
    · intro density velocity hdifferentiable hsolution
      exact linearAdvection_eq_travelingWave_of_differentiable hdifferentiable hsolution

end NumStability.Leveque02Tracer
