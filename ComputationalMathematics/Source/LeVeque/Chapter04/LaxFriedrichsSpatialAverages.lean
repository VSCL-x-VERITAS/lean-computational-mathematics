/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageNeighborTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsExactSolution

/-!
# Exact neighboring scalar cell averages

The neighboring averages of a smooth exact scalar solution have the
Taylor expansions used in the nonlinear Lax–Friedrichs local residual.
-/

namespace NumStability

/-- Smoothness of the exact spatial profile supplies both neighboring
exact-cell-average Taylor bounds at a fixed time. -/
theorem leveque04_scalarExactCellAverage_neighborTaylor
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (profileDeriv : ℝ → ℝ) (K center width time : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time 0) (profileDeriv x) x)
    (hLip : ∀ x y,
      |profileDeriv x - profileDeriv y| ≤ K * |x - y|) :
    let avg : ℝ → ℝ := fun c =>
      (oneDimensionalCellAverage (fun x => q x time)
        (c - width / 2) (c + width / 2)) 0
    let slope := (q (center + width / 2) time 0 -
      q (center - width / 2) time 0) / width
    |avg (center - width) - (avg center - width * slope)| ≤
        K * width ^ 2 ∧
      |avg (center + width) - (avg center + width * slope)| ≤
        K * width ^ 2 := by
  have hscalar := oneDimensionalCellAverage_neighborTaylor
    (fun x => q x time 0) profileDeriv K center width
    hK hwidth hprofile hLip
  have hcoord (c : ℝ) :
      (oneDimensionalCellAverage (fun x => q x time)
        (c - width / 2) (c + width / 2)) 0 =
      oneDimensionalCellAverage (fun x => q x time 0)
        (c - width / 2) (c + width / 2) := by
    exact oneDimensionalCellAverage_apply (fun x => q x time)
      (c - width / 2) (c + width / 2)
      (hq.1 _ _ time) 0
  change
    |(oneDimensionalCellAverage (fun x => q x time)
        (center - width - width / 2)
        (center - width + width / 2)) 0 -
      ((oneDimensionalCellAverage (fun x => q x time)
        (center - width / 2) (center + width / 2)) 0 -
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤
        K * width ^ 2 ∧
      |(oneDimensionalCellAverage (fun x => q x time)
        (center + width - width / 2)
        (center + width + width / 2)) 0 -
      ((oneDimensionalCellAverage (fun x => q x time)
        (center - width / 2) (center + width / 2)) 0 +
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤
        K * width ^ 2
  rw [hcoord (center - width), hcoord center, hcoord (center + width)]
  exact hscalar

end NumStability
