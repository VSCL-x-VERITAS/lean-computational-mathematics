/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Exact one-cell translations of the actual uniform reconstruction

The ceiling representative takes the value of the cell on the left at each
interface. Translating by at most one cell therefore gives exact two-state
formulas inside every open cell, including the translated interface itself.
Cell data and their value type are arbitrary.
-/

namespace NumStability

/-- The actual ceiling reconstruction takes `old i` throughout the interval
open at the left face and closed at the right face. -/
theorem leveque04_uniformReconstruction_eq_of_mem_Ioc
    {E : Type*} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (i : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioc (leveque04_uniformInterface origin width (i - 1))
      (leveque04_uniformInterface origin width i)) :
    leveque04_uniformReconstruction origin width old x = old i := by
  rcases lt_or_eq_of_le hx.2 with hlt | heq
  · exact leveque04_uniformReconstruction_cell origin width hwidth old i x ⟨hx.1, hlt⟩
  · rw [heq]
    exact leveque04_uniformReconstruction_face origin width hwidth old i

/-- For travel in `[0,width]`, the translated left-neighbor value includes
the moving interface. Zero travel and full one-cell travel are included. -/
theorem leveque04_uniformReconstruction_shift_nonneg
    {E : Type*} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (i : ℤ) (x shift : ℝ)
    (hx : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i)
    (hshift : 0 ≤ shift ∧ shift ≤ width) :
    leveque04_uniformReconstruction origin width old (x - shift) =
      if x ≤ leveque04_uniformInterface origin width (i - 1) + shift
      then old (i - 1) else old i := by
  have hprev : leveque04_uniformInterface origin width (i - 1 - 1) =
      leveque04_uniformInterface origin width (i - 1) - width := by
    simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one]
    ring
  by_cases hsplit : x ≤ leveque04_uniformInterface origin width (i - 1) + shift
  · rw [if_pos hsplit]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old (i - 1)
    constructor
    · rw [hprev]
      linarith [hx.1, hshift.2]
    · linarith
  · rw [if_neg hsplit]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old i
    constructor
    · have hfront : leveque04_uniformInterface origin width (i - 1) + shift < x :=
        lt_of_not_ge hsplit
      linarith
    · linarith [hx.2, hshift.1]

/-- For travel in `[-width,0]`, the translated right-neighbor value starts
strictly after the moving interface. At that interface the old cell value
is selected, as required by the actual left-continuous representative. -/
theorem leveque04_uniformReconstruction_shift_nonpos
    {E : Type*} (origin width : ℝ) (hwidth : 0 < width)
    (old : ℤ → E) (i : ℤ) (x shift : ℝ)
    (hx : x ∈ leveque04_cell (leveque04_uniformInterface origin width) i)
    (hshift : -width ≤ shift ∧ shift ≤ 0) :
    leveque04_uniformReconstruction origin width old (x - shift) =
      if leveque04_uniformInterface origin width i + shift < x
      then old (i + 1) else old i := by
  have hnext : leveque04_uniformInterface origin width (i + 1) =
      leveque04_uniformInterface origin width i + width := by
    simp only [leveque04_uniformInterface, Int.cast_add, Int.cast_one]
    ring
  by_cases hsplit : leveque04_uniformInterface origin width i + shift < x
  · rw [if_pos hsplit]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old (i + 1)
    constructor
    · simp only [add_sub_cancel_right]
      linarith
    · rw [hnext]
      linarith [hx.2, hshift.1]
  · rw [if_neg hsplit]
    apply leveque04_uniformReconstruction_eq_of_mem_Ioc origin width hwidth old i
    constructor
    · linarith [hx.1, hshift.2]
    · have hfront : x ≤ leveque04_uniformInterface origin width i + shift :=
        le_of_not_gt hsplit
      linarith

end NumStability
