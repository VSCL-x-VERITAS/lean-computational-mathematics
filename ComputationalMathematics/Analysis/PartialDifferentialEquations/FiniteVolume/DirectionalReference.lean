/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates

/-!
# Independent finite-volume directional references

The physical references and numerical rules are independently supplied.
All admission, positive-step, domain and error hypotheses are explicit.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalFiniteVolume

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- Independent control-volume conservation for the directional problem.
`mean` and `physical` describe a supplied physical reference, not the numerical
update. The main contract below realizes them by cell and face integrals. -/
def IsDirectionalReference (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D) (s t : ℝ) : Prop :=
  (∀ cell, IntervalIntegrable (physical cell) volume s t) ∧
  ∀ cell, cellVolume cell • (mean cell t - mean cell s) =
    ∫ τ in s..t, physical cell τ - physical (Function.update cell d (cell d + 1)) τ

/-- Time average over `[s, t]` of the supplied physical face reference `physical cell`, namely
`(t - s)⁻¹ • ∫ τ in s..t, physical cell τ`. Faces are indexed by the cell they belong to, so
`reference_weighted_balance` restates the conservation law of `IsDirectionalReference` as the
`(t - s)`-weighted difference of these averages at `cell` and at its neighbour in direction `d`. -/
noncomputable def faceAverage (physical : Cell → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  oneDimensionalCellAverage (physical cell) s t

theorem reference_weighted_balance (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D)
    {s t : ℝ} (h : IsDirectionalReference cellVolume mean physical d s t) (hst : s < t) (cell : Cell) :
    cellVolume cell • mean cell t = cellVolume cell • mean cell s +
      (t - s) • (faceAverage physical s t cell -
        faceAverage physical s t (Function.update cell d (cell d + 1))) := by
  have hleft := cellWidth_smul_oneDimensionalCellAverage (physical cell) hst
  have hright := cellWidth_smul_oneDimensionalCellAverage
    (physical (Function.update cell d (cell d + 1))) hst
  have hb := h.2 cell
  rw [intervalIntegral.integral_sub (h.1 cell)
    (h.1 (Function.update cell d (cell d + 1)))] at hb
  rw [smul_sub] at hb
  simpa only [faceAverage, smul_sub, hleft, hright] using (eq_add_of_sub_eq hb).trans (add_comm _ _)

end NumStability.DirectionalFiniteVolume
