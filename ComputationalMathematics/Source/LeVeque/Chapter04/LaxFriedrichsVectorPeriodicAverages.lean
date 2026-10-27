/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAveragePeriodic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PeriodicGridSamples

/-!
# Exact coupled-vector cell averages at a periodic seam

The generic periodic cell-average and grid-sampling results identify the
two wrapped neighbors of a coupled-vector exact state with their adjacent
unwrapped real-line cells.
-/

namespace NumStability

/-- Exact vector cell averages sampled at canonical representatives of a
finite periodic grid. -/
noncomputable def leveque04_periodicVectorExactCellAverage
    {m : ℕ} (n : ℕ) (q : ℝ → ℝ → Fin m → ℝ)
    (width time : ℝ) (i : ZMod n) : Fin m → ℝ :=
  periodicGridSample n
    (fun j => oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)) i

/-- Spatial periodicity repeats the vector exact cell averages after
`n` cell widths. -/
theorem leveque04_vectorExactCellAverage_natPeriod
    {m : ℕ} (n : ℕ) (q : ℝ → ℝ → Fin m → ℝ)
    (width time : ℝ)
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time = q x time)
    (j : ℕ) :
    oneDimensionalCellAverage (fun x => q x time)
      (((j + n : ℕ) : ℝ) * width - width / 2)
      (((j + n : ℕ) : ℝ) * width + width / 2) =
    oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2) := by
  have hl : (((j + n : ℕ) : ℝ) * width - width / 2) =
      ((j : ℝ) * width - width / 2) + (n : ℝ) * width := by
    push_cast
    ring
  have hr : (((j + n : ℕ) : ℝ) * width + width / 2) =
      ((j : ℝ) * width + width / 2) + (n : ℝ) * width := by
    push_cast
    ring
  rw [hl, hr]
  exact oneDimensionalCellAverage_periodic_add
    (fun x => q x time)
    ((j : ℝ) * width - width / 2)
    ((j : ℝ) * width + width / 2)
    ((n : ℝ) * width) hperiod

/-- The wrapped right vector neighbor equals the next unwrapped exact
cell average. -/
theorem leveque04_periodicVectorExactCellAverage_right
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin m → ℝ) (width time : ℝ)
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time = q x time)
    (i : ZMod n) :
    leveque04_periodicVectorExactCellAverage n q width time (i + 1) =
      oneDimensionalCellAverage (fun x => q x time)
        (((i.val + 1 : ℕ) : ℝ) * width - width / 2)
        (((i.val + 1 : ℕ) : ℝ) * width + width / 2) := by
  exact periodicGridSample_add_one n hn
    (fun j => oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2))
    (leveque04_vectorExactCellAverage_natPeriod n q width time hperiod) i

/-- The wrapped left vector neighbor equals the preceding unwrapped exact
cell average, including at the periodic seam. -/
theorem leveque04_periodicVectorExactCellAverage_left
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin m → ℝ) (width time : ℝ)
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time = q x time)
    (i : ZMod n) :
    leveque04_periodicVectorExactCellAverage n q width time (i - 1) =
      oneDimensionalCellAverage (fun x => q x time)
        ((i.val : ℝ) * width - width - width / 2)
        ((i.val : ℝ) * width - width + width / 2) := by
  by_cases hi : 0 < i.val
  · have h := periodicGridSample_sub_one_of_pos n hn
      (fun j => oneDimensionalCellAverage (fun x => q x time)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)) i hi
    have hle : 1 ≤ i.val := by omega
    have hcast : (((i.val - 1 : ℕ) : ℝ) * width) =
        (i.val : ℝ) * width - width := by
      rw [Nat.cast_sub hle]
      push_cast
      ring
    change leveque04_periodicVectorExactCellAverage n q width time (i - 1) = _
    rw [show leveque04_periodicVectorExactCellAverage n q width time (i - 1) =
        oneDimensionalCellAverage (fun x => q x time)
          (((i.val - 1 : ℕ) : ℝ) * width - width / 2)
          (((i.val - 1 : ℕ) : ℝ) * width + width / 2) from h]
    rw [hcast]
  · have hi0 : i.val = 0 := by omega
    have h := periodicGridSample_sub_one_of_zero n hn
      (fun j => oneDimensionalCellAverage (fun x => q x time)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)) i hi0
    have hle : 1 ≤ n := by omega
    have hcast : (((n - 1 : ℕ) : ℝ) * width) =
        -width + (n : ℝ) * width := by
      rw [Nat.cast_sub hle]
      push_cast
      ring
    have hshift := oneDimensionalCellAverage_periodic_add
      (fun x => q x time)
      (-width - width / 2) (-width + width / 2)
      ((n : ℝ) * width) hperiod
    change leveque04_periodicVectorExactCellAverage n q width time (i - 1) = _
    rw [show leveque04_periodicVectorExactCellAverage n q width time (i - 1) =
        oneDimensionalCellAverage (fun x => q x time)
          (((n - 1 : ℕ) : ℝ) * width - width / 2)
          (((n - 1 : ℕ) : ℝ) * width + width / 2) from h]
    rw [hcast]
    have hl : -width + (n : ℝ) * width - width / 2 =
        -width - width / 2 + (n : ℝ) * width := by ring
    have hr : -width + (n : ℝ) * width + width / 2 =
        -width + width / 2 + (n : ℝ) * width := by ring
    rw [hl, hr, hshift, hi0]
    simp

end NumStability
