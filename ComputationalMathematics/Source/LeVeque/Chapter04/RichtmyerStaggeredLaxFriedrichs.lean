/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerPredictor
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: the Richtmyer predictor as a staggered LF step

The half-time interface predictor is exactly the Lax–Friedrichs update
on the grid with both time and cell spacing halved, using the two old
states on either side of the staggered interface.
-/

namespace NumStability

/-- The predictor (4.23) is the Lax–Friedrichs update (4.20) on the
staggered half grid, at the interface between cells `-1` and `1`. -/
theorem leveque04_richtmyerPredictor_eq_staggeredLaxFriedrichs
    {m : ℕ} (timeStep cellWidth : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < cellWidth)
    (physicalFlux : (Fin m → ℝ) → (Fin m → ℝ))
    (old : ℤ → (Fin m → ℝ)) :
    leveque04_richtmyerPredictor timeStep cellWidth physicalFlux
        (old (-1)) (old 1) =
      leveque04_finiteVolumeUpdate (timeStep / 2) (cellWidth / 2) old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (timeStep / 2) (cellWidth / 2)
            physicalFlux) old) 0 := by
  have htime2 : 0 < timeStep / 2 := by positivity
  have hwidth2 : 0 < cellWidth / 2 := by positivity
  ext k
  rw [leveque04_equation23, leveque04_equation20
    (timeStep / 2) (cellWidth / 2) physicalFlux old 0 k
    htime2 hwidth2]
  simp only [Int.zero_sub]
  ring_nf

end NumStability
