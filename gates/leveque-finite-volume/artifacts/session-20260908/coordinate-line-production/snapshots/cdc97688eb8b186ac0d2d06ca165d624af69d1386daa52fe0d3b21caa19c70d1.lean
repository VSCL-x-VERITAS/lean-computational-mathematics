/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance

/-!
# Unequal-volume coordinate-line conservation example

Two cells with supplied volumes one and two exchange a nonzero interior flux.
Their averages change by different amounts while their weighted mass sum
is preserved. The example tests conservative algebra, without asserting a
physical normal-flux model or a Riemann-solver certificate.
-/

open scoped BigOperators

namespace NumStability.CoordinateLineBalance.Witness

/-- A supplied scalar cell volume that is one at index zero and two elsewhere. -/
def nonuniformVolume (cell : Unit → ℤ) : ℝ := if cell () = 0 then 1 else 2

/-- A single nonzero interior face flux, used to test weighted cancellation. -/
def interiorFlux (_d : Unit) (rightCell : Unit → ℤ) (_dt : ℝ) (_line : ℤ → ℝ) : ℝ :=
  if rightCell () = 1 then 1 else 0

/-- Both supplied volume values are strictly positive. -/
theorem nonuniformVolume_pos (cell : Unit → ℤ) : 0 < nonuniformVolume cell := by
  simp only [nonuniformVolume]
  split <;> norm_num

/-- Unequal positive volumes change the averages differently while conserving mass. -/
theorem unequal_volumes_nonzero_update :
    advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 0) = -1 ∧
    advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 1) = 1 / 2 ∧
    nonuniformVolume (fun _ => 0) •
        advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 0) +
      nonuniformVolume (fun _ => 1) •
        advance nonuniformVolume interiorFlux () 1 (fun _ => (0 : ℝ)) (fun _ => 1) = 0 := by
  norm_num [advance, finiteVolumeCellAverageUpdate, netOutwardFlux, normalFaceFlux,
    interiorFlux, nonuniformVolume]
  exact neg_add_cancel (1 : ℝ)

end NumStability.CoordinateLineBalance.Witness
