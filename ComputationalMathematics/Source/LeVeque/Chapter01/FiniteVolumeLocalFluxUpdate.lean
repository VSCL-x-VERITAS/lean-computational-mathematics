/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalCellErrorBounds

/-!
# Chapter 1: finite-volume accuracy from local conservation data

Under the recorded conditional accuracy interpretation, independent old-average
and physical face-flux error bounds imply the next-step bound. The inherited
integral law is used only on the selected cell and time slab. The two density slices and two physical face histories are explicitly those
of the supplied state and flux law. Their integrability and conservation balance
are required only on this cell and slab; no global solution extension is required.
The norm and bounds are explicit parameters, not quantitative data printed by
the source. Cell and face index types also allow bounded physical domains.
-/

open MeasureTheory

namespace NumStability

/-- Local normalized reference averages, numerical flux update, and conditional error control. -/
theorem leveque01_finiteVolumeLocalFluxUpdate_sourceContract {m : ℕ} (hm : 0 < m)
    {Cell Face : Type*}
    (q : ℝ → ℝ → (Fin m → ℝ)) (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (numericalOld : Cell → (Fin m → ℝ)) (rule : (Cell → (Fin m → ℝ)) → Face → (Fin m → ℝ))
    (cell : Cell) (leftFace rightFace : Face)
    {a b s t : ℝ} (hab : a < b) (hst : s < t)
    (holdDensity : IntervalIntegrable (fun x => q x s) volume a b)
    (hnewDensity : IntervalIntegrable (fun x => q x t) volume a b)
    (hleftFlux : IntervalIntegrable (fun τ => flux (q a τ)) volume s t)
    (hrightFlux : IntervalIntegrable (fun τ => flux (q b τ)) volume s t)
    (hphysicalBalance : (∫ x in a..b, (fun x => q x t) x) - (∫ x in a..b, (fun x => q x s) x) =
      ∫ τ in s..t, (flux (q a τ) - flux (q b τ))) :
    0 < m ∧
    IsOneDimensionalCellAverage (fun x => q x s) a b (oneDimensionalCellAverage (fun x => q x s) a b) ∧
    IsOneDimensionalCellAverage (fun x => q x t) a b (oneDimensionalCellAverage (fun x => q x t) a b) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q a τ)) s t
      (oneDimensionalCellAverage (fun τ => flux (q a τ)) s t) ∧
    IsOneDimensionalCellAverage (fun τ => flux (q b τ)) s t
      (oneDimensionalCellAverage (fun τ => flux (q b τ)) s t) ∧
    oneDimensionalCellAverage (fun x => q x s) a b =
      cellVolumeAverage volume (Set.Ioc a b) (fun x => q x s) ∧
    oneDimensionalCellAverage (fun τ => flux (q a τ)) s t =
      cellVolumeAverage volume (Set.Ioc s t) (fun τ => flux (q a τ)) ∧
    finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) =
      numericalOld cell - ((t - s) / (b - a)) •
        (rule numericalOld rightFace - rule numericalOld leftFace) ∧
    (b - a) • (finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
      (rule numericalOld rightFace - rule numericalOld leftFace) -
      oneDimensionalCellAverage (fun x => q x t) a b) =
      (b - a) • (numericalOld cell - oneDimensionalCellAverage (fun x => q x s) a b) +
        (t - s) • ((rule numericalOld leftFace - oneDimensionalCellAverage (fun τ => flux (q a τ)) s t) -
          (rule numericalOld rightFace - oneDimensionalCellAverage (fun τ => flux (q b τ)) s t)) ∧
    ∀ oldBound leftBound rightBound : ℝ,
      ‖numericalOld cell - oneDimensionalCellAverage (fun x => q x s) a b‖ ≤ oldBound →
      ‖rule numericalOld leftFace - oneDimensionalCellAverage (fun τ => flux (q a τ)) s t‖ ≤ leftBound →
      ‖rule numericalOld rightFace - oneDimensionalCellAverage (fun τ => flux (q b τ)) s t‖ ≤ rightBound →
      ‖finiteVolumeCellAverageUpdate (t - s) (b - a) (numericalOld cell)
        (rule numericalOld rightFace - rule numericalOld leftFace) -
        oneDimensionalCellAverage (fun x => q x t) a b‖ ≤
        oldBound + (t - s) / (b - a) * (leftBound + rightBound) := by
  exact ⟨hm, finiteVolumeLocalCell_error_contract (fun x => q x s) (fun x => q x t)
    (fun side τ => if side then flux (q b τ) else flux (q a τ)) numericalOld
    (fun values side => if side then rule values rightFace else rule values leftFace)
    cell false true hab hst holdDensity hnewDensity hleftFlux hrightFlux hphysicalBalance⟩

end NumStability
