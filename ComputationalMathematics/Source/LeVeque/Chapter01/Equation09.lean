/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation08

/-!
# LeVeque Chapter 1, Equation (1.9)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25), equation (1.9).
-/

namespace NumStability

/-- Equation (1.9): the pointwise quasilinear residual
`q_t + f'(q) q_x = 0`. -/
abbrev leveque01_equation09_quasilinearAt
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (fluxDerivative :
      (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)))
    (x t : ℝ) : Prop :=
  IsQuasilinearConservationLawSolutionAt q fluxDerivative x t

/-- The spatial chain rule rewrites equation (1.8) as equation (1.9), under
explicit derivatives of the state slice and the flux at the current state. -/
theorem leveque01_equation09_quasilinearForm
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (fluxDerivative :
      (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)))
    (x t : ℝ) (qx : Fin m → ℝ)
    (hqx : HasDerivAt (fun ξ => q ξ t) qx x)
    (hflux : HasFDerivAt flux (fluxDerivative (q x t)) (q x t)) :
    leveque01_equation08_conservationLawAt q flux x t ↔
      leveque01_equation09_quasilinearAt q fluxDerivative x t :=
  conservationLaw_iff_quasilinearAt
    q flux fluxDerivative x t qx hqx hflux

end NumStability
