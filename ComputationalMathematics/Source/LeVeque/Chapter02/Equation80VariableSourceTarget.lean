/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# LeVeque Chapter 2, Equation (2.80): variable linear source term

Proof-free statement of the product-rule rewrite of Equation (2.79).  Matrix
derivatives are specified entrywise and the state derivative is the actual
spatial derivative at the point.
-/

namespace NumStability.Leveque02Tracer

/-- For differentiable `A(x)` and `q(x,t)`, the conservative residual
`qₜ + ∂ₓ(A(x)q) = 0` is equivalent to
`qₜ + A(x)qₓ = -A'(x)q`. -/
def equation80VariableSourceTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι]
      (coefficient : ℝ → Matrix ι ι ℝ)
      (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ)
      (coefficientDerivative : Matrix ι ι ℝ) (spaceDerivative : ι → ℝ),
    (∀ i j, HasDerivAt (fun ξ => coefficient ξ i j)
      (coefficientDerivative i j) x) →
    HasDerivAt (fun ξ => q ξ t) spaceDerivative x →
      ((∃ timeDerivative fluxDerivative : ι → ℝ,
        HasDerivAt (fun τ => q x τ) timeDerivative t ∧
          HasDerivAt (fun ξ => (coefficient ξ).mulVec (q ξ t))
            fluxDerivative x ∧
            timeDerivative + fluxDerivative = 0) ↔
        (∃ timeDerivative : ι → ℝ,
          HasDerivAt (fun τ => q x τ) timeDerivative t ∧
            timeDerivative + (coefficient x).mulVec spaceDerivative =
              -(coefficientDerivative.mulVec (q x t))))

end NumStability.Leveque02Tracer
