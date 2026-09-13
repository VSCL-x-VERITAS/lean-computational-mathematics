/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Components of a vector conservation law

Each flux component is evaluated at the complete state vector. The vector
equation records precisely the actual scalar conservation laws of all components.
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.39) contains one classical conservation law per conserved component. -/
def systemComponentsTarget : Prop :=
  ∀ (m : ℕ) (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ),
    IsConservationLawSolutionAt q flux x t ↔
      ∀ i : Fin m, ∃ timeDerivative fluxDerivative : ℝ,
        HasDerivAt (fun τ => q x τ i) timeDerivative t ∧
        HasDerivAt (fun ξ => flux (q ξ t) i) fluxDerivative x ∧
        timeDerivative + fluxDerivative = 0

end NumStability.Leveque02Tracer
