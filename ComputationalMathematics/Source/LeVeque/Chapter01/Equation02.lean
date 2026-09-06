/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation01

/-!
# LeVeque Chapter 1, Equation (1.2)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equations (1.1)-(1.2). Equation (1.2) is the
one-dimensional specialization of the constant-coefficient system (1.1).
-/

namespace NumStability

/-- Equation (1.2): scalar constant-speed linear advection at `(x, t)`. -/
abbrev leveque01_equation02_scalarAdvectionAt
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) : Prop :=
  IsLinearAdvectionSolutionAt q speed x t

/-- Equation (1.2) is exactly equation (1.1) for a one-component state and the
one-by-one coefficient matrix `[speed]`. -/
theorem leveque01_equation02_isOneDimensionalSpecialization
    (q : ℝ → ℝ → ℝ) (speed x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt
        (scalarAsOneComponentSystem q)
        (constantCoefficientScalarMatrix speed) x t ↔
      leveque01_equation02_scalarAdvectionAt q speed x t := by
  constructor
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨qt 0, qx 0, ?_, ?_, ?_⟩
    · simpa [scalarAsOneComponentSystem] using (hasDerivAt_pi.mp ht 0)
    · simpa [scalarAsOneComponentSystem] using (hasDerivAt_pi.mp hx 0)
    · have hcomponent := congrFun hresidual (0 : Fin 1)
      simpa [constantCoefficientScalarMatrix, Matrix.mulVec,
        dotProduct] using hcomponent
  · rintro ⟨qt, qx, ht, hx, hresidual⟩
    refine ⟨fun _ => qt, fun _ => qx, ?_, ?_, ?_⟩
    · rw [hasDerivAt_pi]
      intro i
      simpa [scalarAsOneComponentSystem] using ht
    · rw [hasDerivAt_pi]
      intro i
      simpa [scalarAsOneComponentSystem] using hx
    · funext i
      simpa [constantCoefficientScalarMatrix, Matrix.mulVec,
        dotProduct] using hresidual

end NumStability
