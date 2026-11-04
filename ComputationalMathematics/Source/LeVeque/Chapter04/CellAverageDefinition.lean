/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CellAverageDefinitionTarget

/-!
# Physical reference average in LeVeque Equation 4.1

The normalized interval integral agrees with the open-cell and closed-cell
volume integrals and with every scalar coordinate average.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The physical reference average satisfies all representations in Equation 4.1. -/
theorem leveque04_cellAverageDefinition : Leveque04CellAverageDefinitionTarget := by
  intro m _hm interface time q hcell hfield i n
  dsimp only [leveque04_cellWidth, leveque04_cell]
  let f : ℝ → (Fin m → ℝ) := fun x => q x (time n)
  let a : ℝ := interface (i - 1)
  let b : ℝ := interface i
  have hab : a < b := hcell i
  have hf : IntervalIntegrable f volume a b := hfield i n
  have hopen : oneDimensionalCellAverage f a b =
      (b - a)⁻¹ • ∫ x in Set.Ioo a b, f x := by
    simp only [oneDimensionalCellAverage, intervalIntegral.integral_of_le hab.le,
      MeasureTheory.integral_Ioc_eq_integral_Ioo]
  have hclosed : oneDimensionalCellAverage f a b =
      (b - a)⁻¹ • ∫ x in Set.Icc a b, f x := by
    rw [MeasureTheory.integral_Icc_eq_integral_Ioc,
      MeasureTheory.integral_Ioc_eq_integral_Ioo]
    exact hopen
  have hvolume : oneDimensionalCellAverage f a b =
      cellVolumeAverage volume (Set.Ioo a b) f := by
    rw [cellVolumeAverage, Real.volume_Ioo,
      ENNReal.toReal_ofReal (sub_nonneg.mpr hab.le)]
    exact hopen
  refine ⟨sub_pos.mpr hab,
    oneDimensionalCellAverage_isCellAverage f hab hf, ?_, ?_, ?_, ?_, ?_⟩
  · simp only [oneDimensionalCellAverage, one_div]
  · simpa only [one_div] using hopen
  · simpa only [one_div] using hclosed
  · refine ⟨?_, ?_, ?_, hvolume⟩
    · rw [Real.volume_Ioo]
      exact ENNReal.ofReal_ne_zero_iff.mpr (sub_pos.mpr hab)
    · rw [Real.volume_Ioo]
      exact ENNReal.ofReal_ne_top
    · exact hf.1.mono_set (fun _ hx => ⟨hx.1, hx.2.le⟩)
  · intro p
    rw [oneDimensionalCellAverage_apply f a b hf p]
    simp only [oneDimensionalCellAverage, smul_eq_mul, one_div,
      intervalIntegral.integral_of_le hab.le, MeasureTheory.integral_Ioc_eq_integral_Ioo,
      f, a, b]

end NumStability
