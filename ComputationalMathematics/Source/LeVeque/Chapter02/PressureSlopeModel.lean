/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Real.Basic

/-!
# Positive pressure slope as a model assumption

The physical assumption in (2.37) requires a strictly positive actual
derivative of the given pressure law at every positive density. This
predicate imposes that requirement on a chosen law; it does not assert it
for every real function.
-/

namespace NumStability.Leveque02Tracer

/-- Actual pressure derivatives are strictly positive at positive densities. -/
def positivePressureSlope (pressureLaw : ℝ → ℝ) : Prop :=
  ∀ density : ℝ, 0 < density →
    ∃ slope : ℝ, HasDerivAt pressureLaw slope density ∧ 0 < slope

end NumStability.Leveque02Tracer
