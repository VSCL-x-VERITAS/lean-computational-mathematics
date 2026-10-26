/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.IntegerLocalNumericalFlux

/-!
# Centered scalar-advection finite-volume step
-/

namespace NumStability

/-- The actual centered finite-volume step for scalar advection, represented
in the unique component of a `Fin 1` state. -/
noncomputable def centeredScalarAdvectionStep
    (timeStep cellWidth speed : ℝ) (q : ℤ → ℝ) (i : ℤ) : ℝ :=
  conservativeFluxDifferenceUpdateInt (timeStep / cellWidth)
    (fun j (_ : Fin 1) => q j)
    (leveque04_localInterfaceFlux
      (leveque04_centeredFlux (fun state : Fin 1 → ℝ => speed • state))
      (fun j (_ : Fin 1) => q j)) i 0

end NumStability
