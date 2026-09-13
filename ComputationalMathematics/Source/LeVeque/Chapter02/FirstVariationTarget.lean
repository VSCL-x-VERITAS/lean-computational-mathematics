/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# The first-order flux and linearized conservation law

Actual amplitude derivatives identify the first-order state and flux. The
resulting linearized-flux equation uses the fixed background Jacobian.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.44) uses the first variation of the flux at the constant background. -/
def firstVariationTarget : Prop :=
  ∀ (m : ℕ) (admissibleStates : Set (Fin m → ℝ)) (background : admissibleStates)
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (perturbation : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ) (qx : Fin m → ℝ),
    HasFDerivAt flux derivative background →
    HasDerivAt (fun ξ => perturbation ξ t) qx x →
    (∀ direction : Fin m → ℝ,
      HasDerivAt (fun ε : ℝ => (background : Fin m → ℝ) + ε • direction) direction 0 ∧
      HasDerivAt (fun ε : ℝ => flux ((background : Fin m → ℝ) + ε • direction))
        (derivative direction) 0) ∧
    (IsConservationLawSolutionAt perturbation (fun state => derivative state) x t ↔
      ∃ qt : Fin m → ℝ, HasDerivAt (fun τ => perturbation x τ) qt t ∧
        qt + (LinearMap.toMatrix' derivative.toLinearMap).mulVec qx = 0)

end NumStability.Leveque02Tracer
