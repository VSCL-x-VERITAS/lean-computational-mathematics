/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation01
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation08

/-!
# LeVeque Chapter 1: constant linear flux specialization

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26), first paragraph: equation (1.1) is a
conservation law with the linear flux `f(q) = A q`.
-/

namespace NumStability

/-- Every pointwise solution of equation (1.1) is a solution of equation
(1.8) with the linear flux `f(q) = A q`. -/
theorem leveque01_equation01_isLinearFluxConservationLaw
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ)
    (hsystem : leveque01_equation01_constantLinearSystemAt
      q coefficient x t) :
    leveque01_equation08_conservationLawAt q
      (constantLinearFlux coefficient) x t :=
  constantCoefficientLinearSystem_isConservationLaw
    q coefficient x t hsystem

/-- If the state itself has a spatial derivative, equation (1.8) with
`f(q) = A q` and equation (1.1) are equivalent pointwise. -/
theorem leveque01_linearFlux_specializesEquation01
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ)
    (qx : Fin m → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x) :
    leveque01_equation08_conservationLawAt q
        (constantLinearFlux coefficient) x t ↔
      leveque01_equation01_constantLinearSystemAt q coefficient x t :=
  conservationLaw_constantLinearFlux_iff
    q coefficient x t qx hqx

end NumStability
