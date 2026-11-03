/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.Equation05Target

/-!
# Physical time-average reference in LeVeque Equation 4.5

The physical flux is evaluated at a fixed spatial face before time integration.
Its normalized integral has the endpoint, volume and coordinate representations
of the reviewed reference definition.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The exact physical time-average satisfies the whole reference in Eq. 4.5. -/
theorem leveque04_timeAveragedPhysicalFlux : Leveque04TimeAveragedPhysicalFluxTarget := by
  constructor
  · intro m _hm grid time physicalFluxField htime hfield j n
    dsimp only [timeAveragedPhysicalFaceFlux, id]
    let f : ℝ → (Fin m → ℝ) := fun τ => physicalFluxField (grid.cellLeft j) τ
    let a : ℝ := time n
    let b : ℝ := time (n + 1)
    have hab : a < b := htime n
    have hf : IntervalIntegrable f volume a b := hfield j n
    have hopen : oneDimensionalCellAverage f a b =
        (b - a)⁻¹ • ∫ τ in Set.Ioo a b, f τ := by
      simp only [oneDimensionalCellAverage, intervalIntegral.integral_of_le hab.le,
        MeasureTheory.integral_Ioc_eq_integral_Ioo]
    have hclosed : oneDimensionalCellAverage f a b =
        (b - a)⁻¹ • ∫ τ in Set.Icc a b, f τ := by
      rw [MeasureTheory.integral_Icc_eq_integral_Ioc,
        MeasureTheory.integral_Ioc_eq_integral_Ioo]
      exact hopen
    have hvolume : oneDimensionalCellAverage f a b =
        cellVolumeAverage volume (Set.Ioo a b) f := by
      rw [cellVolumeAverage, Real.volume_Ioo,
        ENNReal.toReal_ofReal (sub_nonneg.mpr hab.le)]
      exact hopen
    refine ⟨sub_pos.mpr hab,
      oneDimensionalCellAverage_isCellAverage f hab hf, ?_, ?_, ?_,
      cellWidth_smul_oneDimensionalCellAverage f hab, ?_, ?_⟩
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
  · intro m _hm grid q physicalFlux start finish _hst j _hf
    rfl

end NumStability
