/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainPressureModel
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
# The isentropic real-power pressure law

The law is evaluated on positive densities. Its two coefficients are supplied
constants; this definition makes no separate slope-positivity assertion.
-/

namespace NumStability.Leveque02Tracer

/-- The isentropic law on its positive-density domain, with the given constants. -/
noncomputable def isentropicPressureLaw (coefficient exponent : ℝ)
    (density : Set.Ioi (0 : ℝ)) : ℝ :=
  coefficient * (density : ℝ) ^ exponent

end NumStability.Leveque02Tracer
