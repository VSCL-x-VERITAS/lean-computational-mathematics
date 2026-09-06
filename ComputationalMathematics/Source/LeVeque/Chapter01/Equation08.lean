/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw

/-!
# LeVeque Chapter 1, Equation (1.8)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25), equation (1.8).
-/

namespace NumStability

/-- Equation (1.8): the pointwise classical conservation law
`q_t(x,t) + f(q(x,t))_x = 0`. -/
abbrev leveque01_equation08_conservationLawAt
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ) : Prop :=
  IsConservationLawSolutionAt q flux x t

/-- Equation (1.8), expanded into its time, flux-space, and zero-residual
clauses. -/
theorem leveque01_equation08_conservationLawAt_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ)) (x t : ℝ) :
    leveque01_equation08_conservationLawAt q flux x t ↔
      ∃ qt fluxx : Fin m → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
          HasDerivAt (fun ξ => flux (q ξ t)) fluxx x ∧
            qt + fluxx = 0 :=
  Iff.rfl

end NumStability
