/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableLinearFlux
import ComputationalMathematics.Source.LeVeque.Chapter02.Equation80VariableSourceTarget

/-!
# LeVeque Chapter 2, Equation (2.80): variable linear source term
-/

namespace NumStability.Leveque02Tracer

/-- The product rule rewrites the conservative variable-coefficient equation
with the source term `-A'(x)q`. -/
theorem equation80VariableSource : equation80VariableSourceTarget := by
  intro ι _ coefficient q x t coefficientDerivative spaceDerivative
    hcoefficient hspace
  have hflux := hasDerivAt_variableLinearFlux_comp
    coefficient (fun ξ => q ξ t) coefficientDerivative spaceDerivative
    x hcoefficient hspace
  constructor
  · rintro ⟨timeDerivative, fluxDerivative, htime, hfluxDerivative, hresidual⟩
    have hunique : fluxDerivative =
        coefficientDerivative.mulVec (q x t) +
          (coefficient x).mulVec spaceDerivative :=
      hfluxDerivative.unique hflux
    subst fluxDerivative
    refine ⟨timeDerivative, htime, ?_⟩
    have hzero :
        (timeDerivative + (coefficient x).mulVec spaceDerivative) +
          coefficientDerivative.mulVec (q x t) = 0 := by
      calc
        _ = timeDerivative +
            (coefficientDerivative.mulVec (q x t) +
              (coefficient x).mulVec spaceDerivative) := by abel
        _ = 0 := hresidual
    exact eq_neg_of_add_eq_zero_left hzero
  · rintro ⟨timeDerivative, htime, hsource⟩
    refine ⟨timeDerivative,
      coefficientDerivative.mulVec (q x t) +
        (coefficient x).mulVec spaceDerivative,
      htime, hflux, ?_⟩
    have hzero :
        (timeDerivative + (coefficient x).mulVec spaceDerivative) +
          coefficientDerivative.mulVec (q x t) = 0 := by
      rw [hsource]
      exact neg_add_cancel _
    calc
      timeDerivative +
          (coefficientDerivative.mulVec (q x t) +
            (coefficient x).mulVec spaceDerivative) =
        (timeDerivative + (coefficient x).mulVec spaceDerivative) +
          coefficientDerivative.mulVec (q x t) := by abel
      _ = 0 := hzero

end NumStability.Leveque02Tracer
