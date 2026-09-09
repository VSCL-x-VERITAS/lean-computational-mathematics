/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellVolumeAverage
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance

/-!
# Local finite-volume reference balances and error bounds

Two integrable density slices and two integrable physical boundary-flux histories
on one cell and time slab supply the reference balance. A numerical rule may
read the complete old cell array. No global solution extension or pointwise
boundary representative is required by this local estimate.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Independent input error bounds control a positive weighted error balance. -/
theorem norm_le_of_weighted_error_balance
    {width dt oldBound leftBound rightBound : ℝ} (hw : 0 < width) (hdt : 0 ≤ dt)
    {nextError oldError leftError rightError : E}
    (hbalance : width • nextError = width • oldError + dt • (leftError - rightError))
    (hold : ‖oldError‖ ≤ oldBound) (hleft : ‖leftError‖ ≤ leftBound)
    (hright : ‖rightError‖ ≤ rightBound) :
    ‖nextError‖ ≤ oldBound + dt / width * (leftBound + rightBound) := by
  have hnorm : width * ‖nextError‖ ≤
      width * ‖oldError‖ + dt * (‖leftError‖ + ‖rightError‖) := by
    calc
      _ = ‖width • nextError‖ := by simp [norm_smul, abs_of_pos hw]
      _ = ‖width • oldError + dt • (leftError - rightError)‖ := congrArg norm hbalance
      _ ≤ ‖width • oldError‖ + ‖dt • (leftError - rightError)‖ := norm_add_le _ _
      _ ≤ _ := by
        simp only [norm_smul, Real.norm_eq_abs, abs_of_pos hw, abs_of_nonneg hdt]
        exact add_le_add le_rfl (mul_le_mul_of_nonneg_left (norm_sub_le leftError rightError) hdt)
  apply (mul_le_mul_iff_right₀ hw).mp
  calc
    width * ‖nextError‖ ≤ width * oldBound + dt * (leftBound + rightBound) :=
      hnorm.trans (add_le_add (mul_le_mul_of_nonneg_left hold hw.le)
        (mul_le_mul_of_nonneg_left (add_le_add hleft hright) hdt))
    _ = width * (oldBound + dt / width * (leftBound + rightBound)) := by field_simp

/-- Only the selected cell's two density slices and the selected time slab's
two physical face histories enter the reference law. No global solution,
global grid, derivative, or equality to arbitrary pointwise representatives is assumed.
Shared face IDs can be reused for neighboring cells and for boundary data. -/
theorem finiteVolumeLocalCell_error_contract {Cell Face : Type*}
    (oldDensity newDensity : ℝ → E) (physicalFlux : Face → ℝ → E)
    (numericalOld : Cell → E) (rule : (Cell → E) → Face → E)
    (cell : Cell) (leftFace rightFace : Face)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (holdDensity : IntervalIntegrable oldDensity volume a b)
    (hnewDensity : IntervalIntegrable newDensity volume a b)
    (hleftFlux : IntervalIntegrable (physicalFlux leftFace) volume s t)
    (hrightFlux : IntervalIntegrable (physicalFlux rightFace) volume s t)
    (hphysicalBalance : (∫ x in a..b, newDensity x) - (∫ x in a..b, oldDensity x) =
      ∫ τ in s..t, (physicalFlux leftFace τ - physicalFlux rightFace τ)) :
    IsOneDimensionalCellAverage oldDensity a b (oneDimensionalCellAverage oldDensity a b) ∧
    IsOneDimensionalCellAverage newDensity a b (oneDimensionalCellAverage newDensity a b) ∧
    IsOneDimensionalCellAverage (physicalFlux leftFace) s t
      (oneDimensionalCellAverage (physicalFlux leftFace) s t) ∧
    IsOneDimensionalCellAverage (physicalFlux rightFace) s t
      (oneDimensionalCellAverage (physicalFlux rightFace) s t) ∧
    oneDimensionalCellAverage oldDensity a b =
      cellVolumeAverage volume (Set.Ioc a b) oldDensity ∧
    oneDimensionalCellAverage (physicalFlux leftFace) s t =
      cellVolumeAverage volume (Set.Ioc s t) (physicalFlux leftFace) ∧
    finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) =
      numericalOld cell - ((t - s) / (b - a)) •
        (rule numericalOld rightFace - rule numericalOld leftFace) ∧
    (b - a) • (finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) -
      oneDimensionalCellAverage newDensity a b) =
      (b - a) • (numericalOld cell - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t) -
          (rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t)) ∧
    ∀ oldBound leftBound rightBound : ℝ,
      ‖numericalOld cell - oneDimensionalCellAverage oldDensity a b‖ ≤ oldBound →
      ‖rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t‖ ≤ leftBound →
      ‖rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t‖ ≤ rightBound →
      ‖finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
        (rule numericalOld rightFace - rule numericalOld leftFace) -
        oneDimensionalCellAverage newDensity a b‖ ≤
        oldBound + (t - s) / (b - a) * (leftBound + rightBound) := by
  have href : (b - a) • oneDimensionalCellAverage newDensity a b -
      (b - a) • oneDimensionalCellAverage oldDensity a b =
      (t - s) • (oneDimensionalCellAverage (physicalFlux leftFace) s t -
        oneDimensionalCellAverage (physicalFlux rightFace) s t) := by
    rw [cellWidth_smul_oneDimensionalCellAverage _ hab,
      cellWidth_smul_oneDimensionalCellAverage _ hab, smul_sub,
      cellWidth_smul_oneDimensionalCellAverage _ hst,
      cellWidth_smul_oneDimensionalCellAverage _ hst,
      ← intervalIntegral.integral_sub hleftFlux hrightFlux]
    exact hphysicalBalance
  have herror : (b - a) • (finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) -
      oneDimensionalCellAverage newDensity a b) =
      (b - a) • (numericalOld cell - oneDimensionalCellAverage oldDensity a b) +
        (t - s) • ((rule numericalOld leftFace - oneDimensionalCellAverage (physicalFlux leftFace) s t) -
          (rule numericalOld rightFace - oneDimensionalCellAverage (physicalFlux rightFace) s t)) := by
    rw [smul_sub, cellVolume_smul_finiteVolumeCellAverageUpdate _ _ _ _
      (ne_of_gt (sub_pos.mpr hab)), eq_add_of_sub_eq href]
    module
  refine ⟨oneDimensionalCellAverage_isCellAverage _ hab holdDensity,
    oneDimensionalCellAverage_isCellAverage _ hab hnewDensity,
    oneDimensionalCellAverage_isCellAverage _ hst hleftFlux,
    oneDimensionalCellAverage_isCellAverage _ hst hrightFlux,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hab).symm,
    (cellVolumeAverage_Ioc_eq_oneDimensionalCellAverage _ hst).symm, rfl, herror, ?_⟩
  intro oldBound leftBound rightBound hold hleft hright
  exact norm_le_of_weighted_error_balance (sub_pos.mpr hab) (sub_nonneg.mpr hst.le)
    herror hold hleft hright

end NumStability
