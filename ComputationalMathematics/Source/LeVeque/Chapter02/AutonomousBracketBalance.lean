/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AutonomousBracketBalanceTarget

/-!
# LeVeque equation (2.7)

The endpoint bracket is an algebraic rewriting of the autonomous integral
conservation law (2.6). This theorem does not supply that law independently.
-/

namespace NumStability.Leveque02Tracer

/-- Rewrite the mass derivative using the signed endpoint bracket of (2.7). -/
theorem autonomousBracketBalance : autonomousBracketBalanceTarget := by
  intro q flux a b t _hab
  simp only [neg_sub]

end NumStability.Leveque02Tracer
