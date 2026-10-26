/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Finset.Lattice.Fold
import Mathlib.Data.Fintype.Fin
import Mathlib.Data.Real.Basic

/-!
# Finite-system Courant number

The maximum absolute speed of supplied nonempty finite data, its bound, and
the signed time-step/cell-width scaling. Existing public names and unrestricted
real inputs, total division, and the NeZero instance telescope are retained.
-/

namespace NumStability

/-- The maximum absolute characteristic speed of a nonempty finite system. -/
noncomputable def leveque04_maxCharacteristicSpeed
    {m : ℕ} [NeZero m] (speed : Fin m → ℝ) : ℝ :=
  Finset.univ.sup' (by exact ⟨0, Finset.mem_univ (0 : Fin m)⟩)
    (fun p => |speed p|)

/-- Every characteristic speed is bounded by the finite maximum. -/
theorem leveque04_characteristicSpeed_le_max
    {m : ℕ} [NeZero m] (speed : Fin m → ℝ) (p : Fin m) :
    |speed p| ≤ leveque04_maxCharacteristicSpeed speed := by
  unfold leveque04_maxCharacteristicSpeed
  exact Finset.le_sup' (fun k => |speed k|) (Finset.mem_univ p)

/-- The Courant number (4.17) for a hyperbolic system, using the greatest
absolute characteristic speed. -/
noncomputable def leveque04_systemCourantNumber
    {m : ℕ} [NeZero m] (timeStep cellWidth : ℝ) (speed : Fin m → ℝ) : ℝ :=
  timeStep / cellWidth * leveque04_maxCharacteristicSpeed speed

end NumStability
