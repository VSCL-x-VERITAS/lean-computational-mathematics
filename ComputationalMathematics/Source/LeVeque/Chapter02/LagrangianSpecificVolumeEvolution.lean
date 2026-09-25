/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianSpecificVolumeEvolutionTarget

/-!
# LeVeque equation (2.104): evolution of specific volume
-/

namespace NumStability.Leveque02Tracer

/-- The interval identity differentiated in time, followed by the spatial
fundamental theorem of calculus for Lagrangian velocity. -/
theorem lagrangianSpecificVolumeEvolution : lagrangianSpecificVolumeEvolutionTarget := by
  intro initialDensity referenceLocation particlePosition eulerianVelocity eulerianDensity
    leftLabel rightLabel time _ _ _ _ _ _ hneighborhood hleft hright hspace hint
  have hmass :
      HasDerivAt
        (fun τ => ∫ label in leftLabel..rightLabel,
          lagrangianSpecificVolume eulerianDensity particlePosition label τ)
        (lagrangianParticleVelocity eulerianVelocity particlePosition rightLabel time -
          lagrangianParticleVelocity eulerianVelocity particlePosition leftLabel time)
        time :=
    (hright.sub hleft).congr_of_eventuallyEq hneighborhood
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hspace hint
  exact ⟨hmass, hmass.deriv, hFTC.symm⟩

end NumStability.Leveque02Tracer
