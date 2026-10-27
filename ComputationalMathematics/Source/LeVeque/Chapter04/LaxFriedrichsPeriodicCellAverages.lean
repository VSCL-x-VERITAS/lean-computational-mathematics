/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAveragePeriodic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PeriodicGridSamples
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSpatialAverages

/-!
# Exact scalar cell averages across a periodic grid seam

The exact cell average at a wrapped neighbor agrees with the average
on its translated real-line cell when the scalar solution is periodic.
-/

namespace NumStability

/-- The scalar component of an exact periodic solution has equal cell
averages one spatial period apart. -/
theorem leveque04_scalarExactCellAverage_periodic_add
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (left right period time : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + period) time 0 = q x time 0) :
    (oneDimensionalCellAverage (fun x => q x time)
      (left + period) (right + period)) 0 =
    (oneDimensionalCellAverage (fun x => q x time)
      left right) 0 := by
  rw [oneDimensionalCellAverage_apply (fun x => q x time)
      (left + period) (right + period) (hq.1 _ _ time) 0,
    oneDimensionalCellAverage_apply (fun x => q x time)
      left right (hq.1 _ _ time) 0]
  exact oneDimensionalCellAverage_periodic_add
    (fun x => q x time 0) left right period hperiod

/-- The same equality for a cell shifted backward by one period. -/
theorem leveque04_scalarExactCellAverage_periodic_sub
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (left right period time : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + period) time 0 = q x time 0) :
    (oneDimensionalCellAverage (fun x => q x time)
      (left - period) (right - period)) 0 =
    (oneDimensionalCellAverage (fun x => q x time)
      left right) 0 := by
  rw [oneDimensionalCellAverage_apply (fun x => q x time)
      (left - period) (right - period) (hq.1 _ _ time) 0,
    oneDimensionalCellAverage_apply (fun x => q x time)
      left right (hq.1 _ _ time) 0]
  exact oneDimensionalCellAverage_periodic_shift
    (fun x => q x time 0) left right period hperiod

/-- Exact scalar cell averages sampled at the representatives of a
finite periodic grid. -/
noncomputable def leveque04_periodicScalarExactCellAverage
    (n : ℕ) (q : ℝ → ℝ → Fin 1 → ℝ)
    (width time : ℝ) (i : ZMod n) : ℝ :=
  periodicGridSample n
    (fun j => (oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)) 0) i

/-- The real-line sequence of exact cell averages repeats after `n`
cells when the solution has period `n * width`. -/
theorem leveque04_scalarExactCellAverage_natPeriod
    (n : ℕ) (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (width time : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time 0 = q x time 0)
    (j : ℕ) :
    (oneDimensionalCellAverage (fun x => q x time)
      (((j + n : ℕ) : ℝ) * width - width / 2)
      (((j + n : ℕ) : ℝ) * width + width / 2)) 0 =
    (oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)) 0 := by
  have hl : (((j + n : ℕ) : ℝ) * width - width / 2) =
      ((j : ℝ) * width - width / 2) + (n : ℝ) * width := by
    push_cast
    ring
  have hr : (((j + n : ℕ) : ℝ) * width + width / 2) =
      ((j : ℝ) * width + width / 2) + (n : ℝ) * width := by
    push_cast
    ring
  rw [hl, hr]
  exact leveque04_scalarExactCellAverage_periodic_add q flux
    ((j : ℝ) * width - width / 2)
    ((j : ℝ) * width + width / 2)
    ((n : ℝ) * width) time hq hperiod

/-- The periodic right neighbor is the unwrapped next exact cell average. -/
theorem leveque04_periodicScalarExactCellAverage_right
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (width time : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time 0 = q x time 0)
    (i : ZMod n) :
    leveque04_periodicScalarExactCellAverage n q width time (i + 1) =
      (oneDimensionalCellAverage (fun x => q x time)
        (((i.val + 1 : ℕ) : ℝ) * width - width / 2)
        (((i.val + 1 : ℕ) : ℝ) * width + width / 2)) 0 := by
  exact periodicGridSample_add_one n hn
    (fun j => (oneDimensionalCellAverage (fun x => q x time)
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2)) 0)
    (fun j => leveque04_scalarExactCellAverage_natPeriod n q flux
      width time hq hperiod j) i

