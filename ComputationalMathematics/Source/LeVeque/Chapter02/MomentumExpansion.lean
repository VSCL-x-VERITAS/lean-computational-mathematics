/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumExpansionTarget
import Mathlib.Tactic.Ring

/-!
# Exact momentum expansion
-/

namespace NumStability.Leveque02Tracer

/-- Expanding `rho*u` around `(rho0,u0)` gives the four source terms exactly. -/
theorem momentumExpansion : momentumExpansionTarget := by
  intro densityBackground velocityBackground densityPerturbation velocityPerturbation
  ring

end NumStability.Leveque02Tracer
