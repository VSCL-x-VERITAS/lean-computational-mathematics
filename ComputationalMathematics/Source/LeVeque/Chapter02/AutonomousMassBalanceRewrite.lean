/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AutonomousMassBalanceRewriteTarget

/-!
# LeVeque equation (2.6)

The inherited section-mass balance is rewritten using the autonomous flux at
the two endpoints. The target is independent of the chosen realization of
section mass and of the temporal derivative domain.
-/

namespace NumStability.Leveque02Tracer

/-- Autonomous endpoint substitution rewrites the derivative value in the
section-mass conservation balance. -/
theorem autonomousMassBalanceRewrite : autonomousMassBalanceRewriteTarget := by
  intro q flux leftFlux rightFlux mass a b t timeDomain _hab _ht hleft hright
  rw [hleft, hright]

end NumStability.Leveque02Tracer
