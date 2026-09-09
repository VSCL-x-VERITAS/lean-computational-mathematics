/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.DirectionalReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Cartesian realization of directional references

The physical references and numerical rules are independently supplied.
All admission, positive-step, domain and error hypotheses are explicit.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalFiniteVolume

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- A Cartesian directional reference is derived from a real rectangle PDE,
using actual axis-cell averages and area-weighted physical boundary fluxes. -/
theorem cartesian_reference [Fintype D] (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (flux : State → State)
    (q : ℝ → ℝ → State) (hq : IsRectangleConservationLawSolution q flux) (s t : ℝ) :
    IsDirectionalReference (CartesianGrid.cellVolume axes)
      (fun cell t => finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cell d))
      (fun cell t => CartesianGrid.faceArea axes d cell •
        flux (q ((axes d).cellLeft (cell d)) t)) d s t := by
  refine ⟨?_, ?_⟩
  · intro cell
    exact (hq.2.1 _ s t).smul (CartesianGrid.faceArea axes d cell)
  · intro cell
    have hb := hq.2.2 ((axes d).cellLeft (cell d)) ((axes d).cellRight (cell d)) s t
    have hs := cellWidth_smul_oneDimensionalCellAverage
      (fun x => q x s) ((axes d).cell_nonempty (cell d))
    have ht := cellWidth_smul_oneDimensionalCellAverage
      (fun x => q x t) ((axes d).cell_nonempty (cell d))
    rw [CartesianGrid.cellVolume_eq_width_mul_area axes d cell]
    rw [mul_comm, mul_smul, smul_sub]
    simp only [finiteVolumeCellAverageOn, OneDimensionalFiniteVolumeGrid.cellVolume] at *
    rw [hs, ht, hb]
    simp only [Function.update_self, CartesianGrid.faceArea_update]
    rw [← (axes d).adjacent (cell d + 1)]
    simp only [add_sub_cancel_right]
    rw [← intervalIntegral.integral_smul]
    congr 1
    funext τ
    rw [smul_sub]

end NumStability.DirectionalFiniteVolume
