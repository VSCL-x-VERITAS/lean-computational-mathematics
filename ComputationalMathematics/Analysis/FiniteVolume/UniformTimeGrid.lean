/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Constant-step time coordinates

The construction starts at zero and is indexed by all natural numbers.
Positivity of the step is a separate input when increasing time coordinates
are required.
-/

namespace NumStability.FiniteVolume

/-- The time at level `n` for a constant real step `k`, starting at zero. -/
noncomputable def uniformTimeGrid (k : ℝ) (n : ℕ) : ℝ :=
  (n : ℝ) * k

end NumStability.FiniteVolume
