/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance

/-!
# Directional update errors from independent physical references

The physical references and numerical rules are independently supplied.
All admission, positive-step, domain and error hypotheses are explicit.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalFiniteVolume

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- Numerical old-average and physical face-flux errors control the actual
coordinate update. The independent reference is fixed before the conclusion. -/
theorem advance_error_le (cellVolume : Cell → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (d : D) (old : Cell → State) (mean : Cell → ℝ → State)
    (physical : Cell → ℝ → State) {s t : ℝ}
    (href : IsDirectionalReference cellVolume mean physical d s t)
    (hst : s < t) (cell : Cell) {oldBound leftBound rightBound : ℝ}
    (hold : ‖old cell - mean cell s‖ ≤ oldBound)
    (hleft : ‖CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell -
      faceAverage physical s t cell‖ ≤ leftBound)
    (hright : ‖CoordinateLineBalance.normalFaceFlux rule d (t - s) old
        (Function.update cell d (cell d + 1)) -
      faceAverage physical s t (Function.update cell d (cell d + 1))‖ ≤ rightBound) :
    ‖CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t‖ ≤
      oldBound + (t - s) / cellVolume cell * (leftBound + rightBound) := by
  have hp := reference_weighted_balance cellVolume mean physical d href hst cell
  have hnum := CoordinateLineBalance.advance_mass_balance cellVolume hvolume rule d (t - s) old cell
  have hbalance : cellVolume cell •
      (CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t) =
      cellVolume cell • (old cell - mean cell s) + (t - s) •
        ((CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell - faceAverage physical s t cell) -
         (CoordinateLineBalance.normalFaceFlux rule d (t - s) old (Function.update cell d (cell d + 1)) -
          faceAverage physical s t (Function.update cell d (cell d + 1)))) := by
    rw [smul_sub, hnum, hp]
    simp only [CoordinateLineBalance.netOutwardFlux]
    module
  have hn := congrArg norm hbalance
  have hineq : cellVolume cell *
      ‖CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t‖ ≤
      cellVolume cell * oldBound + (t - s) * (leftBound + rightBound) := by
    calc
      _ = ‖cellVolume cell •
        (CoordinateLineBalance.advance cellVolume rule d (t - s) old cell - mean cell t)‖ := by
          simp [norm_smul, abs_of_pos (hvolume cell)]
      _ = _ := hn
      _ ≤ ‖cellVolume cell • (old cell - mean cell s)‖ + ‖(t - s) •
        ((CoordinateLineBalance.normalFaceFlux rule d (t - s) old cell - faceAverage physical s t cell) -
         (CoordinateLineBalance.normalFaceFlux rule d (t - s) old (Function.update cell d (cell d + 1)) -
          faceAverage physical s t (Function.update cell d (cell d + 1))))‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos (hvolume cell), abs_of_pos (sub_pos.mpr hst)]
        exact add_le_add (mul_le_mul_of_nonneg_left hold (hvolume cell).le)
          (mul_le_mul_of_nonneg_left ((norm_sub_le _ _).trans (add_le_add hleft hright))
            (sub_nonneg.mpr hst.le))
  apply (mul_le_mul_iff_right₀ (hvolume cell)).mp
  calc
    _ ≤ _ := hineq
    _ = cellVolume cell * (oldBound + (t - s) / cellVolume cell * (leftBound + rightBound)) := by
      field_simp [(hvolume cell).ne']

end NumStability.DirectionalFiniteVolume