/-- The periodic left neighbor is the unwrapped preceding exact cell
average, including at the seam. -/
theorem leveque04_periodicScalarExactCellAverage_left
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (width time : ℝ)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time 0 = q x time 0)
    (i : ZMod n) :
    leveque04_periodicScalarExactCellAverage n q width time (i - 1) =
      (oneDimensionalCellAverage (fun x => q x time)
        ((i.val : ℝ) * width - width - width / 2)
        ((i.val : ℝ) * width - width + width / 2)) 0 := by
  by_cases hi : 0 < i.val
  · have h := periodicGridSample_sub_one_of_pos n hn
      (fun j => (oneDimensionalCellAverage (fun x => q x time)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)) 0) i hi
    have hle : 1 ≤ i.val := by omega
    have hcast : (((i.val - 1 : ℕ) : ℝ) * width) =
        (i.val : ℝ) * width - width := by
      rw [Nat.cast_sub hle]
      push_cast
      ring
    change leveque04_periodicScalarExactCellAverage n q width time (i - 1) = _
    rw [show leveque04_periodicScalarExactCellAverage n q width time (i - 1) =
        (oneDimensionalCellAverage (fun x => q x time)
          (((i.val - 1 : ℕ) : ℝ) * width - width / 2)
          (((i.val - 1 : ℕ) : ℝ) * width + width / 2)) 0 from h]
    rw [hcast]
  · have hi0 : i.val = 0 := by omega
    have h := periodicGridSample_sub_one_of_zero n hn
      (fun j => (oneDimensionalCellAverage (fun x => q x time)
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2)) 0) i hi0
    have hle : 1 ≤ n := by omega
    have hcast : (((n - 1 : ℕ) : ℝ) * width) =
        -width + (n : ℝ) * width := by
      rw [Nat.cast_sub hle]
      push_cast
      ring
    have hshift := leveque04_scalarExactCellAverage_periodic_add
      q flux (-width - width / 2) (-width + width / 2)
      ((n : ℝ) * width) time hq hperiod
    change leveque04_periodicScalarExactCellAverage n q width time (i - 1) = _
    rw [show leveque04_periodicScalarExactCellAverage n q width time (i - 1) =
        (oneDimensionalCellAverage (fun x => q x time)
          (((n - 1 : ℕ) : ℝ) * width - width / 2)
          (((n - 1 : ℕ) : ℝ) * width + width / 2)) 0 from h]
    rw [hcast]
    have hl : -width + (n : ℝ) * width - width / 2 =
        -width - width / 2 + (n : ℝ) * width := by ring
    have hr : -width + (n : ℝ) * width + width / 2 =
        -width + width / 2 + (n : ℝ) * width := by ring
    rw [hl, hr, hshift, hi0]
    simp

/-- Smooth periodic exact cell averages satisfy the neighbor Taylor
bounds required by the nonlinear Lax–Friedrichs residual at every cell. -/
theorem leveque04_periodicScalarExactCellAverage_neighborTaylor
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux : ℝ → ℝ)
    (profileDeriv : ℝ → ℝ) (K width time : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time 0 = q x time 0)
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time 0) (profileDeriv x) x)
    (hLip : ∀ x y,
      |profileDeriv x - profileDeriv y| ≤ K * |x - y|)
    (i : ZMod n) :
    let center := (i.val : ℝ) * width
    let exactState := leveque04_periodicScalarExactCellAverage n q width time
    let slope := (q (center + width / 2) time 0 -
      q (center - width / 2) time 0) / width
    |exactState (i - 1) - (exactState i - width * slope)| ≤
        K * width ^ 2 ∧
      |exactState (i + 1) - (exactState i + width * slope)| ≤
        K * width ^ 2 := by
  let center := (i.val : ℝ) * width
  have hneighbors := leveque04_scalarExactCellAverage_neighborTaylor
    q flux profileDeriv K center width time hK hwidth hq hprofile hLip
  have hleft := leveque04_periodicScalarExactCellAverage_left
    n hn q flux width time hq hperiod i
  have hright := leveque04_periodicScalarExactCellAverage_right
    n hn q flux width time hq hperiod i
  have hrightCenter : (((i.val + 1 : ℕ) : ℝ) * width) =
      center + width := by
    dsimp [center]
    push_cast
    ring
  dsimp only at hneighbors
  change
    |leveque04_periodicScalarExactCellAverage n q width time (i - 1) -
      (leveque04_periodicScalarExactCellAverage n q width time i -
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤ K * width ^ 2 ∧
    |leveque04_periodicScalarExactCellAverage n q width time (i + 1) -
      (leveque04_periodicScalarExactCellAverage n q width time i +
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤ K * width ^ 2
  rw [hleft, hright, hrightCenter]
  change
    |(oneDimensionalCellAverage (fun x => q x time)
        (center - width - width / 2)
        (center - width + width / 2)) 0 -
      ((oneDimensionalCellAverage (fun x => q x time)
        (center - width / 2) (center + width / 2)) 0 -
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤ K * width ^ 2 ∧
    |(oneDimensionalCellAverage (fun x => q x time)
        (center + width - width / 2)
        (center + width + width / 2)) 0 -
      ((oneDimensionalCellAverage (fun x => q x time)
        (center - width / 2) (center + width / 2)) 0 +
        width * ((q (center + width / 2) time 0 -
          q (center - width / 2) time 0) / width))| ≤ K * width ^ 2
  exact hneighbors

end NumStability
