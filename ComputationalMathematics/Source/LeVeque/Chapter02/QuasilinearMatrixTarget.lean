/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# The quasilinear Jacobian form

The matrix is the standard-coordinate matrix of the actual flux derivative.
The state derivative is also actual, so the matrix product denotes precisely
the spatial derivative supplied by the chain rule.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.41) uses the actual flux Jacobian in standard coordinates. -/
def quasilinearMatrixTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (x t : ℝ) (qx : Fin m → ℝ),
    HasDerivAt (fun ξ => q ξ t) qx x →
    HasFDerivAt flux derivative (q x t) →
    (IsConservationLawSolutionAt q flux x t ↔
      ∃ qt : Fin m → ℝ, HasDerivAt (fun τ => q x τ) qt t ∧
        qt + (LinearMap.toMatrix' derivative.toLinearMap).mulVec qx = 0)

end NumStability.Leveque02Tracer
