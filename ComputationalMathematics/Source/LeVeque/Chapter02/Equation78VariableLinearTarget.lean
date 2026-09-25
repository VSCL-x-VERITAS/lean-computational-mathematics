/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FirstOrderEquation

/-!
# LeVeque Chapter 2, Equation (2.78): variable-coefficient linear system

Proof-free representation of the equation form with a spatially varying
principal matrix and no source term.
-/

namespace NumStability.Leveque02Tracer

/-- The generic variable-linear equation has exactly the classical solutions of
`q_t + A(x) q_x = 0`, with actual time and space derivatives. -/
def equation78VariableLinearTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι]
      (coefficient : ℝ → Matrix ι ι ℝ)
      (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ),
    (FirstOrderEquation.variableLinear coefficient).IsClassicalSolutionAt q x t ↔
      ∃ timeDerivative spaceDerivative : ι → ℝ,
        HasDerivAt (fun τ => q x τ) timeDerivative t ∧
          HasDerivAt (fun ξ => q ξ t) spaceDerivative x ∧
            timeDerivative + (coefficient x).mulVec spaceDerivative = 0

end NumStability.Leveque02Tracer
