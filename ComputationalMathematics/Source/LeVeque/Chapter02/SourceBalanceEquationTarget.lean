/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw

/-!
# Conservation laws with a source term

Proof-free target for equation (2.28). The reusable balance-law predicate binds
the actual time and spatial flux derivatives to the production field. This
target follows the displayed differential equation independently of the
conflicting sign in the preceding printed integral display.
-/

namespace NumStability.Leveque02Tracer

/-- The balance-law predicate is characterized by the source equation (2.28). -/
def sourceBalanceEquationTarget : Prop :=
  ∀ {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (sourceDensity : (Fin m → ℝ) → ℝ → ℝ → (Fin m → ℝ))
    (qt fluxDerivative : Fin m → ℝ) (x t : ℝ),
    HasDerivAt (fun τ => q x τ) qt t →
    HasDerivAt (fun ξ => flux (q ξ t)) fluxDerivative x →
    (NumStability.IsBalanceLawSolutionAt q flux (sourceDensity (q x t) x t) x t ↔
      qt + fluxDerivative = sourceDensity (q x t) x t)

end NumStability.Leveque02Tracer
