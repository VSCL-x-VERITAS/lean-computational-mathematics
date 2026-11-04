/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction
import ComputationalMathematics.Topology.Order.LocallyConstantJump

/-!
# One-sided traces of the actual uniform reconstruction

Arbitrary bilateral cell data have their prescribed neighboring values as
one-sided traces. The selected left-continuous interface value makes a face
continuous precisely when the adjacent states agree. No boundedness or
nonzero-wave assumption is needed.
-/

open Filter Set
open scoped Topology

namespace NumStability

/-- Consecutive interfaces of a positive-width uniform grid are ordered. -/
theorem leveque04_uniformInterface_lt_succ
    (origin width : ℝ) (hwidth : 0 < width) (j : ℤ) :
    leveque04_uniformInterface origin width j <
      leveque04_uniformInterface origin width (j + 1) := by
  simp only [leveque04_uniformInterface, Int.cast_add, Int.cast_one]
  nlinarith

/-- The open cell on the left supplies the actual left trace at its face. -/
theorem leveque04_uniformReconstruction_tendsto_left
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) :
    Tendsto (leveque04_uniformReconstruction origin width old)
      (𝓝[<] leveque04_uniformInterface origin width j) (𝓝 (old j)) := by
  apply tendsto_nhdsLT_of_eqOn_Ioo
    (a := leveque04_uniformInterface origin width (j - 1))
  · simpa only [sub_add_cancel] using
      leveque04_uniformInterface_lt_succ origin width hwidth (j - 1)
  · intro x hx
    exact leveque04_uniformReconstruction_cell origin width hwidth old j x hx

/-- The neighboring open cell supplies the actual right trace at the face. -/
theorem leveque04_uniformReconstruction_tendsto_right
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) :
    Tendsto (leveque04_uniformReconstruction origin width old)
      (𝓝[>] leveque04_uniformInterface origin width j) (𝓝 (old (j + 1))) := by
  apply tendsto_nhdsGT_of_eqOn_Ioo
    (b := leveque04_uniformInterface origin width (j + 1))
    (leveque04_uniformInterface_lt_succ origin width hwidth j)
  intro x hx
  apply leveque04_uniformReconstruction_cell origin width hwidth old (j + 1) x
  simpa only [leveque04_cell, add_sub_cancel_right] using hx

/-- A face carries a genuine jump exactly when its adjacent states differ. -/
theorem leveque04_uniformReconstruction_hasJumpAt_iff
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) :
    HasJumpAt (leveque04_uniformReconstruction origin width old)
      (leveque04_uniformInterface origin width j) (old j) (old (j + 1)) ↔
      old j ≠ old (j + 1) := by
  constructor
  · exact fun h => h.2.2
  · intro hne
    exact ⟨leveque04_uniformReconstruction_tendsto_left origin width hwidth old j,
      leveque04_uniformReconstruction_tendsto_right origin width hwidth old j, hne⟩

/-- With the actual interface representative, equal neighboring states are
also sufficient for continuity, including completely degenerate data. -/
theorem leveque04_uniformReconstruction_continuousAt_face_iff
    {E : Type*} [TopologicalSpace E] [T2Space E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) :
    ContinuousAt (leveque04_uniformReconstruction origin width old)
      (leveque04_uniformInterface origin width j) ↔ old j = old (j + 1) := by
  apply continuousAt_iff_eq_of_eqOn_Ioo
    (a := leveque04_uniformInterface origin width (j - 1))
    (b := leveque04_uniformInterface origin width (j + 1))
  · simpa only [sub_add_cancel] using
      leveque04_uniformInterface_lt_succ origin width hwidth (j - 1)
  · exact leveque04_uniformInterface_lt_succ origin width hwidth j
  · intro x hx
    exact leveque04_uniformReconstruction_cell origin width hwidth old j x hx
  · intro x hx
    apply leveque04_uniformReconstruction_cell origin width hwidth old (j + 1) x
    simpa only [leveque04_cell, add_sub_cancel_right] using hx
  · exact leveque04_uniformReconstruction_face origin width hwidth old j

/-- Translating the actual reconstruction translates its left trace by the
same amount; the cell data may be arbitrary. -/
theorem leveque04_uniformReconstruction_tendsto_left_shifted
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) (shift : ℝ) :
    Tendsto (fun x => leveque04_uniformReconstruction origin width old (x - shift))
      (𝓝[<] (leveque04_uniformInterface origin width j + shift)) (𝓝 (old j)) := by
  apply tendsto_nhdsLT_of_eqOn_Ioo
    (a := leveque04_uniformInterface origin width (j - 1) + shift)
  · have hlt := leveque04_uniformInterface_lt_succ origin width hwidth (j - 1)
    simp only [sub_add_cancel] at hlt
    linarith
  · intro x hx
    apply leveque04_uniformReconstruction_cell origin width hwidth old j (x - shift)
    change leveque04_uniformInterface origin width (j - 1) < x - shift ∧
      x - shift < leveque04_uniformInterface origin width j
    constructor <;> linarith [hx.1, hx.2]

/-- The right trace travels with the translated uniform-grid interface. -/
theorem leveque04_uniformReconstruction_tendsto_right_shifted
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) (shift : ℝ) :
    Tendsto (fun x => leveque04_uniformReconstruction origin width old (x - shift))
      (𝓝[>] (leveque04_uniformInterface origin width j + shift))
      (𝓝 (old (j + 1))) := by
  apply tendsto_nhdsGT_of_eqOn_Ioo
    (b := leveque04_uniformInterface origin width (j + 1) + shift)
  · have hlt := leveque04_uniformInterface_lt_succ origin width hwidth j
    linarith
  · intro x hx
    apply leveque04_uniformReconstruction_cell origin width hwidth old (j + 1) (x - shift)
    change leveque04_uniformInterface origin width (j + 1 - 1) < x - shift ∧
      x - shift < leveque04_uniformInterface origin width (j + 1)
    simp only [add_sub_cancel_right]
    constructor <;> linarith [hx.1, hx.2]

end NumStability
