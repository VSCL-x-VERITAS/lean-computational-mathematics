/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.UniformReconstructionTraces

/-!
# Continuity of a uniform reconstruction at arbitrary points

The actual reconstruction is locally constant in every open cell. Its only
possible discontinuities are grid interfaces, where continuity is equivalent
to agreement of the two neighboring cell values.
-/

open Filter Set
open scoped Topology

namespace NumStability

/-- Inside an open cell the actual uniform reconstruction is locally constant,
so no separation property on its value space is required for continuity. -/
theorem leveque04_uniformReconstruction_continuousAt_cell
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (j : ℤ) (z : ℝ)
    (hz : z ∈ leveque04_cell (leveque04_uniformInterface origin width) j) :
    ContinuousAt (leveque04_uniformReconstruction origin width old) z := by
  have heq : leveque04_uniformReconstruction origin width old =ᶠ[𝓝 z]
      fun _ => old j := by
    filter_upwards [Ioo_mem_nhds hz.1 hz.2] with x hx
    exact leveque04_uniformReconstruction_cell origin width hwidth old j x hx
  exact continuousAt_const.congr_of_eventuallyEq heq

/-- Any point away from every grid interface lies in an open cell and is a
point of continuity, for arbitrary bilateral cell data. -/
theorem leveque04_uniformReconstruction_continuousAt_of_ne_interfaces
    {E : Type*} [TopologicalSpace E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (z : ℝ)
    (hz : ∀ j : ℤ, z ≠ leveque04_uniformInterface origin width j) :
    ContinuousAt (leveque04_uniformReconstruction origin width old) z := by
  let j : ℤ := ⌈(z - origin) / width⌉
  have hscaled : (j : ℝ) - 1 < (z - origin) / width ∧
      (z - origin) / width ≤ (j : ℝ) := Int.ceil_eq_iff.mp rfl
  have hleft : leveque04_uniformInterface origin width (j - 1) < z := by
    have hmul := (lt_div_iff₀ hwidth).mp hscaled.1
    simp only [leveque04_uniformInterface, Int.cast_sub, Int.cast_one]
    nlinarith
  have hright : z ≤ leveque04_uniformInterface origin width j := by
    have hmul := (div_le_iff₀ hwidth).mp hscaled.2
    dsimp only [leveque04_uniformInterface]
    linarith
  exact leveque04_uniformReconstruction_continuousAt_cell
    origin width hwidth old j z ⟨hleft, lt_of_le_of_ne hright (hz j)⟩

/-- At an arbitrary real point, continuity is equivalent to agreement at every
interface located at that point. The condition is empty inside an open cell. -/
theorem leveque04_uniformReconstruction_continuousAt_iff
    {E : Type*} [TopologicalSpace E] [T2Space E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (z : ℝ) :
    ContinuousAt (leveque04_uniformReconstruction origin width old) z ↔
      ∀ j : ℤ, z = leveque04_uniformInterface origin width j →
        old j = old (j + 1) := by
  constructor
  · intro hc j hj
    rw [hj] at hc
    exact (leveque04_uniformReconstruction_continuousAt_face_iff
      origin width hwidth old j).mp hc
  · intro hagree
    by_cases hface : ∃ j : ℤ, z = leveque04_uniformInterface origin width j
    · obtain ⟨j, rfl⟩ := hface
      exact (leveque04_uniformReconstruction_continuousAt_face_iff
        origin width hwidth old j).mpr (hagree j rfl)
    · apply leveque04_uniformReconstruction_continuousAt_of_ne_interfaces
        origin width hwidth old z
      intro j hj
      exact hface ⟨j, hj⟩

/-- A discontinuity of the actual reconstruction is exactly an interface with
unequal neighboring data, with no boundedness or support restriction. -/
theorem leveque04_uniformReconstruction_not_continuousAt_iff
    {E : Type*} [TopologicalSpace E] [T2Space E]
    (origin width : ℝ) (hwidth : 0 < width) (old : ℤ → E) (z : ℝ) :
    ¬ ContinuousAt (leveque04_uniformReconstruction origin width old) z ↔
      ∃ j : ℤ, z = leveque04_uniformInterface origin width j ∧
        old j ≠ old (j + 1) := by
  rw [leveque04_uniformReconstruction_continuousAt_iff origin width hwidth old z]
  simp only [not_forall, exists_prop]

end NumStability
