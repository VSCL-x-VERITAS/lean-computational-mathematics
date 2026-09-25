/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# Spatially variable linear fluxes

The derivative of a matrix-valued coefficient times a vector-valued state is
computed componentwise. This keeps the coefficient derivative explicit and
does not require a choice of a matrix norm.
-/

namespace NumStability

/-- The spatial derivative of a variable matrix applied to a differentiable
state is the matrix product rule. -/
theorem hasDerivAt_variableLinearFlux_comp
    {ι : Type*} [Fintype ι]
    (coefficient : ℝ → Matrix ι ι ℝ) (state : ℝ → (ι → ℝ))
    (coefficientDerivative : Matrix ι ι ℝ) (stateDerivative : ι → ℝ)
    (x : ℝ)
    (hcoefficient : ∀ i j,
      HasDerivAt (fun ξ => coefficient ξ i j) (coefficientDerivative i j) x)
    (hstate : HasDerivAt state stateDerivative x) :
    HasDerivAt (fun ξ => (coefficient ξ).mulVec (state ξ))
      (coefficientDerivative.mulVec (state x) +
        (coefficient x).mulVec stateDerivative) x := by
  apply (hasDerivAt_pi).2
  intro i
  have hcoefficientEntry (j : ι) :
      HasDerivAt (fun ξ => coefficient ξ i j) (coefficientDerivative i j) x :=
    hcoefficient i j
  have hstateEntry (j : ι) :
      HasDerivAt (fun ξ => state ξ j) (stateDerivative j) x :=
    (hasDerivAt_pi.mp hstate) j
  simpa only [Matrix.mulVec, dotProduct, Pi.add_apply, Finset.sum_add_distrib]
    using HasDerivAt.fun_sum (fun j _ => (hcoefficientEntry j).mul (hstateEntry j))

end NumStability
