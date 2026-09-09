import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineSweep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CartesianCoordinateUpdate
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxUpdateErrorBounds
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.Examples.LeftStateCoordinateSweep

/-! Scratch only. Prospective directional numerical-method correspondence.
The independent physical reference supplies initial averages and physical flux
integrals; no hypothesis states an error bound for the numerical output.
No high-resolution, convergence, or exact multidimensional evolution is claimed.
-/

open MeasureTheory
open scoped BigOperators

namespace NumStability.DirectionalMethodRepair

variable {D : Type*} [DecidableEq D] {m : ℕ}

local notation "Cell" => D → ℤ
local notation "State" => Fin m → ℝ

/-- Independent control-volume conservation for the directional problem.
`mean` and `physical` describe a supplied physical reference, not the numerical
update. The main contract below realizes them by cell and face integrals. -/
def IsDirectionalReference (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D) : Prop :=
  (∀ cell s t, IntervalIntegrable (physical cell) volume s t) ∧
  ∀ cell s t, cellVolume cell • (mean cell t - mean cell s) =
    ∫ τ in s..t, physical cell τ - physical (Function.update cell d (cell d + 1)) τ

noncomputable def faceAverage (physical : Cell → ℝ → State) (s t : ℝ) (cell : Cell) : State :=
  oneDimensionalCellAverage (physical cell) s t

theorem reference_weighted_balance (cellVolume : Cell → ℝ)
    (mean : Cell → ℝ → State) (physical : Cell → ℝ → State) (d : D)
    (h : IsDirectionalReference cellVolume mean physical d) {s t : ℝ} (hst : s < t) (cell : Cell) :
    cellVolume cell • mean cell t = cellVolume cell • mean cell s +
      (t - s) • (faceAverage physical s t cell -
        faceAverage physical s t (Function.update cell d (cell d + 1))) := by
  have hleft := cellWidth_smul_oneDimensionalCellAverage (physical cell) hst
  have hright := cellWidth_smul_oneDimensionalCellAverage
    (physical (Function.update cell d (cell d + 1))) hst
  have hb := h.2 cell s t
  rw [intervalIntegral.integral_sub (h.1 cell s t)
    (h.1 (Function.update cell d (cell d + 1)) s t)] at hb
  rw [smul_sub] at hb
  simpa only [faceAverage, smul_sub, hleft, hright] using eq_add_of_sub_eq hb

/-- Numerical old-average and physical face-flux errors control the actual
coordinate update. The independent reference is fixed before the conclusion. -/
theorem advance_error_le (cellVolume : Cell → ℝ) (hvolume : ∀ cell, 0 < cellVolume cell)
    (rule : D → Cell → ℝ → (ℤ → State) → State)
    (d : D) (old : Cell → State) (mean : Cell → ℝ → State)
    (physical : Cell → ℝ → State) (href : IsDirectionalReference cellVolume mean physical d)
    {s t : ℝ} (hst : s < t) (cell : Cell) {oldBound leftBound rightBound : ℝ}
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
      <;> ring

/-- A Cartesian directional reference is derived from a real rectangle PDE,
using actual axis-cell averages and area-weighted physical boundary fluxes. -/
theorem cartesian_reference [Fintype D] (axes : D → OneDimensionalFiniteVolumeGrid)
    (d : D) (law : OneDimensionalHyperbolicConservationLaw (Fin m))
    (q : ℝ → ℝ → State) (hq : IsRectangleConservationLawSolution q law.physicalFlux) :
    IsDirectionalReference (CartesianGrid.cellVolume axes)
      (fun cell t => finiteVolumeCellAverageOn (axes d) (fun x => q x t) (cell d))
      (fun cell t => CartesianGrid.faceArea axes d cell •
        law.physicalFlux (q ((axes d).cellLeft (cell d)) t)) d := by
  refine ⟨?_, ?_⟩
  · intro cell s t
    exact (hq.2.1 _ s t).smul _
  · intro cell s t
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

end NumStability.DirectionalMethodRepair
