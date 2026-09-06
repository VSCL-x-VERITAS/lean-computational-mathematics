/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# LeVeque Chapter 1, finite-volume cell averages

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27).  A finite-volume unknown is the integral of
the state over a grid cell divided by the cell volume, rather than a pointwise
state value.
-/

namespace NumStability

/-- LeVeque's one-dimensional finite-volume cell average for an `m`-component
state. -/
noncomputable abbrev leveque01_finiteVolumeCellAverage {m : ℕ}
    (state : ℝ → (Fin m → ℝ)) (left right : ℝ) : Fin m → ℝ :=
  oneDimensionalCellAverage state left right

/-- The Chapter 1 cell-average definition, with the nondegenerate-cell and
Bochner-integrability assumptions made explicit. -/
theorem leveque01_finiteVolumeCellAverage_spec {m : ℕ}
    (state : ℝ → (Fin m → ℝ)) {left right : ℝ}
    (hcell : left < right)
    (hstate : IntervalIntegrable state MeasureTheory.volume left right) :
    IsOneDimensionalCellAverage state left right
      (leveque01_finiteVolumeCellAverage state left right) :=
  oneDimensionalCellAverage_isCellAverage state hcell hstate

end NumStability
