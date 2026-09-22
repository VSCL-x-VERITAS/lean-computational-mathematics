/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ConservedAcousticsComponentsTarget

/-!
# Convected linear acoustics in pressure--velocity variables
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.48) follows from the conserved perturbation system after the
accepted pressure and momentum first-variation change of variables. -/
def convectedLinearAcousticsTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground backgroundVelocity pressureSlope : ℝ),
    0 < densityBackground → HasDerivAt pressureLaw pressureSlope densityBackground →
    ∀ (densityPerturbation momentumPerturbation : ℝ → ℝ → ℝ) (x t : ℝ),
      IsConstantCoefficientLinearSystemSolutionAt
        (fun ξ τ => ![densityPerturbation ξ τ, momentumPerturbation ξ τ])
        !![0, 1; -backgroundVelocity ^ 2 + pressureSlope, 2 * backgroundVelocity] x t →
      IsConvectedLinearAcousticsSolutionAt
        (fun ξ τ => pressureSlope * densityPerturbation ξ τ)
        (fun ξ τ => densityBackground⁻¹ *
          (momentumPerturbation ξ τ - backgroundVelocity * densityPerturbation ξ τ))
        (acousticBulkModulus pressureLaw densityBackground)
        densityBackground backgroundVelocity x t

end NumStability.Leveque02Tracer
