/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReferenceLocationModel

/-!
# Planar material displacement

The current position is compared with the same material point's reference
position. The coordinate fields may depend on time.
-/

namespace NumStability.Leveque02Tracer

/-- Displacement from a planar reference location to the current location. -/
noncomputable def materialDisplacement
    (X Y : ℝ → ℝ → ℝ → ℝ) (x y t : ℝ) : ℝ × ℝ :=
  currentMaterialLocation X Y x y t - (x, y)

end NumStability.Leveque02Tracer
