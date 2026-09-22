/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulus
import ComputationalMathematics.Source.LeVeque.Chapter02.ConservedAcousticsComponents
import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedLinearAcousticsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumLinearization
import ComputationalMathematics.Source.LeVeque.Chapter02.PressureLinearization

/-!
# Convected linear acoustics in pressure--velocity variables
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.48): the conserved perturbation system becomes the convected
pressure--velocity acoustics system under the first-variation coordinates. -/
theorem convectedLinearAcoustics : convectedLinearAcousticsTarget := by
  intro pressureLaw densityBackground backgroundVelocity pressureSlope
    hdensity hpressure densityPerturbation momentumPerturbation x t hsystem
  have hcomponents :=
    (conservedAcousticsComponents pressureLaw densityBackground backgroundVelocity
      pressureSlope hdensity hpressure densityPerturbation momentumPerturbation x t).mp hsystem
  obtain ⟨densityTime, momentumTime, densitySpace, momentumSpace,
    hdensityTime, hmomentumTime, hdensitySpace, hmomentumSpace,
    hmass, hmomentum⟩ := hcomponents
  have hdensity_ne : densityBackground ≠ 0 := ne_of_gt hdensity
  have hpressureTime :
      HasDerivAt (fun τ => pressureSlope * densityPerturbation x τ)
        (pressureSlope * densityTime) t :=
    hdensityTime.const_mul pressureSlope
  have hpressureSpace :
      HasDerivAt (fun ξ => pressureSlope * densityPerturbation ξ t)
        (pressureSlope * densitySpace) x :=
    hdensitySpace.const_mul pressureSlope
  have hvelocityTime :
      HasDerivAt
        (fun τ => densityBackground⁻¹ *
          (momentumPerturbation x τ - backgroundVelocity * densityPerturbation x τ))
        (densityBackground⁻¹ * (momentumTime - backgroundVelocity * densityTime)) t := by
    simpa using
      (hmomentumTime.sub (hdensityTime.const_mul backgroundVelocity)).const_mul
        densityBackground⁻¹
  have hvelocitySpace :
      HasDerivAt
        (fun ξ => densityBackground⁻¹ *
          (momentumPerturbation ξ t - backgroundVelocity * densityPerturbation ξ t))
        (densityBackground⁻¹ * (momentumSpace - backgroundVelocity * densitySpace)) x := by
    simpa using
      (hmomentumSpace.sub (hdensitySpace.const_mul backgroundVelocity)).const_mul
        densityBackground⁻¹
  refine ⟨pressureSlope * densityTime, pressureSlope * densitySpace,
    densityBackground⁻¹ * (momentumTime - backgroundVelocity * densityTime),
    densityBackground⁻¹ * (momentumSpace - backgroundVelocity * densitySpace),
    hpressureTime, hpressureSpace, hvelocityTime, hvelocitySpace, ?_, ?_⟩
  · rw [bulkModulus pressureLaw densityBackground pressureSlope hdensity hpressure]
    field_simp [hdensity_ne]
    linear_combination pressureSlope * hmass
  · field_simp [hdensity_ne]
    linear_combination hmomentum - backgroundVelocity * hmass

end NumStability.Leveque02Tracer
