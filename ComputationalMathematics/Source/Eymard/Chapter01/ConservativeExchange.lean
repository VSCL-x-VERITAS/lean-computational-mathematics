/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01.ConservativeExchangeTarget

/-!
# Conservative Exchange

Ordered-pair incidence gives exactly the source's numerical-exchange
antisymmetry condition, at every natural time level and every cell pair.

This module contains an accepted Chapter 1 proof wrapper.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Ordered-pair incidence gives exactly the source's numerical-exchange
antisymmetry condition, at every natural time level and every cell pair. -/
theorem conservativeExchange : conservativeExchangeTarget := by
  intro Cell Value _inst exchange
  constructor
  · intro h n K L
    exact h n (K, L)
  · intro h n pair
    exact h n pair.1 pair.2

end NumStability.Eymard.Chapter01
