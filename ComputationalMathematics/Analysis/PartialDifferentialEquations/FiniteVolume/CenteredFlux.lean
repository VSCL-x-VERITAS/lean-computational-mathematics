/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Algebra.Defs
import Mathlib.Algebra.Module.Pi
import Mathlib.Data.Real.Basic

/-!
# Centered numerical flux

The arithmetic mean of a physical flux on two finite-dimensional real states.
The established public NumStability declaration name is preserved.
-/

namespace NumStability

/-- The arithmetic mean of the physical flux on the left and right states. -/
noncomputable def leveque04_centeredFlux {m : ℕ}
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (left right : Fin m → ℝ) : Fin m → ℝ :=
  (1 / 2 : ℝ) • (physicalFlux left + physicalFlux right)

end NumStability
