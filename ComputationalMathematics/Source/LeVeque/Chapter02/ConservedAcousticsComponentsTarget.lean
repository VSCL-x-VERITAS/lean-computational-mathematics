/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Conserved components of linear acoustics

The actual constant-matrix system expands into density and momentum equations.
The pressure coefficient is linked to its derivative at the background.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.47) expands the actual constant-matrix system in density/momentum coordinates. -/
def conservedAcousticsComponentsTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground backgroundVelocity pressureSlope : ℝ),
    densityBackground ≠ 0 → HasDerivAt pressureLaw pressureSlope densityBackground →
    ∀ (densityPerturbation momentumPerturbation : ℝ → ℝ → ℝ) (x t : ℝ),
    IsConstantCoefficientLinearSystemSolutionAt
      (fun ξ τ => ![densityPerturbation ξ τ, momentumPerturbation ξ τ])
      !![0, 1; -backgroundVelocity ^ 2 + pressureSlope, 2 * backgroundVelocity] x t ↔
    ∃ densityTime momentumTime densitySpace momentumSpace : ℝ,
      HasDerivAt (densityPerturbation x) densityTime t ∧
      HasDerivAt (momentumPerturbation x) momentumTime t ∧
      HasDerivAt (fun ξ => densityPerturbation ξ t) densitySpace x ∧
      HasDerivAt (fun ξ => momentumPerturbation ξ t) momentumSpace x ∧
      densityTime + momentumSpace = 0 ∧
      momentumTime + (-backgroundVelocity ^ 2 + pressureSlope) * densitySpace +
        2 * backgroundVelocity * momentumSpace = 0

end NumStability.Leveque02Tracer
