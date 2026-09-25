/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# LeVeque Chapter 2, Equation (2.79): conservative variable-coefficient system

Proof-free statement of the spatially dependent linear flux and its classical
conservation equation.  The time and flux derivatives are actual derivatives
of the supplied state field.
-/

namespace NumStability.Leveque02Tracer

/-- A spatial matrix family supplies the flux `f(q,x) = A(x)q`; its classical
conservation equation is `qₜ + ∂ₓ(A(x)q) = 0` at each point. -/
def equation79ConservativeVariableLinearTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι]
      (coefficient : ℝ → Matrix ι ι ℝ),
    ∃ flux : ℝ → (ι → ℝ) → (ι → ℝ),
      (∀ x state, flux x state = (coefficient x).mulVec state) ∧
        ∀ (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ),
          (∃ timeDerivative fluxDerivative : ι → ℝ,
            HasDerivAt (fun τ => q x τ) timeDerivative t ∧
              HasDerivAt (fun ξ => flux ξ (q ξ t)) fluxDerivative x ∧
                timeDerivative + fluxDerivative = 0) ↔
            (∃ timeDerivative fluxDerivative : ι → ℝ,
              HasDerivAt (fun τ => q x τ) timeDerivative t ∧
                HasDerivAt
                    (fun ξ => (coefficient ξ).mulVec (q ξ t))
                    fluxDerivative x ∧
                  timeDerivative + fluxDerivative = 0)

end NumStability.Leveque02Tracer
