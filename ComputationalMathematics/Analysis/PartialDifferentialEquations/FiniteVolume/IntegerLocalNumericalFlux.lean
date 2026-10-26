/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Integer-adjacency numerical flux
-/

namespace NumStability

/-- The flux at the left edge of cell `i`, from the values in cells `i - 1`
and `i` at the preceding time level. -/
def leveque04_localInterfaceFlux {m : ℕ}
    (numericalFlux : (Fin m → ℝ) → (Fin m → ℝ) → (Fin m → ℝ))
    (cellAverage : ℤ → (Fin m → ℝ)) (i : ℤ) : Fin m → ℝ :=
  numericalFlux (cellAverage (i - 1)) (cellAverage i)

end NumStability
